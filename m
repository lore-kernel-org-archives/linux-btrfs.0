From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] btrfs: snapshot deletion via readahead
Date: Fri, 13 Apr 2012 15:10:15 +0800
Message-ID: <4F87D157.4040607@cn.fujitsu.com>
References: <cover.1334241664.git.sensille@gmx.net> <4F87A034.3030607@cn.fujitsu.com> <4F87CD6D.5040100@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F87CD6D.5040100@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/13/2012 02:53 PM, Arne Jansen wrote:

> On 13.04.2012 05:40, Liu Bo wrote:
>> > On 04/12/2012 11:54 PM, Arne Jansen wrote:
>>> >> This patchset reimplements snapshot deletion with the help of the readahead
>>> >> framework. For this callbacks are added to the framework. The main idea is
>>> >> to traverse many snapshots at once at read many branches at once. This way
>>> >> readahead get many requests at once (currently about 50000), giving it the
>>> >> chance to order disk accesses properly. On a single disk, the effect is
>>> >> currently spoiled by sync operations that still take place, mainly checksum
>>> >> deletion. The most benefit can be gained with multiple devices, as all devices
>>> >> can be fully utilized. It scales quite well with the number of devices.
>>> >> For more details see the commit messages of the individual patches and the
>>> >> source code comments.
>>> >>
>>> >> How it is tested:
>>> >> I created a test volume using David Sterba's stress-subvol-git-aging.sh. It
>>> >> checks out randoms version of the kernel git tree, creating a snapshot from it
>>> >> from time to time and checks out other versions there, and so on. In the end
>>> >> the fs had 80 subvols with various degrees of sharing between them. The
>>> >> following tests were conducted on it:
>>> >>  - delete a subvol using droptree and check the fs with btrfsck afterwards
>>> >>    for consistency
>>> >>  - delete all subvols and verify with btrfs-debug-tree that the extent
>>> >>    allocation tree is clean
>>> >>  - delete 70 subvols, and in parallel empty the other 10 with rm -rf to get
>>> >>    a good pressure on locking
>>> >>  - add various degrees of memory pressure to the previous test to get pages
>>> >>    to expire early from page cache
>>> >>  - enable all relevant kernel debugging options during all tests
>>> >>
>>> >> The performance gain on a single drive was about 20%, on 8 drives about 600%.
>>> >> It depends vastly on the maximum parallelity of the readahead, that is
>>> >> currently hardcoded to about 50000. This number is subject to 2 factors, the
>>> >> available RAM and the size of the saved state for a commit. As the full state
>>> >> has to be saved on commit, a large parallelity leads to a large state.
>>> >>
>>> >> Based on this I'll see if I can add delayed checksum deletions and running
>>> >> the delayed refs via readahead, to gain a maximum ordering of I/O ops.
>>> >>
>> > 
>> > Hi Arne,
>> > 
>> > Can you please show us some user cases in this, or can we get some extra benefits from it? :)
> 
> The case I'm most concerned with is having large filesystems (like 20x3T)
> with thousands of users on it in thousands of subvolumes and making
> hourly snapshots. Creating these snapshots is relatively easy, getting rid
> of them is not.
> But there are already reports where deleting a single snapshot can take
> several days. So we really need a huge speedup here, and this is only
> the beginning :)


I see.

I've just tested it on 3.4-rc2, I cannot get it through due to the following, could you take a look?

Apr  8 14:58:08 kvm kernel: ------------[ cut here ]------------
Apr  8 14:58:08 kvm kernel: kernel BUG at fs/btrfs/droptree.c:418!
Apr  8 14:58:08 kvm kernel: invalid opcode: 0000 [#1] SMP
Apr  8 14:58:08 kvm kernel: CPU 1
Apr  8 14:58:08 kvm kernel: Modules linked in: btrfs(O) zlib_deflate libcrc32c ip6table_filter ip6_tables ebtable_nat ebtables iptable_filter ipt_REJECT ip_tables bridge stp llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm ppdev sg parport_pc parport coretemp hwmon pcspkr i2c_i801 iTCO_wdt iTCO_vendor_support sky2 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi ata_ge
 neric ata_piix i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: btrfs]
