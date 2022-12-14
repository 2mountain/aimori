DROP TABLE members;
DROP TABLE pet;
DROP TABLE board;
DROP TABLE reply;
DROP TABLE challenge;
DROP TABLE memberCoupon;
DROP TABLE shopCoupon;
DROP TABLE doctor;
DROP TABLE facilities;
DROP TABLE facilitiesEvaluation;
DROP TABLE boardLikedData;
DROP table question;
DROP table answer;
DROP table reportData;

DROP SEQUENCE doctor_seq;
DROP SEQUENCE pet_seq;
DROP SEQUENCE boardNumber_seq;
DROP SEQUENCE reply_seq;
DROP SEQUENCE memberCouponNumber_seq;
DROP SEQUENCE challenge_seq;
DROP SEQUENCE facilitiesNumber_seq;
DROP SEQUENCE facilitiesEvaluationNumber_seq;
DROP SEQUENCE boardLikedNumber_seq;
DROP SEQUENCE questionNumber_seq;
DROP SEQUENCE answerNumber_seq;
DROP SEQUENCE reportNumber_seq;

CREATE SEQUENCE doctor_seq;
CREATE SEQUENCE pet_seq;
CREATE SEQUENCE boardNumber_seq;
CREATE SEQUENCE reply_seq;
CREATE SEQUENCE memberCouponNumber_seq;
CREATE SEQUENCE challenge_seq;
CREATE SEQUENCE facilitiesNumber_seq;
CREATE SEQUENCE facilitiesEvaluationNumber_seq;
CREATE SEQUENCE boardLikedNumber_seq;
CREATE SEQUENCE questionNumber_seq;
CREATE SEQUENCE answerNumber_seq;
CREATE SEQUENCE reportNumber_seq;
CREATE SEQUENCE calendar_seq
       INCREMENT BY 1
       START WITH 1
       MINVALUE 1
       MAXVALUE 9999
       NOCYCLE
       NOCACHE
       NOORDER;

CREATE TABLE members
(
    memberId 					VARCHAR2(40) PRIMARY KEY,
    			--회원 아이디
    memberPassword 				VARCHAR2(100) NOT NULL,
    			--회원 비밀번호
    memberNickName 				VARCHAR2(40) NOT NULL UNIQUE,
    			--회원 닉네임 
    memberPostCode 				VARCHAR2(100),
    			--회원 우편번호 
    memberAddress 				VARCHAR2(300) NOT NULL,
    			--회원 주소
    memberDetailAddress 		VARCHAR2(100),
    			--회원 상세주소 
    memberEmail 				VARCHAR2(50) NOT NULL UNIQUE,
    			--회원 이메일
    memberBirthDay 				VARCHAR2(12) NOT NULL,
    			--회원 생년월일
    memberPoint 				NUMBER DEFAULT 0,
    			--회원 포인트
    memberRoleName 				VARCHAR2(20) DEFAULT 'ROLE_USER'  
			 					CHECK(memberRoleName IN('ROLE_USER', 'ROLE_ADMIN', 'ROLE_DOCTOR')) 
			 					NOT NULL,
    			--회원 역할        
    memberEnabled 				NUMBER DEFAULT 1 CHECK(memberEnabled IN(0, 1)),
    			--회원 차단 여부
    memberJoinDate 				DATE DEFAULT SYSDATE,
    			--회원 가입일
    memberImageOriginalFile 	VARCHAR2(300) DEFAULT 'defaultImage',
                --대표 이미지의 원래 이름
    memberImageSavedFile 		VARCHAR2(100)
                --이미지 첨부파일 서버에 저장된 이름
);



