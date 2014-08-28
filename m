Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48192 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936276AbaH1IpW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 04:45:22 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id A674B3EE1CA
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 17:45:20 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id D0C43AC098D
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 17:45:19 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 7E0E11DB803B
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 17:45:19 +0900 (JST)
Received: from G01JPEXCHYT14.g01.fujitsu.local (G01JPEXCHYT14.g01.fujitsu.local [10.128.194.53])
	by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 6D79D6D6371
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 17:43:24 +0900 (JST)
Message-ID: <53FEEBAB.90305@jp.fujitsu.com>
Date: Thu, 28 Aug 2014 17:43:23 +0900
From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: warning at at fs/btrfs/delayed-inode.c:655 while doing stress test
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

When I ran a stress test for Btrfs (v3.17-rc2), then I got the following
warning messages repeatedly. I think the messages were outputted because
btrfs_block_rsv_migrate() returned as ENOSPC.
I'm not sure this is related to a bug or not...

How to reproduce:

1. Create btrfs on a 5GB partition and mount it.

   # mkfs -t btrfs -f /dev/sdb5
   # mount /dev/sdb5 /mnt/sdb5

2. Run a stress tests like as followings. I used LTP as the stress test.

   # /opt/ltp/testscripts/ltpstress.sh -n -t 168 -d /mnt/sdb5/hogehoge &
   # /opt/ltp/testcases/bin/fsstress -d /mnt/sdb5/test -n 10000 -p 100 -l 0 &

I detected the messages within three hours.

The code which output the message:

static int btrfs_delayed_inode_reserve_metadata(
                                        struct btrfs_trans_handle *trans,
                                        struct btrfs_root *root,
                                        struct inode *inode,
                                        struct btrfs_delayed_node *node)
...
                ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
                if (!WARN_ON(ret)) <= HERE!!
                        goto out; 

                /*   
                 * Ok this is a problem, let's just steal from the global rsv
                 * since this really shouldn't happen that often.
                 */
                ret = btrfs_block_rsv_migrate(&root->fs_info->global_block_rsv,
                                              dst_rsv, num_bytes);

The message:

