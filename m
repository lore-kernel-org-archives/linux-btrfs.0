Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab3DIMB5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 08:01:57 -0400
Date: Tue, 9 Apr 2013 14:01:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Kurt Huwig <kurthuwig@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: (3.9-rc5) WARNING: at fs/btrfs/super.c:255
 __btrfs_abort_transaction
Message-ID: <20130409120154.GG18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAEct+bDZi1rzOPOL_Zeoi=fEPsyAen67OJ+t71K8VZy8BLYvVw@mail.gmail.com>
 <CAEct+bA0sFqjv3AT7Oj+pfSQJyCOpkgH+cipY71E-TVsRi7Trg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEct+bA0sFqjv3AT7Oj+pfSQJyCOpkgH+cipY71E-TVsRi7Trg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 07, 2013 at 01:55:33PM +0200, Kurt Huwig wrote:
> I've got the same message.

The message appears to be the same, but is not. It's a generic
transaction abort message that can have various causes, one has to look
at the whole message.

> I accidentially reduced the size of a LVM
> volume from 700G to 1G instead of increasing it to 1T. dmesg output
> can be found here:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1164336

The messsages matche that the device is smaller than the filesystem assumes and
an attempt to write a block beyond the end happened. There's no way how 1G
device can hold 700G of data. Try to set the device size back and run scrub.

The relevant part (3.9 kernel):

[   65.970915] attempt to access beyond end of device
[   65.970917] dm-2: rw=1041, want=1212490200, limit=2097152
[   65.971008] BTRFS error (device dm-2) in btrfs_commit_transaction:1811: IO failure (Error while writing out transaction.)
[   65.971664] btrfs is forced readonly
[   65.971668] BTRFS warning (device dm-2): Skipping commit of aborted transaction.
[   65.971670] ------------[ cut here ]------------
[   65.971690] WARNING: at /home/apw/COD/linux/fs/btrfs/super.c:255 __btrfs_abort_transaction+0xdf/0x100 [btrfs]()
[   65.971692] Hardware name: Bochs
[   65.971694] btrfs: Transaction aborted
[   65.971695] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables bridge stp llc lp ppdev psmouse serio_raw parport_pc parport microcode ext2 raid10 raid456 async_pq async_xor async_memcpy async_raid6_recov async_tx raid1 raid0 multipath linear btrfs raid6_pq floppy ahci e1000 xor libahci zlib_deflate libcrc32c
[   65.971726] Pid: 1849, comm: btrfsctl Not tainted 3.9.0-030900rc5-generic #201303311835
[   65.971728] Call Trace:
[   65.971737]  [<ffffffff8105a53f>] warn_slowpath_common+0x7f/0xc0
[   65.971742]  [<ffffffff8105a636>] warn_slowpath_fmt+0x46/0x50
[   65.971754]  [<ffffffffa00941af>] __btrfs_abort_transaction+0xdf/0x100 [btrfs]
[   65.971771]  [<ffffffffa00bf05e>] cleanup_transaction+0x6e/0x2a0 [btrfs]
[   65.971777]  [<ffffffff81080ae0>] ? add_wait_queue+0x60/0x60
[   65.971792]  [<ffffffffa00be8eb>] btrfs_commit_transaction+0x86b/0xba0 [btrfs]
[   65.971796]  [<ffffffff81080ae0>] ? add_wait_queue+0x60/0x60
[   65.971815]  [<ffffffffa0105b35>] prepare_to_relocate+0x105/0x1c0 [btrfs]
[   65.971831]  [<ffffffffa010b55f>] relocate_block_group+0x4f/0x570 [btrfs]
[   65.971847]  [<ffffffffa00d6f74>] ? btrfs_wait_ordered_extents+0x234/0x250 [btrfs]
[   65.971852]  [<ffffffff81703b7e>] ? _raw_spin_lock+0xe/0x20
[   65.971867]  [<ffffffffa010bc45>] btrfs_relocate_block_group+0x1c5/0x300 [btrfs]
[   65.971883]  [<ffffffffa00e3316>] btrfs_relocate_chunk.isra.59+0x56/0x3e0 [btrfs]
[   65.971899]  [<ffffffffa00d8a49>] ? release_extent_buffer.isra.26+0x39/0x60 [btrfs]
[   65.971903]  [<ffffffff81703b7e>] ? _raw_spin_lock+0xe/0x20
[   65.971917]  [<ffffffffa00d8aa2>] ? free_extent_buffer.part.41+0x32/0x90 [btrfs]
[   65.971933]  [<ffffffffa00e7130>] btrfs_shrink_device+0x200/0x430 [btrfs]
[   65.971949]  [<ffffffffa00ec2e1>] btrfs_ioctl_resize+0x341/0x390 [btrfs]
[   65.971964]  [<ffffffffa00f29f7>] btrfs_ioctl+0x567/0x920 [btrfs]
[   65.971968]  [<ffffffff811affc8>] do_vfs_ioctl+0x88/0x340
[   65.971972]  [<ffffffff811b0311>] sys_ioctl+0x91/0xb0
[   65.971977]  [<ffffffff817077f5>] ? do_async_page_fault+0x35/0x90
[   65.971981]  [<ffffffff8170cb1d>] system_call_fastpath+0x1a/0x1f
[   65.971984] ---[ end trace 49e2f7fb8e15c8ef ]---
[   65.971986] BTRFS error (device dm-2) in cleanup_transaction:1455: IO failure
[   65.972746] delayed_refs has NO entry


david
