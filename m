Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6029 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751145AbcL1JbM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Dec 2016 04:31:12 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [GIT PULL] btrfs fixes and cleanups
To: Liu Bo <bo.li.liu@oracle.com>, David Sterba <dsterba@suse.cz>
References: <1481786012-18586-1-git-send-email-bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <04f553db-e164-8f52-7ece-885faa34ee9c@cn.fujitsu.com>
Date: Wed, 28 Dec 2016 17:30:59 +0800
MIME-Version: 1.0
In-Reply-To: <1481786012-18586-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

At 12/15/2016 03:13 PM, Liu Bo wrote:
> Hi David,
>
> This is the collection of my patches targetting 4.10, I've
> dropped patch "Btrfs: adjust len of writes if following a
> preallocated extent" because of the deadlock caused by this
> commit.
>
> Patches are based on v4.9-rc8, and test against fstests with
> default mount options has been taken to make sure it doesn't
> break anything.
>
> I haven't got a kernel.org git repo, so this is mainly for
> tracking purpose and for testing git flow.
>
> (cherry-pick patches might be the only way at this moment...sorry
> for the inconvenience.)
>
> Anyway, patches can be found at
>
> 	https://github.com/liubogithub/btrfs-work.git for-dave
>
> Thanks,
> liubo
>
> Liu Bo (9):
>   Btrfs: add 'inode' for extent map tracepoint
>   Btrfs: add truncated_len for ordered extent tracepoints
>   Btrfs: use down_read_nested to make lockdep silent
>   Btrfs: fix lockdep warning about log_mutex
>   Btrfs: fix truncate down when no_holes feature is enabled
>   Btrfs: fix btrfs_ordered_update_i_size to update disk_i_size properly
>   Btrfs: fix comment in btrfs_page_mkwrite
>   Btrfs: clean up btrfs_ordered_update_i_size

While testing David's for-next-20161219 branch, I found btrfs/06[0-5] 
will cause the following kernel panic when ran them in a row.

[ 4207.963063] assertion failed: disk_i_size < i_size, file: 
fs/btrfs//ordered-data.c, line: 1041
[ 4207.963722] ------------[ cut here ]------------
[ 4207.964008] kernel BUG at fs/btrfs//ctree.h:3418!
[ 4207.964008] invalid opcode: 0000 [#1] SMP
[ 4207.964008] Modules linked in: btrfs(O) netconsole ext4 jbd2 mbcache 
xor zlib_deflate raid6_pq xfs [last unloaded: btrfs]
[ 4207.964008] CPU: 0 PID: 3829 Comm: kworker/u4:5 Tainted: G 
O    4.9.0+ #60
[ 4207.964008] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
1.10.1-20161122_114906-anatol 04/01/2014
[ 4207.964008] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[ 4207.964008] task: ffff88000bbf8040 task.stack: ffffc90006598000
[ 4207.964008] RIP: 0010:[<ffffffffa0462245>]  [<ffffffffa0462245>] 
assfail.constprop.10+0x1c/0x1e [btrfs]
<snip>
[ 4207.964008] Call Trace:
[ 4207.964008]  [<ffffffffa03f1f41>] 
btrfs_ordered_update_i_size+0x2b1/0x2e0 [btrfs]
[ 4207.964008]  [<ffffffffa03dd435>] btrfs_finish_ordered_io+0x335/0x6b0 
[btrfs]
[ 4207.964008]  [<ffffffffa03dd7c5>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 4207.964008]  [<ffffffffa040961f>] btrfs_scrubparity_helper+0xef/0x610 
[btrfs]
[ 4207.964008]  [<ffffffffa0409bce>] btrfs_endio_write_helper+0xe/0x10 
[btrfs]
[ 4207.964008]  [<ffffffff810ec9ef>] process_one_work+0x2af/0x720
[ 4207.964008]  [<ffffffff810ec96b>] ? process_one_work+0x22b/0x720
[ 4207.964008]  [<ffffffff810eceab>] worker_thread+0x4b/0x4f0
[ 4207.964008]  [<ffffffff810ece60>] ? process_one_work+0x720/0x720
[ 4207.964008]  [<ffffffff810ece60>] ? process_one_work+0x720/0x720
[ 4207.964008]  [<ffffffff810f3d93>] kthread+0xf3/0x110
[ 4207.964008]  [<ffffffff810f3ca0>] ? kthread_park+0x60/0x60
[ 4207.964008]  [<ffffffff818af7c7>] ret_from_fork+0x27/0x40
[ 4207.964008] Code: c7 00 e4 46 a0 48 89 e5 e8 c8 3c d8 e0 0f 0b 55 89 
f1 48 c7 c2 83 90 46 a0 48 89 fe 48 c7 c7 b0 e4 46 a0 48 89 e5 e8 aa 3c 
d8 e0 <0f> 0b 55 89 f1 48 c7 c2 fb 90 46 a0 48 89 fe 48 c7 c7 e8 e5 46
[ 4207.964008] RIP  [<ffffffffa0462245>] assfail.constprop.10+0x1c/0x1e 
[btrfs]
[ 4207.964008]  RSP <ffffc9000659bc18>
[ 4207.964008] ---[ end trace f7759d2fce14da9f ]---

Not sure if it's related to patch or just it exposed some bug we don't 
find before.

Hopes it will help.

Thanks,
Qu

>   Btrfs: fix another race between truncate and lockless dio write
>
>  fs/btrfs/extent-tree.c       |  3 ++-
>  fs/btrfs/inode.c             | 43 +++++++++++++++++++++++++++++++++++--------
>  fs/btrfs/ordered-data.c      | 42 ++++++++++++++++++++++++------------------
>  fs/btrfs/tree-log.c          | 13 ++++++++++---
>  include/trace/events/btrfs.h | 16 ++++++++++++----
>  5 files changed, 83 insertions(+), 34 deletions(-)
>


