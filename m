Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25938 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaCANXK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Mar 2014 08:23:10 -0500
Message-ID: <5311DF2A.6070406@oracle.com>
Date: Sat, 01 Mar 2014 21:22:50 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
CC: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to identify if a partition containing a btrfs volume is mounted
 and where
References: <CAMU1PDh6crrOW02oqz6jqvG+rAG6W3mb+V=gHEy37FB1q0UpOg@mail.gmail.com> <20140224135702.GG23877@carfax.org.uk> <530C0796.4070205@oracle.com> <CAMU1PDiQwM_ch48yuWMQAOfM0=R+6MD=QfU-HatAHN2d4BQgQQ@mail.gmail.com> <CAMU1PDjf5Wp3FngLFU6V+vvzGEoOeLhvv8UJd9Jxn4nd7YEQ0A@mail.gmail.com>
In-Reply-To: <CAMU1PDjf5Wp3FngLFU6V+vvzGEoOeLhvv8UJd9Jxn4nd7YEQ0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Mike,

On 27/02/2014 05:50, Mike Fleetwood wrote:
> On 25 February 2014 10:28, Mike Fleetwood <mike.fleetwood@googlemail.com> wrote:
>> On 25 February 2014 03:01, Anand Jain <Anand.Jain@oracle.com> wrote:
>>>
>>>> # mkfs.btrfs /dev/sdb2 /dev/sdb3 /dev/sdb4
>>>> # mount /dev/sdb2 /mnt/1
>>>> # btrfs device delete /dev/sdb2 /mnt/1
>>>>
>>>> So /dev/sdb2 is no longer part of the file system, but it's still
>>>> mounted using it.
>>>>
>>>> # grep btrfs /proc/mounts
>>>> /dev/sdb2 /mnt/1 btrfs rw,seclabel,relatime,ssd,space_cache 0 0
>>>
>>>
>>>   This bug isn't there is the current btrfs-next. I couldn't
>>>   reproduce.
>>
>> I've tested this again.  With linux 3.12.10 on Fedora 20 it is still
>> reproducible, but after upgrading to linux 3.13.3 /proc/mounts
>> automatically changes to show another device when the initial mounting
>> one is removed from the btrfs.
>
> Hi Anand,
>
> I've done some more testing and stracing and would appreciate you
> confirming the following understanding is correct:
>
> 1) btrfs-tools >= 3.12 (possibly earlier) will always display correct
> results from btrfs fs show because it uses ioctls to get information
> from the kernel for each mounted btrfs, and reads the disks for
> non-mounted ones.

  it would scan kernel first to pick fsid which are opened
  and then reads disks directly to pick rest of the fsids.

> 2) Old btrfs tools (tested with 0.20-rc1) only reads the disk and so
> may get out of date information for mounted file systems,

  yes.

> 3) Using btrfs fs sync /mnt makes the cached changes to device
> membership get flushed to disk, thus avoiding seeing stale data i
> (2).

  nope this does not work. Calling flush not for the application
  purpose is not a good idea. it would alter the application
  performance when you run btrfs fi show that's unacceptable at
  a lot of data centers.

  further, if you delete the missing disk and if that disk reappears,
  just by user land read would make the wrong judgement on its mount
  status, thats the current bug which I am working on.

> So as such I plan to use /proc/mounts to determine FS busy status and
> btrfs fs show to determine btrfs device membership.

  I don't understand in full. but the toughest test case will
  be to test the theory with seed disk in place. /proc/mounts
  show the seed disk whose fsid is different from sprout fsid.

  IMO /proc/mounts should not show seed disk in theory.
  If there is a practical need, pls do let me know
  as I am planning to write a RFC on it.

> As per my
> previous and the above details this will be correct for linux >= 3.13
> and current btrfs-tools, but for older kernel using /proc/mounts will
> be wrong if the original mounting device has been removed from the
> btrfs.

  btrfs-kernel has no idea about the disk disappeared. Its WIP
  at my end.

Thanks,  Anand

> Thanks,
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
