Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.everyonecounts.com ([198.199.52.19]:42619 "HELO
	prod-ent-smtp02.dc2.ec.loc" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1750783AbcDIWvD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Apr 2016 18:51:03 -0400
Date: Sat, 9 Apr 2016 15:44:41 -0700
From: Vladi Gergov <vladi@aresgate.net>
To: Chris Mason <chris.mason@facebook.com>
Cc: linux-btrfs@vger.kernel.org
Subject: btrfs raid1 degraded does not mount or fsck
Message-ID: <20160409224440.GC6768@gypsyops.denof.sin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anyone know if there is currently with updated kernel and tools a way to
recover the data on this? I have tried btrfs chunk-recovery with not
luck. Anything else I can do to try and get the data off at least?
Thanks in advance!

On Tuesday, 16.11.10 at 16:50, Chris Mason wrote:
> Excerpts from Vladi Gergov's message of 2010-10-29 16:53:42 -0400:
> > >>> gypsyops @ /mnt > sudo mount -o degraded /dev/sdc das3/
> > Password:
> > mount: wrong fs type, bad option, bad superblock on /dev/sdc,
> >        missing codepage or helper program, or other error
> >        In some cases useful info is found in syslog - try
> >        dmesg | tail  or so
> >
> > [  684.577540] device label das4 devid 2 transid 107954 /dev/sdc
> > [  684.595150] btrfs: allowing degraded mounts
> > [  684.595594] btrfs: failed to read chunk root on sdb
> > [  684.604110] btrfs: open_ctree failed
> >
> > >>> gypsyops @ /mnt > sudo btrfsck /dev/sdc
> > btrfsck: volumes.c:1367: btrfs_read_sys_array: Assertion `!(ret)' failed.
> 
> Ok, I dug through this and found the bug responsible for your
> unmountable FS.  When we're mounted in degraded mode, and we don't have
> enough drives available to do raid1,10, we're can use the wrong raid
> level for new allocations.
> 
> I'm fixing the kernel side so this doesn't happen anymore, but I'll need
> to rebuild the chunk tree (and probably a few others) off your good disk to
> fix things.
> 
> I've got it reproduced here though, so I'll make an fsck that can scan
> for the correct trees and fix it for you.
> 
> Since you're basically going to be my first external fsck customer, is
> there anyway you can do a raw device based backup of the blocks?  This
> way if I do mess things up we can repeat the experiment.
> 
> -chris
> 
> !DSPAM:4ce2fd55191821234852255!
> 
> 

-- 

,-| Vladi
`-| Gergov
