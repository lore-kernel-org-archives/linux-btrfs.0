From: Yoshihiro Takahashi <ytakahashi@miraclelinux.com>
Subject: Re: report, kernel BUG at fs/btrfs/extent-tree.c:3106
Date: Tue, 10 Feb 2009 18:45:07 +0900
Message-ID: <20090210184507.82dfa8e7.ytakahashi@miraclelinux.com>
References: <20090130143528.2069bf78.ytakahashi@miraclelinux.com>
	<20090130134935.GB24426@unused.rdu.redhat.com>
	<20090202160011.ee5b7c03.ytakahashi@miraclelinux.com>
	<a4423d670902090651yb24544m88da7ba9343800f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Josef Bacik <jbacik@redhat.com>, chris.mason@oracle.com,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <a4423d670902090651yb24544m88da7ba9343800f3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/extent-tree.c:3176!
> Pid: 2235, comm: stress Not tainted 2.6.29-rc4-next-20090209 #3 PowerEdge 1950

Thank you, your report.
I look like ENOSPC-problem.

I test on 2.6.29-rc4.
I think maybe I'll same issue.
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:3176!
Pid: 15655, comm: mkfbmt Tainted: G   M       2.6.29-rc4 #1


This patch reads a little funny to me.
This is bad patch.
This is extreme.
but, I want to return ENOSPC from btrfs_check_free_space.

regards,

--- linux-2.6.29-rc4/fs/btrfs/inode.c.orig 2009-02-10 18:06:05 +0900
+++ linux-2.6.29-rc4/fs/btrfs/inode.c      2009-02-10 18:07:12 +0900
@@ -119,7 +119,7 @@ int btrfs_check_free_space(struct btrfs_
        if (for_del)
                thresh = total * 90;
        else
-               thresh = total * 85;
+               thresh = total * 40;

        do_div(thresh, 100);

On Mon, 9 Feb 2009 17:51:34 +0300
Alexander Beregalov <a.beregalov@gmail.com> wrote:

> 2009/2/2 Yoshihiro Takahashi <ytakahashi@miraclelinux.com>:
> > Hi, Josef
> >
> > On Fri, 30 Jan 2009 08:49:35 -0500 Josef Bacik <jbacik@redhat.com> wrote:
> >> On Fri, Jan 30, 2009 at 02:35:28PM +0900, Yoshihiro Takahashi wrote:
> >> > Hi.
> >> >
> >> > I create many files on btrfs of 16GB partition.
> >> > may 13,000,000 files.
> >> > I get this report.
> >> >
> >> > I think about the following fix.
> >> > When there is not space, return of ENOSPC.
> >> > Or add lock in free extents.
> >> >
> >>
> >> Are you just creating files, or are you doing something else?  Thanks,
> >>
> >> Josef
> >> --
> >
> > I made a lot of files.
> > Perhaps surpass 13,000,000 file.
> >
> > I created directry first.
> > I get this BUG when I made the file afterwards.
> >
> > I got the following report to count of the files when I performed find.
> 
> Hi
> 
> I have reproduced similar problem on linux-next.
> I run  `stress -c 4 -d 8` on btrfs.
> 
> But it looks like ENOSPC-problem, doesn't it?
> 
> btrfs allocation failed flags 1, wanted 4096
> space_info has 0 free, is full
> block group 12582912 has 8388608 bytes, 8388608 used 0 pinned 0 reserved
> 0 blocks of free space at or bigger than bytes is
> block group 229638144 has 400556032 bytes, 400556032 used 0 pinned 0 reserved
> 0 blocks of free space at or bigger than bytes is
> block group 630194176 has 400556032 bytes, 400556032 used 0 pinned 0 reserved
> 0 blocks of free space at or bigger than bytes is
> block group 1030750208 has 400556032 bytes, 399540224 used 0 pinned
> 1015808 reserved
> 0 blocks of free space at or bigger than bytes is
> block group 1431306240 has 400556032 bytes, 400547840 used 0 pinned
> 8192 reserved
> 0 blocks of free space at or bigger than bytes is
> block group 1831862272 has 400556032 bytes, 400547840 used 0 pinned
> 8192 reserved
> 0 blocks of free space at or bigger than bytes is
> block group 2232418304 has 400556032 bytes, 399519744 used 0 pinned
> 1036288 reserved
> 0 blocks of free space at or bigger than bytes is
> block group 2632974336 has 400556032 bytes, 400547840 used 0 pinned
> 8192 reserved
> 0 blocks of free space at or bigger than bytes is
> block group 3233808384 has 362872832 bytes, 178257920 used 0 pinned
> 184614912 reserved
> 0 blocks of free space at or bigger than bytes is
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/extent-tree.c:3176!
> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/kernel/uevent_seqnum
> CPU 0
> Modules linked in:
> Pid: 2235, comm: stress Not tainted 2.6.29-rc4-next-20090209 #3 PowerEdge 1950
> RIP: 0010:[<ffffffff8041366d>]  [<ffffffff8041366d>]
> __btrfs_reserve_extent+0x28d/0x330
> ..
> Call Trace:
>  [<ffffffff80413746>] btrfs_reserve_extent+0x36/0x60
>  [<ffffffff8042882b>] cow_file_range+0x16b/0x380
>  [<ffffffff80438576>] ? free_extent_state+0x46/0x70
>  [<ffffffff80429470>] run_delalloc_range+0x350/0x360
>  [<ffffffff8043b049>] ? test_range_bit+0xb9/0x180
>  [<ffffffff8043b8e8>] ? find_lock_delalloc_range+0x108/0x190
>  [<ffffffff8043baa3>] __extent_writepage+0x133/0x890
>  [<ffffffff80235ad9>] ? sub_preempt_count+0xa9/0xf0
>  [<ffffffff8062d32d>] ? schedule+0x1d/0x40
>  [<ffffffff8029c3bf>] ? clear_page_dirty_for_io+0xdf/0xf0
>  [<ffffffff80439887>] extent_write_cache_pages+0x1c7/0x390
>  [<ffffffff804388b0>] ? flush_write_bio+0x0/0x30
>  [<ffffffff8043b970>] ? __extent_writepage+0x0/0x890
>  [<ffffffff80282054>] ? __rcu_read_unlock+0xa4/0xc0
>  [<ffffffff80439a8d>] extent_writepages+0x3d/0x60
>  [<ffffffff80426050>] ? btrfs_get_extent+0x0/0x950
>  [<ffffffff80422fe3>] btrfs_writepages+0x23/0x30
>  [<ffffffff8029cbdb>] do_writepages+0x2b/0x50
>  [<ffffffff802e5aa1>] __writeback_single_inode+0xa1/0x3f0
>  [<ffffffff802e62e2>] ? generic_sync_sb_inodes+0x3a2/0x420
>  [<ffffffff802e6288>] generic_sync_sb_inodes+0x348/0x420
>  [<ffffffff802e6545>] writeback_inodes+0x65/0x100
>  [<ffffffff8029d798>] balance_dirty_pages_ratelimited_nr+0x278/0x3f0
>  [<ffffffff8042a82c>] btrfs_file_write+0x42c/0x710
>  [<ffffffff802c6ffb>] vfs_write+0xcb/0x170
>  [<ffffffff802c7190>] sys_write+0x50/0x90
>  [<ffffffff8020bc1b>] system_call_fastpath+0x16/0x1b
