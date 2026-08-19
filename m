Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4014282F3A
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 02:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787105935; cv=none; b=QL8RPXAuqu08HwbA7E/IdUqSuG4G459duJi55iM3JlsEVKDqk4VS65VA2+GE2Nc5c5IIvssyzThMwlsZXcLH1qWrlWvB7zcmRtmebdTpj+l2hYpfEYi+N0tFi4iTgUGw+GsIUUFa0YZ/WvpElZ6/Jy2mm5B/mSr2L1Wb5/olfQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787105935; c=relaxed/simple;
	bh=42sXykUSSx9qskACjAaDNZkCOYY7XmLBjxVNIfmer5s=;
	h=MIME-Version:Date:From:To:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=jVhuR7ig+45Hm+U1NG8XP3Ruqn/Jy20o8Q41LqlfdASHZiPyvTW+YREiZXMCaJrFzSI/qJJrYt0IjZQD5rG7bAoxOXyNFsFt5LGnUEVvl/BeHuRmYCqEhhrxb+7+gfBk5HdEz0r8WYzEq1VaJBhUIqBH/TxIJQLt33D1olQU7g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com; spf=pass smtp.mailfrom=colorremedies.com; dkim=pass (2048-bit key) header.d=colorremedies.com header.i=@colorremedies.com header.b=EQve+Oqt; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gm4zUPRw; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies.com header.i=@colorremedies.com header.b="EQve+Oqt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gm4zUPRw"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CBC2114001A1;
	Tue, 18 Aug 2026 22:18:51 -0400 (EDT)
Received: from phl-imap-01 ([10.202.2.91])
  by phl-compute-01.internal (MEProxy); Tue, 18 Aug 2026 22:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	colorremedies.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to; s=fm1; t=1787105931; x=1787192331; bh=u4FOFf/s4K6iaZOv6GbuB
	cJfPFQmeqsafSw2jEJMksY=; b=EQve+OqtQ0cmOFgdm53NcdXp872N61TyDIa7+
	PjEuGr7aeNEH/Jc+QCFUprQLq+JHVVNJD9f131g9UyLTJOF5AyNVe4vSikGDV7ly
	BXNfq2e+WKNMqnhhfDbAF/PvY5B6jkGiVvsWPlpMAG7H3BpiYMnEQ+fPfpl8vvcZ
	GP35cDEt1TdD5G3qphPB9+cQyS1iGMB5VdgOcDZrI0tF9HfvcLBnl9HCMZFvXxwc
	BYf9YAM3ELILhQFNQEEs72ElqBWmQWDG2FX7rfUZvoIeHoOnj+V54kymGzLb4N46
	hQ8riZXeUxgp1Vqtt0ybJwBq8uOsasBW8EDM4cj6tqVWvcWJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1787105931; x=1787192331; bh=u
	4FOFf/s4K6iaZOv6GbuBcJfPFQmeqsafSw2jEJMksY=; b=gm4zUPRwF+pfwtAgw
	Go37gPUMOk/c7YA2ScgShDRRpUD5tEjt6V59yHV9hCklU/yO8A2DSUGEyA0Fv0q1
	j4TmdtENwxlPelA9HIQV5h7RJAqfazKFZXmlAO85Aeka88zhTFBLIJwsUYnevp9A
	ZSVJoiJ8tI/+UlQKnqHzwprqCYtLjxOIKuvMU8ekxgGd0zGsBeXXERS/U5HvYHwr
	ZXo2oTp7X+jTr+vJTkuRvdGZP8yGQIcfFfN6VNL9nPwYr7QU1ksxuXqNK+j1Ujcn
	8jax25v3s1UlAIXYy2KKAfpLVe/9W19ZJv18v6rdSh5he2XitQpWDSA6PukrSjpi
	AvQ6A==
X-ME-Sender: <xms:ixKFasMFMKA_6iKam5Yi5TfDtcjspYuqDWvHNQfJQJ54_JN7C8VUrw>
    <xme:ixKFatx58p4okTBQj3CChFnMpw4ET_YeQROK7GKMnZIEVJlkFmxDnVZdog25b4Lbe
    YK8baLbePP8fEC0FDgQFZZHo2W2saBtPtEcJUFGhg1EC7uoEzxI6kk>
