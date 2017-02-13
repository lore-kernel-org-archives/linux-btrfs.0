Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-hk2apc01on0084.outbound.protection.outlook.com ([104.47.124.84]:37610
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751297AbdBMDik (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Feb 2017 22:38:40 -0500
From: Sam McLeod <samm@infoxchange.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs btree_ctree_super fault
Date: Mon, 13 Feb 2017 03:38:35 +0000
Message-ID: <1F38CB6B-A8FE-40C8-8A70-814C309BC28E@infoxchange.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/17/2016 12:39 AM, Chris Cui wrote:

We have just encountered the same bug on 4.9.0-rc2.  Any solution now?


kernel BUG at fs/btrfs/ctree.c:3172!
invalid opcode:  [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 0 PID: 22702 Comm: trinity-c40 Not tainted 4.9.0-rc4-think+ #1
task: 8804ffde37c0 task.stack: c90002188000
RIP: 0010:[]
  [] btrfs_set_item_key_safe+0x179/0x190 [btrfs]
RSP: :c9000218b8a8  EFLAGS: 00010246
RAX:  RBX: 8804fddcf348 RCX: 1000
RDX:  RSI: c9000218b9ce RDI: c9000218b8c7
RBP: c9000218b908 R08: 4000 R09: c9000218b8c8
R10:  R11: 0001 R12: c9000218b8b6
R13: c9000218b9ce R14: 0001 R15: 880480684a88
FS:  7f7c7f998b40() GS:88050780() knlGS:
CS:  0010 DS:  ES:  CR0: 80050033
CR2:  CR3: 00044f15f000 CR4: 001406f0
DR0: 7f4ce439d000 DR1:  DR2: 
DR3:  DR6: 0ff0 DR7: 0600
Stack:
 88050143 d305a00a2245 006c0002 0510
 6c0002d3 1000 6427eebb 880480684a88
  8804fddcf348 2000 
Call Trace:
 [] __btrfs_drop_extents+0xb00/0xe30 [btrfs]


We're going to bash on Josef's patch and probably send it with the next 
merge window (queued for stable as well).


https://patchwork.kernel.org/patch/9431679/

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majord...@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


Hello,


We are seeing this issue regularly across many of the CentOS 7 servers we use for automated software builds.
We‚Äôve hit what seems to be this bug from kernel 3.10 through to 4.9.5-1 on physical hardware (HP BL460C G7 Blades, P410i RAID controller in RAID1) for several years now.

I‚Äôm finding it a little hard to navigate the plethora of mailing list archives and changelogs I‚Äôve found thus far and from the patch Chris provided above I couldn‚Äôt find a way to see if this had been merged into the kernel so I‚Äôm wondering ‚Äì

1) Did it make it in?
2) If so, In what kernel version? (and if possible, how can one correlate this information to a release in the future)
3) And finally, if so, do people generally agree that it‚Äôs resolved the issue?

Below is a crash (resulting in a reboot) we experienced this morning on one of the hosts.
(Note that since rebooting, this host has booted into a newer 4.9.9 kernel).


Kernel at time of crash: 4.9.5-1.el7.elrepo.x86_64

root@s1-b12:~  #   btrfs --version
btrfs-progs v4.4.1

root@s1-b12:~  #   btrfs fi show
Label: none  uuid: 87f6d740-0675-41d7-896d-b04d252c7783
	Total devices 1 FS bytes used 1.08GiB
	devid    1 size 426.61GiB used 4.02GiB path /dev/sda3

root@s1-b12:~ #   btrfs fi df /var/lib/docker
Data, single: total=2.01GiB, used=1.00GiB
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=1.00GiB, used=76.88MiB
GlobalReserve, single: total=16.00MiB, used=0.00B


