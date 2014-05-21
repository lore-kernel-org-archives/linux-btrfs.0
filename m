Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39110 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751143AbaEUA1C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 20:27:02 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs check, btrfsck, fsck.btrfs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$bfe22$348a9807$13d86fd5$5784dae1@cox.net>
Date: Tue, 20 May 2014 18:26:59 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <B127F163-5AE6-4E7A-A754-EE92F9DD9162@colorremedies.com>
References: <9B5A4230-5A2F-4C00-AC4F-D9CA36A91620@colorremedies.com> <pan$bfe22$348a9807$13d86fd5$5784dae1@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 20, 2014, at 5:02 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Chris Murphy posted on Tue, 20 May 2014 10:56:26 -0600 as excerpted:
> 
>> Should the initrd/initramfs no longer include btrfsck, and instead
>> include btrfs and fsck.btrfs?
> 
> btrfs (the program) should be included in any case as btrfs device scan 
> should be run (normally triggered via udev rules when a btrfs filesystem 
> block device is detected) to enable mounting multi-device btrfs' (the 
> filesystem) from within the initr*.
> 
> That's already the case with dracut's btrfs module, anyway, and has been 
> for some time.

Yes you're right. And lsinitrd confirms that both btrfs and btrfsck are in the initramfs.


> 
>> In btrfs-progs 3.14 there is now a 1K /sbin/fsck.btrfs placeholder file.
> 
> To be more exact, it's a nearly noop shell-script (basically copied from 
> fsck.xfs) that simply verifies that the passed in filename exists.  If it 
> does, in auto-mode (if called automatically via a passno > 0 in fstab), 
> it exits without error.  In non-auto-mode, it simply points the user at 
> btrfs check.  If the device doesn't exist, it exits with "8" as the error 
> status.  No check other than that the last parameter passed in is 
> actually an existing file, not even whether it's actually a device or 
> not, is done.
> 
> As btrfs (the filesystem) doesn't need a pre-mount check, the 
> recommendation is to set passno to 0 for btrfs in any case, in which case 
> fsck.btrfs shouldn't be needed at all.
> 
> As such, fsck.btrfs really shouldn't be needed in an initr*, since 
> whatever's creating the initr* shouldn't be running a pre-mount auto-fsck 
> against btrfs in any case, as to do so is certainly a bug.


That ought to be true, but at least on a systemd 212-4 system, it assumes the system root needs to be fsck'd before mounting it. Since the fs isn't mounted, fstab isn't available. And the fstab.empty file I found in the initramfs is in fact empty. So even with fs_passno set to 0, systemd is trying to run fsck.btrfs, which it fails to find, warns about, then moves on.

I filed that bug here:
https://bugzilla.redhat.com/show_bug.cgi?id=1098799




> 
> (Tho with compression the incremental size of a single shell-script just 
> over 1 KiB in size before compression should be trivial.)
> 
>> btrfs and btrfsck files are the same binary, the difference is btrfsck
>> only can do check/repair. Including btrfs instead allows more
>> flexibility to use additional subcommands, and it's also consistent with
>> fsck.btrfs which references btrfs not btrfsck.
> 
> Ideally, btrfsck would be a symlink to btrfs in btrfs-progs, and 
> potentially not included in an initr* at all, or if included, likewise 
> included as a symlink.


Yeah it seems to me we should only need btrfs in the initrd/ramfs. It doesn't show up as a link but the Rawhide initramfs, using lsinitrd, lists btrfsck as a 0 byte file.


Chris Murphy