Apr  8 14:58:08 kvm kernel:
Apr  8 14:58:08 kvm kernel: Pid: 532, comm: btrfs-readahead Tainted: G        W  O 3.4.0-rc1+ #10 LENOVO QiTianM7150/To be filled by O.E.M.
Apr  8 14:58:08 kvm kernel: RIP: 0010:[<ffffffffa082f800>]  [<ffffffffa082f800>] droptree_fetch_ref+0x4b0/0x4c0 [btrfs]
Apr  8 14:58:08 kvm kernel: RSP: 0018:ffff88003418bda0  EFLAGS: 00010286
Apr  8 14:58:08 kvm kernel: RAX: 00000000ffffffff RBX: ffff88007ab74348 RCX: 0000000105585190
Apr  8 14:58:08 kvm kernel: RDX: 000000000000003a RSI: ffffffff81ade6a0 RDI: 0000000000000286
Apr  8 14:58:08 kvm kernel: RBP: ffff88003418be10 R08: 000000000000003f R09: 0000000000000003
Apr  8 14:58:08 kvm kernel: R10: 0000000000000002 R11: 0000000000008340 R12: ffff880004194718
Apr  8 14:58:08 kvm kernel: R13: ffff88004004e000 R14: ffff880034b9b000 R15: ffff88000c64a820
Apr  8 14:58:08 kvm kernel: FS:  0000000000000000(0000) GS:ffff88007da80000(0000) knlGS:0000000000000000
Apr  8 14:58:08 kvm kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Apr  8 14:58:08 kvm kernel: CR2: 0000003842d454a4 CR3: 000000003d0a0000 CR4: 00000000000407e0
Apr  8 14:58:08 kvm kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Apr  8 14:58:08 kvm kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr  8 14:58:08 kvm kernel: Process btrfs-readahead (pid: 532, threadinfo ffff88003418a000, task ffff880076d3a040)
Apr  8 14:58:08 kvm kernel: Stack:
Apr  8 14:58:08 kvm kernel: ffff880078f06d40 ffff88007690ecd8 ffff88000c605758 ffff880078f06d80
Apr  8 14:58:08 kvm kernel: ffff880036916740 ffff88007ab742c0 0000000000000002 000000000000064f
Apr  8 14:58:08 kvm kernel: ffff88003418be10 ffff88007690ecc0 ffff88007690ed10 ffff88007690ecd8
Apr  8 14:58:08 kvm kernel: Call Trace:
Apr  8 14:58:08 kvm kernel: [<ffffffffa08032df>] worker_loop+0x14f/0x5a0 [btrfs]
Apr  8 14:58:08 kvm kernel: [<ffffffffa0803190>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
Apr  8 14:58:08 kvm kernel: [<ffffffffa0803190>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
Apr  8 14:58:08 kvm kernel: [<ffffffff8106f1ae>] kthread+0x9e/0xb0
Apr  8 14:58:08 kvm kernel: [<ffffffff814fbea4>] kernel_thread_helper+0x4/0x10
Apr  8 14:58:08 kvm kernel: [<ffffffff8106f110>] ? kthread_freezable_should_stop+0x70/0x70
Apr  8 14:58:08 kvm kernel: [<ffffffff814fbea0>] ? gs_change+0x13/0x13
Apr  8 14:58:08 kvm kernel: Code: fe 0f 0b 0f 1f 84 00 00 00 00 00 eb f6 0f 0b eb fe be fe 01 00 00 48 c7 c7 58 7b 83 a0 e8 e9 dd 81 e0 44 8b 55 a8 e9 77 ff ff ff <0f> 0b eb fe 0f 0b eb fe 90 90 90 90 90 90 90 90 55 48 89 e5 41
Apr  8 14:58:08 kvm kernel: RIP  [<ffffffffa082f800>] droptree_fetch_ref+0x4b0/0x4c0 [btrfs]


thanks,
-- 
liubo 
