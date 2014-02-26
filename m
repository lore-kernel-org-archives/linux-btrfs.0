Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:49935 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaBZVui (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 16:50:38 -0500
Received: by mail-vc0-f179.google.com with SMTP id lh14so1595677vcb.24
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 13:50:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMU1PDiQwM_ch48yuWMQAOfM0=R+6MD=QfU-HatAHN2d4BQgQQ@mail.gmail.com>
References: <CAMU1PDh6crrOW02oqz6jqvG+rAG6W3mb+V=gHEy37FB1q0UpOg@mail.gmail.com>
	<20140224135702.GG23877@carfax.org.uk>
	<530C0796.4070205@oracle.com>
	<CAMU1PDiQwM_ch48yuWMQAOfM0=R+6MD=QfU-HatAHN2d4BQgQQ@mail.gmail.com>
Date: Wed, 26 Feb 2014 21:50:38 +0000
Message-ID: <CAMU1PDjf5Wp3FngLFU6V+vvzGEoOeLhvv8UJd9Jxn4nd7YEQ0A@mail.gmail.com>
Subject: Re: How to identify if a partition containing a btrfs volume is
 mounted and where
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 February 2014 10:28, Mike Fleetwood <mike.fleetwood@googlemail.com> wrote:
> On 25 February 2014 03:01, Anand Jain <Anand.Jain@oracle.com> wrote:
>>
>>> # mkfs.btrfs /dev/sdb2 /dev/sdb3 /dev/sdb4
>>> # mount /dev/sdb2 /mnt/1
>>> # btrfs device delete /dev/sdb2 /mnt/1
>>>
>>> So /dev/sdb2 is no longer part of the file system, but it's still
>>> mounted using it.
>>>
>>> # grep btrfs /proc/mounts
>>> /dev/sdb2 /mnt/1 btrfs rw,seclabel,relatime,ssd,space_cache 0 0
>>
>>
>>  This bug isn't there is the current btrfs-next. I couldn't
>>  reproduce.
>
> I've tested this again.  With linux 3.12.10 on Fedora 20 it is still
> reproducible, but after upgrading to linux 3.13.3 /proc/mounts
> automatically changes to show another device when the initial mounting
> one is removed from the btrfs.

Hi Anand,

I've done some more testing and stracing and would appreciate you
confirming the following understanding is correct:

1) btrfs-tools >= 3.12 (possibly earlier) will always display correct
results from btrfs fs show because it uses ioctls to get information
from the kernel for each mounted btrfs, and reads the disks for
non-mounted ones.

2) Old btrfs tools (tested with 0.20-rc1) only reads the disk and so
may get out of date information for mounted file systems, sometimes
showing *** Some devices missing.

3) Using btrfs fs sync /mnt makes the cached changes to device
membership get flushed to disk, thus avoiding seeing stale data in
(2).

So as such I plan to use /proc/mounts to determine FS busy status and
btrfs fs show to determine btrfs device membership.  As per my
previous and the above details this will be correct for linux >= 3.13
and current btrfs-tools, but for older kernel using /proc/mounts will
be wrong if the original mounting device has been removed from the
btrfs.

Thanks,
Mike
