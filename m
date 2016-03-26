Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39695 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbcCZOAj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Mar 2016 10:00:39 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailout.nyi.internal (Postfix) with ESMTP id 6365120A2B
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 10:00:38 -0400 (EDT)
Message-Id: <1459000838.655295.560259050.32AD1D24@webmail.messagingengine.com>
From: Stephen Williams <stephenw@veryfast.biz>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: Possible Raid Bug
Date: Sat, 26 Mar 2016 14:00:38 +0000
In-Reply-To: <CAA7pwKMnj5+pLoBPg1z3aRQZJ-kWJefSc+Cg6JrhGSzdW4WFnQ@mail.gmail.com>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
 <CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
 <CAA7pwKNgDi9C8E+duwNA6H8MrT1nVEHkWAm4=JZp3GjFgAvZ1g@mail.gmail.com>
 <1458926454.3855039.559662618.4F365498@webmail.messagingengine.com>
 <CAA7pwKP90OTQLdOw4LHtGxZEBWhz3bZCam2E2-CHwA1p9CMdnA@mail.gmail.com>
 <CAGGqMYR9LdCiqHfO5Rn5zY1G7_YKYjrEzkovTVVaFRXqQ7vpeQ@mail.gmail.com>
 <56F5FD42.5010701@oracle.com>
 <CAA7pwKMnj5+pLoBPg1z3aRQZJ-kWJefSc+Cg6JrhGSzdW4WFnQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can confirm that you only get one chance to fix the problem before the
array is dead.

I know this is quite a rare occurrence for home use but for Data center
use this is something that will happen A LOT. 
This really should be placed in the wiki while we wait for a fix. I can
see a lot of sys admins crying over this. 

-- 
  Stephen Williams
  stephenw@veryfast.biz

On Sat, Mar 26, 2016, at 11:51 AM, Patrik Lundquist wrote:
> So with the lessons learned:
> 
> # mkfs.btrfs -m raid10 -d raid10 /dev/sdb /dev/sdc /dev/sdd /dev/sde
> 
> # mount /dev/sdb /mnt; dmesg | tail
> # touch /mnt/test1; sync; btrfs device usage /mnt
> 
> Only raid10 profiles.
> 
> # echo 1 >/sys/block/sde/device/delete
> 
> We lost a disk.
> 
> # touch /mnt/test2; sync; dmesg | tail
> 
> We've got write errors.
> 
> # btrfs device usage /mnt
> 
> No 'single' profiles because we haven't remounted yet.
> 
> # reboot
> # wipefs -a /dev/sde; reboot
> 
> # mount -o degraded /dev/sdb /mnt; dmesg | tail
> # btrfs device usage /mnt
> 
> Still only raid10 profiles.
> 
> # touch /mnt/test3; sync; btrfs device usage /mnt
> 
> Now we've got 'single' profiles. Replace now or get hosed.
> 
> # btrfs replace start -B 4 /dev/sde /mnt; dmesg | tail
> 
> # btrfs device stats /mnt
> 
> [/dev/sde].write_io_errs   0
> [/dev/sde].read_io_errs    0
> [/dev/sde].flush_io_errs   0
> [/dev/sde].corruption_errs 0
> [/dev/sde].generation_errs 0
> 
> We didn't inherit the /dev/sde error count. Is that a bug?
> 
> # btrfs balance start -dconvert=raid10,soft -mconvert=raid10,soft
> -sconvert=raid10,soft -vf /mnt; dmesg | tail
> 
> # btrfs device usage /mnt
> 
> Back to only 'raid10' profiles.
> 
> # umount /mnt; mount /dev/sdb /mnt; dmesg | tail
> 
> # btrfs device stats /mnt
> 
> [/dev/sde].write_io_errs   11
> [/dev/sde].read_io_errs    0
> [/dev/sde].flush_io_errs   2
> [/dev/sde].corruption_errs 0
> [/dev/sde].generation_errs 0
> 
> The old counters are back. That's good, but wtf?
> 
> # btrfs device stats -z /dev/sde
> 
> Give /dev/sde a clean bill of health. Won't warn when mounting again.
