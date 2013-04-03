Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44426 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761454Ab3DCIn2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2013 04:43:28 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 4CE393EE0AE
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2013 17:43:27 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 364AC45DE52
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2013 17:43:27 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 2162E45DE51
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2013 17:43:27 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 14DD61DB803B
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2013 17:43:27 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id B9E3D1DB8037
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2013 17:43:26 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 6BFC09F7D64
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2013 17:43:26 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.101.132])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 530D09F7D71
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2013 17:43:10 +0900 (JST)
Message-ID: <515BEB8F.8030208@jp.fujitsu.com>
Date: Wed, 03 Apr 2013 17:42:55 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: (3.9-rc5) WARNING: at fs/btrfs/super.c:255 __btrfs_abort_transaction
References: <515B838A.7020000@jp.fujitsu.com>
In-Reply-To: <515B838A.7020000@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/04/03 10:19, Tsutomu Itoh wrote:
> Hi,
> 
> When inode_cache was specified for the mount option, I encountered the
> following messages at umount.
> 
> Step to reproduce:
> 
>   mkfs.btrfs -f /dev/sdc4
>   mount -o compress=lzo,autodefrag,inode_cache /dev/sdc4 /test1
>   dd if=/dev/zero of=/test1/file1 bs=1M count=8192
>   dd if=/test1/file1 of=/dev/null bs=1M
>   rm -f /test1/file1
>   umount /test1

The size of my test partition is about 20GB.

# df -T /test1
Filesystem     Type  1K-blocks  Used Available Use% Mounted on
/dev/sdc4      btrfs  19530752    56  17404928   1% /test1
# btrfs fi sh /dev/sdc4
Label: none  uuid: d4937df0-618d-4854-8fac-5b5c9aa3c84f
        Total devices 1 FS bytes used 28.00KB
        devid    1 size 18.63GB used 2.04GB path /dev/sdc4

Btrfs v0.20-rc1-253-g7854c8b
# btrfs fi df /test1
Data: total=8.00MB, used=0.00
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=24.00KB
Metadata: total=8.00MB, used=0.00

- Tsutomu