CREATE TABLE pet    --Pet table
(
    petNumber 				NUMBER PRIMARY KEY, 
    			--애완동물 등록번호
    memberId 				VARCHAR2(40) REFERENCES members(memberId),
    			--회원 아이디 참조
    petName 				VARCHAR2(20) NOT NULL, 
    			--애완동물 이름
    petBreed 				VARCHAR2(40) NOT NULL CHECK(petBreed in('말티즈', '치와와', '포메라니안', '푸들', '시츄', '시바견', '비글', '웰시코기', '코커스패니얼', '보더콜리', '골든리트리버', '달마시안', '도베르만', '그레이하운드', '허스키', '기타(직접입력)')), 
    			--애완동물 품종
    petGender 				VARCHAR2(1) NOT NULL CHECK(petGender in('M', 'F')), 
    			--애완동물 성별
    petBirthDay 			VARCHAR2(12) NOT NULL, 
    			--애완동물 생년월일
    petWeight 				NUMBER default 0 NOT NULL, 
    			--애완동물 몸무게
    petNeuter 				VARCHAR2(1) CHECK(petNeuter IN('Y', 'N')), 
    			--중성화 여부
    petImage 				VARCHAR2(300)
    			--애완동물 사진의 이름
);

/*
	petBreed
		소형견 - 말티즈 치와와 포메라니안 푸들 시츄
		중형견 - 시바견 비글 웰시코기 코커스패니얼 보더콜리
		대형견 - 골든리트리버 달마시안 도베르만 그레이하운드 허스키
		직접입력
*/

CREATE TABLE BOARD
(
    boardNumber number PRIMARY KEY,
		/* 글 번호(BoardNumber_seq사용) */
    memberId varchar2(40) REFERENCES Members(memberId),
		/* 회원 아이디 */
    boardTitle varchar2(300) NOT NULL,
		/* 글 제목 */
    memberNickName varchar2(40),
		/* 작성자 닉네임 */                                                       
    boardInputDate date DEFAULT SYSDATE,
		/* 글 작성일 */
    boardHits number DEFAULT 0,
		/* 글 조회수 */
    boardReport number DEFAULT 0,
		/* 글 신고수 */
    boardContents varchar2(4000) NOT NULL,
		/* 글 내용 */
    boardCategory varchar2(20) default '전체' CHECK (boardCategory IN ('전체', '일상', '모임', 'Tip')),
		/* 글 말머리 */
    boardImageOriginal varchar2(300),
		/* 게시글 이미지 첨부파일*/
    boardImageSaved varchar2(100),
		/* 서버에 저장된 첨부파일 이름*/
	replyCount number
		-- 게시글에 달린 전체 댓글 개수
);



create table boardLikedData
(
    boardLikedNumber number primary key not null,
    memberId varchar2(40) references members(memberId),
    boardNumber number references board(boardNumber)
);



CREATE TABLE reply
(
    replyNumber 	NUMBER PRIMARY KEY,  
    			--댓글 번호
    boardNumber NUMBER REFERENCES board(boardNumber) on delete cascade, 
    			--글 번호(외래키)
	memberId		VARCHAR2(40) NOT NULL,
    			--댓글 작성하는 회원 아이디
    memberNickName 	VARCHAR2(40) NOT NULL,
    			--댓글 작성하는 회원 닉네임
    replyContents 	VARCHAR2(4000) NOT NULL, 
    			--댓글 내용
    replyInputDate 	DATE DEFAULT SYSDATE
    			--댓글 작성 일자
);

CREATE TABLE shopCoupon
(
	couponType		VARCHAR2(100) PRIMARY KEY,  -- 쿠폰의 종류(이름)
	couponPrice	 	NUMBER NOT NULL,            -- 쿠폰포인트 가격
	couponEndDate 	VARCHAR2(12)                -- 쿠폰 만료일
);

CREATE TABLE memberCoupon
(
    memberCouponNumber 	NUMBER PRIMARY KEY,   
    			--쿠폰 식별 번호
    memberId 		            	VARCHAR2(40) NOT NULL REFERENCES members(memberid),
                --회원 아이디
    couponType 			        VARCHAR2(100) NOT NULL REFERENCES shopCoupon(couponType)      
    			--쿠폰 종류(이름)
);

