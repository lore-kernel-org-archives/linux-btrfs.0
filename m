Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703408460
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 02:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781489286; cv=none; b=UhpZcP47qE+IHWmHGjkrgIJK3K4sdBJLQhYVxc7PGBaYXodpp43L89aeqyUJfjcqTtKSDGL1J9ZZAIm0V3KnwiTtdrX2Qb83aiBXJFm0NY6eLHMloKKMuDGVO/JgmZzjL5TUEwsN2QrYqMU87yV0hHZzVPt3wF1GjFSCj6CGYrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781489286; c=relaxed/simple;
	bh=NtZZ7Aee2GzuZjJLG0r/7kwzvqpMeCHJYoAAy0Tf9zE=;
	h=MIME-Version:Date:From:To:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=WgSbUUKece6/GDWc56U0n1IH4AjCDAPSU3vJ0QaKLHuAQPmkLDzC3DI59EcjPDf5khfbXcuZIQi3DziDnxBiokq8wJ/t9TCb/a08PxWOJWYtSHSCdKEZUIgFZ4Hd5QV8kmQQat70Zmt794j3zaLnsznkbJKy/fbcLAWQ7pg3oNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com; spf=pass smtp.mailfrom=colorremedies.com; dkim=pass (2048-bit key) header.d=colorremedies.com header.i=@colorremedies.com header.b=AboF+f8j; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fSPVsiy7; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies.com header.i=@colorremedies.com header.b="AboF+f8j";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fSPVsiy7"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 87669140002E;
	Sun, 14 Jun 2026 22:08:03 -0400 (EDT)
Received: from phl-imap-01 ([10.202.2.91])
  by phl-compute-01.internal (MEProxy); Sun, 14 Jun 2026 22:08:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	colorremedies.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to; s=fm2; t=1781489283; x=1781575683; bh=UvN2KkeUP43ydRoRVQgHZ
	1sHjs5gTPpq+y3pCqd/gL0=; b=AboF+f8jDrs+ecjSb/dcrlfxZzD2DlRY84SGI
	0SuXieexcFGNVhNJs9u3i5UY5nXKDq8qKTKan7a7OAe3PKdAmyiD0bMU9jI2LaE8
	2Bh4qIOCZfeLXu5eEKcu2aJZsBkzJc8DVM/QC/vMD2x/XH8aPHmgVJkFFLbD25sv
	qzcLU2S83luJeha+aelQ1iAma1YbUPA2/xVTcd5SFG5NU7gVKTttkfvEKPB3WsuN
	8hoeuK+vRaN52V/1zu2NlxGNuMx+t8HEwRXgSczEzkvQt0DJLpFnwROM9DpyDyj0
	PWEejKCu9tbRDyf0dHghuMJwEojmCZVOoLu7uuOZYU3WEVu3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1781489283; x=1781575683; bh=U
	vN2KkeUP43ydRoRVQgHZ1sHjs5gTPpq+y3pCqd/gL0=; b=fSPVsiy7ueZ7kLEVp
	YIeUxlfkDgmOXGt5Vy9ycruZCzIgQLWgyVDlwcVvwg7BpCj2JlhyEivQLmmzlMOa
	6GIcIc3IVXuplj4WeENqhDcW76M+4NLFunDDCHf5jnV8jLtZv7WaYGyKgwmkh/ow
	FG0SSKFBdI3tQyZ3+JxBK/gR69dpzWh/i6weGcCCYWJn7+67wCdb6ZLsakcuzx5H
	IziDFGsw8BsQznHSnywMo51RWNHVD3u8YrxMHpfP4Rz0PRTGVB185mKi38u8eSq0
	rncFdTBO21XdSsnBLLw8wsqk6mJOb+ReOqjp2k/UaGmxDufOJ698Jmj4pWU8mb4C
	5wdxA==
X-ME-Sender: <xms:g14vamk2Hw5abb5gDp8niMaOFHFqZOCo-pkj0IWIzLYiy2FmxUEAcw>
    <xme:g14vaopUhyCRjvuGvqDsXSaNh46TT17gN1wCctp6LLH-1Nh-0G7uOF4JJ8rYCNzUK
    5FTGE9xuPXxl5c8X2Mmu1jmp5uYcNLWVcWNn2-7lXGEDG5rfT1KXcog>
X-ME-Proxy-Cause: dmFkZTFbLmAHIHT6oYk0fgFP53FIVBpYcRLdnlXO6xnoqx/YqxP585zG9I2lTAfqcGhGxF
    mYtAdvL20onXdNWpylOalJ8nz1x34uDTyqyYXWpp16ZvOjg1fczqqOKZqNOX9Ws8+G726t
    tx/bZeEk8lmx2aOaxTd7bh7TSh57TMMce9OeJ2fYlPkQFV//wA7/7AeQ8bk21rQk4dta/M
    XMF3WQuzvn1qkg16iLF22dGGnFmRxIry4TizNqaw/aMtt3nlYnvd8tuyr3MrLMFevyQKmT
    JEzGLc118U+Xp1/VsRUzatbRFo/oibYNWBdzPrhlJJGteqKu3SdsJ02XxA8HmO/MSUrDqK
    7m/qrihP7sBMaQXsxCnkk1pYIHNfwdAJFOnS2EIMWyCVK5hB299siDMpW6O1ZyaqQZkxBS
    GcWuIgwK2xKa4bio14gUIsKJ4ECixhtRmLrROKZAbG6/oFRtzO+51lPf/ju3z/H+KG9Wmy
    mqkjg7fKilsWgarEGSZS2cFNorrSDb1JAoLZtyKOCKUg4tfztcY0AqoYJnAW/oLcdA7c0i
    q9aDWOT/iruIHdrgPVr/xL/nq9jpW+qYeLM9uc2eju8TRcnC/ruAFn9WDDxmmIOa8xGv8l
    TeVtwnQfPzJ9K54FzH8NPm8W744plD7Sd0aYqtSt1oBPI4bSvPrZj+9kTcFw
