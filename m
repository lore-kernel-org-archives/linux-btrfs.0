Received: from mxex1.tik.uni-stuttgart.de (mxex1.tik.uni-stuttgart.de [129.69.192.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C3631F9A0
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.69.192.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777019508; cv=none; b=JFYSD+aSq/uQrE7MxYN60iuhfCqfDb/Hk/3wMngXjDZlhOsnNguW0OBZsa2Hg4NO+C7V4hRU4EwiHvnPU2eakWXYJI+UUDVDJAtysU590ZSQdBgnCDXlz3sfGUnsTDpVU30V7kCSbko4so5Ya3TFUrgta9jSnDCVfbMt8yIWbic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777019508; c=relaxed/simple;
	bh=j/zzEnU47NMEhhYV6aRq9c6sRS+WV1EOV82rnByRKDA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=scklY7M7tuNS7Hu/sPQJGxAEs92XXPBrgboHADFsQ0cG7oL4fvl9UEGo5d5TdCE0lO3CfXwUSsjJ/3VSJg2s3RvgaUcPMhYhz2yYjGxvC/N7g9H44ny8Da9IHf5eqkDeShsNH1oJzuQDK4KP7PsulW8v6BYZUJ77CNxnZZqwYik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de; spf=pass smtp.mailfrom=rus.uni-stuttgart.de; dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b=x5HSJu3N; arc=none smtp.client-ip=129.69.192.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b="x5HSJu3N"
Received: from localhost (localhost [127.0.0.1])
	by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTP id 12AA160E7D
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 10:23:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
	 h=user-agent:in-reply-to:content-disposition:content-type
	:content-type:mime-version:references:message-id:subject:subject
	:from:from:date:date; s=dkim; i=@rus.uni-stuttgart.de; t=
	1777018981; x=1778757782; bh=j/zzEnU47NMEhhYV6aRq9c6sRS+WV1EOV82
	rnByRKDA=; b=x5HSJu3N27u//rNmjvtfBSHzhgE0Swkb1mTx/PD54+cgtf4B9Q0
	CfoUv8JzjbKVq4lMAaC1miOLPf2vV0fPD3ZNjmVNqM+xruKfALghTej9cVQXgixH
	PVLQZ8XWmOigHnj8Xkxuy1l3+0p0Dw8dHqCEz/4IHmGoAlRPPmytcCtx7wXZMwN1
	aEoguXMfV96sNJ0eJUsuJrRSpCdPMui675fqlPlRIof8eWRlIzsNNnB7jsw+N7oj
	gjQhPU6s01Xv3K2uK4ki8YpSXurnfqlBLKCRQpKACv/B2Nymt10ONCv+qRNtA+H8
	VvoCNeNKJhET517x+bKcF5XnODyVA09qIfQ==
X-Virus-Scanned: USTUTT mailrelay AV services at mxex1.tik.uni-stuttgart.de
Received: from mxex1.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex1.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id T7kUyIo6z7fU for <linux-btrfs@vger.kernel.org>;
 Fri, 24 Apr 2026 10:23:01 +0200 (CEST)
Received: from authenticated client
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Date: Fri, 24 Apr 2026 10:23:00 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Fixing a corrupted file system
Message-ID: <20260424082300.GA361238@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
References: <8c8e2466574b29ba1da29c325a108824c8373a85.camel@infradead.org>
 <fc202c52-cb3e-40b2-a80a-6ffda886f76b@suse.com>
 <571fb6a8-d4e7-42ed-9f19-22962163918d@app.fastmail.com>
 <87d1aca.ae41f579.19d4f977d95@tnonline.net>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d1aca.ae41f579.19d4f977d95@tnonline.net>
User-Agent: Mutt/1.5.23 (2014-03-12)


On Thu 2026-04-02 (21:07), Forza wrote:

> > I forget what mkfs version, but the default behaviour changed a few years ago so the default profile is Single on SSD's. (Correct me if this has since been reverted.)  Something about the way SSD's copy on write, the DUP entries would end up on the same physical block, so the redundancy was not effective.
> 
> It is the reverse. Since btrfs-progs 5.15, the default was changed to DUP for single device fs.
> 
> https://github.com/kdave/btrfs-progs/commit/65181c273e67bd48d01fc79f00826dce38b93c4c

I have some old btrfs filesystems with single metadata:

root@moep:~# btrfs filesystem df /
Data, single: total=23.01GiB, used=12.51GiB
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=1.75GiB, used=930.19MiB
GlobalReserve, single: total=42.06MiB, used=0.00B

root@moep:~# btrfs filesystem df /home
Data, single: total=95.01GiB, used=54.27GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=1.00GiB, used=293.70MiB
GlobalReserve, single: total=80.53MiB, used=0.00B

(How) can I convert /home to DUP for System and Metadata?
(/ looks good)

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    https://www.tik.uni-stuttgart.de/
REF:<87d1aca.ae41f579.19d4f977d95@tnonline.net>