--도전과제 정보테이블
CREATE TABLE challenge 
(
   challengeNumber    NUMBER PRIMARY KEY,
   challengeName       VARCHAR2(200),
   challengeStartDate    VARCHAR2(200),
   challengeEndDate    VARCHAR2(200),
   challengeContents    VARCHAR2(200),
   challengeType    VARCHAR2(200),
   challengeRegistDay date,
   challengeSavedFile	VARCHAR2(100),
   challengeOriginalFile	VARCHAR2(300)
);

--의사 정보 테이블
CREATE TABLE doctor  -- DOCTOR CHECK 테이블이 있다면 기본키 수정 필요
(
    doctorNumber 				NUMBER CONSTRAINT doctor_doctorNumber_pk PRIMARY KEY,                              
    			--의사회원번호
    memberId 					VARCHAR2(40) CONSTRAINT doctor_memberId_fk REFERENCES members(memberId),  
    			--회원 번호
    doctorName 					VARCHAR2(20) CONSTRAINT doctor_doctorName_nn NOT NULL,                               
    			--의사 회원 이름
    hospitalName 				VARCHAR2(40), 
    			--병원이름
    licenseGetDate 				DATE, 
    			--자격증 취득일
    licenseImageOriginalFile 	VARCHAR2(300) NOT NULL,
    			--수의사 자격증 이미지 첨부파일의 원래 이름
    licenseImageSavedFile 		VARCHAR2(100),  
    			--자격증 이미지 첨부파일 서버에 저장된 이름
    doctorApproval 				VARCHAR2(10) CONSTRAINT doctor_doctorApproval_ck CHECK(doctorApproval IN('Y','Wait', 'N')),
    			--의사 인증 승인 여부
	doctorApplicationDate 		DATE DEFAULT SYSDATE, 
				--의사 인증 신청일
    doctorAcceptedDate			DATE 
    			--의사 인증 승인일
);

CREATE TABLE facilities 
(
	facilitiesNumber   NUMBER CONSTRAINT facilities_facilitiesNumber_pk PRIMARY KEY,
                -- 시설 번호
	facilitiesName      VARCHAR2(100) CONSTRAINT facilities_faciliteisName_NN NOT NULL,
                -- 시설 이름
    facilitiesAddress VARCHAR2(300),
                -- 시설 도로명 주소
    facilitiesDetailAddress VARCHAR2(300),
                -- 시설 지번 주소
    facilitiesPhoneNumber VARCHAR2(40)
                -- 시설 전화번호
);

CREATE TABLE facilitiesEvaluation
(
	facilitiesEvaluationNumber  	NUMBER PRIMARY KEY,
                -- 시설 평가 번호
	facilitiesNumber                NUMBER REFERENCES facilities(facilitiesNumber),
                -- 시설 번호
	memberId                        VARCHAR2(40) REFERENCES members(memberId),
                -- 리뷰 작성 회원 아이디
	facilitiesReview                VARCHAR2(1000) NOT NULL,
                -- 시설 리뷰 내용
	facilitiesStar                  NUMBER CHECK(facilitiesStar IN(0, 1, 2, 3, 4, 5)) NOT NULL,
                -- 시설 평가(별점)
	facilitiesReviewDate            DATE DEFAULT SYSDATE
                -- 시설 리뷰 작성 일자
);
create table entrylist
(
     entrylistNumber number primary key,
	 memberId varchar2(40)  references  MEMBERS(MEMBERID),
	 challengeNumber number references CHALLENGE(CHALLENGENUMBER),
	 challengeSuccess  number,
	 getPoint number,
     getPointDate DATE default sysdate
);

