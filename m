Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51198 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627AbaFSI5G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 04:57:06 -0400
Received: by mail-wi0-f174.google.com with SMTP id bs8so8944676wib.13
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 01:57:04 -0700 (PDT)
Message-ID: <53A2A5DB.40204@gmail.com>
Date: Thu, 19 Jun 2014 11:56:59 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: frustrations with handling of crash reports
References: <20140519134915.GA27432@merlins.org>	<539FE03F.5030306@jp.fujitsu.com> <20140617145957.GH19071@merlins.org>	<20140617182745.GO19071@merlins.org> <53A192B8.2040601@gmail.com> <pan$d2b51$8d2a30e2$29b90599$a8fc24d9@cox.net>
In-Reply-To: <pan$d2b51$8d2a30e2$29b90599$a8fc24d9@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/6/2014 12:22 πμ, Duncan wrote:
> Konstantinos Skarlatos posted on Wed, 18 Jun 2014 16:23:04 +0300 as
> excerpted:
>
>> I guess that btrfs developers have put these BUG_ONs so that they get
>> reports from users when btrfs gets in these unexpected situations. But
>> if most of these reports are ignored or not resolved, then maybe there
>> is no use for these BUG_ONs and they should be replaced with something
>> more mild.
>>
>> Keep in mind that if a system panics, then the only way to get logs from
>> it is with serial or netconsole, so BUG_ON really makes it much harder
>> for users to know what happened and send reports, and only the most
>> technical and determined users will manage to send reports here.
> In terms of the BUGONs, they've been converting them to WARNONs recently,
> exactly due to the point you and Marc have made.  Not being a dev and
> simply based on the patch-flow I've seen as btrfs has been basically
> behaving itself so far here[1], I had /thought/ that was more or less
> done (perhaps some really bad bug-ons left but only a few, and basically
> only where the kernel couldn't be sure it was in a logical enough state
> to continue writing to other filesystems too, so bugon being logical in
> that case), but based on you guys' comments there's apparently more to go.
>
> So at least for BUGONs they agree.  I guess it's simply a matter of
> getting them all converted.
Thats good to hear. But we should have a way to recover from these kinds 
of problems, first of all having btrfs report the exact location, disk 
and file name that is affected, and then make scrub fix or at least 
report about it, and finaly make fsck work for this.

My filesystem that consistently kernel panics when a specific logical 
address is read, passes scrub without anything bad reported. What's the 
use of scrub if it cant deal with this?

>
> Tho at least in Marc's case, he's running kernels a couple back in some
> cases and they may still have BUGONs already replaced in the most current
> kernel.
>
> As for experimental, they've been toning down and removing the warnings
> recently.  Yes, the on-device format may come with some level of
> compatibility guarantee now so I do agree with that bit, but IMO anyway,
> that warning should be being replaced with a more explicit "on-device-
> format is now stable but the code is not yet entirely so, so keep your
> backups and be prepared to use them, and run current kernels", language,
> and that's not happening, they're mostly just toning it down without the
> still explicit warnings, ATM.
>
> ---
> [1] Btrfs (so far) behaving itself here: Possibly because my filesystems
> are relatively small and I don't use snapshots much and prefer several
> smaller independent filesystems rather than doing subvolumes, thus
> keeping the number of eggs in a single basket small.  Plus, with small
> filesystems on SSD, I can balance reasonably regularly, and I do full
> fresh mkfs.btrfs rounds every few kernels as well to take advantage of
> newer features, which may well have the result of killing smaller
> problems that aren't yet showing up before they get big enough to cause
> real issues.  Anyway, I'm not complaining! =:^)
Well my use case is about 25 filesystems on rotating disks, 20 of them 
on single disks, and the rest are multiple disk filesystems, either 
raid1 or single. I have many subvolumes and in some cases thousands of 
snapshots, but no databases, systemd and the like on them. Of course I 
have everything backed up, </nag mode on> but I believe that after all 
those years of development I shouldnt still be forced to do mkfs every 6 
monts or so, when i use no new features. </nag mode off>
>


-- 
Konstantinos Skarlatos