X-ME-Proxy-Cause: dmFkZTGJAnQebNQfj275s6QUk0SynzPzdEaqk4a8nJP+k2h+BFIoftOmeo2F4Bjbd9xBZd
    1i8PehH7Fgx4JHfZSYbhGc193/IdcPByL7zG5MUGDgINa+GvAzDhegzK3h6un+QMllO0YO
    xqJ97C0jXjgVR+VWaN6cpWsNsiZSLjY3Ni4i4BgWBO6frHfbBvSkz1xvBz7jLfGMpQtCCr
    xsugUipqwvRORvWSvOqjotVaCkcaA5l8gky5EvaqstIzeaYRx4DReBrIIkayPbLLYnXPMl
    lhrpCVFPUcaYrd0YD8/viBAs5ZT95JjiCwf2wS0/+j0frZ3vFahRI4STJ1dp8dVUoGQjt0
    oBQvBvckIewYjgaAK8oqHFd9vpUbtke7FiTwUzeo+7+zv4XbBOZWXjUHpiwI8Ra9tV4Zwz
    irvhVONTug1GojtySw/gmozee1Y6g1e4TMnkXOCg+CZczRchsDbQq/4P9/1bHXHnmKjYbH
    4PK5HTttxk7CJDNPUKVUOM5kYPEAyY9VtapAsSK0hdzEvL+gANuIDDCewUAYVb+e94zvoN
    fwIFDLvKlhRGV8p8jxXvaSmZ8EO8Jeft+BboTYq9dz4wALwfN87XOn5edyiyOEt8//FueZ
    G3XjZuPdlXs3ONzpdn+txyRP78g1flVPKiY4759ItA92gSasSs17NR2bQ2zg
X-ME-Proxy: <xmx:ixKFaq5j48PFYdUpGrbKddwUgEVvaq6TRqmEqHY1ap_KrIcfIqWhJg>
    <xmx:ixKFah0OoqMZsz6ZHQY068x-S8Us11L1ipe8kNETIC-lJ0xlE29eXw>
    <xmx:ixKFahCOMFemcAK7txrZZ9EhaRaOzrIjF6FviipYakfl0NjyZxuuXw>
    <xmx:ixKFaj3IpjP51rxsNuzJMi8l0Suq9WsPl78FVKfsgEHzYDBM_eaNng>
    <xmx:ixKFaiillAy_-jd50Jqp8Mtc4ittJXEP3UtlQ_a285XrVJQvPJ1IjAhz>
Feedback-ID: i06494636:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 835E918C0067; Tue, 18 Aug 2026 22:18:51 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AZN6E3htsR6w
Date: Tue, 18 Aug 2026 20:18:31 -0600
From: "Chris Murphy" <lists@colorremedies.com>
To: "Alex Writing" <alex.writing.things@gmail.com>,
 "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Message-Id: <673ac50d-75c2-4416-bad6-8f4d2f253ce2@app.fastmail.com>
In-Reply-To: 
 <CAD0nGLtyhz=M-97M4YowUpGpt+b5OBhD9fJZCx3e1hU1JYXemg@mail.gmail.com>
References: 
 <CAD0nGLtyhz=M-97M4YowUpGpt+b5OBhD9fJZCx3e1hU1JYXemg@mail.gmail.com>
Subject: Re: Space cache rebuild failed and reports fs corrupted
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, Aug 11, 2026, at 12:00 AM, Alex Writing wrote:
> Hi, I just updated from Proxmox 8 to Proxmox 9, which updates from
> Debian 12 to Debian 13. The new kernel is a Proxmox-specific build of
> 7.0.14. btrfs-progs version is the latest version Proxmox provides,
> 6.14.
>
> After the update, my btrfs RAID1 HDD array failed to mount
> automatically at boot because it was timing out; it now takes 90-120
> seconds to mount the array for some reason. I turned on debugging and
> there are lots of lines like this during the delay:
>
> [Mon Aug 10 17:47:28 2026] BTRFS debug (device sdb1):
> btrfs_submit_dev_bio: rw 0 0x1000, sector=1924895456, dev=8388625
> (/dev/sdb1 id 2), size=16384
> [Mon Aug 10 17:47:28 2026] BTRFS debug (device sdb1):
> btrfs_submit_dev_bio: rw 0 0x1000, sector=5154454848, dev=8388625
> (/dev/sdb1 id 2), size=16384
>
> I read something online that suggested clearing the space cache. I
> tried that, which ran for about 15 minutes but then failed:

I am not a developer but they might want to know working kernel version, the failing kernel version, and the btrfs-progs version.

And then the exact command used to clear space cache. And mount options.



> btrfs check reports "errors found in extent allocation tree or chunk
> allocation" in the checking extents phase (mostly root 10 but a few in
> root 1 and root 4), and in the "checking free space tree" phase
> reports "could not load free space tree: No such file or directory"
> which makes sense since the space tree rebuild failed. It doesn't
> report any issues in any other phase.

Free space tree is the inverse of the extent tree. If free space tree is corrupt or needs to be replaced, then the extent tree needs to be consistent. If it has inconsistency it's a big problem for future writability of the file system because writing Btrfs is complex.

Whereas reads make no changes, and depend primarily on file tree.


>
> Here's the full btrfs check output: https://pastebin.com/XZFHLLvd

That looks bad.

Anyway, I suggest using the file system only in read-only mode and not attempt repair. It's not merely that they can make things worse but it quickly changes the file system state and makes it difficult for a developer to offer an opinion or possible fix.



> The logs show that one of the drives dropped out briefly during the
> btrfs check, so I'm guessing there may be a flaky cable or SATA port
> that might be the root cause of the issue. I'll also probably run a
> memtest before doing much more to it.

Definitely do a memtest as a first step, or memtester. And then do a scrub. Scrub can fix many more issues when data and metadata are raid1.



-- 
Chris Murphy
