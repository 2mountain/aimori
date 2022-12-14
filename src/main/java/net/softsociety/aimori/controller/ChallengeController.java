package net.softsociety.aimori.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.slf4j.Slf4j;
import net.softsociety.aimori.domain.Board;
import net.softsociety.aimori.domain.Challenge;
import net.softsociety.aimori.domain.Entrylist;
import net.softsociety.aimori.domain.Memberchallenge;
import net.softsociety.aimori.service.ChallengeService;
import net.softsociety.aimori.util.FileService;
import net.softsociety.aimori.util.PageNavigator;

@Slf4j
@RequestMapping("challenge")
@Controller
public class ChallengeController {


	//게시판 목록의 페이지당 글 수
	@Value("${user.board.page}")
	int countPerPage;

	//게시판 목록의 페이지 이동 링크 수
	@Value("${user.board.group}")
	int pagePerGroup;

	@Value("${spring.servlet.multipart.location}")
	String uploadPath;

	@Autowired
	ChallengeService chser;

	@GetMapping("main")
	public String main() {
		return "/challenge/main";
	}

	@GetMapping({"challengeupadate"})
	public String challengeupdate()
	{


		return "";

	}
	@GetMapping("challengedelete")
	public String challengeDelete(int challengeNumber,Model model) {

		// 해당 번호의 글 정보 조회
		Challenge challenge = chser.read(challengeNumber);

		if (challenge == null) {
			return "redirect:/challenge/challengelist";
		}

		// 첨부된 파일명 확인
		String savedfile = challenge.getChallengeSavedFile();

		// board.setMemberId("test1");

		// 글 삭제
		int result = chser.delete(challengeNumber);

		// 글 삭제 성공 and 첨부된 파일이 있는 경우 파일도 삭제
		if (result == 1 && savedfile != null) {
			FileService.deleteFile(uploadPath + "/" + savedfile);
		}
		String chtype=null;
		String chsearchWord=null;
		int page=1;	
		challengelist(model
				,page,chtype,chsearchWord);
		return "redirect:/challenge/challengelist";
	}

	
	
	@GetMapping({"challengelist"})
	public String challengelist(Model model
			, @RequestParam(name = "page", defaultValue = "1") int page
			, String chtype
			, String chsearchWord)
	{
		PageNavigator chnavi = chser.getchPageNavigator(pagePerGroup, countPerPage, page, chtype, chsearchWord);

		System.out.println(chnavi.getTotalRecordsCount());

		ArrayList<Challenge> challengelist = chser.challengelist(chnavi, chtype, chsearchWord);

		log.debug("challengelist : {}", challengelist);
		log.debug("chnavi : {}", chnavi);


		model.addAttribute("chnavi", chnavi);
		model.addAttribute("challengelist", challengelist);
		model.addAttribute("chtype", chtype);
		model.addAttribute("chsearchWord", chsearchWord);
		return "/challenge/challengelist";
	}
	@GetMapping({"challengelistadmin"})
	public String challengelistadmin(Model model
			, @RequestParam(name = "page", defaultValue = "1") int page
			, String chtype
			, String chsearchWord)
	{
		challengelist(model,1,chtype,chsearchWord);
		return "/challenge/challengelistadmin";
	}
	@GetMapping({"contestlist"})
	public String contestlist(Model model
			, @RequestParam(name = "page", defaultValue = "1") int page
			, String cotype
			, String cosearchWord) {

		PageNavigator conavi = chser.getCoPageNavigator(pagePerGroup, countPerPage, page, cotype, cosearchWord);
		ArrayList<Challenge> contestlist = chser.contestlist(conavi, cotype, cosearchWord);

		log.debug("contest : {}", contestlist);

		model.addAttribute("conavi", conavi);
		model.addAttribute("contestlist", contestlist);
		model.addAttribute("chtype", cotype);
		model.addAttribute("chsearchWord", cosearchWord);

		return "/challenge/contestlist";
	}

	@GetMapping({"contestlistadmin"})
	public String contestlistadmin(Model model
			, @RequestParam(name = "page", defaultValue = "1") int page
			, String cotype
			, String cosearchWord) {

		challengelist(model,1,cotype,cosearchWord);
		return "/challenge/contestlistadmin";
	}

	@GetMapping({"contestwrite"})
	public String contestwrite()
	{
		return "/challenge/contestwrite";
	}

