From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1301!
Date: Mon, 20 Jun 2011 16:30:28 -0600
Message-ID: <4DFFCA04.1000209@sandia.gov>
References: <4DFB7C77.6010807@sandia.gov>
 <4DFF1CFA.7060201@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Cc: linux-btrfs@vger.kernel.org, "Josef Bacik" <josef@redhat.com>,
	ceph-devel@vger.kernel.org
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DFF1CFA.7060201@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

Miao Xie wrote:
> Hi, Jim
> 
> Could you test the attached patch for me? 
> I have done some quick tests, it worked well. But I'm not sure if it can fix
> the bug you reported or not, so I need your help!

So far I haven't been able to reproduce with your patch
applied.  I'd like to test for a few more days, though,
before calling it good.

Thanks for the patch -- I'll let you know what more
testing brings.

-- Jim

> 
> Thanks
> Miao
> 
> On fri, 17 Jun 2011 10:10:31 -0600, Jim Schutt wrote:
>> Hi,
>>
>> I've hit this delayed-inode BUG several times.  I'm using btrfs
>> as the data store for Ceph OSDs, and testing a heavy write load.
>> The kernel I'm running is a recent commit (f8f44f09eaa) from
>> Linus' tree with the for-chris branch (commit ed0ca14021e5) of
>>   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git
>> merged in.
>>
>> Please let me know what I can do to help resolve this.
>>
>> [ 5447.554187] err add delayed dir index item(name: pglog_0.965_0) into the insertion tree of the delayed node(root id: 262, inode id: 258, errno: -17)
>> [ 5447.569766] ------------[ cut here ]------------
>> [ 5447.575361] kernel BUG at fs/btrfs/delayed-inode.c:1301!
>> [ 5447.580672] invalid opcode: 0000 [#1] SMP
>> [ 5447.584806] CPU 2
>> [ 5447.586646] Modules linked in: loop btrfs zlib_deflate lzo_compress ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp i2c_dev i2c_core ext3 jbd scsi_transport_iscsi rds ib_ipoib rdma_ucm rdma_cm ib_ucm ib_uverbs ib_umad ib_cm iw_cm ib_addr ipv6 ib_sa dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod video sbs sbshc pci_slot battery acpi_pad ac kvm sg ses enclosure sd_mod megaraid_sas ide_cd_mod cdrom qla2xxx ib_mthca scsi_transport_fc ib_mad scsi_tgt ib_core button serio_raw ata_piix i5k_amb libata hwmon i5000_edac scsi_mod tpm_tis edac_core ehci_hcd pcspkr iTCO_wdt tpm dcdbas tpm_bios iTCO_vendor_support uhci_hcd rtc nfs nfs_acl auth_rpcgss fscache lockd sunrpc tg3 bnx2
  e1000 [last unloaded: freq_table]
>> [ 5447.660248]
>> [ 5447.661744] Pid: 7622, comm: cosd Not tainted 3.0.0-rc3-00178-gbfc8ccb #34 Dell Inc. PowerEdge 1950/0DT097
>> [ 5447.671421] RIP: 0010:[<ffffffffa068a7fc>]  [<ffffffffa068a7fc>] btrfs_insert_delayed_dir_index+0x124/0x14c [btrfs]
>> [ 5447.681922] RSP: 0018:ffff88021c0edaf8  EFLAGS: 00010292
>> [ 5447.687351] RAX: 000000000000009e RBX: ffff880085bf0480 RCX: 0000000000012e0f
>> [ 5447.694487] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffffff819aed98
>> [ 5447.701631] RBP: ffff88021c0edb48 R08: ffff88021c0ed908 R09: ffffffff8189ef98
>> [ 5447.708783] R10: 0000000000000000 R11: 0000000000000006 R12: 00000000ffffffef
>> [ 5447.715923] R13: ffff880072e64240 R14: ffff880072e64288 R15: 000000000000000d
>> [ 5447.723065] FS:  00007fefc66a9940(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
>> [ 5447.731178] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [ 5447.736934] CR2: 00000000004042b0 CR3: 00000001ca4ef000 CR4: 00000000000006e0
>> [ 5447.744087] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [ 5447.751218] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [ 5447.758343] Process cosd (pid: 7622, threadinfo ffff88021c0ec000, task ffff8801d92996b0)
>> [ 5447.766422] Stack:
>> [ 5447.768429]  00000001d2da3700 ffff88021c0edb88 ffff8802238d50f8 ffff880225627000
>> [ 5447.775866]  ffff8801e32f5e58 ffff8801d2da3700 0000000000000000 ffff8801d9aec510
>> [ 5447.783291]  000000000000000d ffff8802238d50f8 ffff88021c0edbf8 ffffffffa0641c4e
>> [ 5447.790721] Call Trace:
>> [ 5447.793191]  [<ffffffffa0641c4e>] btrfs_insert_dir_item+0x189/0x1bb [btrfs]
>> [ 5447.800156]  [<ffffffffa0651a45>] btrfs_add_link+0x12b/0x191 [btrfs]
>> [ 5447.806517]  [<ffffffffa0651adc>] btrfs_add_nondir+0x31/0x58 [btrfs]
>> [ 5447.812876]  [<ffffffffa0651d6a>] btrfs_create+0xf9/0x197 [btrfs]
>> [ 5447.818961]  [<ffffffff8111f840>] vfs_create+0x72/0x92
>> [ 5447.824090]  [<ffffffff8111fa8c>] do_last+0x22c/0x40b
>> [ 5447.829133]  [<ffffffff8112076a>] path_openat+0xc0/0x2ef
>> [ 5447.834438]  [<ffffffff810c58e2>] ? __perf_event_task_sched_out+0x24/0x44
>> [ 5447.841216]  [<ffffffff8103ecdd>] ? perf_event_task_sched_out+0x59/0x67
>> [ 5447.847846]  [<ffffffff81121a79>] do_filp_open+0x3d/0x87
>> [ 5447.853156]  [<ffffffff811e126c>] ? strncpy_from_user+0x43/0x4d
>> [ 5447.859072]  [<ffffffff8111f1f5>] ? getname_flags+0x2e/0x80
>> [ 5447.864636]  [<ffffffff8111f179>] ? do_getname+0x14b/0x173
>> [ 5447.870112]  [<ffffffff8111f1b7>] ? audit_getname+0x16/0x26
>> [ 5447.875682]  [<ffffffff8112b1ab>] ? spin_lock+0xe/0x10
>> [ 5447.880882]  [<ffffffff81112d39>] do_sys_open+0x69/0xae
>> [ 5447.886153]  [<ffffffff81112db1>] sys_open+0x20/0x22
>> [ 5447.891114]  [<ffffffff813b9aab>] system_call_fastpath+0x16/0x1b
>> [ 5447.897124] Code: 85 c0 41 89 c4 74 28 49 8b 45 10 49 8b 4d 00 45 89 e0 48 8b 75 c0 48 c7 c7 bb 43 69 a0 48 8b 90 e8 02 00 00 31 c0 e8 ce fb 9b e0 <0f> 0b eb fe 4c 89 f7 e8 81 7b d2 e0 4c 89 ef e8 d4 e4 ff ff 48
>> [ 5447.916562] RIP  [<ffffffffa068a7fc>] btrfs_insert_delayed_dir_index+0x124/0x14c [btrfs]
>> [ 5447.924683]  RSP <ffff88021c0edaf8>
>> [ 5447.928514] ---[ end trace 461a7f9887994fe0 ]---
>>
>> -- Jim
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 


