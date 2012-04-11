From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:3982!
Date: Wed, 11 Apr 2012 15:39:07 -0600
Message-ID: <4F85F9FB.5020007@sandia.gov>
References: <4F848C62.6030100@sandia.gov>
 <20120411190926.GE2506@localhost.localdomain>
 <4F85E87E.90804@sandia.gov>
 <20120411202823.GG2506@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Josef Bacik" <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120411202823.GG2506@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/11/2012 02:28 PM, Josef Bacik wrote:
> On Wed, Apr 11, 2012 at 02:24:30PM -0600, Jim Schutt wrote:
>> On 04/11/2012 01:09 PM, Josef Bacik wrote:
>>> On Tue, Apr 10, 2012 at 01:39:14PM -0600, Jim Schutt wrote:
>>>> Hi,
>>>>
>>>> I hit this BUG today.
>>>>
>>>> I'm running 3.3.1 merged with the ceph and btrfs bits for 3.4,
>>>> i.e. 3.3.1 +
>>>>    commit bc3f116fec194 "Btrfs: update the checks for mixed block groups with big metadata blocks"
>>>>    commit c666601a935b9 "rbd: move snap_rwsem to the device, rename to header_rwsem"
>>>>
>>>> The btrfs filesystem in question is backing a Ceph OSD under
>>>> a heavy write load.
>>>>
>>>> Here's the bug:
>>>>
>>>
>>> Can you give this a whirl and let me know how it goes?  If I'm right you should
>>> see a warning pop up in your messages.  Thanks,
>>
>> OK, I've got my test running with your patch applied
>> to my previous kernel.
>>
>> Do you expect your warning to only fire when my
>> previous kernel would have BUGged?  I ask because I've
>> only seen the BUG once, so it may be a low-probability
>> occurrence.
>>
>> It seems like I should keep testing until I see either
>> your new warning or the BUG, right?
>>
>
> So hopefully you will see my WARN with no BUG, but yes keep running until you
> see one or the other please ;).  Thanks,

Hmmm, the BUG won:

