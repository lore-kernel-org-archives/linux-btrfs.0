Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:26461 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2HOP73 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 11:59:29 -0400
Message-ID: <502BC75F.9060803@giantdisaster.de>
Date: Wed, 15 Aug 2012 17:59:27 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Anthony Plack <anthony@oddllc.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1884 - BTRFS
References: <1C74CEFB-327D-44F9-8311-E0C1148C6F0B@oddllc.com>
In-Reply-To: <1C74CEFB-327D-44F9-8311-E0C1148C6F0B@oddllc.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 15 Aug 2012 10:21:48 -0500, Anthony Plack wrote:
> Okay, this is the second occurrence of this bug.  I have searched Google, and while there are two posting for exten_io, I am not sure if they match.
> 
> Running Gentoo with kernel 3.5 on a dual core AMD.  The machine has 19 drives of varied types.  I am running rsync from an xfs volume (on two md arrays) to the btrfs volume and moving 8.2T.  This is the first time some of these drives have been exercised.  Four of the drives are in an external cage with a SATA multiplexer running across an eSATA cable.
> 
> On the btrfs volume, the metadata is RAID1, but the data is RAID0.
> 
> To me the most troubling issue is that the bug causes the system to become unresponsive whenever accessing the btrfs volume.  Any btrfs command will hang at the prompt.  umount would similarly hang.   On Aug 10th, I let the prompts sit for 48 hours with no progress because I did not desire to take the box down for other processes.  All attempts to kill the processes come back with no impact on the process, they are just zombies in the system.  The system does not seem to have excessive CPU or memory consumption.
> 
> After the first event, I have learned what is forcing the situation.  There are two used "ST3000DM001-9YN1 CC9D" Seagate drives which are posting some errors in the console.  The multiplexer is responding to these errors by shutting down the drive.  If I reboot the box, the multiplexer will show one drive as off-line.  I was successful in removing and reseating the drive.  The bad block count is up, but not that high for a 3T drive (200s).  "shutdown" command would also hang on this first event.  I unmounted all the other volumes, and had to hard reboot the server.
> 
> The second event, suspecting the multiplexer did it again, I hot unplugged the second drive (/dev/sdi) which was missing from lsscsi.  The drive is back online (as /dev/sdt) but btrfs is not detecting the shift and is still hung.  I have the original rsync stuck.  This time, I was able to get btrfs command to operate without hanging.  In addition, the drive is accessible, but the rsync commands are hung.
> 
> When I attempted to scrub the volume, I posted another trace in the log.
> 
> 
> 
> Okay details....
> 
> 
> Trace Failure 1:
> Aug 10 06:22:48 fatdrive kernel: [131136.506053] kernel BUG at fs/btrfs/extent_io.c:1884!
> Aug 10 06:22:48 fatdrive kernel: [131136.506070] invalid opcode: 0000 [#1] SMP 
> Aug 10 06:22:48 fatdrive kernel: [131136.506087] CPU 1 
> Aug 10 06:22:48 fatdrive kernel: [131136.506090] Modules linked in: btrfs lzo_compress lzo_decompress zlib_deflate crc32c libcrc32c r8168(O) nfsd xfs exportfs shpchp pci_hotplug r8169 k10temp mii kvm_amd kvm
> Aug 10 06:22:48 fatdrive kernel: [131136.506168] 
> Aug 10 06:22:48 fatdrive kernel: [131136.506184] Pid: 8458, comm: btrfs-endio-wri Tainted: G        W  O 3.5.0-gentoo #2 BIOSTAR Group TA880G HD/TA880G HD
> Aug 10 06:22:48 fatdrive kernel: [131136.506219] RIP: 0010:[<ffffffffa02b9231>]  [<ffffffffa02b9231>] repair_io_failure+0x1a1/0x1e0 [btrfs]
> Aug 10 06:22:48 fatdrive kernel: [131136.506270] RSP: 0018:ffff8800889dd970  EFLAGS: 00010246
> Aug 10 06:22:48 fatdrive kernel: [131136.506288] RAX: ffff8800889dd9a0 RBX: 0000000000000000 RCX: 0000007879ea8000
> Aug 10 06:22:48 fatdrive kernel: [131136.506318] RDX: 0000000000001000 RSI: 0000007879ea8000 RDI: ffff880215754108
> Aug 10 06:22:48 fatdrive kernel: [131136.506347] RBP: ffff8800889dd9f0 R08: ffffea0000ef8a80 R09: 0000000000000000
> Aug 10 06:22:48 fatdrive kernel: [131136.506378] R10: 57ffe641d6ef8a80 R11: 0000000000000001 R12: 0000000000000000
> Aug 10 06:22:48 fatdrive kernel: [131136.506407] R13: ffff8800889dd990 R14: 0000007879ea8000 R15: 0000000000001000
> Aug 10 06:22:48 fatdrive kernel: [131136.506439] FS:  00007f7f6959e700(0000) GS:ffff88021fc40000(0000) knlGS:0000000000000000
> Aug 10 06:22:48 fatdrive kernel: [131136.506469] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Aug 10 06:22:48 fatdrive kernel: [131136.506490] CR2: 00007f12b121f624 CR3: 0000000198bac000 CR4: 00000000000007e0
> Aug 10 06:22:48 fatdrive kernel: [131136.506521] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Aug 10 06:22:48 fatdrive kernel: [131136.506556] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Aug 10 06:22:48 fatdrive kernel: [131136.506584] Process btrfs-endio-wri (pid: 8458, threadinfo ffff8800889dc000, task ffff88018a3c0770)
> Aug 10 06:22:48 fatdrive kernel: [131136.506614] Stack:
> Aug 10 06:22:48 fatdrive kernel: [131136.506628]  ffffea0000ef8a80 0000007879ea8000 ffff880215754108 ffffea0000ef8a80
> Aug 10 06:22:48 fatdrive kernel: [131136.506659]  0000000000000000 0000000000000000 ffff8800889dd9a0 ffff8800889dd9a0
> Aug 10 06:22:48 fatdrive kernel: [131136.506690]  0000000000000000 0000000000000000 ffff880200000001 0000000000000000
> Aug 10 06:22:48 fatdrive kernel: [131136.506721] Call Trace:
> Aug 10 06:22:48 fatdrive kernel: [131136.506746]  [<ffffffffa02b9b91>] repair_eb_io_failure+0x81/0xa0 [btrfs]
> Aug 10 06:22:48 fatdrive kernel: [131136.506770]  [<ffffffffa029119a>] btree_read_extent_buffer_pages.constprop.115+0x11a/0x120 [btrfs]
[...]

This issue is already fixed with commit c0901581 which is part of Linux 3.6 RC1:

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/18594
