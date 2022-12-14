package net.softsociety.aimori.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import net.softsociety.aimori.domain.Board;
import net.softsociety.aimori.domain.Member;

/**
 * 사용자 정보 관련 매퍼 인터페이스
 */
@Mapper
public interface MemberDAO {
	// 회원가입
	public int signInMember(Member member);
	
	// ID 중복검사
	public Member selectOne(String memberId);
	
	// 닉네임 중복검사
	public Member selectOne2(String memberNickName);

	// 정보 수정
	public int updateMember(Member member);

	//메인 탑 랭커들 뿌리기
	public ArrayList<Member> selectRanker();
	

	

}

