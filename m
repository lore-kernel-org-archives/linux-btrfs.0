Received: from mxex1.tik.uni-stuttgart.de (mxex1.tik.uni-stuttgart.de [129.69.192.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04AB466B6E
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 10:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.69.192.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788777761; cv=none; b=Ax31Grdvgi1SDYTIm3K85OvAQ2ko6bJYeU///hTCsjGQka53H6OSIwTwll1a/y5aE75J7FT08dH1uiSo59vtiyEntOXlIdS6U7BDknCdPB20Qonwm9zcHLJy0dj/O4xi7Z5ATEMH6E+jLI/0IODg37P+LXLdjqhr4lRasm/2IBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788777761; c=relaxed/simple;
	bh=xMzjVAOnawh00qIQF8MTw0VurZlYsC/y55LYjHctNMI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IW6LsU5TcGgh6vj0gdoYwqAPbQ2MkNZn6joCjWGLeFXVh/HXLasfyfyBCV+OW2lwzyQPiGqvMEOOWzIq42aJi3pllJKEFSYAWslZ4MfdNWKW2MPMcdIlZgsTyiJvHRfctWdyKGjAhZ6Wzs0IipwyLzuKleNJ1aguBDee/SNX354=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de; spf=pass smtp.mailfrom=rus.uni-stuttgart.de; dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b=h+zf82wj; arc=none smtp.client-ip=129.69.192.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b="h+zf82wj"
Received: from localhost (localhost [127.0.0.1])
	by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTP id BADDF608D1
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 12:33:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
	 h=user-agent:content-disposition:content-type:content-type
	:mime-version:message-id:subject:subject:from:from:date:date; s=
	dkim; i=@rus.uni-stuttgart.de; t=1788777219; x=1790516020; bh=xM
	zjVAOnawh00qIQF8MTw0VurZlYsC/y55LYjHctNMI=; b=h+zf82wj3oxTxxlHtI
	Q4y6lWLgXcnyiVFMRZ78n5uacVIPLpPzg0rcWZFWxQsadewU/yomusNy/Y/yUotF
	ybK3xdA6VSJJ3twjR8WVACiGGVuWbSziWXvswn+M5wm1ttpJ+yKQYhY6+WM3z9Cd
	Itcl4qRi2ZcvreR/a7jYFcREM/lc3iL+0bnk0AzTyREFdJm7WhjQOEnYTAiVYfz8
	MkziLJQQesklCl5ODR47O629a5IRdH4Zc45xyM6IkakMrqyfSg28jFIpuAuMP1Qb
	qcVVdBFVDDNnKcFzgr6/YjAscmGfOmtQ8TpUZtSd8Hoj7Dh4vTQEAe7Dk0GLQW+b
	We7Q==
X-Virus-Scanned: USTUTT mailrelay AV services at mxex1.tik.uni-stuttgart.de
Received: from mxex1.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex1.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id 2dDrDIwM_BJ8 for <linux-btrfs@vger.kernel.org>;
 Mon,  7 Sep 2026 12:33:39 +0200 (CEST)
Received: from authenticated client
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Date: Mon, 7 Sep 2026 12:33:39 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: How to exclude other filesystems but include subvolumes?
Message-ID: <20260907103339.GA786966@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)


Many programs like find, tar, rsync, cp, du, etc have options to exclude
other filesystems, eg rsync: 
  --one-file-system, -x    don't cross filesystem boundaries

But this also excludes subvolumes, which are in the same filesystem.

How can I address a btrfs filesystem with all subvolumes, but exclude
other filesystems?

Example: I want to copy the / filesystem (with all subvolumes), what is the
best solution (for scripting!)?


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    https://www.tik.uni-stuttgart.de/
REF:<20260907103339.GA786966@tik.uni-stuttgart.de>
