Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41875 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbcC1Dy1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 23:54:27 -0400
Subject: Re: Possible Raid Bug
To: Patrik Lundquist <patrik.lundquist@gmail.com>,
        Stephen Williams <stephenw@veryfast.biz>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
 <CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
 <CAA7pwKNgDi9C8E+duwNA6H8MrT1nVEHkWAm4=JZp3GjFgAvZ1g@mail.gmail.com>
 <1458926454.3855039.559662618.4F365498@webmail.messagingengine.com>
 <CAA7pwKP90OTQLdOw4LHtGxZEBWhz3bZCam2E2-CHwA1p9CMdnA@mail.gmail.com>
 <CAGGqMYR9LdCiqHfO5Rn5zY1G7_YKYjrEzkovTVVaFRXqQ7vpeQ@mail.gmail.com>
 <56F5FD42.5010701@oracle.com>
 <CAA7pwKMnj5+pLoBPg1z3aRQZJ-kWJefSc+Cg6JrhGSzdW4WFnQ@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56F8AAE7.5020201@oracle.com>
Date: Mon, 28 Mar 2016 11:54:15 +0800
MIME-Version: 1.0
In-Reply-To: <CAA7pwKMnj5+pLoBPg1z3aRQZJ-kWJefSc+Cg6JrhGSzdW4WFnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Patrik,

Thanks for posting a test case. more below.

On 03/26/2016 07:51 PM, Patrik Lundquist wrote:
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

  Since you are replacing the failed device without mount/unmount/reboot,
  so this should work.

  And you would need those parts of hot spare/auto replace patches only
  if the test case had unmount/mount or reboot at this stage.


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

   No. Its other way, it would have been a bug if the replace-target
   inherited the error counters.

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

  No. I doubt if they are old counters. The steps above didn't
  show old error counts, but since you have created a file
  test3 so there will be some write_io_errors, which we don;t
  see after the balance. So I doubt if they are old counter
  but instead they are new flush errors.

> # btrfs device stats -z /dev/sde
>
> Give /dev/sde a clean bill of health. Won't warn when mounting again.




Thanks, Anand

