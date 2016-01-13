Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097AbcAMQ5q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 11:57:46 -0500
Date: Wed, 13 Jan 2016 17:57:44 +0100
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?B?TOlv?= Gillot-Lamure <leo.gillot@navaati.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "BTRFS critical (device sda1): unable to find logical
 576460868201611264 len 4096", hardware or software error ?
Message-ID: <20160113165744.GS4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAMuu1rPqTOweYKGGxwW1ZReQfgafSOdSsztZBGZoUpidRDDOTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAMuu1rPqTOweYKGGxwW1ZReQfgafSOdSsztZBGZoUpidRDDOTw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2016 at 05:43:59PM +0100, Léo Gillot-Lamure wrote:
> Hello.
> 
> I'm running a btrfs filesystem on 2 SSDs and have done successfully so
> for a few years, keeping the same filesystem while hot-migrating from
> one ssd to another and then both of them.
> 
> Now since the last few days i get errors like this:
> 
> > janv. 13 17:25:17 queulorior.navaati.net kernel: BTRFS critical (device sda1): unable to find logical 576460868201611264 len 4096

576460868201611264 == 0x800001afc120000

the 0x8... could be a biflip, the number otherwise looks like an aligned
block pointer.

> > janv. 13 17:25:17 queulorior.navaati.net kernel: BTRFS critical (device sda1): No mapping for 576460868201611264-576460868201615360
> > janv. 13 17:25:17 queulorior.navaati.net kernel: ------------[ cut here ]------------
> > janv. 13 17:25:17 queulorior.navaati.net kernel: WARNING: CPU: 0 PID: 389 at fs/btrfs/extent-tree.c:6264 __btrfs_free_extent.isra.76+0x139/0xd30()
> > janv. 13 17:25:17 queulorior.navaati.net kernel: BTRFS: Transaction aborted (error -5)
> > janv. 13 17:25:17 queulorior.navaati.net kernel: Modules linked in:
> > janv. 13 17:25:17 queulorior.navaati.net kernel: CPU: 0 PID: 389 Comm: btrfs-transacti Not tainted 4.2.3 #29
> > janv. 13 17:25:17 queulorior.navaati.net kernel: Hardware name: MSI MS-7816/Z87-G43 (MS-7816), BIOS V1.5 09/23/2013
> > janv. 13 17:25:17 queulorior.navaati.net kernel:  0000000000000000 ffffffff81eb6bf2 ffffffff81a73bc0 ffff8800c3183b38
> > janv. 13 17:25:17 queulorior.navaati.net kernel:  ffffffff810b5d57 00000000fffffffb 0000001c15991000 ffff8800c3a8f800
> > janv. 13 17:25:17 queulorior.navaati.net kernel:  ffff880212dae000 0000000000000000 ffffffff810b5dd5 ffffffff81ea54f8
> > janv. 13 17:25:17 queulorior.navaati.net kernel: Call Trace:
> > janv. 13 17:25:17 queulorior.navaati.net kernel:  [<ffffffff81a73bc0>] ? dump_stack+0x47/0x67
> > janv. 13 17:25:17 queulorior.navaati.net kernel:  [<ffffffff810b5d57>] ? warn_slowpath_common+0x77/0xb0
> > janv. 13 17:25:17 queulorior.navaati.net kernel:  [<ffffffff810b5dd5>] ? warn_slowpath_fmt+0x45/0x50
> > janv. 13 17:25:17 queulorior.navaati.net kernel:  [<ffffffff81344129>] ? __btrfs_free_extent.isra.76+0x139/0xd30
> > janv. 13 17:25:17 queulorior.navaati.net kernel:  [<ffffffff81347c16>] ? __btrfs_run_delayed_refs+0x5d6/0xf60
> > janv. 13 17:25:17 queulorior.navaati.net kernel:  [<ffffffff8134afd8>] ? btrfs_run_delayed_refs.part.81+0x68/0x250
> > janv. 13 17:25:17 queulorior.navaati.net kernel:  [<ffffffff8135e32b>] ? btrfs_commit_transaction+0x3b/0xa50
> > janv. 13 17:25:17 queulorior.navaati.net kernel:  [<ffffffff8135edcb>] ? start_transaction+0x8b/0x530
> 
> Then the filesystem remounts itself readonly, everything on the system
> gets crazy as a consequence and I need to reboot. On the next boot
> everything seem to be working fine, until it happens again after a day
> or so.
> Of course I freaked out for my data and started backuping like crazy,
> as I could still read my data.
> 
> I went to see the SMART infos of the disk (it's always on sda1, never
> on sdb1 which is also part of the fs) using gnome-disks and it looks
> fine. Is this kind of error a problem with my hardware or a corruption
> of the filesystem ?

Single bit errors usually point to faulty RAM. Depending on how far the
biflip has spread, it should be fixable by overwriting to the expected
value and recalculating the metadata block checksum.
