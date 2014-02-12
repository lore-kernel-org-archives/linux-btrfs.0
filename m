Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:62109 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaBLRQj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 12:16:39 -0500
Received: by mail-qa0-f44.google.com with SMTP id w5so14169707qac.17
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2014 09:16:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$9c91a$c8fe6c36$f85dce0f$d0a92204@cox.net>
References: <20140209224055.3175e70f@system>
	<191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com>
	<20140211041527.57ef96c4@system>
	<pan$e606d$929b6b8a$283bf1a2$38f7ec5@cox.net>
	<CAJbEPe44PoBQkovMz=-w=A4DYYS2vAVoS+29z7J8Q+xaQrYGXQ@mail.gmail.com>
	<pan$9c91a$c8fe6c36$f85dce0f$d0a92204@cox.net>
Date: Wed, 12 Feb 2014 18:16:38 +0100
Message-ID: <CAJbEPe6+3uH97z-oA-QCb-cCb_xDXb016YLP+gZM1wAdMk2KGw@mail.gmail.com>
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11 February 2014 21:35, Duncan <1i5t5.duncan@cox.net> wrote:
> Saint Germain posted on Tue, 11 Feb 2014 11:04:57 +0100 as excerpted:
>
>> The big problem I currently have is that based on your input, I hesitate
>> a lot on my partitioning scheme: should I use a dedicated /boot
>> partition or should I have one global BTRFS partition ?
>> It is not very clear in the doc (a lof of people used a dedicated /boot
>> because at that time, grub couldn't natively boot BTRFS it seems, but it
>> has changed).
>> Could you recommend a partitioning scheme for a simple RAID1 with 2
>> identical hard drives (just for home computing, not business).
>
> FWIW... I'm planning to and have your previous message covering that
> still marked unread to reply to later.  But "real life" has temporarily
> been monopolizing my time so the last day or two I've only done
> relatively short and quick replies.  That one will require a bit more
> time to answer to my satisfaction.
>
> So I'm punting for the moment.  But FWIW I tend to be a reasonably heavy
> partitioner (tho nowhere near what I used to be), so a lot of folks will
> consider my setup somewhat extreme.  That's OK.  It's my computer, setup
> for my purposes, not their computer for theirs, and it works very well
> for me, so it's all good. =:^)
>
> But hopefully I'll get back to that with a longer reply by the end of the
> week.  If I don't, you can probably consider that monopoly lasting longer
> than I thought, and it could be that I'll never get back to properly
> reply.  But it's an interesting enough topic to me that I'll /probably/
> get back, just not right ATM.
>

No problem, I have started another thread where we discuss partitioning.
It may be slightly off-topic, but the intention is really to have a
partition BTRFS-friendly.
For instance it seems that a dedicated /boot partition instead of a
subvolume is not necessary (better to have the /boot in the RAID1).
However I'm no expert.

Thanks for your help.
