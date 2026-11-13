Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=49.212.13.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794529543;
	b=uee/Lt0ZDkLDZeFFmrpUJ05HgK2BCHwsfZJCVRUKNxGEKgQqTKWdRbRT0KdGK7hWTqIm
	 uzXJ+ToWRFsjOoOsqz6TyfI4oAUAv94DhWb3yxXbTV7nT9zasUzRYDZ9pa7yfY3HF0qfn
	 mCGkPI3YLpnqLopLJZmXZwu5IBmle3KEkbGvxXwsMWKTs0bDB1BHQlQiFsD/ENDBJgnND
	 qiHdYWCRnoWVFVWwx05fy5jHyuFPrjPO7S1FJKefBDUh0nRFH4A+5xtCIR+jJ1KgfGMhe
	 uF6TRvlC+ztosuAggReHZ2zwwI1W3XfUDaEAAfjus3GKwm5+H3zFg+Mza4hJQvH2NYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794529543;
	h=DMARC-Filter:Received:DKIM-Filter:To:From:X-Ip:X-Ip-source:
	 Precedence:List-Unsubscribe:List-Unsubscribe-Post:Subject:
	 Mime-Version:Content-Type:Content-Transfer-Encoding:X-MagazineId:
	 X-uId:X-Sender:X-Url:Message-Id:Date;
	bh=NOfNgTyd0uEr6RzFm0WGakXbVq4eVhUqaBjZ/gzkpPY=;
	b=oq1Rpqz5DccSRSYWg6Cp0FkRmGs7nZNKyz+5DSS9JlhPZFnECXCGfgnHKrhjRWRNOZ9E
	 DPM/qxzUs5Zwo71+zZrnfRmKPugNRRrrfD31wQ/YZ8x360PAGUkebWVCSi53i2hg//DGm
	 fxiT+WlvJxf80bizFs/l78zGyy8qA3Sjtieog2jlNHOXWBV7ENLlJTs5rssAOMlJWD9cN
	 nXTQm90tcFevm+KZyb1tGLB165zEYl3pjAgfDIfHtUf/aYVB05YEowJ0NsRuX2f5B/sYT
	 mjt2uCENCExRc0JqA33Eo8QODONay5nFgGP49Kd5DZPRVHu+nQn7AkjG7qiHyA1k6mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=knowledgelink-corp.jp;
	spf=pass smtp.mailfrom=magerr.combzmail.jp;
	arc=none smtp.remote-ip=49.212.13.37
Received: from r9133.ps.combzmail.jp (r9133.ps.combzmail.jp [49.212.13.37])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211E9606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 00:25:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 211E9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=knowledgelink-corp.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=magerr.combzmail.jp
Received: by r9133.ps.combzmail.jp (Postfix, from userid 99)
	id 355058901E; Fri, 13 Nov 2026 09:23:43 +0900 (JST)
DKIM-Filter: OpenDKIM Filter v2.11.0 r9133.ps.combzmail.jp 355058901E
To: linux-btrfs@vger.kernel.org
From: =?ISO-2022-JP?B?GyRCP0BFRCFDMGxITDxSQ0RLIT9NJUolbCVDJTglaiVzJS8bKEI=?= <info@knowledgelink-corp.jp>
X-Ip: 7189651268118417
X-Ip-source: k85gj72848dnsad1u0p6gd
Precedence: bulk
List-Unsubscribe-Post: List-Unsubscribe=One-Click
Subject: =?ISO-2022-JP?B?GyRCPFJEOSROMnE8UiROIVYlKCE8JTkhVyEiGyhC?=
 =?ISO-2022-JP?B?GyRCJCQkRDwtJGEkXiQ5JCshKSFaN1AxRDxUOEJEaiU7GyhC?=
 =?ISO-2022-JP?B?GyRCJV8lSiE8IVsbKEI=?=
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-MagazineId: 28d1
X-uId: 6764325137486067654956401034
X-Sender: CombzMailSender
X-Url: http://www.combzmail.jp/
Message-Id: <20261113002441.355058901E@r9133.ps.combzmail.jp>
Date: Fri, 13 Nov 2026 09:23:43 +0900 (JST)

　
　ルールを決めたら、社員は辞めるどころか
　「迷わなく」なった。
　
　これまでに4,800社以上への支援から分かった
　
　“凡人”を常勝集団に変える
　ルールのつくり方を
　
　次の朝礼から実践できる形で
　分かりやすく丁寧にお伝えします。

┏… Overview …………………………………………┓
　
　「あいつが辞めたら、うちは回るのか？」
　
　　エースに頼らず“凡人”を
　　常勝集団に変えるルールのつくり方

　　　　　　　　―――
　　日　時　11月24日（火）13:00-15:00
　
　　会　場　Zoom無料開催／定員100名
　　事務局　ナレッジリンクセミナー窓口
　
　　詳細はこちら
　　https://knowledge-co.jp/rule/

┗……………………………………………………………┛
　
　
　多くの社長とお話しする中で
　このようなお悩みをよく伺います。
　
　　・エースが辞めたら、売上が大きく落ちる
　　・朝礼に遅れてくる社員がいても、誰も何も言わない
　　・同じミスに、毎回説教。その後、自己嫌悪になる

　研修も、クレドも、評価制度も試した。
　それでも改善は続かず「結局は人次第なのか」と感じている。
　
　
　そんなお悩みを解決し、成果を生み出す会社に一変させる
　本質をついた、ルールづくりをお伝えします。

　
― セミナーで得られること ―

　・ルールを増やすと社員は辞めるのか？への答え
　・「姿勢のルール」の決め方
　・「完全結果」の指示に書き換える方法
　・エラー時に上司がかける「一言」
　
　
　いずれも、翌日の朝礼から試していただける内容です。
　
　自社の組織に希望を持つための気づきを得られる
　内容となっておりますので、ぜひご視聴ください。　
　
　
_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

　一般社団法人ナレッジリンク
　東京都千代田区神田小川町1-8-3
　セミナー窓口：03-5256-7638

……………………………………………………………………
　メール案内が不要な方にはご迷惑をお掛けしまして
　大変申し訳ございません。
　お手数ですが下記URLより手続きをお願い致します。
　
　配信の解除依頼はこちら
　https://fc-knowledgelink-corp.jp/mail/

_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