> 
> Thanks,
> Tsutomu
> 
> ==========================================================================================
> 
> Apr  3 09:42:29 luna kernel: [  511.911342] btrfs: use lzo compression
> Apr  3 09:42:29 luna kernel: [  511.911348] btrfs: enabling auto defrag
> Apr  3 09:42:29 luna kernel: [  511.911352] btrfs: enabling inode map caching
> Apr  3 09:42:29 luna kernel: [  511.911353] btrfs: disk space caching is enabled
> Apr  3 09:43:12 luna kernel: [  554.638768] ------------[ cut here ]------------
> Apr  3 09:43:12 luna kernel: [  554.638815] WARNING: at fs/btrfs/super.c:255 __btrfs_abort_transaction+0x55/0xdc [btrfs]()
> Apr  3 09:43:12 luna kernel: [  554.638818] Hardware name: PRIMERGY
> Apr  3 09:43:12 luna kernel: [  554.638822] Modules linked in: btrfs(O) raid6_pq zlib_deflate xor crc32c libcrc32c ebtable_nat ebtables bnx2i cnic uio xt_CHECKSUM cxgb4i iptable_mangle cxgb4 cxgb3i cxgb3 mdio libcxgbi bridge stp llc iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfsd auth_rpcgss acpi_cpufreq mperf vhost_net freq_table coretemp tun nfs_acl lockd kvm dm_mirror dm_region_hash iTCO_wdt dm_log dm_mod iTCO_vendor_support tg3 shpchp sunrpc lpc_ich mfd_core ptp pci_hotplug i3000_edac edac_core pps_core microcode i2c_i801 pcspkr i2c_core uinput ipv6 autofs4 ext4 crc16 jbd2 mbcache sr_mod cdrom sd_mod crc_t10dif ata_piix libata megaraid_sas scsi_mod
> Apr  3 09:43:12 luna kernel: [  554.638898] Pid: 1749, comm: btrfs-transacti Tainted: G           O 3.9.0-rc5 #1
> Apr  3 09:43:12 luna kernel: [  554.638900] Call Trace:
> Apr  3 09:43:12 luna kernel: [  554.638909]  [<ffffffff8103e52f>] warn_slowpath_common+0x83/0x9e
> Apr  3 09:43:12 luna kernel: [  554.638914]  [<ffffffff8103e5ed>] warn_slowpath_fmt+0x46/0x48
> Apr  3 09:43:12 luna kernel: [  554.638931]  [<ffffffffa040db62>] __btrfs_abort_transaction+0x55/0xdc [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.638960]  [<ffffffffa04601e4>] ? btrfs_truncate_free_space_cache+0x6c/0x122 [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.638981]  [<ffffffffa0426513>] btrfs_save_ino_cache+0x190/0x2f9 [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.639003]  [<ffffffffa042cc6c>] commit_fs_roots.isra.27+0xa6/0x14e [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.639026]  [<ffffffff81064690>] ? should_resched+0x9/0x28
> Apr  3 09:43:12 luna kernel: [  554.639045]  [<ffffffff813dc287>] ? _cond_resched+0xe/0x22
> Apr  3 09:43:12 luna kernel: [  554.639079]  [<ffffffffa042e434>] btrfs_commit_transaction+0x471/0x898 [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.639084]  [<ffffffff8105a8d2>] ? bit_waitqueue+0x7a/0x7a
> Apr  3 09:43:12 luna kernel: [  554.639106]  [<ffffffffa0427820>] transaction_kthread+0xef/0x190 [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.639127]  [<ffffffffa0427731>] ? try_to_freeze+0x32/0x32 [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.639130]  [<ffffffff8105a2b9>] kthread+0x8d/0x95
> Apr  3 09:43:12 luna kernel: [  554.639134]  [<ffffffff8105a22c>] ? __kthread_parkme+0x65/0x65
> Apr  3 09:43:12 luna kernel: [  554.639138]  [<ffffffff813e3f2c>] ret_from_fork+0x7c/0xb0
> Apr  3 09:43:12 luna kernel: [  554.639142]  [<ffffffff8105a22c>] ? __kthread_parkme+0x65/0x65
> Apr  3 09:43:12 luna kernel: [  554.639145] ---[ end trace ab791b60ae901bf9 ]---
> Apr  3 09:43:12 luna kernel: [  554.639149] BTRFS error (device sdc4) in btrfs_save_ino_cache:471: error 28
> Apr  3 09:43:12 luna kernel: [  554.639153] btrfs is forced readonly
> Apr  3 09:43:12 luna kernel: [  554.640329] BTRFS warning (device sdc4): Skipping commit of aborted transaction.
> Apr  3 09:43:12 luna kernel: [  554.640335] BTRFS error (device sdc4) in cleanup_transaction:1455: error 28
> Apr  3 09:43:12 luna kernel: [  554.832554] ------------[ cut here ]------------
> Apr  3 09:43:12 luna kernel: [  554.832587] WARNING: at fs/btrfs/extent-tree.c:130 btrfs_put_block_group+0x4e/0x66 [btrfs]()
> Apr  3 09:43:12 luna kernel: [  554.832590] Hardware name: PRIMERGY
> Apr  3 09:43:12 luna kernel: [  554.832592] Modules linked in: btrfs(O) raid6_pq zlib_deflate xor crc32c libcrc32c ebtable_nat ebtables bnx2i cnic uio xt_CHECKSUM cxgb4i iptable_mangle cxgb4 cxgb3i cxgb3 mdio libcxgbi bridge stp llc iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfsd auth_rpcgss acpi_cpufreq mperf vhost_net freq_table coretemp tun nfs_acl lockd kvm dm_mirror dm_region_hash iTCO_wdt dm_log dm_mod iTCO_vendor_support tg3 shpchp sunrpc lpc_ich mfd_core ptp pci_hotplug i3000_edac edac_core pps_core microcode i2c_i801 pcspkr i2c_core uinput ipv6 autofs4 ext4 crc16 jbd2 mbcache sr_mod cdrom sd_mod crc_t10dif ata_piix libata megaraid_sas scsi_mod
> Apr  3 09:43:12 luna kernel: [  554.832663] Pid: 1787, comm: umount Tainted: G        W  O 3.9.0-rc5 #1
> Apr  3 09:43:12 luna kernel: [  554.832665] Call Trace:
> Apr  3 09:43:12 luna kernel: [  554.832674]  [<ffffffff8103e52f>] warn_slowpath_common+0x83/0x9e
> Apr  3 09:43:12 luna kernel: [  554.832679]  [<ffffffff8103e564>] warn_slowpath_null+0x1a/0x1c
> Apr  3 09:43:12 luna kernel: [  554.832697]  [<ffffffffa0419c0f>] btrfs_put_block_group+0x4e/0x66 [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.832717]  [<ffffffffa0420182>] btrfs_free_block_groups+0xec/0x286 [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.832740]  [<ffffffffa042ae0d>] close_ctree+0x200/0x32f [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.832745]  [<ffffffff81133f91>] ? evict_inodes+0xe0/0xef
> Apr  3 09:43:12 luna kernel: [  554.832761]  [<ffffffffa040abec>] btrfs_put_super+0x19/0x1b [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.832766]  [<ffffffff81121106>] generic_shutdown_super+0x57/0xd3
> Apr  3 09:43:12 luna kernel: [  554.832770]  [<ffffffff8112124c>] kill_anon_super+0x14/0x20
> Apr  3 09:43:12 luna kernel: [  554.832785]  [<ffffffffa040aa2b>] btrfs_kill_super+0x17/0x23 [btrfs]
> Apr  3 09:43:12 luna kernel: [  554.832789]  [<ffffffff81121639>] deactivate_locked_super+0x26/0x52
> Apr  3 09:43:12 luna kernel: [  554.832793]  [<ffffffff8112186e>] deactivate_super+0x38/0x3d
> Apr  3 09:43:12 luna kernel: [  554.832798]  [<ffffffff8113710d>] mntput_no_expire+0x11e/0x126
> Apr  3 09:43:12 luna kernel: [  554.832802]  [<ffffffff81137f0d>] sys_umount+0x2fa/0x31b
> Apr  3 09:43:12 luna kernel: [  554.832806]  [<ffffffff813e3fd9>] system_call_fastpath+0x16/0x1b
> Apr  3 09:43:12 luna kernel: [  554.832809] ---[ end trace ab791b60ae901bfa ]---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


