Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay06.ispgateway.de ([80.67.31.95]:56304 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbcGPK3w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jul 2016 06:29:52 -0400
Subject: Re: Status of SMR with BTRFS
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hendrik Friedel <hendrik@friedels.name>
Message-ID: <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
Date: Sat, 16 Jul 2016 12:29:48 +0200
MIME-Version: 1.0
In-Reply-To: <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Tomasz,

thanks for your reply.
> What disk are you using ?

It's a Seagate Expansion Desktop 5TB (USB3). It is probably a ST5000DM000.

> There are two types:
> 1. SMR managed by device firmware. BTRFS sees that as a normal block device … problems you get are not related to BTRFS it self …
That for sure. But the way BTRFS uses/writes data could cause problems 
in conjunction with these devices still, no?

> 2. SMR managed by host system, BTRFS still does see this as a block device … just emulated by host system to look normal.
I am not sure, what I am using. How can I find out?

> In case of funky technologies like that I would research how exactly data is stored in terms of “BAND” and experiment with setting leaf & sector size to match a band,
Sorry, but I have no idea where to start.

It seems to me, although the drive being a pure consumer drive, it is a 
'pro' feature and I should avoid it with BTRFS. I am just surprised, 
there is no hint in the wiki with that regards.

Greetings,
Hendrik


>> > On 15 Jul 2016, at 19:29, Hendrik Friedel <hendrik@friedels.name> wrote:
>> >
>> > Hello,
>> >
>> > I have a 5TB Seagate drive that uses SMR.
>> >
>> > I was wondering, if BTRFS is usable with this Harddrive technology. So, first I searched the BTRFS wiki -nothing. Then google.
>> >
>> > * I found this: https://bbs.archlinux.org/viewtopic.php?id=203696
>> > But this turned out to be an issue not related to BTRFS.
>> >
>> > * Then this: http://www.snia.org/sites/default/files/SDC15_presentations/smr/ HannesReinecke_Strategies_for_running_unmodified_FS_SMR.pdf
>> >  " BTRFS operation matches SMR parameters very closely [...]
>> >
>> >     High number of misaligned write accesses ; points to an issue with btrfs itself
>> >
>> >
>> > * Then this: http://superuser.com/questions/962257/fastest-linux-filesystem-on-shingled-disks
>> > The BTRFS performance seemed good.
>> >
>> >
>> > * Finally this: http://www.spinics.net/lists/linux-btrfs/msg48072.html
>> > "So you can get mixed results when trying to use the SMR devices but I'd say it will mostly not work.
>> > But, btrfs has all the fundamental features in place, we'd have to make
>> > adjustments to follow the SMR constraints:"
>> > [...]
>> > I have some notes at
>> > https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt"
>> >
>> >
>> > So, now I am wondering, what the state is today. "We" (I am happy to do that; but not sure of access rights) should also summarize this in the wiki.
>> > My use-case by the way are back-ups. I am thinking of using some of the interesting BTRFS features for this (send/receive, deduplication)
>> >
>> > Greetings,
>> > Hendrik
>> >
>> >
>> > ---
>> > Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
>> > https://www.avast.com/antivirus
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

