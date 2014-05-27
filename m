Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45582 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591AbaE0VMq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 17:12:46 -0400
Message-ID: <5385007A.4000301@fb.com>
Date: Tue, 27 May 2014 17:15:38 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.15-rc6 - btrfs-transacti:4157 blocked for more than 120 seconds.
References: <5384D53C.9070509@skagestad.org> <5384E2FA.1070509@fb.com> <5384F0B4.7040309@skagestad.org> <5384F8A4.1050206@skagestad.org> <5384FAB2.6000204@fb.com>
In-Reply-To: <5384FAB2.6000204@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/27/2014 04:50 PM, Chris Mason wrote:
> On 05/27/2014 04:42 PM, Torbjørn wrote:
>> On 05/27/2014 10:08 PM, Torbjørn wrote:
>>> On 05/27/2014 09:09 PM, Chris Mason wrote:
>>>>
>>>> On 05/27/2014 02:11 PM, Torbjørn wrote:
>>>>> Hi,
>>>>>
>>>>> Btrfs-transaction keeps blocking for me on all 3.15-rc versions.
>>>>> 3.14 does not have this issue.
>>>>> The process never gets unstuck. btrfs fi sync does not help. A hard
>>>>> reboot seems to be the only way to recover.
>>>>>
>>>>> The volume is still readable when it's in this state.
>>>>>
>>>>> dmesg + sysrq-w is available at
>>>>> https://urldefense.proofpoint.com/v1/url?u=http://pastebin.com/vHQnRE2F&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=IKSs%2F0C3x9a0LIiVKFmZVoP9lSAZ%2BK9JgEkchLEAAzM%3D%0A&s=127b40cc34dbb205b5277e6081b082f26e84fc417d35310f3aeee04998a679a8
>>>>>
>>>>>
>>>>> It's over 6000 lines, and would most likely not be allowed on the list.
>>>>>
>>>>> The blocking happons on a server with local kvm-clients reading and
>>>>> writing to a local btrfs-volume over nfs.
>>>>> The btrfs-volume is on top of dm-crypt devices.
>>>>>
>>>>> Any additional info I can give to help?
>>>>> Tests you want me to run?
>>>> Very strange, since I don't actually see what we're waiting for.  Can
>>>> you please either send me your btrfs.ko or use gdb to see where this
>>>> statement is:
>>>>
>>>>
>>>> btrfs_commit_transaction+0x315
>>>>
>>>> The syntax is
>>>>
>>>> gdb btrfs.ko
>>>> gdb> list *btrfs_commit_transaction+0x315
>>>>
>>>> -chris
>>> Sure, here you go.
>>>
>>> Reading symbols from btrfs.ko...done.
>>> (gdb) list *btrfs_commit_transaction+0x315
>>> 0x30f95 is in btrfs_commit_transaction (fs/btrfs/transaction.c:1752).
>>> 1747         * COMMIT_DOING so make sure to wait for num_writers to ==
>>> 1 again.
>>> 1748         */
>>> 1749        spin_lock(&root->fs_info->trans_lock);
>>> 1750        cur_trans->state = TRANS_STATE_COMMIT_DOING;
>>> 1751        spin_unlock(&root->fs_info->trans_lock);
>>> 1752        wait_event(cur_trans->writer_wait,
>>> 1753               atomic_read(&cur_trans->num_writers) == 1);
>>> 1754
>>> 1755        /* ->aborted might be set after the previous check, so
>>> check it */
>>> 1756        if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
>>> (gdb)
>>>
>>> I'm attaching the btrfs.ko as well, hopefully the 20M file gets through.


Ok, we're stuck here.  The transaction won't coomplete until this disk IO is done.

Since this is just a read, are you able to read from the device when this is
happening?  This would be the dm-crypt block device w/btrfs on it.

