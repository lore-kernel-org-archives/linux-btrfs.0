Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51437 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbbACW6V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Jan 2015 17:58:21 -0500
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 37E202BA13
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Jan 2015 23:58:18 +0100 (CET)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GnRsqiFd0CQJ for <linux-btrfs@vger.kernel.org>;
	Sat,  3 Jan 2015 23:58:17 +0100 (CET)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Jan 2015 23:58:17 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 03 Jan 2015 23:58:17 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: WARNING: CPU: 1 PID: 2436 at fs/btrfs/qgroup.c:1414
 =?UTF-8?Q?btrfs=5Fdelayed=5Fqgroup=5Faccounting+=30x=39f=31/=30xa=30b=20?=
 =?UTF-8?Q?=5Bbtrfs=5D=28=29?=
Message-ID: <27573d37c7d634c3232820fa8464f235@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got this with 3.18.1 and qgroups enabled. Not sure how to reproduce.


[1262648.802286] ------------[ cut here ]------------
[1262648.802350] WARNING: CPU: 1 PID: 2436 at fs/btrfs/qgroup.c:1414 
btrfs_delayed_qgroup_accounting+0x9f1/0xa0b [btrfs]()
[1262648.802441] Modules linked in: ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand 
cpufreq_conservative cpufreq_powersave cpufreq_stats nfsd auth_rpcgss 
oid_registry exportfs nfs_acl nfs lockd grace fscache sunrpc ipv6 btrfs 
xor raid6_pq zlib_deflate coretemp hwmon loop pcspkr i2c_i801 i2c_core 
battery parport_pc parport 8250_fintek tpm_infineon tpm_tis tpm video 
ehci_pci ehci_hcd lpc_ich mfd_core acpi_cpufreq button ext4 crc16 jbd2 
mbcache raid1 sg sd_mod r8169 mii ahci libahci libata scsi_mod
[1262648.802854] CPU: 1 PID: 2436 Comm: btrfs-cleaner Not tainted 3.18.1 
#1
[1262648.802902] Hardware name: System manufacturer System Product 
Name/P8H77-M PRO, BIOS 1101 02/04/2013
[1262648.802992]  0000000000000009 ffff8800c805fbe8 ffffffff813b1128 
0000000000000000
[1262648.803081]  0000000000000000 ffff8800c805fc28 ffffffff81039b39 
ffff8807f341c000
[1262648.803170]  ffffffffa0300be2 ffff8807f341c000 ffff8807f3fd8b40 
ffffffffffffffff
[1262648.803259] Call Trace:
[1262648.803305]  [<ffffffff813b1128>] dump_stack+0x46/0x58
[1262648.803352]  [<ffffffff81039b39>] warn_slowpath_common+0x77/0x91
[1262648.803406]  [<ffffffffa0300be2>] ? 
btrfs_delayed_qgroup_accounting+0x9f1/0xa0b [btrfs]
[1262648.803495]  [<ffffffff81039b68>] warn_slowpath_null+0x15/0x17
[1262648.803548]  [<ffffffffa0300be2>] 
btrfs_delayed_qgroup_accounting+0x9f1/0xa0b [btrfs]
[1262648.803642]  [<ffffffffa02a12a5>] 
btrfs_run_delayed_refs+0x1e4/0x21b [btrfs]
[1262648.803734]  [<ffffffffa02aec96>] 
btrfs_should_end_transaction+0x4a/0x53 [btrfs]
[1262648.803826]  [<ffffffffa029fc34>] btrfs_drop_snapshot+0x379/0x68f 
[btrfs]
[1262648.803881]  [<ffffffffa02be478>] ? 
btrfs_run_defrag_inodes+0x2fa/0x30e [btrfs]
[1262648.803974]  [<ffffffffa02b0401>] 
btrfs_clean_one_deleted_snapshot+0xb3/0xc2 [btrfs]
[1262648.804067]  [<ffffffffa02a84ff>] cleaner_kthread+0x134/0x16c 
[btrfs]
[1262648.804119]  [<ffffffffa02a83cb>] ? btrfs_alloc_root+0x2c/0x2c 
[btrfs]
[1262648.804169]  [<ffffffff8104ebe7>] kthread+0xcd/0xd5
[1262648.804215]  [<ffffffff8104eb1a>] ? 
kthread_freezable_should_stop+0x43/0x43
[1262648.804264]  [<ffffffff813b59ec>] ret_from_fork+0x7c/0xb0
[1262648.804311]  [<ffffffff8104eb1a>] ? 
kthread_freezable_should_stop+0x43/0x43
[1262648.804360] ---[ end trace b76fd72b4be63515 ]---


-- 
Tomasz Chmielewski
http://www.sslrack.com

