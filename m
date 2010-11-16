From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs raid1 degraded does not mount or fsck
Date: Tue, 16 Nov 2010 16:50:58 -0500
Message-ID: <1289943080-sup-1244@think>
References: <20101029205340.GA10326@gypsyops.denof.sin>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Vladi Gergov <vgergov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101029205340.GA10326@gypsyops.denof.sin>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Vladi Gergov's message of 2010-10-29 16:53:42 -0400:
> >>> gypsyops @ /mnt > sudo mount -o degraded /dev/sdc das3/
> Password: 
> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> [  684.577540] device label das4 devid 2 transid 107954 /dev/sdc
> [  684.595150] btrfs: allowing degraded mounts
> [  684.595594] btrfs: failed to read chunk root on sdb
> [  684.604110] btrfs: open_ctree failed
> 
> >>> gypsyops @ /mnt > sudo btrfsck /dev/sdc
> btrfsck: volumes.c:1367: btrfs_read_sys_array: Assertion `!(ret)' failed.

Ok, I dug through this and found the bug responsible for your
unmountable FS.  When we're mounted in degraded mode, and we don't have
enough drives available to do raid1,10, we're can use the wrong raid
level for new allocations.

I'm fixing the kernel side so this doesn't happen anymore, but I'll need
to rebuild the chunk tree (and probably a few others) off your good disk to
fix things.

I've got it reproduced here though, so I'll make an fsck that can scan
for the correct trees and fix it for you.

Since you're basically going to be my first external fsck customer, is
there anyway you can do a raw device based backup of the blocks?  This
way if I do mess things up we can repeat the experiment.

-chris