CREATE TABLE question
(
    questionNumber number PRIMARY KEY,
		/* 질문글 번호(BoardNumber_seq사용) */
    memberId varchar2(40) REFERENCES Members(memberId),
		/* 회원 아이디 */
    questionTitle varchar2(300) NOT NULL,
		/* 질문글 제목 */
    memberNickName varchar2(40),
		/* 작성자 닉네임 */
    questionInputDate date DEFAULT SYSDATE,
		/* 질문글 작성일 */
    questionHits number DEFAULT 0,
		/* 질문글 조회수 */
    questionReport number DEFAULT 0,
		/* 질문글 신고수 */
    questionContents varchar2(4000) NOT NULL,
		/* 질문글 내용 */
    questionCategory varchar2(20) default '전체' CHECK (questionCategory IN ('일반', '의료')),
		/* 질문글 말머리 */
    questionImageOriginal varchar2(300),
		/* 질문글 이미지 첨부파일*/
    questionImageSaved varchar2(100),
		/* 서버에 저장된 첨부파일 이름*/
    answerCount number default 0,
		-- 질문글에 달린 전체 답변 개수
    answeredOrNot number default 0 check (answeredOrNot IN (0, 1)),
		-- 답변이 달렸는지 안 달렸는지 여부
    answerAccepted	number default 0 check(answerAccepted in (0,1 ))
        --답변 채택 여부
);

CREATE TABLE answer
(
    answerNumber    NUMBER PRIMARY KEY,  
    			--댓글 번호
    questionNumber  NUMBER REFERENCES question(questionNumber) on delete cascade, 
    			--글 번호(외래키)
    memberId        VARCHAR2(40) NOT NULL,
    			--답변 작성하는 회원 아이디
    memberNickName  VARCHAR2(40) NOT NULL,
    			--답변 작성하는 회원 닉네임
    memberRoleName  VARCHAR2(20) default 'ROLE_USER' CHECK (memberRoleName IN ('ROLE_ADMIN', 'ROLE_DOCTOR', 'ROLE_USER')),
                --답변 작성하는 회원 등급
    answerContents 	VARCHAR2(4000) NOT NULL,
    			--답변 내용
    answerInputDate DATE DEFAULT SYSDATE,
    			--답변 작성 일자
    answerAcceptedOrNot number default 0 check (answerAcceptedOrNot IN (0, 1))
                --답변 채택 여부
);

create table reportData
(
    reportNumber NUMBER primary key not null,
        --신고 식별번호
    reportCategory VARCHAR2(200) not null,
        --신고 사유 담을 변수(홍보/도배, 음란물, 불법정보, 욕설/혐오표현, 개인정보 노출)
    memberId VARCHAR2(40) references members(memberId) on delete cascade,
        --신고한 멤버 아이디
    boardNumber NUMBER references board(boardNumber) on delete cascade,
        --신고받은 커뮤니티 게시글번호
	questionNumber NUMBER references question(questionNumber) on delete cascade
        --신고받은 질문글 게시글번호
);

CREATE TABLE "CALENDAR"
(
	"SEQ" NUMBER(*,0) NOT NULL ENABLE, 
	"TITLE" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
	"START_DATE" DATE NOT NULL ENABLE, 
	"END_DATE" DATE NOT NULL ENABLE
);






	insert into BOARD (
		boardNumber
		, memberId
		, boardTitle
		, memberNickName
		, boardContents
		, boardCategory
		)
	values (
		boardNumber_seq.nextval
		, 'khs11111' --멤버 아이디
		, 'testTitle' --글제목
		, 'khs11111' --멤버닉네임
		, 'testContents' --글내용
		, '일상' --글 카테고리(일상, 모임, Tip)
		);
        
    insert into question (
		questionNumber
		, memberId
		, questionTitle
		, memberNickName
		, questionContents
		, questionCategory
		)
    values (
		questionNumber_seq.nextval
		, 'khs11111' --멤버아이디
		, 'testTitle'
		, 'khs11111' --멤버닉네임
		, 'testContents'
		, '일반' --질문글 카테고리(일반, 의료)
		);
        
    insert into answer
		(
			answerNumber
			, questionNumber
			, memberId
			, memberNickName
			, answerContents
		)
    values
		(
			answerNumber_seq.nextval
			, 10
			, 'khs11111'
			, 'khs11111'
			, 'testContents'
		);

select * from members;

alter table answer
add (answerAcceptedOrNot number default 0 check (answerAcceptedOrNot IN (0, 1)));

commit;
