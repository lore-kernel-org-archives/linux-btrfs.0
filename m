Received: from mxex1.tik.uni-stuttgart.de (mxex1.tik.uni-stuttgart.de [129.69.192.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674F1175A94
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2026 23:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.69.192.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782690159; cv=none; b=AfB6ycklmSyctbIFf5dRlcpIQN0ipE7ZGifChAfwm9YvQc8+cIDCY0q2wVpRdxgwCBFsVi7Lch9mPsKhqMDsrrtnNy9YjjaSn5+wD36F2VvC9rzmRyTYNvJW+hllNwmbhgtB9D8Tg/cVq1mvWtEmH9yI+usH7NCl+nbUGNPQKs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782690159; c=relaxed/simple;
	bh=EMlkZILCNeibyvUWq/FvJtNsoOaLz0NA/G+LCx3EcvI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uo9jqpd8RyNEOHv8/wTfr+Kmi64gsn37N3VL2cmC5UHTpgG/FaakPpk5dG7O/nlG0LaZhl/Tbz5pXkPa6pGeVc7m3DSplWmrQRcPcIEu+b8pfhBsAjiIXZ7kNiEwsZTTKCL5rhAKJ6yWERyONlg24Xro4j3fNQ21yejoJ+iMvFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de; spf=pass smtp.mailfrom=rus.uni-stuttgart.de; dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b=hz2pId2e; arc=none smtp.client-ip=129.69.192.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b="hz2pId2e"
Received: from localhost (localhost [127.0.0.1])
	by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTP id 727F0603C9
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 01:37:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
	 h=user-agent:content-disposition:content-type:content-type
	:mime-version:message-id:subject:subject:from:from:date:date; s=
	dkim; i=@rus.uni-stuttgart.de; t=1782689818; x=1784428619; bh=EM
	lkZILCNeibyvUWq/FvJtNsoOaLz0NA/G+LCx3EcvI=; b=hz2pId2eojhE1JHyBn
	1AfBVDHEFUWoN0/v4ekBsM3MqS84jbJCQwyxLwlTEeBncXgyxHNGfUXefdHT3Akb
	WmdqqED5VcVI8EsTLdiB+gPp+L9xLyWMPyu5r1Z5M8rZ93ZNwDUFSd7tZPxbSBU0
	SW0cXv/iBq4F6Xe2+vL/e6zw5MpWBF1kZ6CNYz8NhyaGom7/IxgiybsH71Hf+UEp
	biHC/aN3BmnEG+nXgHKxvS/xRV/w7LygkdZU9et1H6KiXCganX6xwY8GCwm4J2Wq
	7GXwkUPDA5l8/j2pL9AhPhFQ549JRwLGOrAm0QHbC6h6s/mCIHIv6Uo7hIniax14
	QQGA==
X-Virus-Scanned: USTUTT mailrelay AV services at mxex1.tik.uni-stuttgart.de
Received: from mxex1.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex1.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id Tvtf0B6-abAs for <linux-btrfs@vger.kernel.org>;
 Mon, 29 Jun 2026 01:36:58 +0200 (CEST)
Received: from authenticated client
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Date: Mon, 29 Jun 2026 01:36:58 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: shrink btrfs partition - recommended way?
Message-ID: <20260628233658.GA3404176@tik.uni-stuttgart.de>
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


Is there a recommended way (or tool) to shrink a btrfs partition?

I have:

root@zoo:~# lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS /dev/sdc
NAME    SIZE FSTYPE MOUNTPOINTS
sdc     256G
`-sdc1  256G btrfs  /LXC

root@zoo:~# df -Th /LXC
Filesystem     Type   Size  Used Avail Use% Mounted on
/dev/sdc1      btrfs  256G   19G  236G   8% /LXC

And want to shrink /dev/sdc1 to 200 GB

I know, I can use btrfs filesystem resize and afterwards use fdisk to
delete /dev/sdc1, create a new smaller /dev/sdc1 and then add a new
/dev/sdc2 
BUT if make a calculation error with fdisk the btrfs filesystem will be
damaged.
gparted can do it all together in one step, but it needs X11, which I do
not have on host zoo. I have only text console access, no X11.
                                       
-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    https://www.tik.uni-stuttgart.de/
REF:<20260628233658.GA3404176@tik.uni-stuttgart.de>
