Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42570 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754328AbaEEDXO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 May 2014 23:23:14 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does Suse do live filesystem revert with btrfs?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140504232645.GQ9061@merlins.org>
Date: Sun, 4 May 2014 21:23:12 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <D087B454-AEEA-4555-8679-11A46B963975@colorremedies.com>
References: <20140504005257.GF9061@merlins.org> <20140504232645.GQ9061@merlins.org>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 4, 2014, at 5:26 PM, Marc MERLIN <marc@merlins.org> wrote:

> Actually, never mind Suse, does someone know whether you can revert to
> an older snapshot in place?

They are using snapper. Updates are not atomic, that is they are applied to the currently mounted fs, not the snapshot, and after update the system is rebooted using the same (now updated) subvolumes. The rollback I think creates another snapshot and an earlier snapshot is moved into place because they are using the top level (subvolume id 5) for rootfs.

> The only way I can think of is to mount the snapshot on top of the other
> filesystem. This gets around the umounting a filesystem with open
> filehandles problem, but this also means that you have to keep track of
> daemons that are still accessing filehandles on the overlayed
> filesystem.

Production baremetal systems need well tested and safe update strategies that avoid update related problems, so that rollbacks aren't even necessary. Or such systems can tolerate rebooting.

If the use case considers rebooting a bit problem, then either a heavy weight virtual machine should be used, or something lighter weight like LXC containers. systemd-nspawn containers I think are still not considered for production use, but for testing and proof of concept you could see if it can boot arbitrary subvolumes - I think it can. And they boot really fast, like maybe a few seconds fast. For user space applications needing rollbacks, that's where application containers come in handy - you could either have two applications icons available (current and previous) and if on Btrfs the "previous" version could be a reflink copy.

Maybe there's some way to quit everything but the kernel and PID 1 switching back to an initrd, and then at switch root time, use a new root with all new daemons and libraries. It'd be faster than a warm reboot. It probably takes a special initrd to do this. The other thin you can consider is kexec, but then going forward realize this isn't compatible with a UEFI Secure Boot world.

> 
> My one concern with this approach is that you can't free up the
> subvolume/snapshot of the underlying filesystem if it's mounted and even
> after you free up filehandles pointing to it, I don't think you can
> umount it.
> 
> In other words, you can play this trick to delay a reboot a bit, but
> ultimately you'll have to reboot to free up the mountpoints, old
> subvolumes, and be able to delete them.

Well I think the bigger issue with system updates is the fact they're not atomic right now. The running system has a bunch of libraries yanked out from under it during the update process, things are either partially updated, or wholly replaced, and it's just a matter of time before something up in user space really doesn't like that. This was a major motivation for offline updates in gnome, so certain updates require reboot/poweroff.

To take advantage of Btrfs (and LVM thinp snapshots for that matter) what we ought to do is take a snapshot of rootfs and update the snapshot in a chroot or a container. And then the user can reboot whenever its convenient for them, and instead of a much, much longer reboot as the updates are applied, they get a normal boot. Plus there could be some metric to test for whether the update process was even successful, or likely to result in an unbootable system; and at that point the snapshot could just be obliterated and the reasons logged.

Of course this "update the snapshot" idea poses some problems with the FHS because there are things in /var that the current system needs to continue to write to, and yet so does the new system, and they shouldn't necessarily be separate, e.g. logs. /usr is a given, /boot is a given, and then /home should be dealt with differently because we probably shouldnt ever have rollbacks of /home but rather retrieval of deleted files from a snapshot into the current /home using reflink. So we either need some FHS re-evaluation with atomic system updates, and system rollbacks in mind. Or we end up needing a lot of subvolumes to carve the necessarily snapshotting/rollback granularity needed. And this makes for a less well understood system: how it functions, how to troubleshoot it, etc. So I'm more in favor of changes to the FHS.

Already look at how Fedora does this. The file system at the top level of a Btrfs volume is not FHS. It's its own thing, and only via fstab do the subvolumes at the top level get mounted in accordance with the FHS. So that means you get to look at fstab to figure out how a system is put together when troubleshooting it, if you're not already familiar with the layout. Will every distribution end up doing their own thing? Almost certainly yes, SUSE does it differently still as a consequence of installing the whole OS to the top level, making every snapshot navigable from the always mounted top level. *shrug*

Chris Murphy