[ 6202.249041] ------------[ cut here ]------------
[ 6202.253654] kernel BUG at fs/btrfs/extent_io.c:3989!
[ 6202.258607] invalid opcode: 0000 [#1] SMP
[ 6202.262737] CPU 5
[ 6202.264578] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 ib_sa iw_cxgb4 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun kvm uinput sg joydev sd_mod ata_piix libata microcode button mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ehci_hcd uhci_hcd ioatdma dm_mod i7core_edac edac_core nfs nfs_acl auth_rpcgss fscache lockd sunrpc tg3 bnx2 igb dca e1000 [last unloaded: scsi_wait_scan]
[ 6202.319360]
[ 6202.320862] Pid: 1676, comm: kworker/5:2 Not tainted 3.3.1-00163-gdf6ae83 #17 Supermicro X8DTH-i/6/iF/6F/X8DTH
[ 6202.330900] RIP: 0010:[<ffffffffa057724c>]  [<ffffffffa057724c>] btrfs_release_extent_buffer_page.clone.0+0x2c/0x130 [btrfs]
[ 6202.342121] RSP: 0018:ffff88060c74da00  EFLAGS: 00010202
[ 6202.347417] RAX: 0000000000000004 RBX: ffff88049b4d3b20 RCX: ffff8809135bf9a8
[ 6202.354521] RDX: ffff8802df769cd9 RSI: 00000000001409bc RDI: ffff88049b4d3b20
[ 6202.361626] RBP: ffff88060c74da30 R08: 000000000000003c R09: 0000000000000003
[ 6202.368734] R10: 0000000000000008 R11: ffff8802a9aa6a20 R12: ffff88060c74c000
[ 6202.375848] R13: ffff88049b4d3b20 R14: 000000000000000e R15: ffff88060c74dc10
[ 6202.382963] FS:  0000000000000000(0000) GS:ffff880627ca0000(0000) knlGS:0000000000000000
[ 6202.391029] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6202.396758] CR2: ffffffffff600400 CR3: 000000061e956000 CR4: 00000000000006e0
[ 6202.403872] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6202.410986] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6202.418104] Process kworker/5:2 (pid: 1676, threadinfo ffff88060c74c000, task ffff8806166616b0)
[ 6202.426776] Stack:
[ 6202.428792]  ffff880600000000 ffff88049b4d3b20 ffff88060c74c000 ffff8802fc3c3290
[ 6202.436257]  000000000000000e ffff88060c74dc10 ffff88060c74da60 ffffffffa05773f2
[ 6202.443735]  ffff88060c74db80 ffff88049b4d3b20 ffff88060c74db10 0000000000000000
[ 6202.451211] Call Trace:
[ 6202.453690]  [<ffffffffa05773f2>] release_extent_buffer+0xa2/0xe0 [btrfs]
[ 6202.460505]  [<ffffffffa05775b4>] free_extent_buffer+0x34/0x80 [btrfs]
[ 6202.467051]  [<ffffffffa0578152>] btree_write_cache_pages+0x272/0x480 [btrfs]
[ 6202.474169]  [<ffffffff81077588>] ? update_curr+0x128/0x1f0
[ 6202.479761]  [<ffffffffa054c96a>] btree_writepages+0x3a/0x50 [btrfs]
[ 6202.486110]  [<ffffffff810fc421>] do_writepages+0x21/0x40
[ 6202.491500]  [<ffffffff810f0b0b>] __filemap_fdatawrite_range+0x5b/0x60
[ 6202.498019]  [<ffffffff810f0de3>] filemap_fdatawrite_range+0x13/0x20
[ 6202.504407]  [<ffffffffa0552ecf>] btrfs_write_marked_extents+0x7f/0xe0 [btrfs]
[ 6202.511639]  [<ffffffffa0552f5e>] btrfs_write_and_wait_marked_extents+0x2e/0x60 [btrfs]
[ 6202.519679]  [<ffffffffa0552fbb>] btrfs_write_and_wait_transaction+0x2b/0x50 [btrfs]
[ 6202.527464]  [<ffffffffa055404c>] btrfs_commit_transaction+0x7ac/0xa10 [btrfs]
[ 6202.534675]  [<ffffffff81079540>] ? set_next_entity+0x90/0xa0
[ 6202.540418]  [<ffffffff8105f5d0>] ? wake_up_bit+0x40/0x40
[ 6202.545830]  [<ffffffffa0554590>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[ 6202.552825]  [<ffffffffa05545af>] do_async_commit+0x1f/0x30 [btrfs]
[ 6202.559111]  [<ffffffffa0554590>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[ 6202.566062]  [<ffffffff81058680>] process_one_work+0x140/0x490
[ 6202.571886]  [<ffffffff8105a417>] worker_thread+0x187/0x3f0
[ 6202.577453]  [<ffffffff8105a290>] ? manage_workers+0x120/0x120
[ 6202.583281]  [<ffffffff8105f02e>] kthread+0x9e/0xb0
[ 6202.588159]  [<ffffffff81486c64>] kernel_thread_helper+0x4/0x10
[ 6202.594076]  [<ffffffff8147d84a>] ? retint_restore_args+0xe/0xe
[ 6202.599988]  [<ffffffff8105ef90>] ? kthread_freezable_should_stop+0x80/0x80
[ 6202.606936]  [<ffffffff81486c60>] ? gs_change+0xb/0xb
[ 6202.611975] Code: 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 66 66 66 66 90 8b 47 38 49 89 fd 85 c0 75 0c 48 8b 47 20 4c 8d 7f 20 84 c0 79 04 <0f> 0b eb fe 48 8b 47 20 a8 04 75 f4 48 8b 07 49 89 c4 4c 03 67
[ 6202.631894] RIP  [<ffffffffa057724c>] btrfs_release_extent_buffer_page.clone.0+0x2c/0x130 [btrfs]
[ 6202.640773]  RSP <ffff88060c74da00>
[ 6202.644691] ---[ end trace de7af0e9a646be3b ]---

git blame fs/btrfs/extent_io.c | grep -w 3989
0b32f4bb (Josef Bacik        2012-03-13 09:38:00 -0400 3989) 	BUG_ON(extent_buffer_under_io(eb));

-- Jim


>
> Josef
>


