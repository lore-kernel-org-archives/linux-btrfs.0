Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44113 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab2IYRjz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 13:39:55 -0400
Received: by obbuo13 with SMTP id uo13so6114228obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2012 10:39:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347875936-14165-2-git-send-email-bo.li.liu@oracle.com>
References: <1347875936-14165-1-git-send-email-bo.li.liu@oracle.com>
	<1347875936-14165-2-git-send-email-bo.li.liu@oracle.com>
Date: Tue, 25 Sep 2012 12:39:54 -0500
Message-ID: <CAKcLGm_4iUB1B8DPOx1D7i8eMa7po9fWFUYVOqp1N9nmZ1ExHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2 v3] Btrfs: snapshot-aware defrag
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dave@jikos.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 4:58 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> This comes from one of btrfs's project ideas,
> As we defragment files, we break any sharing from other snapshots.
> The balancing code will preserve the sharing, and defrag needs to grow this
> as well.
>
> Now we're able to fill the blank with this patch, in which we make full use of
> backref walking stuff.
>
> Here is the basic idea,
> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
> o  at endio, after we finish updating fs tree, we use backref walking to find
>    all parents of the ranges and re-link them with the new COWed file layout by
>    adding corresponding backrefs.
>
> Originally patch by Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

I'm hitting the WARN_ON in record_extent_backrefs() indicating a
problem with the return value from iterate_inodes_from_logical().

[ 6865.184782] ------------[ cut here ]------------
[ 6865.184819] WARNING: at fs/btrfs/inode.c:2062
record_extent_backrefs+0xe5/0xe7 [btrfs]()
[ 6865.184823] Hardware name: OptiPlex 745
[ 6865.184825] Modules linked in: lpc_ich mfd_core xts gf128mul cryptd
aes_x86_64 sha256_generic btrfs libcrc32c
[ 6865.184841] Pid: 4239, comm: btrfs-endio-wri Not tainted 3.5.4-git-local+ #1
[ 6865.184844] Call Trace:
[ 6865.184856]  [<ffffffff81031d6a>] warn_slowpath_common+0x74/0xa2
[ 6865.184862]  [<ffffffff81031db2>] warn_slowpath_null+0x1a/0x1c
[ 6865.184884]  [<ffffffffa003356b>] record_extent_backrefs+0xe5/0xe7 [btrfs]
[ 6865.184908]  [<ffffffffa003cf3a>] btrfs_finish_ordered_io+0x131/0xa4b [btrfs]
[ 6865.184930]  [<ffffffffa003d869>] finish_ordered_fn+0x15/0x17 [btrfs]
[ 6865.184951]  [<ffffffffa005882f>] worker_loop+0x145/0x516 [btrfs]
[ 6865.184959]  [<ffffffff81059727>] ? __wake_up_common+0x54/0x84
[ 6865.184983]  [<ffffffffa00586ea>] ? btrfs_queue_worker+0x2d3/0x2d3 [btrfs]
[ 6865.184989]  [<ffffffff810516bb>] kthread+0x93/0x98
[ 6865.184996]  [<ffffffff817d7934>] kernel_thread_helper+0x4/0x10
[ 6865.185001]  [<ffffffff81051628>] ? kthread_freezable_should_stop+0x6a/0x6a
[ 6865.185021]  [<ffffffff817d7930>] ? gs_change+0xb/0xb
[ 6865.185025] ---[ end trace 26cc0e186efc79d8 ]---


I'm testing a 3.5.4 kernel merged with 3.6_rc patchset as well as the
send_recv patches and most of the btrfs-next patches.

I'm running into this issue when mounting with autodefrag, and running
some snapshot tests.

This may be related to a problem elsewhere, because I've been
encountering other backref issues even before testing this patch.
