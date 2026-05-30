Received: from mx15lb.world4you.com (mx15lb.world4you.com [81.19.149.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BACB221FCD
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 00:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.19.149.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780101004; cv=none; b=Aep2fhhaDw48mbsdSZmcO1mc8tBFfa1HN8s0Kk9mkd5ZpLe+01b2DwaBkT/oAuTqG6gwzRzdcxG31bCQs03aMn0J+ONHr1yZOSCXl+3M842ZpPHo6gZ8mcCxU6YNq41vXdYId8nRuqbLM8290sdHHHniQjRLLCV1HfCN0/tbIF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780101004; c=relaxed/simple;
	bh=lrqESvHtzVxCup20IfhPY4UgohEb5gDozIQ+3qU99Q8=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=pK14v6J84B1iQEU/PxuuoxI1cdvNZmajF5ouqdsZ9W2Fm7zRIy5sK70YQXELR/VyQNU7YDXgQe3uXCjCTuLz5QxG6vHjV2NpuHlbTcv3+1Q6K3/h2LtBAO7qN3L2l/AFXJ5fbotVhbRTEBYzRIdiLuY9arjPC5M7jPooQRbEBCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com; spf=pass smtp.mailfrom=bluemole.com; dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b=BK0okka+; arc=none smtp.client-ip=81.19.149.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bluemole.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b="BK0okka+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bluemole.com; s=dkim11; h=To:Date:Message-Id:Subject:Mime-Version:
	Content-Transfer-Encoding:Content-Type:From:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nyyHLvjKKiEIquoUrBFg6dGnDULpMyx+VjYRmRLZxjk=; b=BK0okka+kun5K3Q2Bi1digweIZ
	olkKtxVPbmTuXEB3MdOE0TogHlx8o6f3PBvBuM+YGkgKp+wOXM8d3e2PywLeos9RAbdousq7Hkx4W
	ic0k/vlGu+Vy5X1UrfuoSv9SS+tfq8L53NP+Lqnl9+1cCJIgZ9y1cnm7ntQSVn3d/hPZYL8xic+Lv
	EywubUH5xw6F5A3CEUOpQNtDC17xxjE1VqXGIsDElVY4mPBQaBI60SSaqlQxr2Uu/LRA2mBa9ZHqR
	EY+LUZ2JprIbvpNlqtKGIJDovqUn/OJmHh5thVdCu5E/f2a1itjG2aPqSircuk/CBdxa2jAjxtVkT
	F0piaVrw==;
Received: from [41.66.99.8] (helo=smtpclient.apple)
	by mx15lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <ubu@bluemole.com>)
	id 1wT7Qq-000000004US-2b72
	for linux-btrfs@vger.kernel.org;
	Sat, 30 May 2026 02:20:04 +0200
From: Michael Zacherl <ubu@bluemole.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.10\))
Subject: scrub error & discrepancy 
Message-Id: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
Date: Sat, 30 May 2026 02:19:53 +0200
To: linux-btrfs@vger.kernel.org
X-Mailer: Apple Mail (2.3776.700.51.11.10)
X-AV-Do-Run: Yes

Hello, I did a routine scrub on the offline root fs of a notebook =
(EndeavourOS, Arch based).

This is the output:

$ sudo btrfs scrub start -B /mnt
Starting scrub on devid 1
scrub done for 44cb181f-faf6-48c2-a462-904cfe493576
Scrub started:    Fri May 29 23:54:53 2026
Status:           finished
Duration:         0:10:23
Total to scrub:   911.45GiB
Rate:             1.46GiB/s
Error summary:    csum=3D18
  Corrected:      0
  Uncorrectable:  18
  Unverified:     0
ERROR: there are 1 uncorrectable errors

Last line vs. "Uncorrectable:  18=E2=80=9D ..
How would I deal with that?

Thank you, Michael.=
