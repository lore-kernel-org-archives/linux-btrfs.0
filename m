Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:41745 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbeISFke (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 01:40:34 -0400
Subject: Re: btrfs panic problem
To: "sunny.s.zhang" <sunny.s.zhang@oracle.com>, linux-btrfs@vger.kernel.org
References: <2cce0d8b-0958-9fb9-bb88-09fbfbf94c9e@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <20bd1849-9fab-743c-1a1a-575fa5199f54@gmx.com>
Date: Wed, 19 Sep 2018 08:05:20 +0800
MIME-Version: 1.0
In-Reply-To: <2cce0d8b-0958-9fb9-bb88-09fbfbf94c9e@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CBZac2E1dxFLG7zsgtmAcVPy3ZM7ComBp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CBZac2E1dxFLG7zsgtmAcVPy3ZM7ComBp
Content-Type: multipart/mixed; boundary="Pzg3adIZxktKnc7NW0slQw0tz5HDZp3f9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "sunny.s.zhang" <sunny.s.zhang@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <20bd1849-9fab-743c-1a1a-575fa5199f54@gmx.com>
Subject: Re: btrfs panic problem
References: <2cce0d8b-0958-9fb9-bb88-09fbfbf94c9e@oracle.com>
In-Reply-To: <2cce0d8b-0958-9fb9-bb88-09fbfbf94c9e@oracle.com>

--Pzg3adIZxktKnc7NW0slQw0tz5HDZp3f9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/18 =E4=B8=8A=E5=8D=888:28, sunny.s.zhang wrote:
> Hi All,
>=20
> My OS(4.1.12) panic in kmem_cache_alloc, which is called by
> btrfs_get_or_create_delayed_node.

Any reproducer?

Anyway we need a reproducer as a testcase.

The code looks

>=20
> I found that the freelist of the slub is wrong.
>=20
> crash> struct kmem_cache_cpu ffff887e7d7a24b0
>=20
> struct kmem_cache_cpu {
> =C2=A0 freelist =3D 0x2026,=C2=A0=C2=A0 <<< the value is id of one inod=
e
> =C2=A0 tid =3D 29567861,
> =C2=A0 page =3D 0xffffea0132168d00,
> =C2=A0 partial =3D 0x0
> }
>=20
> And, I found there are two different btrfs inodes pointing delayed_node=
=2E
> It means that the same slub is used twice.
>=20
> I think this slub is freed twice, and then the next pointer of this slu=
b
> point itself. So we get the same slub twice.
>=20
> When use this slub again, that break the freelist.
>=20
> Folloing code will make the delayed node being freed twice. But I don't=

> found what is the process.
>=20
> Process A (btrfs_evict_inode) Process B
>=20
> call btrfs_remove_delayed_node call=C2=A0 btrfs_get_delayed_node
>=20
> node =3D ACCESS_ONCE(btrfs_inode->delayed_node);
>=20
> BTRFS_I(inode)->delayed_node =3D NULL;
> btrfs_release_delayed_node(delayed_node);
>=20
> if (node) {
> atomic_inc(&node->refs);
> return node;
> }
>=20
> ......
>=20
> btrfs_release_delayed_node(delayed_node);
>=20
>=20
> 1313 void btrfs_remove_delayed_node(struct inode *inode)
> 1314 {
> 1315=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_delay=
ed_node *delayed_node;
> 1316
> 1317=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 delayed_node =3D A=
CCESS_ONCE(BTRFS_I(inode)->delayed_node);
> 1318=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!delayed_node)=

> 1319=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
> 1320
> 1321=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_I(inode)->de=
layed_node =3D NULL;
> 1322=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_release_dela=
yed_node(delayed_node);
> 1323 }
>=20
>=20
> =C2=A0 87 static struct btrfs_delayed_node *btrfs_get_delayed_node(stru=
ct
> inode *inode)
> =C2=A0 88 {
> =C2=A0 89=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_=
inode *btrfs_inode =3D BTRFS_I(inode);
> =C2=A0 90=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_=
root *root =3D btrfs_inode->root;
> =C2=A0 91=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 ino =3D b=
trfs_ino(inode);
> =C2=A0 92=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_=
delayed_node *node;
> =C2=A0 93
> =C2=A0 94=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 node =3D ACCE=
SS_ONCE(btrfs_inode->delayed_node);
> =C2=A0 95=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (node) {
> =C2=A0 96=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_inc(&node->refs);
> =C2=A0 97=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return node;
> =C2=A0 98=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20

The analyse looks valid.
Can be fixed by adding a spinlock.

Just wondering why we didn't hit it.

Thanks,
Qu

>=20
> Thanks,
>=20
> Sunny
>=20
>=20
> PS:
>=20
> ------------------------------------------------
>=20
> panic informations
>=20
> PID: 73638=C2=A0 TASK: ffff887deb586200=C2=A0 CPU: 38=C2=A0 COMMAND: "d=
ockerd"
> =C2=A0#0 [ffff88130404f940] machine_kexec at ffffffff8105ec10
> =C2=A0#1 [ffff88130404f9b0] crash_kexec at ffffffff811145b8
> =C2=A0#2 [ffff88130404fa80] oops_end at ffffffff8101a868
> =C2=A0#3 [ffff88130404fab0] no_context at ffffffff8106ea91
> =C2=A0#4 [ffff88130404fb00] __bad_area_nosemaphore at ffffffff8106ec8d
> =C2=A0#5 [ffff88130404fb50] bad_area_nosemaphore at ffffffff8106eda3
> =C2=A0#6 [ffff88130404fb60] __do_page_fault at ffffffff8106f328
> =C2=A0#7 [ffff88130404fbd0] do_page_fault at ffffffff8106f637
> =C2=A0#8 [ffff88130404fc10] page_fault at ffffffff816f6308
> =C2=A0=C2=A0=C2=A0 [exception RIP: kmem_cache_alloc+121]
> =C2=A0=C2=A0=C2=A0 RIP: ffffffff811ef019=C2=A0 RSP: ffff88130404fcc8=C2=
=A0 RFLAGS: 00010286
> =C2=A0=C2=A0=C2=A0 RAX: 0000000000000000=C2=A0 RBX: 0000000000000000=C2=
=A0 RCX: 0000000001c32b76
> =C2=A0=C2=A0=C2=A0 RDX: 0000000001c32b75=C2=A0 RSI: 0000000000000000=C2=
=A0 RDI: 00000000000224b0
> =C2=A0=C2=A0=C2=A0 RBP: ffff88130404fd08=C2=A0=C2=A0 R8: ffff887e7d7a24=
b0=C2=A0=C2=A0 R9: 0000000000000000
> =C2=A0=C2=A0=C2=A0 R10: ffff8802668b6618=C2=A0 R11: 0000000000000002=C2=
=A0 R12: ffff887e3e230a00
> =C2=A0=C2=A0=C2=A0 R13: 0000000000002026=C2=A0 R14: ffff887e3e230a00=C2=
=A0 R15: ffffffffa01abf49
> =C2=A0=C2=A0=C2=A0 ORIG_RAX: ffffffffffffffff=C2=A0 CS: 0010=C2=A0 SS: =
0018
> =C2=A0#9 [ffff88130404fd10] btrfs_get_or_create_delayed_node at
> ffffffffa01abf49 [btrfs]
> #10 [ffff88130404fd60] btrfs_delayed_update_inode at ffffffffa01aea12
> [btrfs]
> #11 [ffff88130404fdb0] btrfs_update_inode at ffffffffa015b199 [btrfs]
> #12 [ffff88130404fdf0] btrfs_dirty_inode at ffffffffa015cd11 [btrfs]
> #13 [ffff88130404fe20] btrfs_update_time at ffffffffa015fa25 [btrfs]
> #14 [ffff88130404fe50] touch_atime at ffffffff812286d3
> #15 [ffff88130404fe90] iterate_dir at ffffffff81221929
> #16 [ffff88130404fee0] sys_getdents64 at ffffffff81221a19
> #17 [ffff88130404ff50] system_call_fastpath at ffffffff816f2594
> =C2=A0=C2=A0=C2=A0 RIP: 00000000006b68e4=C2=A0 RSP: 000000c866259080=C2=
=A0 RFLAGS: 00000246
> =C2=A0=C2=A0=C2=A0 RAX: ffffffffffffffda=C2=A0 RBX: 000000c828dbbe00=C2=
=A0 RCX: 00000000006b68e4
> =C2=A0=C2=A0=C2=A0 RDX: 0000000000001000=C2=A0 RSI: 000000c83da14000=C2=
=A0 RDI: 0000000000000011
> =C2=A0=C2=A0=C2=A0 RBP: 0000000000000000=C2=A0=C2=A0 R8: 00000000000000=
00=C2=A0=C2=A0 R9: 0000000000000000
> =C2=A0=C2=A0=C2=A0 R10: 0000000000000000=C2=A0 R11: 0000000000000246=C2=
=A0 R12: 00000000000000c7
> =C2=A0=C2=A0=C2=A0 R13: 0000000002174e74=C2=A0 R14: 0000000005555555=C2=
=A0 R15: 0000000000000038
> =C2=A0=C2=A0=C2=A0 ORIG_RAX: 00000000000000d9=C2=A0 CS: 0033=C2=A0 SS: =
002b
>=20
>=20
> We also find the list double add informations, including n_list and p_l=
ist:
>=20
> [8642921.110568] ------------[ cut here ]------------
> [8642921.167929] WARNING: CPU: 38 PID: 73638 at lib/list_debug.c:33
> __list_add+0xbe/0xd0()
> [8642921.263780] list_add corruption. prev->next should be next
> (ffff887e40fa5368), but was ff:ff884c85a36288. (prev=3Dffff884c85a36288=
).
> [8642921.405490] Modules linked in: ipt_MASQUERADE
> nf_nat_masquerade_ipv4 xt_conntrack iptable_filter arc4 ecb ppp_mppe
> ppp_async crc_ccitt ppp_generic slhc nfsv3 nfs_acl rpcsec_gss_krb5
> auth_rpcgss nfsv4 nfs fscache lockd sunrpc grace veth xt_nat xt_addrtyp=
e
> br_netfilter bridge tcp_diag inet_diag oracleacfs(POE) oracleadvm(POE)
> oracleoks(POE) oracleasm autofs4 dm_queue_length cpufreq_powersave
> be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i iw_cxgb4 cxgb4 cxgb3i
> libcxgbi iw_cxgb3 cxgb3 ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_cor=
e
> ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi 8021q mrp
> garp stp llc bonding iptable_nat nf_nat_ipv4 nf_nat ipt_REJECT
> nf_reject_ipv4 xt_pkttype nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
> ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
> [8642922.259780]=C2=A0 nf_conntrack ip6table_filter ip6_tables ipv6
> dm_multipath sg iTCO_wdt iTCO_vendor_support ipmi_devintf ipmi_si
> ipmi_msghandler intel_powerclamp coretemp kvm_intel kvm pcspkr ixgbe dc=
a
> ptp pps_core vxlan udp_tunnel ip6_udp_tunnel mdio sb_edac edac_core
> i2c_i801 i2c_core lpc_ich mfd_core shpchp ext4 jbd2 mbcache2 btrfs
> raid6_pq xor sd_mod megaraid_sas ghash_clmulni_intel crc32_pclmul
> crc32c_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper
> aes_x86_64 ahci libahci mxm_wmi wmi dm_mirror dm_region_hash dm_log
> dm_mod [last unloaded: xt_conntrack]
> [8642922.850285] CPU: 38 PID: 73638 Comm: dockerd Tainted: P=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> OE=C2=A0=C2=A0 4.1.12-112.14.13.el6uek.x86_64 #2
> [8642922.965881] Hardware name: Oracle Corporation ORACLE SERVER
> X6-2/ASM,MOTHERBOARD,1U, BIOS 38040100 06/06/2016
> [8642923.086670]=C2=A0 0000000000000000 ffff88130404fc28 ffffffff816ec9=
1e
> ffff88130404fc78
> [8642923.177730]=C2=A0 0000000000000021 ffff88130404fc68 ffffffff810889=
25
> 00ff88130404fc98
> [8642923.268793]=C2=A0 ffff884c85a36288 ffff887e40fa5368 ffff884c85a362=
88
> 0000000000000000
> [8642923.359851] Call Trace:
> [8642923.391194]=C2=A0 [<ffffffff816ec91e>] dump_stack+0x63/0x85
> [8642923.454780]=C2=A0 [<ffffffff81088925>] warn_slowpath_common+0x95/0=
xe0
> [8642923.528769]=C2=A0 [<ffffffff81088a26>] warn_slowpath_fmt+0x46/0x50=

> [8642923.599635]=C2=A0 [<ffffffff81343f3e>] __list_add+0xbe/0xd0
> [8642923.663333]=C2=A0 [<ffffffffa01abb92>]
> btrfs_queue_delayed_node+0xb2/0xe0 [btrfs]
> [8642923.749898]=C2=A0 [<ffffffffa01abc66>]
> __btrfs_release_delayed_node+0xa6/0x160 [btrfs]
> [8642923.841661]=C2=A0 [<ffffffffa01aea5e>]
> btrfs_delayed_update_inode+0x7e/0x100 [btrfs]
> [8642923.931336]=C2=A0 [<ffffffffa015b199>] btrfs_update_inode+0xa9/0x1=
30
> [btrfs]
> [8642924.012686]=C2=A0 [<ffffffffa015cd11>] btrfs_dirty_inode+0x71/0xe0=
 [btrfs]
> [8642924.091954]=C2=A0 [<ffffffffa015fa25>] btrfs_update_time+0x65/0xc0=
 [btrfs]
> [8642924.171145]=C2=A0 [<ffffffff812286d3>] touch_atime+0x123/0x170
> [8642924.237849]=C2=A0 [<ffffffff81221929>] iterate_dir+0xf9/0x140
> [8642924.303512]=C2=A0 [<ffffffff81221a19>] SyS_getdents64+0xa9/0x100
> [8642924.372296]=C2=A0 [<ffffffff81221720>] ? fillonedir+0xe0/0xe0
> [8642924.437963]=C2=A0 [<ffffffff816f2594>] system_call_fastpath+0x12/0=
xce
> [8642924.512201] ---[ end trace 6782707b09f9f873 ]---
> [8642924.569677] ------------[ cut here ]------------
> [8642924.627055] WARNING: CPU: 38 PID: 73638 at lib/list_debug.c:36
> __list_add+0x9c/0xd0()
> [8642924.722925] list_add double add: new=3Dffff884c85a36288,
> prev=3Dffff884c85a36288, next=3Dffff887e40fa5368.
> [8642924.834373] Modules linked in: ipt_MASQUERADE
> nf_nat_masquerade_ipv4 xt_conntrack iptable_filter arc4 ecb ppp_mppe
> ppp_async crc_ccitt ppp_generic slhc nfsv3 nfs_acl rpcsec_gss_krb5
> auth_rpcgss nfsv4 nfs fscache lockd sunrpc grace veth xt_nat xt_addrtyp=
e
> br_netfilter bridge tcp_diag inet_diag oracleacfs(POE) oracleadvm(POE)
> oracleoks(POE) oracleasm autofs4 dm_queue_length cpufreq_powersave
> be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i iw_cxgb4 cxgb4 cxgb3i
> libcxgbi iw_cxgb3 cxgb3 ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_cor=
e
> ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi 8021q mrp
> garp stp llc bonding iptable_nat nf_nat_ipv4 nf_nat ipt_REJECT
> nf_reject_ipv4 xt_pkttype nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
> ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
> [8642925.688498]=C2=A0 nf_conntrack ip6table_filter ip6_tables ipv6
> dm_multipath sg iTCO_wdt iTCO_vendor_support ipmi_devintf ipmi_si
> ipmi_msghandler intel_powerclamp coretemp kvm_intel kvm pcspkr ixgbe dc=
a
> ptp pps_core vxlan udp_tunnel ip6_udp_tunnel mdio sb_edac edac_core
> i2c_i801 i2c_core lpc_ich mfd_core shpchp ext4 jbd2 mbcache2 btrfs
> raid6_pq xor sd_mod megaraid_sas ghash_clmulni_intel crc32_pclmul
> crc32c_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper
> aes_x86_64 ahci libahci mxm_wmi wmi dm_mirror dm_region_hash dm_log
> dm_mod [last unloaded: xt_conntrack]
> [8642926.279029] CPU: 38 PID: 73638 Comm: dockerd Tainted: P=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0
> OE=C2=A0=C2=A0 4.1.12-112.14.13.el6uek.x86_64 #2
> [8642926.394626] Hardware name: Oracle Corporation ORACLE SERVER
> X6-2/ASM,MOTHERBOARD,1U, BIOS 38040100 06/06/2016
> [8642926.515421]=C2=A0 0000000000000000 ffff88130404fc28 ffffffff816ec9=
1e
> ffff88130404fc78
> [8642926.606485]=C2=A0 0000000000000024 ffff88130404fc68 ffffffff810889=
25
> 00ff88130404fc98
> [8642926.697544]=C2=A0 ffff884c85a36288 ffff887e40fa5368 ffff884c85a362=
88
> 0000000000000000
> [8642926.788605] Call Trace:
> [8642926.819945]=C2=A0 [<ffffffff816ec91e>] dump_stack+0x63/0x85
> [8642926.883535]=C2=A0 [<ffffffff81088925>] warn_slowpath_common+0x95/0=
xe0
> [8642926.957529]=C2=A0 [<ffffffff81088a26>] warn_slowpath_fmt+0x46/0x50=

> [8642927.028400]=C2=A0 [<ffffffff81343f1c>] __list_add+0x9c/0xd0
> [8642927.092116]=C2=A0 [<ffffffffa01abb92>]
> btrfs_queue_delayed_node+0xb2/0xe0 [btrfs]
> [8642927.178669]=C2=A0 [<ffffffffa01abc66>]
> __btrfs_release_delayed_node+0xa6/0x160 [btrfs]
> [8642927.270440]=C2=A0 [<ffffffffa01aea5e>]
> btrfs_delayed_update_inode+0x7e/0x100 [btrfs]
> [8642927.360112]=C2=A0 [<ffffffffa015b199>] btrfs_update_inode+0xa9/0x1=
30
> [btrfs]
> [8642927.441447]=C2=A0 [<ffffffffa015cd11>] btrfs_dirty_inode+0x71/0xe0=
 [btrfs]
> [8642927.520716]=C2=A0 [<ffffffffa015fa25>] btrfs_update_time+0x65/0xc0=
 [btrfs]
> [8642927.599910]=C2=A0 [<ffffffff812286d3>] touch_atime+0x123/0x170
> [8642927.666615]=C2=A0 [<ffffffff81221929>] iterate_dir+0xf9/0x140
> [8642927.732284]=C2=A0 [<ffffffff81221a19>] SyS_getdents64+0xa9/0x100
> [8642927.801072]=C2=A0 [<ffffffff81221720>] ? fillonedir+0xe0/0xe0
> [8642927.866741]=C2=A0 [<ffffffff816f2594>] system_call_fastpath+0x12/0=
xce
> [8642927.940843] ---[ end trace 6782707b09f9f874 ]---
> [8642927.998378] ------------[ cut here ]------------
>=20
>=20
>=20
>=20


--Pzg3adIZxktKnc7NW0slQw0tz5HDZp3f9--

--CBZac2E1dxFLG7zsgtmAcVPy3ZM7ComBp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluhksAACgkQwj2R86El
/qj1hwgAm4tXUTDIAmgJJI+Q/IeSREgLpw1kxcuCpkLfFUQT8Eobsa532ZrnXor1
/GNGuddnU8imVUm59CBNyZt8qEC361hD4rIdS4Xvff2OYgJGgRboS3wkj1X23kPq
qSUUEAMEalrkzXJV1O1FSZANWa4GabIz7nSQMKiJQIyI4ml1BB7ZmCLqxmeFPfxt
wPcGVgtsOljR0YWyntn0aeHluTjJccFZtlv/UMxkQByID3hdJAQo9kt/4fm/lzLP
nGYGBw8VoepZXQb+F3WVfNgjrQiyrXFwU2y7Z3cT6EexHOhAYhPHZKpXXD9c/g95
maESF4sQA+wvYIuERdbQqnaM3lCBUQ==
=L8u+
-----END PGP SIGNATURE-----

--CBZac2E1dxFLG7zsgtmAcVPy3ZM7ComBp--
