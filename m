Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B4238A72B;
	Mon, 20 Jul 2026 03:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784517252; cv=none; b=pT63yzBA+a8TtKF1JPMut6mBwP4cy3+Mton4rCrkPRIzuCUPnPTpCp3J7LGFcOI23147GHQGIMldRI2YPhuX8TLQeQA1JWawS0E//NB6ckpbQTsXbrFJgCpaRbAEvsCfcYZMncSxTfAEA8gcTqROhzuseSUVr/Fk0E/x0namVe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784517252; c=relaxed/simple;
	bh=uA+Ktf78jQDoJY8g826Z0cN6whyhGvKAq1Zxhoz5ZGE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kd8Lq7maBQkpBvfqYO7dp7Dy6Z2i0ubNB6yQbzSzRpIVSWE7YXQcR0/0asH/gCA05GnveSzfHiSClBhAS98mJcnX+ys+f4zDwJDLLod46aYOfEdwDLROvd1fYWOtTUyFl7cH9RzoZJ5S0GcxteOxClk+DNWfVGyG4DnXImqP26A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=XfFPEv85; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="XfFPEv85"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784517169;
	bh=tNCcbLxW5ysB/z14g+kDufq8rAM5uOtRlsNI4S/ZnKo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=XfFPEv85WlVmRkOc2VXUqXaGp6g3L/5s/nnMQFTA4JUWSrmAPSs2sSgIgvdNazd7i
	 BUUfCkO8RNd9abs3DPnG4Nx2Fa1YoHvlWo1fAFrZifL+zNM9M9cjoNHqBlB5vqH+5/
	 K2VBQBisg4kw1Wu2mXxb4SHYdQ63uY+3irNohaH4=
X-QQ-mid: esmtpsz17t1784517152t49bc07af
X-QQ-Originating-IP: JSiI9i92DjNdWlppyi8BVdc5xRYc2wekek2ONKYx6DU=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 20 Jul 2026 11:12:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12472878844775802034
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: boris@bur.io
Cc: chenyichong@uniontech.com,
	clm@fb.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	willy@infradead.org
Subject: Re: [PATCH v2] btrfs: add verity Merkle folio to page cache after reading it
Date: Mon, 20 Jul 2026 11:12:30 +0800
Message-Id: <20260720031230.1378521-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260716162349.GA3278562@zen.localdomain>
References: <20260716162349.GA3278562@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Nz5LPJkwiVdpS1wnp5WM6T8BUwjWVHGfQqOsGJzY1KkuoL1Tt8vBLina
	LUji6PwgTShcTWW3cVTpGKg7JgW5vj/8wU4CE52vKiq36hAaWQvz+vI2zCabdSskazTyGch
	etAS3/vwBVvlqzbQg/CSAXMHZy+hdKJdojIHy59TE2YnMuTjIRou4GJsTsqwNSigcaW/Aip
	MoWKjESfPQBRoP+R2/C2aI3qnrtIid4xgYm04vYO8CDf5D9glGXQJdXzTc0BHjz1JYYevrd
	KuH0WX3krOWMZk+9RMrwz1D++odbUOdngvyStdzIL215oacm6lxSpGasTauK7iuaztS5ZKq
	qtmYwAaeNCGOU6Fd5Mo2lu+e+2PrMRAjUmoZIQmEeRCQCC6xUnNeOE4l6cO/nfoQHnuidIp
	lVWeeVupuuIzToi4AURvbWT95mVr1nE5QzqEyZ0jHHD6RpkoUwnYh8gJpJr++iyhfN3RPRb
	XtdheDT2SfEzZcsDzta7vfaNuBC2bTtItR/zLZRkINJlt18HipQciGcsT6mElpKQGFPsqlL
	uDWMSb7TBTegoMUAfWdUX8ko/zQ3YBs3qHwgy109EjCg0KcWkKJe5QWDmNY0F+5P6Kxgq9Q
	sBDy/K8tXUZi2Q8xGwObqL8v4sMknq4wARUyvib8Y7ADGbfbCoBeTlt2REJi7AFm8+O4cz6
	g2wh7xYZj4cBlpM2uPt2WP3oySA/34Un10acdwQgD8t1adr0UbZCyyYdZuw0k81+q9r1Zfc
	g7+CebBlR02sWFknRhYGV/5gMkX/MlB2WwuxReMo6lK3bezogy8ILj0wFjbJPl6D7747ubM
	QSTPq364OX+umZ0mskpcpoz13Hi8RUG24Pkp1QTprSSSicZ9p4YCkRv+Gbznf6C7hFz9HGI
	YKCU8bCkK/X47Z9T0n0vaai9jPnO4QI1bpQwv/oFefo4heuE/inrc0kVvP70dpUS7EuPXfk
	FSTesss53s/B78fboLLkMXihj6J69eeaBVoNMHPlcdZeiQV1oZkHlUiSFWRVlfknqvts+JX
	31iM8bgTC5LZDvcBtMKGCUOTXfrEE=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

Thanks for the review.

I agree.  I'll rework it to keep the existing page-cache insertion and
locking order, and handle the not-uptodate folio case by retrying the
read as suggested.

Thanks,
Yichong
