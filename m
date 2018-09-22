Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37627 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbeIVMn5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Sep 2018 08:43:57 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1g3bjB-0003Fa-CQ
        for linux-btrfs@vger.kernel.org; Sat, 22 Sep 2018 08:49:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs problems
Date: Sat, 22 Sep 2018 06:49:09 +0000 (UTC)
Message-ID: <pan$86919$f45c3291$e5d7c003$4a1fecbd@cox.net>
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
        <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com>
        <CAMrg+aTNK1cBG7rGVfudpydD6hMJz9UW0-3mdS8Yx4tqAQZE6Q@mail.gmail.com>
        <ecac52ad-70ed-e0e3-5660-1717f0d4f5e0@gmx.com>
        <CAMrg+aTtyOSOnZMj+4q13f7pv9wMydFgTDZ5KLbQSRz8HHcbKw@mail.gmail.com>
        <405d08b1-9f22-1038-67c3-c055477029d4@gmx.com>
        <CAMrg+aQV97Cv4WgH-DQvwDikFydrxD-zeJajUk3iLk1oKf12_A@mail.gmail.com>
        <CAJCQCtQ6GQ=oihewodXDOfSRE1X_gE=esxY7kZnPZmCXYHGqiA@mail.gmail.com>
        <CAMrg+aQX+NM+Rt7nhQqBa50Ar2bPh9MEN5iOk-48P_27dgAD-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adrian Bastholm posted on Thu, 20 Sep 2018 23:35:57 +0200 as excerpted:

> Thanks a lot for the detailed explanation.
> Aabout "stable hardware/no lying hardware". I'm not running any raid
> hardware, was planning on just software raid. three drives glued
> together with "mkfs.btrfs -d raid5 /dev/sdb /dev/sdc /dev/sdd". Would
> this be a safer bet, or would You recommend running the sausage method
> instead, with "-d single" for safety ? I'm guessing that if one of the
> drives dies the data is completely lost Another variant I was
> considering is running a raid1 mirror on two of the drives and maybe a
> subvolume on the third, for less important stuff

Agreed with CMurphy's reply, but he didn't mention...

As I wrote elsewhere recently, don't remember if it was in a reply to you 
before you tried zfs and came back, or to someone else, so I'll repeat 
here, briefer this time...

Keep in mind that on btrfs, it's possible (and indeed the default with 
multiple devices) to run data and metadata at different raid levels.

IMO, as long as you're following an appropriate backup policy that backs 
up anything valuable enough to be worth the time/trouble/resources of 
doing so, so if you /do/ lose the array you still have a backup of 
anything you considered valuable enough to worry about (and that caveat 
is always the case, no matter where or how it's stored, value of data is 
in practice defined not by arbitrary claims but by the number of backups 
it's considered worth having of it)...

With that backups caveat, I'm now confident /enough/ about raid56 mode to 
be comfortable cautiously recommending it for data, tho I'd still /not/ 
recommend it for metadata, which I'd recommend should remain the multi-
device default raid1 level.

That way, you're only risking a limited amount of raid5 data to the not 
yet as mature and well tested raid56 mode, the metadata remains protected 
by the more mature raid1 mode, and if something does go wrong, it's much 
more likely to be only a few files lost instead of the entire filesystem, 
as is at risk if your metadata is raid56 as well, the metadata including 
checksums will be intact so scrub should tell you what files are bad, and 
if those few files are valuable they'll be on the backup and easy enough 
to restore, compared to restoring the entire filesystem.  But for most 
use-cases, metadata should be relatively small compared to data, so 
duplicating metadata as raid1 while doing raid5 for data should go much 
easier on the capacity needs than raid1 for both would.

Tho I'd still recommend raid1 data as well for higher maturity and tested 
ability to use the good copy to rewrite the bad one if one copy goes bad 
(in theory, raid56 mode can use parity to rewrite as well, but that's not 
yet as well tested and there's still the narrow degraded-mode crash write 
hole to worry about), if it's not cost-prohibitive for the amount of data 
you need to store.  But for people on a really tight budget or who are 
storing double-digit TB of data or more, I can understand why they prefer 
raid5, and I do think raid5 is stable enough for data now, as long as the 
metadata remains raid1, AND they're actually executing on a good backup 
policy.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
