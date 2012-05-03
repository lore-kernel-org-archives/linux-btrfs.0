From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:3982!
Date: Thu, 3 May 2012 08:43:32 -0600
Message-ID: <4FA29994.6030009@sandia.gov>
References: <4F848C62.6030100@sandia.gov>
 <20120411190926.GE2506@localhost.localdomain>
 <4F85E87E.90804@sandia.gov>
 <20120501160047.GA2050@localhost.localdomain>
 <4FA01239.7080907@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Josef Bacik" <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA01239.7080907@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/01/2012 10:41 AM, Jim Schutt wrote:
> On 05/01/2012 10:00 AM, Josef Bacik wrote:
>> On Wed, Apr 11, 2012 at 02:24:30PM -0600, Jim Schutt wrote:
>>> On 04/11/2012 01:09 PM, Josef Bacik wrote:
>>>> On Tue, Apr 10, 2012 at 01:39:14PM -0600, Jim Schutt wrote:
>>>>> Hi,
>>>>>
>>>>> I hit this BUG today.
>>>>>
>>>>> I'm running 3.3.1 merged with the ceph and btrfs bits for 3.4,
>>>>> i.e. 3.3.1 +
>>>>> commit bc3f116fec194 "Btrfs: update the checks for mixed block groups with big metadata blocks"
>>>>> commit c666601a935b9 "rbd: move snap_rwsem to the device, rename to header_rwsem"
>>>>>
>>>>> The btrfs filesystem in question is backing a Ceph OSD under
>>>>> a heavy write load.
>>>>>
>>>>> Here's the bug:
>>>>>
>>>>
>>>> Can you give this a whirl and let me know how it goes? If I'm right you should
>>>> see a warning pop up in your messages. Thanks,
>>>
>>> OK, I've got my test running with your patch applied
>>> to my previous kernel.
>>>
>>> Do you expect your warning to only fire when my
>>> previous kernel would have BUGged? I ask because I've
>>> only seen the BUG once, so it may be a low-probability
>>> occurrence.
>>>
>>> It seems like I should keep testing until I see either
>>> your new warning or the BUG, right?
>>
>> Hey Jim,
>>
>> I just sent a patch to the list
>>
>> [PATCH] Btrfs: fix page leak when allocing extent buffers
>>
>> Could you try that and see if you can reproduce your problem?
>
> Taking it for a spin now...
>

Hit it again:

