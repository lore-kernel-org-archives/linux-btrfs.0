Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:31186 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2J3BUQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 21:20:16 -0400
Message-ID: <508F2B44.5090408@oracle.com>
Date: Tue, 30 Oct 2012 09:20:04 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v4] Btrfs: snapshot-aware defrag
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com> <CAKcLGm_sWkwROKfYA_7cUt=kBSL_WWsoO7AegeCFG8GPczs2kw@mail.gmail.com>
In-Reply-To: <CAKcLGm_sWkwROKfYA_7cUt=kBSL_WWsoO7AegeCFG8GPczs2kw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/30/2012 04:06 AM, Mitch Harder wrote:
> On Sat, Oct 27, 2012 at 5:28 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> This comes from one of btrfs's project ideas,
>> As we defragment files, we break any sharing from other snapshots.
>> The balancing code will preserve the sharing, and defrag needs to grow this
>> as well.
>>
>> Now we're able to fill the blank with this patch, in which we make full use of
>> backref walking stuff.
>>
>> Here is the basic idea,
>> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
>> o  at endio, after we finish updating fs tree, we use backref walking to find
>>    all parents of the ranges and re-link them with the new COWed file layout by
>>    adding corresponding backrefs.
>>
>> Originally patch by Li Zefan <lizf@cn.fujitsu.com>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>> v3->v4:
>>       - fix duplicated refs bugs detected by mounting with autodefrag, thanks
>>         for the bug report from Mitch and Chris.
>>
> 
> I'm picking up many WARN_ON messages while testing this patch.
> 
> I'm testing a snapshot script that uses kernel git sources along with
> some git manipulations.
> 
> The kernel is a 3.6.4 kernel merged with the latest for-linus branch.
> 
> I mounted with -o compress-force=lzo,autodefrag.
> 
> I also have the second patch in this set (Btrfs: make snapshot-aware
> defrag as a mount option).  However, I did not mount with
> 'snap_aware_defrag'.
> 
> I did not find any corrupted data, and the partition passes a btrfsck
> without error after these warnings were observed.
> 

Hi Mitch,

Well, good report, but I don't think it has anything to do with this patch(since you
didn't mount with 'snap_aware_defrag' :)

After going through the below messages, the bug comes from the space side where we
must have mis-used our reservation somehow.

So can you show me your script so that I can give it a shot to reproduce locally?

thanks,
liubo