	@PostMapping({"challengewrite"})
	public String challengewrite(Model model,
			Challenge challenge, MultipartFile upload)
	{
	
		if (!upload.isEmpty()) 
		{
			String savedfile = FileService.saveFile(upload, uploadPath);
			challenge.setChallengeOriginalFile(upload.getOriginalFilename());
			challenge.setChallengeSavedFile(savedfile);
		}
		
		int result = chser.writechallenge(challenge);

		
		String chtype="";
		String chsearchword="";

		challengelist(model,1,chtype,chsearchword);
		return "/challenge/challengelist";

	}
	@GetMapping({"challengewrite"})
	public String challengewrite()
	{

		return "/challenge/challengewrite";
	}
	@GetMapping({"entrychallenge"})
	public String entrychallenge(Model model,
			@AuthenticationPrincipal UserDetails user,
			@RequestParam(defaultValue = "0") int challengeNumber
			)
	{
	
		Memberchallenge memberchall = new Memberchallenge();
		memberchall.setChallengeNumber(challengeNumber);
		memberchall.setMemberId(user.getUsername());
		int result=chser.entrychallenge(memberchall);
		mychallengelist(model,user.getUsername());
		return "/mypageView/mychallengelist";
	}

	@GetMapping({"mychallengelist"})
	public String mychallengelist(Model model,String memberId
			)
	{
		ArrayList<Memberchallenge> mychallengelist = chser.mychallengelist(memberId);
		model.addAttribute("mychallengelist", mychallengelist);
		return "/mypageView/mychallengelist";
	}
	
	//해당 도전과제를 읽고 내 도전과제에 등록하거나 도전과제를 수행한 사람에게 일정 포인트를 주는 것ㄴ 
	@GetMapping({"challengeread"})
	public String challengeread(Model model
			,  int challengeNumber) { 
		log.debug("번호:"+challengeNumber);
		// 도전과제를 불러오는 페이지
		Challenge challenge = chser.read(challengeNumber);
		if (challenge == null) {
			return "redirect:/challenge/challengelist"; //글이 없으면 목록으로
		}
		//관리자 계정에서만 뜨는페이지 접속할 시 해당인원에게 포인트 주기 기능
		ArrayList<Entrylist>  entrylist = chser.list(challengeNumber);
		if (entrylist == null) {
			return "redirect:/challenge/challengelist"; //글이 없으면 목록으로
		}

		log.debug("challenge1: {}",challenge);
		log.debug("entrylist: {}",entrylist);

		model.addAttribute("challenge", challenge);
		model.addAttribute("entrylist", entrylist);
		return "/challenge/challengeread";
	}	

	@GetMapping({"challengegivepoint"})
	public String givepoint(int point , String memberId,Model model,int entrylistNumber
			,  int challengeNumber) { 

		int result =chser.givepoint(point,memberId,entrylistNumber);
		// 도전과제를 불러오는 페이지
		Challenge challenge = chser.read(challengeNumber);
		if (challenge == null) {
			return "redirect:/challenge/challengelist"; //글이 없으면 목록으로
		}
		//관리자 계정에서만 뜨는페이지 접속할 시 해당인원에게 포인트 주기 기능
		ArrayList<Entrylist>  entrylist = chser.list(challengeNumber);
		if (entrylist == null) {
			return "redirect:/challenge/challengelist"; //글이 없으면 목록으로
		}


		model.addAttribute("challenge", challenge);
		model.addAttribute("entrylist", entrylist);
		return "/challenge/challengeread";
	}


	@GetMapping({"contestread"})
	public String contestread(Model model
			, @RequestParam(name="challengeNumber", defaultValue = "0") int challengeNumber) { 

		// 도전과제를 불러오는 페이지
		Challenge challenge = chser.read(challengeNumber);
		if (challenge == null) {
			return "redirect:/challenge/contestlist"; //글이 없으면 목록으로
		}
		//관리자 계정에서만 뜨는페이지 접속할 시 해당인원 등 수 부여
		ArrayList<Entrylist>  entrylist = chser.list(challengeNumber);

		model.addAttribute("challenge", challenge);
		model.addAttribute("entrylist", entrylist);

		log.debug("challenge1: {}",challenge);
		log.debug("entrylist: {}",entrylist);
		return "/challenge/contestread";
	}
}
