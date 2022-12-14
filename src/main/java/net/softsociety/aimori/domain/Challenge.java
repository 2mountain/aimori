package net.softsociety.aimori.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Challenge {
 int challengeNumber;
 String challengeName;
 String challengeStartDate;
 String challengeEndDate;
 String challengeRegistDay;
 String challengeContents;
 String challengeType;
	int challPoint;
	int firPoint;
	int secPoint;
	int thdPoint;
	int sanka;
	String challengeOriginalFile;	// 게시글 이미지 첨부파일
	String challengeSavedFile;	//서버에 저장된 이름

	}