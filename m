Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52292 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbeIRF6a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 01:58:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8I0JQHv012581
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 00:28:39 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mgsgthcxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 00:28:39 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8I0SXDe011399
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 00:28:34 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8I0SX9c021448
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 00:28:33 GMT
To: linux-btrfs@vger.kernel.org
From: "sunny.s.zhang" <sunny.s.zhang@oracle.com>
Subject: btrfs panic problem
Message-ID: <2cce0d8b-0958-9fb9-bb88-09fbfbf94c9e@oracle.com>
Date: Tue, 18 Sep 2018 08:28:14 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

My OS(4.1.12) panic in kmem_cache_alloc, which is called by 
btrfs_get_or_create_delayed_node.

I found that the freelist of the slub is wrong.

crash> struct kmem_cache_cpu ffff887e7d7a24b0

struct kmem_cache_cpu {
   freelist = 0x2026,   <<< the value is id of one inode
   tid = 29567861,
   page = 0xffffea0132168d00,
   partial = 0x0
}

And, I found there are two different btrfs inodes pointing delayed_node. 
It means that the same slub is used twice.

I think this slub is freed twice, and then the next pointer of this slub 
point itself. So we get the same slub twice.

When use this slub again, that break the freelist.

Folloing code will make the delayed node being freed twice. But I don't 
found what is the process.

Process A (btrfs_evict_inode) Process B

call btrfs_remove_delayed_node call  btrfs_get_delayed_node

node = ACCESS_ONCE(btrfs_inode->delayed_node);

BTRFS_I(inode)->delayed_node = NULL;
btrfs_release_delayed_node(delayed_node);

if (node) {
atomic_inc(&node->refs);
return node;
}

......

btrfs_release_delayed_node(delayed_node);


