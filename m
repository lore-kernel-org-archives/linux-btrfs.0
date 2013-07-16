Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab3GPLhs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jul 2013 07:37:48 -0400
Date: Tue, 16 Jul 2013 13:37:45 +0200
From: David Sterba <dsterba@suse.cz>
To: George Amvrosiadis <gamvrosi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: filebench varmail + scrubber = btrfs_update_root bug
Message-ID: <20130716113745.GI24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CABF9=8i1Bd6mVOR8kNZmQJa2UJLg9tiCojWHbN1HLVWhEh7_0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABF9=8i1Bd6mVOR8kNZmQJa2UJLg9tiCojWHbN1HLVWhEh7_0g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 15, 2013 at 12:56:29AM -0400, George Amvrosiadis wrote:
> I'm trying to run the varmail personality in filebench, on a 50GB btrfs
> filesystem. I am also starting the scrubber at the same time. I have
> applied the latest patches for 3.8.13 (hoping to fix log tree issues).

There's a bugreport that looks the same,
https://bugzilla.kernel.org/show_bug.cgi?id=60051

> Every time, after the scrubber completes, however, I get the following:
> 
> [ 2558.688026] ------------[ cut here ]------------
> [ 2558.688055] WARNING: at fs/btrfs/tree-log.c:3882
> btrfs_log_inode_parent+0x41e/0x480 [btrfs]()
> [ 2558.688061] Hardware name: ProLiant DL160 Gen8
> [ 2558.688065] Modules linked in: btrfs zlib_deflate libcrc32c psmouse
> sb_edac serio_raw edac_core hpilo ioatdma hpwdt acpi_power_meter
> mac_hid lp parport igb dca ptp pps_core be2iscsi iscsi_boot_sysfs
> mpt2sas libiscsi scsi_transport_sas scsi_transport_iscsi raid_class
> be2net
> [ 2558.688109] Pid: 13631, comm: filebench Tainted: G      D W    3.8.13 #9
> [ 2558.688115] Call Trace:
> [ 2558.688128]  [<ffffffff8105824f>] warn_slowpath_common+0x7f/0xc0
> [ 2558.688137]  [<ffffffff810582aa>] warn_slowpath_null+0x1a/0x20
> [ 2558.688161]  [<ffffffffa020fcce>] btrfs_log_inode_parent+0x41e/0x480 [btrfs]
> [ 2558.688182]  [<ffffffffa020fd76>] btrfs_log_dentry_safe+0x46/0x70 [btrfs]
> [ 2558.688206]  [<ffffffffa01e527c>] btrfs_sync_file+0x18c/0x230 [btrfs]
> [ 2558.688214]  [<ffffffff811b642d>] do_fsync+0x5d/0x90
> [ 2558.688222]  [<ffffffff8115a9c9>] ? vm_munmap+0x59/0x70
> [ 2558.688230]  [<ffffffff811b6810>] sys_fsync+0x10/0x20
> [ 2558.688239]  [<ffffffff8168a959>] system_call_fastpath+0x16/0x1b
> [ 2558.688245] ---[ end trace 1cf4adc709e16e0b ]---
> 
> And that root key (18446744073709551610) looks very suspicious. Any ideas?

It translates to key type 250 which is BTRFS_DEV_REPLACE_KEY, plus the
parent transid error this looks like broken/unfinished device replace.
Have you used the 'btrfs device replace' recently?

david