[1712950.168671] ------------[ cut here ]------------
[1712950.169806] kernel BUG at fs/btrfs/ctree.c:3172!
[1712950.170925] invalid opcode: 0000 [#1] SMP
[1712950.172034] Modules linked in: fuse ufs hfsplus hfs vfat msdos fat veth binfmt_misc mptctl mptbase ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack bonding xfs libcrc32c intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd intel_cstate btrfs xor ipmi_devintf raid6_pq iTCO_wdt gpio_ich iTCO_vendor_support pcspkr sg lpc_ich mfd_core hpwdt hpilo ipmi_si ipmi_msghandler be2iscsi iscsi_boot_sysfs libiscsi i7core_edac acpi_power_meter scsi_transport_iscsi edac_core shpchp pcc_cpufreq acpi_cpufreq ip_tables ext4 jbd2 mbcache sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt
[1712950.179662]  crc32c_intel fb_sys_fops serio_raw ttm hpsa drm scsi_transport_sas be2net fjes dm_mirror dm_region_hash dm_log dm_mod
[1712950.182391] CPU: 7 PID: 18324 Comm: apt-get Tainted: G          I     4.9.5-1.el7.elrepo.x86_64 #1
[1712950.183805] Hardware name: HP ProLiant BL460c G7, BIOS I27 08/16/2015
[1712950.185223] task: ffff880549f48000 task.stack: ffffc9000d640000
[1712950.186655] RIP: 0010:[<ffffffffa04042b2>]  [<ffffffffa04042b2>] btrfs_set_item_key_safe+0x172/0x180 [btrfs]
[1712950.188180] RSP: 0018:ffffc9000d643920  EFLAGS: 00010246
[1712950.189664] RAX: 0000000000000000 RBX: 0000000000000031 RCX: 00000000000a0000
[1712950.191155] RDX: 0000000000000000 RSI: ffffc9000d643a3e RDI: ffffc9000d64393f
[1712950.192639] RBP: ffffc9000d643980 R08: 0000000000004000 R09: ffffc9000d643940
[1712950.194111] R10: 0000000000000000 R11: 0000000000000003 R12: ffffc9000d64392e
[1712950.195569] R13: ffff8808efb15d90 R14: ffffc9000d643a3e R15: ffff8807ef220d20
[1712950.197044] FS:  00007ff1686d56e0(0000) GS:ffff880bdb8c0000(0000) knlGS:0000000000000000
[1712950.198529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1712950.200008] CR2: 00007ff1672adb8c CR3: 0000000ac136f000 CR4: 00000000000006e0
[1712950.201524] Stack:
[1712950.203021]  ffff8812b46f0000 438effffa044a2c8 006c000000000000 8e00000000000a00
[1712950.204562]  6c00000000000043 00000000000a0000 0000000050c4c66c ffff8808efb15d90
[1712950.206119]  0000000000003540 0000000000000000 0000000000c00000 ffff8807ef220d20
[1712950.207684] Call Trace:
[1712950.209248]  [<ffffffffa0444dc6>] __btrfs_drop_extents+0x536/0xd90 [btrfs]
[1712950.210889]  [<ffffffffa04709c6>] btrfs_log_changed_extents+0x356/0x650 [btrfs]
[1712950.212480]  [<ffffffffa0470161>] ? fill_inode_item.isra.17+0x231/0x290 [btrfs]
[1712950.214058]  [<ffffffffa04765e6>] btrfs_log_inode+0xa56/0xc20 [btrfs]
[1712950.215626]  [<ffffffffa046f99c>] ? check_parent_dirs_for_sync+0xec/0x120 [btrfs]
[1712950.217216]  [<ffffffffa0476abb>] btrfs_log_inode_parent+0x27b/0x970 [btrfs]
[1712950.218814]  [<ffffffffa042cea1>] ? wait_current_trans.isra.23+0x31/0x110 [btrfs]
[1712950.220394]  [<ffffffff81202847>] ? kmem_cache_alloc+0xd7/0x1a0
[1712950.221985]  [<ffffffffa042f5fc>] ? start_transaction+0x11c/0x4b0 [btrfs]
[1712950.223583]  [<ffffffffa0478112>] btrfs_log_dentry_safe+0x62/0x80 [btrfs]
[1712950.225173]  [<ffffffffa0447702>] btrfs_sync_file+0x2a2/0x3f0 [btrfs]
[1712950.226748]  [<ffffffff8125e8bd>] vfs_fsync_range+0x3d/0xb0
[1712950.228331]  [<ffffffff811de57e>] SyS_msync+0x16e/0x1f0
[1712950.229903]  [<ffffffff81003a47>] do_syscall_64+0x67/0x180
[1712950.231466]  [<ffffffff8175692b>] entry_SYSCALL64_slow_path+0x25/0x25
[1712950.233023] Code: 48 8b 45 b7 48 8d 7d bf 4c 89 f6 48 89 45 c8 0f b6 45 b6 88 45 c7 48 8b 45 ae 48 89 45 bf e8 c6 f2 ff ff 85 c0 0f 8f 46 ff ff ff <0f> 0b e8 e7 dd c7 e0 0f 0b 0f 1f 44 00 00 66 66 66 66 90 55 48 
[1712950.236350] RIP  [<ffffffffa04042b2>] btrfs_set_item_key_safe+0x172/0x180 [btrfs]
[1712950.238008]  RSP <ffffc9000d643920>

I apologise in advance if this is incorrectly posted in any way, I don‚Äôt often post to mailing lists.

--
Sam McLeod



ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