[180625.987870] kworker/u16:12  D ffff88042fd94500     0 15271      2 0x00000000 
[180625.987935] Workqueue: btrfs-delalloc normal_work_helper [btrfs]
[180625.987987]  ffff880107a4f648 0000000000000002 ffff88001383b260 ffff880107a4ffd8
[180625.988075]  0000000000014500 0000000000014500 ffff880419749930 ffff88042fd94e18
[180625.988163]  ffff88042ffadce8 0000000000000002 ffffffff8114df40 ffff880107a4f6c0
[180625.988251] Call Trace:
[180625.988291]  [<ffffffff8114df40>] ? wait_on_page_read+0x60/0x60
[180625.988342]  [<ffffffff816f84cd>] io_schedule+0x9d/0x140
[180625.988391]  [<ffffffff8114df4e>] sleep_on_page+0xe/0x20
[180625.988440]  [<ffffffff816f8962>] __wait_on_bit+0x62/0x90
[180625.988490]  [<ffffffff8114dd0f>] wait_on_page_bit+0x7f/0x90
[180625.988541]  [<ffffffff810acf80>] ? autoremove_wake_function+0x40/0x40
[180625.988601]  [<ffffffffa01c8e8a>] read_extent_buffer_pages+0x2ca/0x300 [btrfs]
[180625.988687]  [<ffffffffa019dd70>] ? free_root_pointers+0x60/0x60 [btrfs]
[180625.988746]  [<ffffffffa019efa3>] btree_read_extent_buffer_pages.constprop.52+0xb3/0x120 [btrfs]
[180625.988839]  [<ffffffffa01a00c8>] read_tree_block+0x38/0x60 [btrfs]
[180625.988895]  [<ffffffffa01828c8>] read_block_for_search.isra.33+0x148/0x380 [btrfs]
[180625.988983]  [<ffffffffa0187f97>] btrfs_next_old_leaf+0x297/0x4a0 [btrfs]
[180625.989041]  [<ffffffffa01881b0>] btrfs_next_leaf+0x10/0x20 [btrfs]
[180625.989099]  [<ffffffffa01cdc9c>] find_free_dev_extent+0xbc/0x350 [btrfs]
[180625.989159]  [<ffffffffa01ce0e4>] __btrfs_alloc_chunk+0x1b4/0x770 [btrfs]
[180625.989214]  [<ffffffff8101ad25>] ? native_sched_clock+0x35/0x90
[180625.989265]  [<ffffffff811bef49>] ? __sb_start_write+0x49/0xe0
[180625.989322]  [<ffffffffa01d0b94>] btrfs_alloc_chunk+0x34/0x40 [btrfs]
[180625.989380]  [<ffffffffa018f9fe>] do_chunk_alloc+0x23e/0x410 [btrfs]
[180625.989438]  [<ffffffffa0194753>] find_free_extent+0xb03/0xbb0 [btrfs]
[180625.989496]  [<ffffffffa01949d8>] btrfs_reserve_extent+0xa8/0x1a0 [btrfs]
[180625.989555]  [<ffffffffa01ad9f5>] cow_file_range+0x135/0x440 [btrfs]
[180625.989613]  [<ffffffffa01aecff>] submit_compressed_extents+0x1bf/0x480 [btrfs]
[180625.989700]  [<ffffffffa01ac804>] ? async_cow_free+0x24/0x30 [btrfs]
[180625.989758]  [<ffffffffa01aefc0>] ? submit_compressed_extents+0x480/0x480 [btrfs]
[180625.989845]  [<ffffffffa01af046>] async_cow_submit+0x86/0x90 [btrfs]
[180625.989904]  [<ffffffffa01d5333>] normal_work_helper+0x193/0x2b0 [btrfs]
[180625.989957]  [<ffffffff81081532>] process_one_work+0x182/0x450
[180625.990008]  [<ffffffff81082331>] worker_thread+0x121/0x410
[180625.990058]  [<ffffffff81082210>] ? rescuer_thread+0x430/0x430
[180625.990109]  [<ffffffff81088e72>] kthread+0xd2/0xf0
[180625.990156]  [<ffffffff81088da0>] ? kthread_create_on_node+0x190/0x190
[180625.990210]  [<ffffffff81704dfc>] ret_from_fork+0x7c/0xb0
[180625.990259]  [<ffffffff81088da0>] ? kthread_create_on_node+0x190/0x190

