Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54361 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbbLQN31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Dec 2015 08:29:27 -0500
Received: from merkaba.localnet (host-188-174-216-157.customer.m-online.net [188.174.216.157])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 12118199
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 14:29:26 +0100 (CET)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.3-rc4] scrubbing aborts before finishing (SOLVED)
Date: Thu, 17 Dec 2015 14:29:25 +0100
Message-ID: <7163629.YhTYQ8DPxj@merkaba>
In-Reply-To: <4230736.3pqTg9ZQT8@merkaba>
References: <16063727.bYixifcRQC@merkaba> <2196957.diBSeBoUhe@merkaba> <4230736.3pqTg9ZQT8@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 16. Dezember 2015, 00:18:53 CET schrieb Martin Steigerwald:
> Am Montag, 14. Dezember 2015, 08:59:59 CET schrieb Martin Steigerwald:
> > Am Mittwoch, 25. November 2015, 16:35:39 CET schrieben Sie:
> > > Am Samstag, 31. Oktober 2015, 12:10:37 CET schrieb Martin Steigerwald:
> > > > Am Donnerstag, 22. Oktober 2015, 10:41:15 CET schrieb Martin
> Steigerwald:
> > > > > I get this:
> > > > > 
> > > > > merkaba:~> btrfs scrub status -d /
> > > > > scrub status for […]
> > > > > scrub device /dev/mapper/sata-debian (id 1) history
> > > > > 
> > > > >         scrub started at Thu Oct 22 10:05:49 2015 and was aborted
> > > > >         after
> > > > >         00:00:00
> > > > >         total bytes scrubbed: 0.00B with 0 errors
> > > > > 
> > > > > scrub device /dev/dm-2 (id 2) history
> > > > > 
> > > > >         scrub started at Thu Oct 22 10:05:49 2015 and was aborted
> > > > >         after
> > > > >         00:01:30
> > > > >         total bytes scrubbed: 23.81GiB with 0 errors
> > > > > 
> > > > > For / scrub aborts for sata SSD immediately.
> > > > > 
> > > > > For /home scrub aborts for both SSDs at some time.
[…]
> I now have 4.4-rc5 running, the boot crash I had appears to be fixed. Oh,
> and I see that scrubbing / at leasted worked now:
> 
> merkaba:~> btrfs scrub status -d /
> scrub status for […]
> scrub device /dev/dm-5 (id 1) history
>         scrub started at Wed Dec 16 00:13:20 2015 and finished after
> 00:01:42 total bytes scrubbed: 23.94GiB with 0 errors
> scrub device /dev/mapper/msata-debian (id 2) history
>         scrub started at Wed Dec 16 00:13:20 2015 and finished after
> 00:01:34 total bytes scrubbed: 23.94GiB with 0 errors
> 
> I will check with other BTRFS filesystems tomorrow and report back whether
> scrubbing is stable for meagain.

This appears to be fixed with 4.4-rc5. Thank you!!!

Thanks,
-- 
Martin