X-ME-Proxy: <xmx:g14varji1KlVL2B5LZ3NqHYsGSPW57ezXWFz49CRLKGWVB_hDyqxMA>
    <xmx:g14vavxbwA3G9a5HAmQ3M2BB7cLuneIZNGAtgizVChjkuBFzkrD1vw>
    <xmx:g14vauINPWwt3OrF6Zqti-2vmqQQYNajeDx8SEr2deyxh877wZzm3A>
    <xmx:g14vamR2YcPoDzuw-2A2euiFyf5cPZTUhRxkyARCSKFy1c1jVJYtoA>
    <xmx:g14vagXvib1dHn6w1nTUmv6eRdwbbnWVe8Bb7H14u8jTb7LqiMWcAmfp>
Feedback-ID: i06494636:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 523C918C0067; Sun, 14 Jun 2026 22:08:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A0sQEpqRO37s
Date: Sun, 14 Jun 2026 20:07:43 -0600
From: "Chris Murphy" <lists@colorremedies.com>
To: "Alban Browaeys" <alban.browaeys@gmail.com>,
 "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>, "Qu WenRuo" <wqu@suse.com>
Message-Id: <791bf200-b3b8-4811-bdf7-3ceaadb9a4f3@app.fastmail.com>
In-Reply-To: <a0df776c-63a3-4ff8-afb5-dc6bce8768c9@gmail.com>
References: <068e841a-37fd-4fe5-ba2d-0ab93c55830d@gmail.com>
 <abd33b32-aadf-4206-81bc-c2c7832e13dd@gmail.com>
 <43f6ea2b-8b23-49c1-acfe-1d2617f28132@app.fastmail.com>
 <28d08133-999f-4d43-9cd5-67b856246687@gmail.com>
 <f519b8d1-f6d0-4975-9301-74571e87436f@gmail.com>
 <a0df776c-63a3-4ff8-afb5-dc6bce8768c9@gmail.com>
Subject: Re: Btrfs ENOSPC / Stuck in RO with "exclusive operation balance paused in
 progress"
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sun, Jun 14, 2026, at 6:25 PM, Alban Browaeys wrote:
> Hi,
>
> I had space after the sdb3 btrfs /var partition, a 9GB swap partition. I 
> deleted this swap partition and expanded the sdb3 btrfs size with parted
> But I don't seem to be able to expand the btrfs filesystem inside sdb3 
> if I cannot mount it read write, is it so? Or is it only due to my 
> pending operation?

If the file system goes read-only it cannot be modified at all, including resize.


> Can I get this btrfs partition back?

I think there's a bug. I do know know if the bug wrote confusion to disk, but either way the current kernel code can't handle it so it's a bug. One of your dmesg contained this

>[ 1084.779326] BTRFS info (device sdb3 state A): space_info METADATA (sub-group id 0) has -190382080 free, is full

Can you run 'btrfs check --readonly' on this file system?

My recommendation is to stop mounting it rw. Only mount it ro. The more it is changed the worse the problem is likely to get.


> Is there a way to copy the content of the partition mounted in ro in its 
> current state, create a new partition and copy the content back to it?

mount -o ro

Then use rsync -a or cp -a

I think that's safest.

The other option I was suggesting might make it possible to fix, but I've never been able to try it in a case like what you're experiencing so it's entirely untested and therefore risky.

btrfstune -S1

This *changes the file system* therefore it's a risk. But I think it's a minimal change to just the superblock to make the file system a read-only seed device. This is the only exception to the rule that  you cannot add a device when a Btrfs is read-only. It is possible to add a device to a  seed device. But the unintuitive part is how to make it read-write.

btrfstune -S1 $device1
mount $device1 /mnt
btrfs device add $device2 /mnt
mount -o remount,rw /mnt

This is now a two device Btrfs file system. The seed device remains read-only. The second device receives all the writes/changes as a feature of COW. In effect it's a kind of overlay.

What I'm suggesting is if you now do:

btrfs device remove $device1 /mnt

This tells the btrfs kernel code to replicate the contents of device1 onto device2. This command will not complete until the replication is complete, which could take hours (no idea, depends on how full the file system is). 

$device2 size needs to be at least as much as the used amount for $device1.

> There are docker subvolumes on it wich seems they can be recreated by 
> docker later on (I hope so) so rsync might be an option but if the 
> docker subvolume need to be backed up rsync is not able to backup them 
> correctly.

I do not know to what degree the docker btrfs graph driver uses reflinks. Using rsync or cp might dramatically explode the amount of storage needed. It could be docker usage is part of the problem if the problem is at all related to bookend extents. I seem to recall that docker graph driver does result in substantial amounts of bookend extents.


> And btrfs restore gives me thousands of

Btrfs restore may not help. It's a scraping tool. It's designed to get data out at all costs, even permitting extraction of corrupt files. It won't prefer reflinks or snapshots.

>
> Also should I expect this behavior to happen everytime I do a btrfs 
> filessytem conversion without checking I have enough metadata space 
> available beforehand or will this be prevented by some new code one day ?

This is always the hard part about file systems. Computers are ordinarily deterministic. But file systems are increasingly non-deterministic as they age. And once you hit the bug, the state of the file system has already changed making it important to stop making all changes to the file system in order to preserve that state for file system developers. The more we hammer on trying to fix it, it's like a crime scene being cleaned up or tampered with. It makes it impossible for the developers to understand what happened and therefore how to fix it so it doesn't happen again.



-- 
Chris Murphy