1313 void btrfs_remove_delayed_node(struct inode *inode)
1314 {
1315         struct btrfs_delayed_node *delayed_node;
1316
1317         delayed_node = ACCESS_ONCE(BTRFS_I(inode)->delayed_node);
1318         if (!delayed_node)
1319                 return;
1320
1321         BTRFS_I(inode)->delayed_node = NULL;
1322         btrfs_release_delayed_node(delayed_node);
1323 }


   87 static struct btrfs_delayed_node *btrfs_get_delayed_node(struct 
inode *inode)
   88 {
   89         struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
   90         struct btrfs_root *root = btrfs_inode->root;
   91         u64 ino = btrfs_ino(inode);
   92         struct btrfs_delayed_node *node;
   93
   94         node = ACCESS_ONCE(btrfs_inode->delayed_node);
   95         if (node) {
   96                 atomic_inc(&node->refs);
   97                 return node;
   98         }


Thanks,

Sunny


PS:

------------------------------------------------

panic informations

PID: 73638  TASK: ffff887deb586200  CPU: 38  COMMAND: "dockerd"
  #0 [ffff88130404f940] machine_kexec at ffffffff8105ec10
  #1 [ffff88130404f9b0] crash_kexec at ffffffff811145b8
  #2 [ffff88130404fa80] oops_end at ffffffff8101a868
  #3 [ffff88130404fab0] no_context at ffffffff8106ea91
  #4 [ffff88130404fb00] __bad_area_nosemaphore at ffffffff8106ec8d
  #5 [ffff88130404fb50] bad_area_nosemaphore at ffffffff8106eda3
  #6 [ffff88130404fb60] __do_page_fault at ffffffff8106f328
  #7 [ffff88130404fbd0] do_page_fault at ffffffff8106f637
  #8 [ffff88130404fc10] page_fault at ffffffff816f6308
     [exception RIP: kmem_cache_alloc+121]
     RIP: ffffffff811ef019  RSP: ffff88130404fcc8  RFLAGS: 00010286
     RAX: 0000000000000000  RBX: 0000000000000000  RCX: 0000000001c32b76
     RDX: 0000000001c32b75  RSI: 0000000000000000  RDI: 00000000000224b0
     RBP: ffff88130404fd08   R8: ffff887e7d7a24b0   R9: 0000000000000000
     R10: ffff8802668b6618  R11: 0000000000000002  R12: ffff887e3e230a00
     R13: 0000000000002026  R14: ffff887e3e230a00  R15: ffffffffa01abf49
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
  #9 [ffff88130404fd10] btrfs_get_or_create_delayed_node at 
ffffffffa01abf49 [btrfs]
#10 [ffff88130404fd60] btrfs_delayed_update_inode at ffffffffa01aea12 
[btrfs]
#11 [ffff88130404fdb0] btrfs_update_inode at ffffffffa015b199 [btrfs]
#12 [ffff88130404fdf0] btrfs_dirty_inode at ffffffffa015cd11 [btrfs]
#13 [ffff88130404fe20] btrfs_update_time at ffffffffa015fa25 [btrfs]
#14 [ffff88130404fe50] touch_atime at ffffffff812286d3
#15 [ffff88130404fe90] iterate_dir at ffffffff81221929
#16 [ffff88130404fee0] sys_getdents64 at ffffffff81221a19
#17 [ffff88130404ff50] system_call_fastpath at ffffffff816f2594
     RIP: 00000000006b68e4  RSP: 000000c866259080  RFLAGS: 00000246
     RAX: ffffffffffffffda  RBX: 000000c828dbbe00  RCX: 00000000006b68e4
     RDX: 0000000000001000  RSI: 000000c83da14000  RDI: 0000000000000011
     RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000000
     R10: 0000000000000000  R11: 0000000000000246  R12: 00000000000000c7
     R13: 0000000002174e74  R14: 0000000005555555  R15: 0000000000000038
     ORIG_RAX: 00000000000000d9  CS: 0033  SS: 002b


We also find the list double add informations, including n_list and p_list:

[8642921.110568] ------------[ cut here ]------------
[8642921.167929] WARNING: CPU: 38 PID: 73638 at lib/list_debug.c:33 
__list_add+0xbe/0xd0()
[8642921.263780] list_add corruption. prev->next should be next 
(ffff887e40fa5368), but was ff:ff884c85a36288. (prev=ffff884c85a36288).
[8642921.405490] Modules linked in: ipt_MASQUERADE 
nf_nat_masquerade_ipv4 xt_conntrack iptable_filter arc4 ecb ppp_mppe 
ppp_async crc_ccitt ppp_generic slhc nfsv3 nfs_acl rpcsec_gss_krb5 
auth_rpcgss nfsv4 nfs fscache lockd sunrpc grace veth xt_nat xt_addrtype 
br_netfilter bridge tcp_diag inet_diag oracleacfs(POE) oracleadvm(POE) 
oracleoks(POE) oracleasm autofs4 dm_queue_length cpufreq_powersave 
be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i iw_cxgb4 cxgb4 cxgb3i 
libcxgbi iw_cxgb3 cxgb3 ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core 
ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi 8021q mrp 
garp stp llc bonding iptable_nat nf_nat_ipv4 nf_nat ipt_REJECT 
nf_reject_ipv4 xt_pkttype nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables 
ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
[8642922.259780]  nf_conntrack ip6table_filter ip6_tables ipv6 
dm_multipath sg iTCO_wdt iTCO_vendor_support ipmi_devintf ipmi_si 
ipmi_msghandler intel_powerclamp coretemp kvm_intel kvm pcspkr ixgbe dca 
ptp pps_core vxlan udp_tunnel ip6_udp_tunnel mdio sb_edac edac_core 
i2c_i801 i2c_core lpc_ich mfd_core shpchp ext4 jbd2 mbcache2 btrfs 
raid6_pq xor sd_mod megaraid_sas ghash_clmulni_intel crc32_pclmul 
crc32c_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper 
aes_x86_64 ahci libahci mxm_wmi wmi dm_mirror dm_region_hash dm_log 
dm_mod [last unloaded: xt_conntrack]
[8642922.850285] CPU: 38 PID: 73638 Comm: dockerd Tainted: P           
OE   4.1.12-112.14.13.el6uek.x86_64 #2
[8642922.965881] Hardware name: Oracle Corporation ORACLE SERVER 
X6-2/ASM,MOTHERBOARD,1U, BIOS 38040100 06/06/2016
[8642923.086670]  0000000000000000 ffff88130404fc28 ffffffff816ec91e 
ffff88130404fc78
[8642923.177730]  0000000000000021 ffff88130404fc68 ffffffff81088925 
00ff88130404fc98
[8642923.268793]  ffff884c85a36288 ffff887e40fa5368 ffff884c85a36288 
0000000000000000
[8642923.359851] Call Trace:
[8642923.391194]  [<ffffffff816ec91e>] dump_stack+0x63/0x85
[8642923.454780]  [<ffffffff81088925>] warn_slowpath_common+0x95/0xe0
[8642923.528769]  [<ffffffff81088a26>] warn_slowpath_fmt+0x46/0x50
[8642923.599635]  [<ffffffff81343f3e>] __list_add+0xbe/0xd0
[8642923.663333]  [<ffffffffa01abb92>] 
btrfs_queue_delayed_node+0xb2/0xe0 [btrfs]
[8642923.749898]  [<ffffffffa01abc66>] 
__btrfs_release_delayed_node+0xa6/0x160 [btrfs]
[8642923.841661]  [<ffffffffa01aea5e>] 
btrfs_delayed_update_inode+0x7e/0x100 [btrfs]
[8642923.931336]  [<ffffffffa015b199>] btrfs_update_inode+0xa9/0x130 [btrfs]
[8642924.012686]  [<ffffffffa015cd11>] btrfs_dirty_inode+0x71/0xe0 [btrfs]
[8642924.091954]  [<ffffffffa015fa25>] btrfs_update_time+0x65/0xc0 [btrfs]
[8642924.171145]  [<ffffffff812286d3>] touch_atime+0x123/0x170
[8642924.237849]  [<ffffffff81221929>] iterate_dir+0xf9/0x140
[8642924.303512]  [<ffffffff81221a19>] SyS_getdents64+0xa9/0x100
[8642924.372296]  [<ffffffff81221720>] ? fillonedir+0xe0/0xe0
[8642924.437963]  [<ffffffff816f2594>] system_call_fastpath+0x12/0xce
[8642924.512201] ---[ end trace 6782707b09f9f873 ]---
[8642924.569677] ------------[ cut here ]------------
[8642924.627055] WARNING: CPU: 38 PID: 73638 at lib/list_debug.c:36 
__list_add+0x9c/0xd0()
[8642924.722925] list_add double add: new=ffff884c85a36288, 
prev=ffff884c85a36288, next=ffff887e40fa5368.
[8642924.834373] Modules linked in: ipt_MASQUERADE 
nf_nat_masquerade_ipv4 xt_conntrack iptable_filter arc4 ecb ppp_mppe 
ppp_async crc_ccitt ppp_generic slhc nfsv3 nfs_acl rpcsec_gss_krb5 
auth_rpcgss nfsv4 nfs fscache lockd sunrpc grace veth xt_nat xt_addrtype 
br_netfilter bridge tcp_diag inet_diag oracleacfs(POE) oracleadvm(POE) 
oracleoks(POE) oracleasm autofs4 dm_queue_length cpufreq_powersave 
be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i iw_cxgb4 cxgb4 cxgb3i 
libcxgbi iw_cxgb3 cxgb3 ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core 
ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi 8021q mrp 
garp stp llc bonding iptable_nat nf_nat_ipv4 nf_nat ipt_REJECT 
nf_reject_ipv4 xt_pkttype nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables 
ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
[8642925.688498]  nf_conntrack ip6table_filter ip6_tables ipv6 
dm_multipath sg iTCO_wdt iTCO_vendor_support ipmi_devintf ipmi_si 
ipmi_msghandler intel_powerclamp coretemp kvm_intel kvm pcspkr ixgbe dca 
ptp pps_core vxlan udp_tunnel ip6_udp_tunnel mdio sb_edac edac_core 
i2c_i801 i2c_core lpc_ich mfd_core shpchp ext4 jbd2 mbcache2 btrfs 
raid6_pq xor sd_mod megaraid_sas ghash_clmulni_intel crc32_pclmul 
crc32c_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper 
aes_x86_64 ahci libahci mxm_wmi wmi dm_mirror dm_region_hash dm_log 
dm_mod [last unloaded: xt_conntrack]
[8642926.279029] CPU: 38 PID: 73638 Comm: dockerd Tainted: P        W  
OE   4.1.12-112.14.13.el6uek.x86_64 #2
[8642926.394626] Hardware name: Oracle Corporation ORACLE SERVER 
X6-2/ASM,MOTHERBOARD,1U, BIOS 38040100 06/06/2016
[8642926.515421]  0000000000000000 ffff88130404fc28 ffffffff816ec91e 
ffff88130404fc78
[8642926.606485]  0000000000000024 ffff88130404fc68 ffffffff81088925 
00ff88130404fc98
[8642926.697544]  ffff884c85a36288 ffff887e40fa5368 ffff884c85a36288 
0000000000000000
[8642926.788605] Call Trace:
[8642926.819945]  [<ffffffff816ec91e>] dump_stack+0x63/0x85
[8642926.883535]  [<ffffffff81088925>] warn_slowpath_common+0x95/0xe0
[8642926.957529]  [<ffffffff81088a26>] warn_slowpath_fmt+0x46/0x50
[8642927.028400]  [<ffffffff81343f1c>] __list_add+0x9c/0xd0
[8642927.092116]  [<ffffffffa01abb92>] 
btrfs_queue_delayed_node+0xb2/0xe0 [btrfs]
[8642927.178669]  [<ffffffffa01abc66>] 
__btrfs_release_delayed_node+0xa6/0x160 [btrfs]
[8642927.270440]  [<ffffffffa01aea5e>] 
btrfs_delayed_update_inode+0x7e/0x100 [btrfs]
[8642927.360112]  [<ffffffffa015b199>] btrfs_update_inode+0xa9/0x130 [btrfs]
[8642927.441447]  [<ffffffffa015cd11>] btrfs_dirty_inode+0x71/0xe0 [btrfs]
[8642927.520716]  [<ffffffffa015fa25>] btrfs_update_time+0x65/0xc0 [btrfs]
[8642927.599910]  [<ffffffff812286d3>] touch_atime+0x123/0x170
[8642927.666615]  [<ffffffff81221929>] iterate_dir+0xf9/0x140
[8642927.732284]  [<ffffffff81221a19>] SyS_getdents64+0xa9/0x100
[8642927.801072]  [<ffffffff81221720>] ? fillonedir+0xe0/0xe0
[8642927.866741]  [<ffffffff816f2594>] system_call_fastpath+0x12/0xce
[8642927.940843] ---[ end trace 6782707b09f9f874 ]---
[8642927.998378] ------------[ cut here ]------------