> Here's a summary of the WARN_ON messages:
> 
> $ cat local/dmesg-3.6.4-x+ | grep "WARNING:"
> [  610.407561] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [  610.407757] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [  610.407929] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [  661.211849] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [  661.212004] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [  661.212236] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [  719.882942] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [  719.883112] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [  719.883232] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [  786.978869] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [  786.979003] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [  786.979140] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [  845.605176] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [  845.605323] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [  845.605445] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [  912.300307] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [  912.300454] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [  912.300577] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [  968.835873] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [  968.836032] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [  968.836156] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1023.778160] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1023.778316] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1023.778435] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1064.342768] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1064.342914] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1064.343112] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1177.892047] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1177.892189] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1177.892312] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1281.951715] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1281.951857] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1281.951978] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1282.804376] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1282.804524] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1282.804645] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1351.187114] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1351.187263] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1351.187391] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1399.022919] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1399.023086] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1399.023206] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1483.724756] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1483.724895] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1483.725031] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1523.081643] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1523.081792] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1523.081922] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1555.993160] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1555.993299] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1555.993420] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1556.252181] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1556.252312] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1556.252427] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1557.218561] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1557.218691] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1557.218805] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1557.895069] WARNING: at fs/btrfs/extent-tree.c:4417
> btrfs_free_block_groups+0x2ad/0x34c [btrfs]()
> [ 1557.895261] WARNING: at fs/btrfs/extent-tree.c:4418
> btrfs_free_block_groups+0x347/0x34c [btrfs]()
> [ 1557.895435] WARNING: at fs/btrfs/extent-tree.c:7687
> btrfs_free_block_groups+0x23e/0x34c [btrfs]()
> [ 1557.895619] WARNING: at fs/btrfs/extent-tree.c:7687
> btrfs_free_block_groups+0x23e/0x34c [btrfs]()
> 
> Here's a snip of the code that has the WARN_ONs in inode.c:
> 
> void btrfs_destroy_inode(struct inode *inode)
> {
>         struct btrfs_ordered_extent *ordered;
>         struct btrfs_root *root = BTRFS_I(inode)->root;
> 
>         WARN_ON(!hlist_empty(&inode->i_dentry));
>         WARN_ON(inode->i_data.nrpages);
>         WARN_ON(BTRFS_I(inode)->outstanding_extents);  // line 7779
>         WARN_ON(BTRFS_I(inode)->reserved_extents);  // line 7780
>         WARN_ON(BTRFS_I(inode)->delalloc_bytes); // line 7781
>         WARN_ON(BTRFS_I(inode)->csum_bytes); // line 7782
> 
> Here's the dmesg output for just the last set of errors (the other
> WARN_ONs had similar backtraces):
> 
> [ 1557.218529] ------------[ cut here ]------------
> [ 1557.218561] WARNING: at fs/btrfs/inode.c:7779
> btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]()
> [ 1557.218564] Hardware name: OptiPlex 745
> [ 1557.218566] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
> mfd_core xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
> btrfs libcrc32c
> [ 1557.218582] Pid: 5728, comm: umount Tainted: G        W    3.6.4-x+ #3
> [ 1557.218584] Call Trace:
> [ 1557.218592]  [<ffffffff810350ea>] warn_slowpath_common+0x74/0xa2
> [ 1557.218596]  [<ffffffff81035132>] warn_slowpath_null+0x1a/0x1c
> [ 1557.218612]  [<ffffffffa00414c9>] btrfs_destroy_inode+0x2ac/0x2e6 [btrfs]
> [ 1557.218618]  [<ffffffff8113ef00>] destroy_inode+0x3c/0x5f
> [ 1557.218622]  [<ffffffff8113f045>] evict+0x122/0x1ac
> [ 1557.218626]  [<ffffffff8113f619>] dispose_list+0x3a/0x49
> [ 1557.218629]  [<ffffffff8113fd27>] evict_inodes+0x106/0x115
> [ 1557.218635]  [<ffffffff81127c32>] generic_shutdown_super+0x4c/0xdc
> [ 1557.218639]  [<ffffffff81127d44>] kill_anon_super+0x16/0x24
> [ 1557.218650]  [<ffffffffa000ad48>] btrfs_kill_super+0x1a/0x8f [btrfs]
> [ 1557.218654]  [<ffffffff81127f68>] deactivate_locked_super+0x34/0x5a
> [ 1557.218658]  [<ffffffff81128b60>] deactivate_super+0x4e/0x66
> [ 1557.218663]  [<ffffffff81142924>] mntput_no_expire+0xf7/0x14d
> [ 1557.218666]  [<ffffffff811437ad>] sys_umount+0x63/0x37a
> [ 1557.218672]  [<ffffffff81824c12>] system_call_fastpath+0x16/0x1b
> [ 1557.218674] ---[ end trace 29a44c3c46b1a1b9 ]---
> [ 1557.218676] ------------[ cut here ]------------
> [ 1557.218691] WARNING: at fs/btrfs/inode.c:7780
> btrfs_destroy_inode+0x296/0x2e6 [btrfs]()
> [ 1557.218693] Hardware name: OptiPlex 745
> [ 1557.218694] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
> mfd_core xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
> btrfs libcrc32c
> [ 1557.218708] Pid: 5728, comm: umount Tainted: G        W    3.6.4-x+ #3
> [ 1557.218709] Call Trace:
> [ 1557.218714]  [<ffffffff810350ea>] warn_slowpath_common+0x74/0xa2
> [ 1557.218717]  [<ffffffff81035132>] warn_slowpath_null+0x1a/0x1c
> [ 1557.218733]  [<ffffffffa00414b3>] btrfs_destroy_inode+0x296/0x2e6 [btrfs]
> [ 1557.218737]  [<ffffffff8113ef00>] destroy_inode+0x3c/0x5f
> [ 1557.218741]  [<ffffffff8113f045>] evict+0x122/0x1ac
> [ 1557.218744]  [<ffffffff8113f619>] dispose_list+0x3a/0x49
> [ 1557.218748]  [<ffffffff8113fd27>] evict_inodes+0x106/0x115
> [ 1557.218752]  [<ffffffff81127c32>] generic_shutdown_super+0x4c/0xdc
> [ 1557.218757]  [<ffffffff81127d44>] kill_anon_super+0x16/0x24
> [ 1557.218767]  [<ffffffffa000ad48>] btrfs_kill_super+0x1a/0x8f [btrfs]
> [ 1557.218771]  [<ffffffff81127f68>] deactivate_locked_super+0x34/0x5a
> [ 1557.218775]  [<ffffffff81128b60>] deactivate_super+0x4e/0x66
> [ 1557.218779]  [<ffffffff81142924>] mntput_no_expire+0xf7/0x14d
> [ 1557.218783]  [<ffffffff811437ad>] sys_umount+0x63/0x37a
> [ 1557.218787]  [<ffffffff81824c12>] system_call_fastpath+0x16/0x1b
> [ 1557.218789] ---[ end trace 29a44c3c46b1a1ba ]---
> [ 1557.218791] ------------[ cut here ]------------
> [ 1557.218805] WARNING: at fs/btrfs/inode.c:7782
> btrfs_destroy_inode+0x26a/0x2e6 [btrfs]()
> [ 1557.218807] Hardware name: OptiPlex 745
> [ 1557.218809] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
> mfd_core xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
> btrfs libcrc32c
> [ 1557.218822] Pid: 5728, comm: umount Tainted: G        W    3.6.4-x+ #3
> [ 1557.218823] Call Trace:
> [ 1557.218827]  [<ffffffff810350ea>] warn_slowpath_common+0x74/0xa2
> [ 1557.218831]  [<ffffffff81035132>] warn_slowpath_null+0x1a/0x1c
> [ 1557.218847]  [<ffffffffa0041487>] btrfs_destroy_inode+0x26a/0x2e6 [btrfs]
> [ 1557.218851]  [<ffffffff8113ef00>] destroy_inode+0x3c/0x5f
> [ 1557.218854]  [<ffffffff8113f045>] evict+0x122/0x1ac
> [ 1557.218858]  [<ffffffff8113f619>] dispose_list+0x3a/0x49
> [ 1557.218862]  [<ffffffff8113fd27>] evict_inodes+0x106/0x115
> [ 1557.218866]  [<ffffffff81127c32>] generic_shutdown_super+0x4c/0xdc
> [ 1557.218870]  [<ffffffff81127d44>] kill_anon_super+0x16/0x24
> [ 1557.218881]  [<ffffffffa000ad48>] btrfs_kill_super+0x1a/0x8f [btrfs]
> [ 1557.218885]  [<ffffffff81127f68>] deactivate_locked_super+0x34/0x5a
> [ 1557.218889]  [<ffffffff81128b60>] deactivate_super+0x4e/0x66
> [ 1557.218893]  [<ffffffff81142924>] mntput_no_expire+0xf7/0x14d
> [ 1557.218897]  [<ffffffff811437ad>] sys_umount+0x63/0x37a
> [ 1557.218901]  [<ffffffff81824c12>] system_call_fastpath+0x16/0x1b
> [ 1557.218903] ---[ end trace 29a44c3c46b1a1bb ]---
> [ 1557.895037] ------------[ cut here ]------------
> [ 1557.895069] WARNING: at fs/btrfs/extent-tree.c:4417
> btrfs_free_block_groups+0x2ad/0x34c [btrfs]()
> [ 1557.895073] Hardware name: OptiPlex 745
> [ 1557.895075] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
> mfd_core xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
> btrfs libcrc32c
> [ 1557.895097] Pid: 5728, comm: umount Tainted: G        W    3.6.4-x+ #3
> [ 1557.895100] Call Trace:
> [ 1557.895112]  [<ffffffff810350ea>] warn_slowpath_common+0x74/0xa2
> [ 1557.895118]  [<ffffffff81035132>] warn_slowpath_null+0x1a/0x1c
> [ 1557.895136]  [<ffffffffa0022769>] btrfs_free_block_groups+0x2ad/0x34c [btrfs]
> [ 1557.895157]  [<ffffffffa002e953>] close_ctree+0x1bc/0x2f1 [btrfs]
> [ 1557.895165]  [<ffffffff8113fd27>] ? evict_inodes+0x106/0x115
> [ 1557.895179]  [<ffffffffa0007075>] btrfs_put_super+0x19/0x1b [btrfs]
> [ 1557.895187]  [<ffffffff81127c41>] generic_shutdown_super+0x5b/0xdc
> [ 1557.895193]  [<ffffffff81127d44>] kill_anon_super+0x16/0x24
> [ 1557.895208]  [<ffffffffa000ad48>] btrfs_kill_super+0x1a/0x8f [btrfs]
> [ 1557.895214]  [<ffffffff81127f68>] deactivate_locked_super+0x34/0x5a
> [ 1557.895220]  [<ffffffff81128b60>] deactivate_super+0x4e/0x66
> [ 1557.895226]  [<ffffffff81142924>] mntput_no_expire+0xf7/0x14d
> [ 1557.895231]  [<ffffffff811437ad>] sys_umount+0x63/0x37a
> [ 1557.895239]  [<ffffffff81824c12>] system_call_fastpath+0x16/0x1b
> [ 1557.895243] ---[ end trace 29a44c3c46b1a1bc ]---
> [ 1557.895245] ------------[ cut here ]------------
> [ 1557.895261] WARNING: at fs/btrfs/extent-tree.c:4418
> btrfs_free_block_groups+0x347/0x34c [btrfs]()
> [ 1557.895264] Hardware name: OptiPlex 745
> [ 1557.895266] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
> mfd_core xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
> btrfs libcrc32c
> [ 1557.895285] Pid: 5728, comm: umount Tainted: G        W    3.6.4-x+ #3
> [ 1557.895287] Call Trace:
> [ 1557.895294]  [<ffffffff810350ea>] warn_slowpath_common+0x74/0xa2
> [ 1557.895299]  [<ffffffff81035132>] warn_slowpath_null+0x1a/0x1c
> [ 1557.895317]  [<ffffffffa0022803>] btrfs_free_block_groups+0x347/0x34c [btrfs]
> [ 1557.895337]  [<ffffffffa002e953>] close_ctree+0x1bc/0x2f1 [btrfs]
> [ 1557.895343]  [<ffffffff8113fd27>] ? evict_inodes+0x106/0x115
> [ 1557.895358]  [<ffffffffa0007075>] btrfs_put_super+0x19/0x1b [btrfs]
> [ 1557.895364]  [<ffffffff81127c41>] generic_shutdown_super+0x5b/0xdc
> [ 1557.895370]  [<ffffffff81127d44>] kill_anon_super+0x16/0x24
> [ 1557.895385]  [<ffffffffa000ad48>] btrfs_kill_super+0x1a/0x8f [btrfs]
> [ 1557.895391]  [<ffffffff81127f68>] deactivate_locked_super+0x34/0x5a
> [ 1557.895397]  [<ffffffff81128b60>] deactivate_super+0x4e/0x66
> [ 1557.895402]  [<ffffffff81142924>] mntput_no_expire+0xf7/0x14d
> [ 1557.895407]  [<ffffffff811437ad>] sys_umount+0x63/0x37a
> [ 1557.895413]  [<ffffffff81824c12>] system_call_fastpath+0x16/0x1b
> [ 1557.895417] ---[ end trace 29a44c3c46b1a1bd ]---
> [ 1557.895419] ------------[ cut here ]------------
> [ 1557.895435] WARNING: at fs/btrfs/extent-tree.c:7687
> btrfs_free_block_groups+0x23e/0x34c [btrfs]()
> [ 1557.895438] Hardware name: OptiPlex 745
> [ 1557.895440] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
> mfd_core xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
> btrfs libcrc32c
> [ 1557.895458] Pid: 5728, comm: umount Tainted: G        W    3.6.4-x+ #3
> [ 1557.895461] Call Trace:
> [ 1557.895467]  [<ffffffff810350ea>] warn_slowpath_common+0x74/0xa2
> [ 1557.895472]  [<ffffffff81035132>] warn_slowpath_null+0x1a/0x1c
> [ 1557.895489]  [<ffffffffa00226fa>] btrfs_free_block_groups+0x23e/0x34c [btrfs]
> [ 1557.895510]  [<ffffffffa002e953>] close_ctree+0x1bc/0x2f1 [btrfs]
> [ 1557.895516]  [<ffffffff8113fd27>] ? evict_inodes+0x106/0x115
> [ 1557.895533]  [<ffffffffa0007075>] btrfs_put_super+0x19/0x1b [btrfs]
> [ 1557.895540]  [<ffffffff81127c41>] generic_shutdown_super+0x5b/0xdc
> [ 1557.895547]  [<ffffffff81127d44>] kill_anon_super+0x16/0x24
> [ 1557.895561]  [<ffffffffa000ad48>] btrfs_kill_super+0x1a/0x8f [btrfs]
> [ 1557.895567]  [<ffffffff81127f68>] deactivate_locked_super+0x34/0x5a
> [ 1557.895573]  [<ffffffff81128b60>] deactivate_super+0x4e/0x66
> [ 1557.895578]  [<ffffffff81142924>] mntput_no_expire+0xf7/0x14d
> [ 1557.895583]  [<ffffffff811437ad>] sys_umount+0x63/0x37a
> [ 1557.895588]  [<ffffffff81824c12>] system_call_fastpath+0x16/0x1b
> [ 1557.895591] ---[ end trace 29a44c3c46b1a1be ]---
> [ 1557.895595] space_info 1 has 806678528 free, is not full
> [ 1557.895600] space_info total=4303355904, used=3496611840, pinned=0,
> reserved=0, may_use=2998272, readonly=65536
> [ 1557.895603] ------------[ cut here ]------------
> [ 1557.895619] WARNING: at fs/btrfs/extent-tree.c:7687
> btrfs_free_block_groups+0x23e/0x34c [btrfs]()
> [ 1557.895622] Hardware name: OptiPlex 745
> [ 1557.895624] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
> mfd_core xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
> btrfs libcrc32c
> [ 1557.895643] Pid: 5728, comm: umount Tainted: G        W    3.6.4-x+ #3
> [ 1557.895646] Call Trace:
> [ 1557.895652]  [<ffffffff810350ea>] warn_slowpath_common+0x74/0xa2
> [ 1557.895656]  [<ffffffff81035132>] warn_slowpath_null+0x1a/0x1c
> [ 1557.895673]  [<ffffffffa00226fa>] btrfs_free_block_groups+0x23e/0x34c [btrfs]
> [ 1557.895693]  [<ffffffffa002e953>] close_ctree+0x1bc/0x2f1 [btrfs]
> [ 1557.895699]  [<ffffffff8113fd27>] ? evict_inodes+0x106/0x115
> [ 1557.895716]  [<ffffffffa0007075>] btrfs_put_super+0x19/0x1b [btrfs]
> [ 1557.895723]  [<ffffffff81127c41>] generic_shutdown_super+0x5b/0xdc
> [ 1557.895729]  [<ffffffff81127d44>] kill_anon_super+0x16/0x24
> [ 1557.895743]  [<ffffffffa000ad48>] btrfs_kill_super+0x1a/0x8f [btrfs]
> [ 1557.895749]  [<ffffffff81127f68>] deactivate_locked_super+0x34/0x5a
> [ 1557.895754]  [<ffffffff81128b60>] deactivate_super+0x4e/0x66
> [ 1557.895760]  [<ffffffff81142924>] mntput_no_expire+0xf7/0x14d
> [ 1557.895764]  [<ffffffff811437ad>] sys_umount+0x63/0x37a
> [ 1557.895770]  [<ffffffff81824c12>] system_call_fastpath+0x16/0x1b
> [ 1557.895773] ---[ end trace 29a44c3c46b1a1bf ]---
> [ 1557.895776] space_info 4 has 92979200 free, is not full
> [ 1557.895780] space_info total=813694976, used=720715776, pinned=0,
> reserved=0, may_use=26738688, readonly=0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

