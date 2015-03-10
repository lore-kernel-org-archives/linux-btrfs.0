Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:53473 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbbCJLmk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Mar 2015 07:42:40 -0400
Date: Tue, 10 Mar 2015 12:42:37 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>
Subject: Re: WARNING: CPU: 2 PID: 32343 at fs/btrfs/inode.c:8693
 btrfs_destroy_inode+0x278/0x2a0()
Message-ID: <20150310114237.GC351@x4>
References: <20150220100934.GA343@x4>
 <20150224122901.GC343@x4>
 <20150302112547.GA345@x4>
 <CAL3q7H6LPNt4zqrt9DFigJhc=gaNRew5VrKQGaP5o_h-5X1eRw@mail.gmail.com>
 <20150302132933.GA347@x4>
 <20150303141349.GA342@x4>
 <CAL3q7H5UZ3NVUOAnFatY4MGFDfBRR5e3O5Bm-d+zoqQ9NG7UhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5UZ3NVUOAnFatY4MGFDfBRR5e3O5Bm-d+zoqQ9NG7UhQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015.03.07 at 09:35 +0000, Filipe David Manana wrote:
> On Tue, Mar 3, 2015 at 2:13 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On 2015.03.02 at 14:29 +0100, Markus Trippelsdorf wrote:
> >> On 2015.03.02 at 12:07 +0000, Filipe David Manana wrote:
> >> > >> [83159.038708] ------------[ cut here ]------------
> >> > >> [83159.038716] WARNING: CPU: 2 PID: 32343 at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x278/0x2a0()
> >> > >> [83159.038718] CPU: 2 PID: 32343 Comm: rm Tainted: G        W       4.0.0-rc1-dirty #104
> >> > >> [83159.038719] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
> >> > >> [83159.038720]  0000000000000000 ffffffff8199990f ffffffff8168d723 0000000000000000
> >> > >> [83159.038722]  ffffffff8106d2d2 0000000000000000 ffff88005756edf0 ffff880215805800
> >> > >> [83159.038723]  ffff880169477eb8 ffff88005756edf0 ffffffff8121bab8 ffff880100675000
> >> > >> [83159.038725] Call Trace:
> >> > >> [83159.038728]  [<ffffffff8168d723>] ? dump_stack+0x40/0x50
> >> > >> [83159.038731]  [<ffffffff8106d2d2>] ? warn_slowpath_common+0x72/0xc0
> >> > >> [83159.038732]  [<ffffffff8121bab8>] ? btrfs_destroy_inode+0x278/0x2a0
> >> > >> [83159.038735]  [<ffffffff8111f747>] ? do_unlinkat+0x1a7/0x2e0
> >> > >> [83159.038737]  [<ffffffff81083974>] ? task_work_run+0xb4/0x100
> >> > >> [83159.038740]  [<ffffffff8103b9a9>] ? do_notify_resume+0x69/0x80
> >> > >> [83159.038742]  [<ffffffff81694092>] ? system_call_fastpath+0x12/0x17
> >> > >> [83159.038743] ---[ end trace 3b7c45c6e46fe8dd ]---
> >> > >> [83159.038744] ------------[ cut here ]------------
> >> > >> [83159.038745] WARNING: CPU: 2 PID: 32343 at fs/btrfs/inode.c:8694 btrfs_destroy_inode+0x1f2/0x2a0()
> >> > >> [83159.038746] CPU: 2 PID: 32343 Comm: rm Tainted: G        W       4.0.0-rc1-dirty #104
> >> > >> [83159.038747] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
> >> > >> [83159.038747]  0000000000000000 ffffffff8199990f ffffffff8168d723 0000000000000000
> >> > >> [83159.038749]  ffffffff8106d2d2 0000000000000000 ffff88005756edf0 ffff880215805800
> >> > >> [83159.038750]  ffff880169477eb8 ffff88005756edf0 ffffffff8121ba32 ffff880100675000
> >> > >> [83159.038751] Call Trace:
> >> > >> [83159.038753]  [<ffffffff8168d723>] ? dump_stack+0x40/0x50
> >> > >> [83159.038754]  [<ffffffff8106d2d2>] ? warn_slowpath_common+0x72/0xc0
> >> > >> [83159.038755]  [<ffffffff8121ba32>] ? btrfs_destroy_inode+0x1f2/0x2a0
> >> > >> [83159.038757]  [<ffffffff8111f747>] ? do_unlinkat+0x1a7/0x2e0
> >> > >> [83159.038758]  [<ffffffff81083974>] ? task_work_run+0xb4/0x100
> >> > >> [83159.038760]  [<ffffffff8103b9a9>] ? do_notify_resume+0x69/0x80
> >> > >> [83159.038761]  [<ffffffff81694092>] ? system_call_fastpath+0x12/0x17
> >> > >> [83159.038762] ---[ end trace 3b7c45c6e46fe8de ]---
> >> > >
> >> > > Unfortunately the issue isn't 100% reproducible, so I unfortunately
> >> > > cannot bisect.
> >> >
> >> > You probably don't need to bisect. The warning is related to the
> >> > outstanding_extents counter being != 0:
> >> >
> >> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/inode.c?id=refs/tags/v4.0-rc1#n8693
> >> >
> >> > The only change in 4.0 that changes updates to that counter is:
> >> >
> >> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=3e05bde8c3c2dd761da4d52944a087907955a53c
> >> >
> >> > So that's likely the change you would find with a bisect.
> >>
> >> OK, thank you. I will revert the commit and see if it fixes the issue.
> >
> > No. Reverting 3e05bde8c3 does _not_ fix the issue. It still happens.
> 
> Ok, so I ran into this as well, and identified the following patch as
> the source of the problem:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=dcab6a3b2ae657a2017637083c28ee303b6b1b8e
> 
> It's actually very easy to trigger. The following fio job config triggers it:
> 
> [global]
> ioengine=sync
> direct=0
> bssplit=130M/100
> fallocate=none
> filename=foobar
> 
> [job1]
> numjobs=1
> size=1G
> rw=randwrite
> 
> Then run these steps:
> 
> mkfs.btrfs -f /dev/sdd
> mount /dev/sdd /mnt
> cd /mnt
> fio fio_job.ini
> cd ..
> umount /mnt
> (see dmesg)
> 
> The important part is that the writes need to be larger than 128Mb.
> With btrfs assertions enabled (CONFIG_BTRFS_ASSERT=y) you'll get a
> BUG_ON() immediately:
> 
> [211158.555563] BTRFS: assertion failed:
> BTRFS_I(inode)->outstanding_extents >= num_extents, file:
> fs/btrfs/extent-tree.c, line: 4983
> [211158.557901] ------------[ cut here ]------------
> [211158.558666] kernel BUG at fs/btrfs/ctree.h:4013!
> [211158.559660] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> (....)
> [211158.561837] Call Trace:
> [211158.561837]  [<ffffffffa0474666>] drop_outstanding_extent+0x3d/0x6d [btrfs]
> [211158.561837]  [<ffffffffa047a5b8>]
> btrfs_delalloc_release_metadata+0x53/0xfc [btrfs]
> (....)
> 
> Otherwise only the warnings you reported during inode eviction.
> 
> This happens for both direct IO and buffered writes (direct=0). At
> least for the direct IO case, the issue happens due to underflows when
> decrementing the inode's outstanding_extents counter (after the very
> first write we get outstanding_extents = (unsigned)1 - 2 =
> 4294967295).

Josef?

-- 
Markus
