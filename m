Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36278 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbcGOWPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 18:15:08 -0400
Received: by mail-wm0-f68.google.com with SMTP id x83so3794239wma.3
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 15:15:07 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Status of SMR with BTRFS
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
In-Reply-To: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
Date: Fri, 15 Jul 2016 23:15:04 +0100
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thou I’m not a hardcore storage system professional:

What disk are you using ? There are two types:
1. SMR managed by device firmware. BTRFS sees that as a normal block device … problems you get are not related to BTRFS it self …
2. SMR managed by host system, BTRFS still does see this as a block device … just emulated by host system to look normal. 

In case of funky technologies like that I would research how exactly data is stored in terms of “BAND” and experiment with setting leaf & sector size to match a band, then create a btrfs on this device. 
Run stress.sh on it for couple of days.
If you get errors - setup a two standard disk raid1 btrfs file system
run stress.sh to see whenever you get errors on this system - to eliminate possibility that your system is actually generating errors. 

Then come back and we will see what’s going on :)


> On 15 Jul 2016, at 19:29, Hendrik Friedel <hendrik@friedels.name> wrote:
> 
> Hello,
> 
> I have a 5TB Seagate drive that uses SMR.
> 
> I was wondering, if BTRFS is usable with this Harddrive technology. So, first I searched the BTRFS wiki -nothing. Then google.
> 
> * I found this: https://bbs.archlinux.org/viewtopic.php?id=203696
> But this turned out to be an issue not related to BTRFS.
> 
> * Then this: http://www.snia.org/sites/default/files/SDC15_presentations/smr/ HannesReinecke_Strategies_for_running_unmodified_FS_SMR.pdf
>  " BTRFS operation matches SMR parameters very closely [...]
> 
>     High number of misaligned write accesses ; points to an issue with btrfs itself
> 
> 
> * Then this: http://superuser.com/questions/962257/fastest-linux-filesystem-on-shingled-disks
> The BTRFS performance seemed good.
> 
> 
> * Finally this: http://www.spinics.net/lists/linux-btrfs/msg48072.html
> "So you can get mixed results when trying to use the SMR devices but I'd say it will mostly not work.
> But, btrfs has all the fundamental features in place, we'd have to make
> adjustments to follow the SMR constraints:"
> [...]
> I have some notes at
> https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt"
> 
> 
> So, now I am wondering, what the state is today. "We" (I am happy to do that; but not sure of access rights) should also summarize this in the wiki.
> My use-case by the way are back-ups. I am thinking of using some of the interesting BTRFS features for this (send/receive, deduplication)
> 
> Greetings,
> Hendrik
> 
> 
> ---
> Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
> https://www.avast.com/antivirus
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

