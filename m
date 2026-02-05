Received: from mxex1.tik.uni-stuttgart.de (mxex1.tik.uni-stuttgart.de [129.69.192.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6723281376
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Feb 2026 23:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.69.192.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770334917; cv=none; b=qMH18kC2uSOh5e2jWEPk+FyZn4vyaR1PVuLWvjOLyi/wbsrX72+7f+UI2q9O12OGWNF5k7dLpnyX1WKGcHq+2GvBr24GZi9gI3NFM4zTwh0UQC8EPoE+scUfjf9534JFwDjgnsA02GFz9ub1pdX0diWqXcNpqTQUHpkE0jJOJ+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770334917; c=relaxed/simple;
	bh=iZrwrERHa9sAdXfuPz3WDiLTByCKO4AumEvdnIvxccg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yai5GM2KMnE9flnMN9AgOvLqIJh4EBWwCDXNF3w4KcIM+NknIKPP8XSYbgJbEzoqTNsVnVyoItjPrToEc02VqULFAr5EbVm1Ie1I6IlnqGJWTKEWKxDmqx3iKpbisKEzD7CXH3ZjEWEubDgjCPRE3foaOBIP286/Z45HNyEtwbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de; spf=pass smtp.mailfrom=rus.uni-stuttgart.de; dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b=boiQBcIm; arc=none smtp.client-ip=129.69.192.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b="boiQBcIm"
Received: from localhost (localhost [127.0.0.1])
	by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTP id E4E4160F73
	for <linux-btrfs@vger.kernel.org>; Fri, 06 Feb 2026 00:41:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
	 h=user-agent:in-reply-to:content-disposition:content-type
	:content-type:mime-version:references:message-id:subject:subject
	:from:from:date:date; s=dkim; i=@rus.uni-stuttgart.de; t=
	1770334910; x=1772073711; bh=iZrwrERHa9sAdXfuPz3WDiLTByCKO4AumEv
	dnIvxccg=; b=boiQBcImhy2sfjE9Qdz6UtDDnireAjkGpRS7BOhYIfqEfq+aOfK
	fXw5MnmiMYNYr1E20i8Uo5VN39/Scdx/l6BEF7PKbd334umRrxHSBgm/wQQ4V11E
	4JJKIBYX2aw3kX76Ouilfs7snOKwl33fkWQDf7pKbk8HCHlozrnURnz0PaCOKTY1
	fNND2zdKCmNWHeZgaPTN26wVfzb7bQSxwiVvg6CZTsKet7Hgf66U9fVfqMXNJEOQ
	IoPbRLkf6keyvhYM/vNq9VehvsDIin0bvMNVr4ubRuy81uUKgSlfVF05xfzaG0Cg
	mYxwXXhzFwFMRbNlJiFs8MsgGC64RdkggZQ==
X-Virus-Scanned: USTUTT mailrelay AV services at mxex1.tik.uni-stuttgart.de
Received: from mxex1.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex1.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id yQJO_tFRpOrx for <linux-btrfs@vger.kernel.org>;
 Fri,  6 Feb 2026 00:41:50 +0100 (CET)
Received: from authenticated client
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Date: Fri, 6 Feb 2026 00:41:50 +0100
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: critical target error?
Message-ID: <20260205234150.GB5656@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
References: <20260205141205.GA5656@tik.uni-stuttgart.de>
 <a1f42d52-9ca5-4b6f-b2ae-4a63b0f443cc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1f42d52-9ca5-4b6f-b2ae-4a63b0f443cc@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)

On Thu 2026-02-05 (21:01), Andrei Borzenkov wrote:

> > 2026-02-05 14:56:44 kernel: critical target error, dev sdg, sector 27160 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0
> >
> > A media error is highly implausible, because sdg is a ESX virtual disk on a
> > high redundant Netapp fileserver.
> > Maybe an internal btrfs problem?
> 
> Kernel attempted to discard unused blocks (you use the option "discard")
> and decided to use WRITE_SAME SCSI command that the disk rejected. It is
> completely unrelated to the btrfs; normally SCSI device should report
> what features it supports. Either your device lies or there is a bug in
> sd driver resulting in selecting the wrong discard method or parameters
> of it.

I have no explicit discard option in /etc/fstab :

root@fex:# grep /spool /etc/fstab 
LABEL=spool  /spool btrfs   user_subvol_rm_allowed  0 2

But:

root@fex:# grep /spool /proc/mounts 
/dev/sdg /spool btrfs rw,relatime,discard=async,space_cache=v2,user_subvol_rm_allowed,subvolid=5,subvol=/ 0 0

Shall I add nodiscard to the btrfs mount options in /etc/fstab?
Or can I simply ignore this error?


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    https://www.tik.uni-stuttgart.de/
REF:<a1f42d52-9ca5-4b6f-b2ae-4a63b0f443cc@gmail.com>
