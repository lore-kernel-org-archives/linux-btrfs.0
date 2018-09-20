Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f42.google.com ([209.85.167.42]:36268 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725759AbeIUEB0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 00:01:26 -0400
Received: by mail-lf1-f42.google.com with SMTP id v17-v6so5880725lfe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 15:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
 <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com> <CAMrg+aTNK1cBG7rGVfudpydD6hMJz9UW0-3mdS8Yx4tqAQZE6Q@mail.gmail.com>
 <ecac52ad-70ed-e0e3-5660-1717f0d4f5e0@gmx.com> <CAMrg+aTtyOSOnZMj+4q13f7pv9wMydFgTDZ5KLbQSRz8HHcbKw@mail.gmail.com>
 <405d08b1-9f22-1038-67c3-c055477029d4@gmx.com> <CAMrg+aQV97Cv4WgH-DQvwDikFydrxD-zeJajUk3iLk1oKf12_A@mail.gmail.com>
 <CAJCQCtQ6GQ=oihewodXDOfSRE1X_gE=esxY7kZnPZmCXYHGqiA@mail.gmail.com> <CAMrg+aQX+NM+Rt7nhQqBa50Ar2bPh9MEN5iOk-48P_27dgAD-Q@mail.gmail.com>
In-Reply-To: <CAMrg+aQX+NM+Rt7nhQqBa50Ar2bPh9MEN5iOk-48P_27dgAD-Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 20 Sep 2018 16:15:33 -0600
Message-ID: <CAJCQCtR5yz6py6Tc759ZkDvRdkreFvLLZRnfVaFx50Yyxz_vLw@mail.gmail.com>
Subject: Re: btrfs problems
To: Adrian Bastholm <adrian@javaguru.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2018 at 3:36 PM Adrian Bastholm <adrian@javaguru.org> wrote:
>
> Thanks a lot for the detailed explanation.
> Aabout "stable hardware/no lying hardware". I'm not running any raid
> hardware, was planning on just software raid.

Yep. I'm referring to the drives, their firmware, cables, logic board,
its firmware, the power supply, power, etc. Btrfs is by nature
intolerant of corruption. Other file systems are more tolerant because
they don't know about it (although recent versions of XFS and ext4 are
now defaulting to checksummed metadata and journals).


>three drives glued
> together with "mkfs.btrfs -d raid5 /dev/sdb /dev/sdc /dev/sdd". Would
> this be a safer bet, or would You recommend running the sausage method
> instead, with "-d single" for safety ? I'm guessing that if one of the
> drives dies the data is completely lost
> Another variant I was considering is running a raid1 mirror on two of
> the drives and maybe a subvolume on the third, for less important
> stuff

RAID does not substantially reduce the chances of data loss. It's not
anything like a backup. It's an uptime enhancer. If you have backups,
and your primary storage dies, of course you can restore from backup
no problem, but it takes time and while the restore is happening,
you're not online - uptime is killed. If that's a negative, might want
to run RAID so you can keep working during the degraded period, and
instead of a restore you're doing a rebuild. But of course there is a
chance of failure during the degraded period. So you have to have a
backup anyway. At least with Btrfs/ZFS, there is another reason to run
with some replication like raid1 or raid5 and that's so that if
there's corruption or a bad sector, Btrfs doesn't just detect it, it
can fix it up with the good copy.

For what it's worth, make sure the drives have lower SCT ERC time than
the SCSI command timer. This is the same for Btrfs as it is for md and
LVM RAID. The command timer default is 30 seconds, and most drives
have SCT ERC disabled with very high recovery times well over 30
seconds. So either set SCT ERC to something like 70 deciseconds. Or
increase the command timer to something like 120 or 180 (either one is
absurdly high but what you want is for the drive to eventually give up
and report a discrete error message which Btrfs can do something
about, rather than do a SATA link reset in which case Btrfs can't do
anything about it).




-- 
Chris Murphy