[65058.999117] ------------[ cut here ]------------
[65058.999170] WARNING: CPU: 0 PID: 3284 at fs/btrfs/delayed-inode.c:655 btrfs_delayed_update_inode+0x2a0/0x450 [btrfs]()
[65058.999172] Modules linked in: ip6t_rpfilter ip6t_REJECT ipt_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter ip_tables sg coretemp kvm_intel btrfs iTCO_wdt xor kvm nfsd iTCO_vendor_support raid6_pq auth_rpcgss nfs_acl lockd crc32c_intel uinput osst ipmi_si lpc_ich st i2c_i801 i7core_edac mfd_core ipmi_msghandler edac_core sunrpc shpchp pcspkr xfs libcrc32c sd_mod sr_mod cdrom crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect sysimgblt drm_kms_helper ttm usb_storage drm ahci libahci libata
[65058.999221]  igb ptp pps_core megaraid_sas dca i2c_algo_bit
[65058.999230] CPU: 0 PID: 3284 Comm: kworker/u9:1 Tainted: G        W      3.17.0-rc2 #1
[65058.999232] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[65058.999249] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[65058.999251]  0000000000000000 0000000057b6814e ffff88010096fc28 ffffffff816363b7
[65058.999254]  0000000000000000 ffff88010096fc60 ffffffff810741ad ffff880172d1d0a0
[65058.999257]  0000000000040000 ffff880159c20958 ffff880239435000 ffff8802192411c0
[65058.999260] Call Trace:
[65058.999271]  [<ffffffff816363b7>] dump_stack+0x45/0x56
[65058.999277]  [<ffffffff810741ad>] warn_slowpath_common+0x7d/0xa0
[65058.999279]  [<ffffffff810742da>] warn_slowpath_null+0x1a/0x20
[65058.999296]  [<ffffffffa05a58d0>] btrfs_delayed_update_inode+0x2a0/0x450 [btrfs]
[65058.999311]  [<ffffffffa055531c>] btrfs_update_inode+0x5c/0xd0 [btrfs]
[65058.999326]  [<ffffffffa055820c>] btrfs_update_inode_fallback+0x1c/0x50 [btrfs]
[65058.999341]  [<ffffffffa055876b>] btrfs_finish_ordered_io+0x52b/0x610 [btrfs]
[65058.999347]  [<ffffffff810ae300>] ? pick_next_task_fair+0x590/0x870
[65058.999362]  [<ffffffffa0558b65>] finish_ordered_fn+0x15/0x20 [btrfs]
[65058.999378]  [<ffffffffa057f256>] normal_work_helper+0xc6/0x280 [btrfs]
[65058.999382]  [<ffffffff8108c8cf>] process_one_work+0x17f/0x420
[65058.999384]  [<ffffffff8108cfcb>] worker_thread+0x11b/0x510
[65058.999387]  [<ffffffff8108ceb0>] ? rescuer_thread+0x340/0x340
[65058.999390]  [<ffffffff81092671>] kthread+0xe1/0x100
[65058.999393]  [<ffffffff81092590>] ? kthread_create_on_node+0x1a0/0x1a0
[65058.999397]  [<ffffffff8163e37c>] ret_from_fork+0x7c/0xb0
[65058.999400]  [<ffffffff81092590>] ? kthread_create_on_node+0x1a0/0x1a0
[65058.999402] ---[ end trace fc1325844b8e13c1 ]---
[65332.479837] ------------[ cut here ]------------
[65332.479887] WARNING: CPU: 0 PID: 3285 at fs/btrfs/delayed-inode.c:655 btrfs_delayed_update_inode+0x2a0/0x450 [btrfs]()
[65332.479889] Modules linked in: ip6t_rpfilter ip6t_REJECT ipt_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter ip_tables sg coretemp kvm_intel btrfs iTCO_wdt xor kvm nfsd iTCO_vendor_support raid6_pq auth_rpcgss nfs_acl lockd crc32c_intel uinput osst ipmi_si lpc_ich st i2c_i801 i7core_edac mfd_core ipmi_msghandler edac_core sunrpc shpchp pcspkr xfs libcrc32c sd_mod sr_mod cdrom crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect sysimgblt drm_kms_helper ttm usb_storage drm ahci libahci libata
[65332.479939]  igb ptp pps_core megaraid_sas dca i2c_algo_bit
[65332.479946] CPU: 0 PID: 3285 Comm: kworker/u9:2 Tainted: G        W      3.17.0-rc2 #1
[65332.479948] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[65332.479966] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[65332.479968]  0000000000000000 00000000015b5564 ffff88004e863c28 ffffffff816363b7
[65332.479971]  0000000000000000 ffff88004e863c60 ffffffff810741ad ffff880104441c80
[65332.479974]  0000000000040000 ffff8801635dc578 ffff880239435000 ffff8802192411c0
[65332.479977] Call Trace:
[65332.479986]  [<ffffffff816363b7>] dump_stack+0x45/0x56
[65332.479991]  [<ffffffff810741ad>] warn_slowpath_common+0x7d/0xa0
[65332.479994]  [<ffffffff810742da>] warn_slowpath_null+0x1a/0x20
[65332.480011]  [<ffffffffa05a58d0>] btrfs_delayed_update_inode+0x2a0/0x450 [btrfs]
[65332.480026]  [<ffffffffa055531c>] btrfs_update_inode+0x5c/0xd0 [btrfs]
[65332.480041]  [<ffffffffa055820c>] btrfs_update_inode_fallback+0x1c/0x50 [btrfs]
[65332.480056]  [<ffffffffa055876b>] btrfs_finish_ordered_io+0x52b/0x610 [btrfs]
[65332.480061]  [<ffffffff810ae300>] ? pick_next_task_fair+0x590/0x870
[65332.480076]  [<ffffffffa0558b65>] finish_ordered_fn+0x15/0x20 [btrfs]
[65332.480093]  [<ffffffffa057f256>] normal_work_helper+0xc6/0x280 [btrfs]
[65332.480097]  [<ffffffff8108c8cf>] process_one_work+0x17f/0x420
[65332.480100]  [<ffffffff8108cfcb>] worker_thread+0x11b/0x510
[65332.480102]  [<ffffffff8108ceb0>] ? rescuer_thread+0x340/0x340
[65332.480106]  [<ffffffff81092671>] kthread+0xe1/0x100
[65332.480109]  [<ffffffff81092590>] ? kthread_create_on_node+0x1a0/0x1a0
[65332.480115]  [<ffffffff8163e37c>] ret_from_fork+0x7c/0xb0
[65332.480117]  [<ffffffff81092590>] ? kthread_create_on_node+0x1a0/0x1a0
[65332.480119] ---[ end trace fc1325844b8e13c2 ]---
[65332.618477] ------------[ cut here ]------------

Thanks,
Masayoshi Mizuma