[ 4638.295231] ------------[ cut here ]------------
[ 4638.299840] kernel BUG at fs/btrfs/extent_io.c:3993!
[ 4638.304792] invalid opcode: 0000 [#1] SMP
[ 4638.308912] CPU 3
[ 4638.310745] Modules linked in: btrfs zlib_deflate dm_round_robin ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 ib_sa iw_cxgb4 sg sd_mod dm_mirror dm_region_hash dm_log dm_multipath scsi_dh vhost_net macvtap macvlan tun kvm uinput joydev button ata_piix libata mpt2sas scsi_transport_sas raid_class scsi_mod microcode serio_raw pcspkr mlx4_ib ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ehci_hcd uhci_hcd ioatdma i7core_edac edac_core dm_mod nfs nfs_acl auth_rpcgss fscache lockd sunrpc broadcom tg3 bnx2 igb dca e1000 [last unloaded: scsi_wait_scan]
[ 4638.366288]
[ 4638.367786] Pid: 32179, comm: kworker/3:5 Not tainted 3.3.4-00186-g56a0ae2 #65 Supermicro X8DTH-i/6/iF/6F/X8DTH
[ 4638.377898] RIP: 0010:[<ffffffffa057717c>]  [<ffffffffa057717c>] btrfs_release_extent_buffer_page.clone.0+0x2c/0x130 [btrfs]
[ 4638.389112] RSP: 0018:ffff8805ff6cba00  EFLAGS: 00010202
[ 4638.394408] RAX: 0000000000000004 RBX: ffff880152ba8c18 RCX: ffff8800be9e4468
[ 4638.401529] RDX: ffff8802f7d64b19 RSI: 00000000000858ec RDI: ffff880152ba8c18
[ 4638.408644] RBP: ffff8805ff6cba30 R08: 000000000000002c R09: 0000000000000003
[ 4638.415759] R10: 0000000000000008 R11: ffff880618cee0c0 R12: ffff8805ff6ca000
[ 4638.422874] R13: ffff880152ba8c18 R14: 000000000000000e R15: ffff8805ff6cbc10
[ 4638.429987] FS:  0000000000000000(0000) GS:ffff880627c60000(0000) knlGS:0000000000000000
[ 4638.438052] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4638.443781] CR2: ffffffffff600400 CR3: 0000000a06461000 CR4: 00000000000006e0
[ 4638.450900] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4638.458018] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 4638.465130] Process kworker/3:5 (pid: 32179, threadinfo ffff8805ff6ca000, task ffff88060bf14500)
[ 4638.473886] Stack:
[ 4638.475899]  ffff880500000000 ffff880152ba8c18 ffff8805ff6ca000 ffff880a0cf1aeb0
[ 4638.483350]  000000000000000e ffff8805ff6cbc10 ffff8805ff6cba60 ffffffffa0577322
[ 4638.490782]  ffff8805ff6cbb80 ffff880152ba8c18 ffff8805ff6cbb50 0000000000000008
[ 4638.498234] Call Trace:
[ 4638.500705]  [<ffffffffa0577322>] release_extent_buffer+0xa2/0xe0 [btrfs]
[ 4638.507492]  [<ffffffffa05774e4>] free_extent_buffer+0x34/0x80 [btrfs]
[ 4638.514036]  [<ffffffffa05780a2>] btree_write_cache_pages+0x272/0x480 [btrfs]
[ 4638.521155]  [<ffffffff81075b18>] ? enqueue_sleeper+0x248/0x2c0
[ 4638.527072]  [<ffffffffa054c92a>] btree_writepages+0x3a/0x50 [btrfs]
[ 4638.533411]  [<ffffffff810fc9f1>] do_writepages+0x21/0x40
[ 4638.538794]  [<ffffffff810f10db>] __filemap_fdatawrite_range+0x5b/0x60
[ 4638.545300]  [<ffffffff810f13b3>] filemap_fdatawrite_range+0x13/0x20
[ 4638.551654]  [<ffffffffa0552e8f>] btrfs_write_marked_extents+0x7f/0xe0 [btrfs]
[ 4638.558862]  [<ffffffffa0552f1e>] btrfs_write_and_wait_marked_extents+0x2e/0x60 [btrfs]
[ 4638.566867]  [<ffffffffa0552f7b>] btrfs_write_and_wait_transaction+0x2b/0x50 [btrfs]
[ 4638.574615]  [<ffffffffa0554058>] btrfs_commit_transaction+0x7d8/0x9f0 [btrfs]
[ 4638.581818]  [<ffffffff81079910>] ? set_next_entity+0x90/0xa0
[ 4638.587556]  [<ffffffff8105f970>] ? wake_up_bit+0x40/0x40
[ 4638.592957]  [<ffffffffa0554570>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[ 4638.599902]  [<ffffffffa055458f>] do_async_commit+0x1f/0x30 [btrfs]
[ 4638.606161]  [<ffffffffa0554570>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[ 4638.613106]  [<ffffffff81058a20>] process_one_work+0x140/0x490
[ 4638.618926]  [<ffffffff8105a7b7>] worker_thread+0x187/0x3f0
[ 4638.624484]  [<ffffffff8105a630>] ? manage_workers+0x120/0x120
[ 4638.630303]  [<ffffffff8105f3ce>] kthread+0x9e/0xb0
[ 4638.635171]  [<ffffffff81487a24>] kernel_thread_helper+0x4/0x10
[ 4638.641072]  [<ffffffff8147e60a>] ? retint_restore_args+0xe/0xe
[ 4638.646974]  [<ffffffff8105f330>] ? kthread_freezable_should_stop+0x80/0x80
[ 4638.653915]  [<ffffffff81487a20>] ? gs_change+0xb/0xb
[ 4638.658952] Code: 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 66 66 66 66 90 8b 47 38 49 89 fd 85 c0 75 0c 48 8b 47 20 4c 8d 7f 20 84 c0 79 04 <0f> 0b eb fe 48 8b 47 20 a8 04 75 f4 48 8b 07 49 89 c4 4c 03 67
[ 4638.678851] RIP  [<ffffffffa057717c>] btrfs_release_extent_buffer_page.clone.0+0x2c/0x130 [btrfs]
[ 4638.687729]  RSP <ffff8805ff6cba00>
[ 4638.691654] ---[ end trace 51121d321f4755d6 ]---


Kernel is 3.3.4 + for-linus branch (commit c666601a93) of
     git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
+ for-linus branch (commit dc7fdde39e) of
     git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
+ your debug patch for me: "kernel BUG at fs/btrfs/extent_io.c:3982!"
+ your patch "Btrfs: fix page leak when allocing extent buffers"


git blame fs/btrfs/extent_io.c | grep -w -C 10 3993
0b32f4bb (Josef Bacik        2012-03-13 09:38:00 -0400 3983)
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3984) /*
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3985)  * Helper for releasing extent buffer page.
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3986)  */
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3987) static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3988) 						unsigned long start_idx)
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3989) {
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3990) 	unsigned long index;
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3991) 	struct page *page;
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3992)
0b32f4bb (Josef Bacik        2012-03-13 09:38:00 -0400 3993) 	BUG_ON(extent_buffer_under_io(eb));
0b32f4bb (Josef Bacik        2012-03-13 09:38:00 -0400 3994)
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3995) 	index = num_extent_pages(eb->start, eb->len);
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3996) 	if (start_idx >= index)
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3997) 		return;
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3998)
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 3999) 	do {
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 4000) 		index--;
897ca6e9 (Miao Xie           2010-10-26 20:57:29 -0400 4001) 		page = extent_buffer_page(eb, index);
4f2de97a (Josef Bacik        2012-03-07 16:20:05 -0500 4002) 		if (page) {
4f2de97a (Josef Bacik        2012-03-07 16:20:05 -0500 4003) 			spin_lock(&page->map

FWIW, it takes a while to hit this - load was 128 Ceph clients writing
to a Ceph filesystem with 288 OSDs - the above bug hit several tens of
TB into a 65 TB aggregate write test.

-- Jim

> Thanks -- Jim
>
>> Thanks,
>>
>> Josef
>>
>


