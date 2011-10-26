From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: linux v3.1 with btrfs-work: oops when deleting files
Date: 26 Oct 2011 12:25:00 +0200
Message-ID: <Bw$+jLhT1uB@helmut.hullen.de>
References: <4EA7D478.8030106@parallels.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_Bw$00WiD1u3Yl4AS8sJjdB5cwZacs9NklUd9q4A4Nq60mBhfsPKECEH"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA7D478.8030106@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>

--=_Bw$00WiD1u3Yl4AS8sJjdB5cwZacs9NklUd9q4A4Nq60mBhfsPKECEH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hallo, dima,

Du meintest am 26.10.11:

>> I'm trying to rm some files, this is what I get in dmesg:
>>
>> [30975.249519] ------------[ cut here ]------------
>> [30975.249529] WARNING: at fs/btrfs/extent-tree.c:4588
>> __btrfs_free_extent+0x3b7/0x7ed()

[...]

>> [30975.249604] Pid: 12291, comm: rm Tainted: G       A C
>> 3.1.0-00057- gc82b96b-dirty #6

> Can you ls the directory where the problem files are located? What
> would the the output? I had a very similar problem but on 3.0.x
> kernel when several files suddenly got corrupted.

This morning I've tried kernel 3.1; you remembder my problems with 1  
disk.

   dd if=/dev/baddisk of=/dev/zero bs=8M conv=noerror

showed some bad sectors.

   hdparm ... --write-sector /dev/baddisk

seems to repair them (I use a loop which not only tests the sector which  
is shown via "dd" but also some sectors around this one)

Rebooting the machine with kernel 3.1: I could delete the old entries  
which seemed to contain bad sectors. Fine.

Running btrfsck from the "Hugo Mills" git branch: still some errors -  
see attachment "btrfsck.txt", especially the last lines; there seems to  
be a bug.

Copying some *.mpg files from another place to the btrfs cluster:  
suddenly the system hangs, "dmesg" shows similar messages as above (from  
Kai Krakow). See second attachment "dmesg-1.txt".
"halt" doesn't work, "reboot" doesn't work, "ctrl alt delete" doesn't  
work.

Reboot via power switch.

Again copying: there was (within 1 file) a long pause, but then copying  
worked. There's still hope ...
Maybe the pause caused kernel oops #3 and #4 - see attachment "dmesg- 
2.txt".

------------

Just to show the only big difference: now I've seen some problem(s) not  
related to "rm" but to "cp".

Viele Gruesse!
Helmut

--=_Bw$00WiD1u3Yl4AS8sJjdB5cwZacs9NklUd9q4A4Nq60mBhfsPKECEH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename=dmesg-1.txt;
 modification-date="Wed, 26 Oct 2011 12:14:55 +0200";
 creation-date="Wed, 26 Oct 2011 12:13:04 +0200";
 read-date="Wed, 26 Oct 2011 12:13:04 +0200"

ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/100
ata1: EH complete
parent transid verify failed on 5340297310208 wanted 57354 found 53683
parent transid verify failed on 5340297310208 wanted 57354 found 53683
parent transid verify failed on 5340297310208 wanted 57354 found 53683
parent transid verify failed on 5340297310208 wanted 57354 found 53683
parent transid verify failed on 5340297310208 wanted 57354 found 53683
BUG: unable to handle kernel NULL pointer dereference at 00000014
IP: [<c1241d76>] btrfs_print_leaf+0x16/0x850
*pdpt = 0000000022784001 *pde = 0000000000000000 

Oops: 0000 [#1] 
Modules linked in: hisax w83781d hwmon_vid hwmon nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp xt_owner ipt_MASQUERADE iptable_nat nf_nat xt_DSCP ipt_LOG xt_multiport xt_recent xt_tcpudp ipt_REJECT iptable_filter iptable_mangle ip_tables xt_iprange nfsd exportfs xt_NOTRACK xt_state ip6t_REJECT ip6table_mangle ip6_tables x_tables nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ipv6 crc_ccitt isdn slhc 8139too 8139cp mii e1000 aty128fb i2c_i801 piix iTCO_wdt iTCO_vendor_support intel_agp intel_gtt agpgart fuse [last unloaded: hisax]

Pid: 5903, comm: btrfs-endio-wri Not tainted 3.1.0-ODSbig #1 MAXDATA */<P4B>
EIP: 0060:[<c1241d76>] EFLAGS: 00010296 CPU: 0
EIP is at btrfs_print_leaf+0x16/0x850
EAX: d8941c00 EBX: d8941c00 ECX: 00000001 EDX: 00000000
ESI: 00000002 EDI: 00000000 EBP: d3379c54 ESP: d3379be8
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Process btrfs-endio-wri (pid: 5903, ti=d3378000 task=e4a29b80 task.ti=d3378000)
Stack:
 00000774 00000774 8ce62000 d8941c00 ffffffff 00000850 85bca000 00000000
 d3379c54 00000000 d5015070 00000000 00000000 00000002 00000000 00000000
 c122e2f7 000000b0 c122e2f7 00000070 748ce620 a8000007 00001000 00000000
Call Trace:
 [<c122e2f7>] ? btrfs_alloc_path+0x17/0x20
 [<c122e2f7>] ? btrfs_alloc_path+0x17/0x20
 [<c1239d46>] __btrfs_free_extent+0x6e6/0x7c0
 [<c10ba9d5>] ? kfree+0xe5/0x110
 [<c123ca26>] ? run_clustered_refs+0x106/0x8a0
 [<c123cb4f>] run_clustered_refs+0x22f/0x8a0
 [<c128ae00>] ? btrfs_find_ref_cluster+0x60/0x1a0
 [<c123d259>] btrfs_run_delayed_refs+0x99/0x190
 [<c124da86>] __btrfs_end_transaction+0x66/0x1f0
 [<c124dc89>] btrfs_end_transaction+0x19/0x20
 [<c125445e>] btrfs_finish_ordered_io+0x2ee/0x3c0
 [<c1254573>] btrfs_writepage_end_io_hook+0x43/0xa0
 [<c126ab41>] end_bio_extent_writepage+0x181/0x1c0
 [<c1254530>] ? btrfs_finish_ordered_io+0x3c0/0x3c0
 [<c10e6df9>] bio_endio+0x19/0x30
 [<c1247835>] end_workqueue_fn+0x125/0x180
 [<c17c8d6a>] ? schedule_timeout+0xea/0x1d0
 [<c103cf70>] ? cascade+0x80/0x80
 [<c1277b21>] worker_loop+0x91/0x350
 [<c1028098>] ? __wake_up_common+0x48/0x70
 [<c1277a90>] ? btrfs_queue_worker+0x240/0x240
 [<c104b594>] kthread+0x74/0x80
 [<c104b520>] ? kthread_worker_fn+0xd0/0xd0
 [<c17ca93e>] kernel_thread_helper+0x6/0x10
Code: 00 8b 5d f4 8b 75 f8 8b 7d fc 89 ec 5d c3 8d b4 26 00 00 00 00 55 89 e5 83 ec 6c 89 5d f4 89 75 f8 89 7d fc 3e 8d 74 26 00 89 c3 <8b> 42 14 89 d7 e8 70 3a e6 ff 89 fa 8b 40 60 89 45 dc 89 d8 e8 
EIP: [<c1241d76>] btrfs_print_leaf+0x16/0x850 SS:ESP 0068:d3379be8
CR2: 0000000000000014
---[ end trace 4f51358d854abcb0 ]---
parent transid verify failed on 5340297310208 wanted 57354 found 53683
parent transid verify failed on 5340297310208 wanted 57354 found 53683
parent transid verify failed on 5340297310208 wanted 57354 found 53683
parent transid verify failed on 5340297310208 wanted 57354 found 53683
parent transid verify failed on 5340297310208 wanted 57354 found 53683
BUG: unable to handle kernel NULL pointer dereference at 00000014
IP: [<c1241d76>] btrfs_print_leaf+0x16/0x850
*pdpt = 0000000036132001 *pde = 0000000000000000 
Oops: 0000 [#2] 
Modules linked in: hisax w83781d hwmon_vid hwmon nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp xt_owner ipt_MASQUERADE iptable_nat nf_nat xt_DSCP ipt_LOG xt_multiport xt_recent xt_tcpudp ipt_REJECT iptable_filter iptable_mangle ip_tables xt_iprange nfsd exportfs xt_NOTRACK xt_state ip6t_REJECT ip6table_mangle ip6_tables x_tables nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ipv6 crc_ccitt isdn slhc 8139too 8139cp mii e1000 aty128fb i2c_i801 piix iTCO_wdt iTCO_vendor_support intel_agp intel_gtt agpgart fuse [last unloaded: hisax]

Pid: 32278, comm: btrfs-transacti Tainted: G      D     3.1.0-ODSbig #1 MAXDATA */<P4B>
EIP: 0060:[<c1241d76>] EFLAGS: 00010296 CPU: 0
EIP is at btrfs_print_leaf+0x16/0x850
EAX: d8941c00 EBX: d8941c00 ECX: 00000001 EDX: 00000000
ESI: 00000002 EDI: 00000000 EBP: c20fbd78 ESP: c20fbd0c
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Process btrfs-transacti (pid: 32278, ti=c20fa000 task=d14494a0 task.ti=c20fa000)
Stack:
 00000766 00000774 8a936000 d8941c00 ffffffff 00000850 3f383000 00000000
 c20fbd78 00000000 d5015000 00000000 00000000 00000002 00000000 00000000
 c122e2f7 000000b0 c122e2f7 00000070 748a9360 a8000007 00001000 00000000
Call Trace:
 [<c122e2f7>] ? btrfs_alloc_path+0x17/0x20
 [<c122e2f7>] ? btrfs_alloc_path+0x17/0x20
 [<c1239d46>] __btrfs_free_extent+0x6e6/0x7c0
 [<c10ba9d5>] ? kfree+0xe5/0x110
 [<c12ee2fa>] ? rb_erase+0x11a/0x290
 [<c123cb4f>] run_clustered_refs+0x22f/0x8a0
 [<c128ae00>] ? btrfs_find_ref_cluster+0x60/0x1a0
 [<c123d259>] btrfs_run_delayed_refs+0x99/0x190
 [<c1268d4b>] ? btrfs_run_ordered_operations+0x15b/0x170
 [<c124d318>] btrfs_commit_transaction+0x68/0x740
 [<c124dd55>] ? start_transaction+0xc5/0x2a0
 [<c124dd05>] ? start_transaction+0x75/0x2a0
 [<c104ba40>] ? wake_up_bit+0x30/0x30
 [<c124752f>] transaction_kthread+0x1cf/0x1e0
 [<c1247360>] ? btrfs_congested_fn+0x90/0x90
 [<c1247360>] ? btrfs_congested_fn+0x90/0x90
 [<c104b594>] kthread+0x74/0x80
 [<c104b520>] ? kthread_worker_fn+0xd0/0xd0
 [<c17ca93e>] kernel_thread_helper+0x6/0x10
Code: 00 8b 5d f4 8b 75 f8 8b 7d fc 89 ec 5d c3 8d b4 26 00 00 00 00 55 89 e5 83 ec 6c 89 5d f4 89 75 f8 89 7d fc 3e 8d 74 26 00 89 c3 <8b> 42 14 89 d7 e8 70 3a e6 ff 89 fa 8b 40 60 89 45 dc 89 d8 e8 
EIP: [<c1241d76>] btrfs_print_leaf+0x16/0x850 SS:ESP 0068:c20fbd0c
CR2: 0000000000000014
---[ end trace 4f51358d854abcb1 ]---

--=_Bw$00WiD1u3Yl4AS8sJjdB5cwZacs9NklUd9q4A4Nq60mBhfsPKECEH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline; filename=dmesg-2.txt;
 modification-date="Wed, 26 Oct 2011 12:16:09 +0200";
 creation-date="Wed, 26 Oct 2011 12:14:58 +0200";
 read-date="Wed, 26 Oct 2011 12:14:58 +0200"

Oops: 0000 [#3] =0AModules linked in: hisax w83781d hwmon_vid hwmon nf_nat_=
irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp xt_owner ipt_MASQUERADE ip=
table_nat nf_nat xt_DSCP ipt_LOG xt_multiport xt_recent xt_tcpudp ipt_REJEC=
T iptable_filter iptable_mangle ip_tables xt_iprange nfsd exportfs xt_NOTRA=
CK xt_state ip6t_REJECT ip6table_mangle ip6_tables x_tables nf_conntrack_ne=
tbios_ns nf_conntrack_broadcast nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntra=
ck_ipv4 nf_defrag_ipv4 nf_conntrack ipv6 crc_ccitt isdn slhc 8139too 8139cp=
 mii e1000 aty128fb i2c_i801 piix iTCO_wdt iTCO_vendor_support intel_agp in=
tel_gtt agpgart fuse [last unloaded: hisax]=0A=0APid: 18455, comm: smbd Tai=
nted: G      D     3.1.0-ODSbig #1 MAXDATA */<P4B>=0AEIP: 0060:[<c1241d76>]=
 EFLAGS: 00210286 CPU: 0=0AEIP is at btrfs_print_leaf+0x16/0x850=0AEAX: db4=
de800 EBX: db4de800 ECX: 00000001 EDX: 00000000=0AESI: 00000007 EDI: 000000=
00 EBP: f6e13cfc ESP: f6e13c90=0A DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0=
068=0AProcess smbd (pid: 18455, ti=3Df6e12000 task=3Dd0001810 task.ti=3Df6e=
12000)=0AStack:=0A 000007a7 000007a7 a53f5000 db4de800 ffffffff 00000850 a5=
3f4000 00000000=0A f6e13cfc 00000000 dcff8000 00000000 00000000 00000007 00=
000000 00000000=0A c122e2f7 000000b0 c122e2f7 00000070 a7a53f50 a8000007 00=
001000 00000000=0ACall Trace:=0A [<c122e2f7>] ? btrfs_alloc_path+0x17/0x20=
=0A [<c122e2f7>] ? btrfs_alloc_path+0x17/0x20=0A [<c1239d46>] __btrfs_free_=
extent+0x6e6/0x7c0=0A [<c10ba9d5>] ? kfree+0xe5/0x110=0A [<c12ee3c9>] ? rb_=
erase+0x1e9/0x290=0A [<c123cb4f>] run_clustered_refs+0x22f/0x8a0=0A [<c122d=
861>] ? leaf_space_used+0x81/0xb0=0A [<c128ae00>] ? btrfs_find_ref_cluster+=
0x60/0x1a0=0A [<c123d259>] btrfs_run_delayed_refs+0x99/0x190=0A [<c124da86>=
] __btrfs_end_transaction+0x66/0x1f0=0A [<c1253a84>] ? btrfs_orphan_del+0xb=
4/0xe0=0A [<c124dc89>] btrfs_end_transaction+0x19/0x20=0A [<c125896f>] btrf=
s_evict_inode+0x20f/0x270=0A [<c10d2d2f>] evict+0x6f/0x140=0A [<c10d2edb>] =
iput+0xdb/0x1a0=0A [<c10ca934>] do_unlinkat+0x114/0x160=0A [<c10cb565>] sys=
_unlink+0x15/0x20=0A [<c17c9dfc>] syscall_call+0x7/0xb=0A [<c17c0000>] ? mv=
s_64xx_init+0x233/0x6cc=0ACode: 00 8b 5d f4 8b 75 f8 8b 7d fc 89 ec 5d c3 8=
d b4 26 00 00 00 00 55 89 e5 83 ec 6c 89 5d f4 89 75 f8 89 7d fc 3e 8d 74 2=
6 00 89 c3 <8b> 42 14 89 d7 e8 70 3a e6 ff 89 fa 8b 40 60 89 45 dc 89 d8 e8=
 =0AEIP: [<c1241d76>] btrfs_print_leaf+0x16/0x850 SS:ESP 0068:f6e13c90=0ACR=
2: 0000000000000014=0A---[ end trace e823394b87ecbfba ]---=0Aparent transid=
 verify failed on 5340297986048 wanted 57354 found 42286=0Aparent transid v=
erify failed on 5340297986048 wanted 57354 found 42286=0Aparent transid ver=
ify failed on 5340297986048 wanted 57354 found 42286=0Aparent transid verif=
y failed on 5340297986048 wanted 57354 found 42286=0Aparent transid verify =
failed on 5340297986048 wanted 57354 found 42286=0ABUG: unable to handle ke=
rnel NULL pointer dereference at 00000014=0AIP: [<c1241d76>] btrfs_print_le=
af+0x16/0x850=0A*pdpt =3D 0000000018af8001 *pde =3D 0000000000000000 =0AOop=
s: 0000 [#4] =0AModules linked in: hisax w83781d hwmon_vid hwmon nf_nat_irc=
 nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp xt_owner ipt_MASQUERADE iptab=
le_nat nf_nat xt_DSCP ipt_LOG xt_multiport xt_recent xt_tcpudp ipt_REJECT i=
ptable_filter iptable_mangle ip_tables xt_iprange nfsd exportfs xt_NOTRACK =
xt_state ip6t_REJECT ip6table_mangle ip6_tables x_tables nf_conntrack_netbi=
os_ns nf_conntrack_broadcast nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_=
ipv4 nf_defrag_ipv4 nf_conntrack ipv6 crc_ccitt isdn slhc 8139too 8139cp mi=
i e1000 aty128fb i2c_i801 piix iTCO_wdt iTCO_vendor_support intel_agp intel=
_gtt agpgart fuse [last unloaded: hisax]=0A=0APid: 18484, comm: smbd Tainte=
d: G      D     3.1.0-ODSbig #1 MAXDATA */<P4B>=0AEIP: 0060:[<c1241d76>] EF=
LAGS: 00210286 CPU: 0=0AEIP is at btrfs_print_leaf+0x16/0x850=0AEAX: db4de8=
00 EBX: db4de800 ECX: 00000001 EDX: 00000000=0AESI: 00000007 EDI: 00000000 =
EBP: f6e13cfc ESP: f6e13c90=0A DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068=
=0AProcess smbd (pid: 18484, ti=3Df6e12000 task=3Ddb4c46e0 task.ti=3Df6e120=
00)=0AStack:=0A 00000000 000007a7 a53fa000 db4de800 ffffffff 0000e231 f6e13=
ce4 00000000=0A 00000000 00000000 dcff8150 00000000 00000000 00000007 00200=
282 00000000=0A c122e2f7 000000b0 c122e2f7 00000070 a7a53fa0 a8000007 00001=
000 00000000=0ACall Trace:=0A [<c122e2f7>] ? btrfs_alloc_path+0x17/0x20=0A =
[<c122e2f7>] ? btrfs_alloc_path+0x17/0x20=0A [<c1239d46>] __btrfs_free_exte=
nt+0x6e6/0x7c0=0A [<c1249a2a>] ? btrfs_mark_buffer_dirty+0x7a/0xe0=0A [<c12=
3cb4f>] run_clustered_refs+0x22f/0x8a0=0A [<c122e700>] ? btrfs_free_path+0x=
20/0x30=0A [<c1257590>] ? btrfs_truncate_inode_items+0x1e0/0x7d0=0A [<c128a=
e00>] ? btrfs_find_ref_cluster+0x60/0x1a0=0A [<c123d259>] btrfs_run_delayed=
_refs+0x99/0x190=0A [<c124da86>] __btrfs_end_transaction+0x66/0x1f0=0A [<c1=
24dc89>] btrfs_end_transaction+0x19/0x20=0A [<c125890e>] btrfs_evict_inode+=
0x1ae/0x270=0A [<c10d2d2f>] evict+0x6f/0x140=0A [<c10d2edb>] iput+0xdb/0x1a=
0=0A [<c10ca934>] do_unlinkat+0x114/0x160=0A [<c10cb565>] sys_unlink+0x15/0=
x20=0A [<c17c9dfc>] syscall_call+0x7/0xb=0A [<c17c0000>] ? mvs_64xx_init+0x=
233/0x6cc=0ACode: 00 8b 5d f4 8b 75 f8 8b 7d fc 89 ec 5d c3 8d b4 26 00 00 =
00 00 55 89 e5 83 ec 6c 89 5d f4 89 75 f8 89 7d fc 3e 8d 74 26 00 89 c3 <8b=
> 42 14 89 d7 e8 70 3a e6 ff 89 fa 8b 40 60 89 45 dc 89 d8 e8 =0AEIP: [<c12=
41d76>] btrfs_print_leaf+0x16/0x850 SS:ESP 0068:f6e13c90=0ACR2: 00000000000=
00014=0A---[ end trace e823394b87ecbfbb ]---=0Aparent transid verify failed=
 on 5340297986048 wanted 57354 found 42286=0Aparent transid verify failed o=
n 5340297986048 wanted 57354 found 42286=0Aparent transid verify failed on =

--=_Bw$00WiD1u3Yl4AS8sJjdB5cwZacs9NklUd9q4A4Nq60mBhfsPKECEH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename=btrfsck.txt;
 modification-date="Wed, 26 Oct 2011 12:19:20 +0200";
 creation-date="Wed, 26 Oct 2011 12:19:20 +0200";
 read-date="Wed, 26 Oct 2011 12:19:20 +0200"

parent transid verify failed on 21094400 wanted 57401 found 47987
parent transid verify failed on 8520776257536 wanted 57347 found 55978
parent transid verify failed on 8520219820032 wanted 57343 found 55967
parent transid verify failed on 8520776273920 wanted 57347 found 55978
parent transid verify failed on 8520776278016 wanted 57347 found 55978
parent transid verify failed on 8520219832320 wanted 57343 found 55967
parent transid verify failed on 8520219836416 wanted 57343 found 55967
parent transid verify failed on 8520219844608 wanted 57343 found 55967
leaf parent key incorrect 5340295811072
bad block 5340295811072
leaf parent key incorrect 5340295839744
bad block 5340295839744
parent transid verify failed on 8520218161152 wanted 57343 found 55967
parent transid verify failed on 8520218169344 wanted 57343 found 55967
leaf parent key incorrect 8520218673152
bad block 8520218673152
parent transid verify failed on 8520218828800 wanted 57343 found 55967
leaf parent key incorrect 8520775094272
bad block 8520775094272
leaf parent key incorrect 8520777793536
bad block 8520777793536
parent transid verify failed on 5340298461184 wanted 57354 found 53683
parent transid verify failed on 8520777793536 wanted 57362 found 57240
parent transid verify failed on 8520777793536 wanted 57362 found 57240
parent transid verify failed on 5340295811072 wanted 57354 found 42286
parent transid verify failed on 5340295811072 wanted 57354 found 42286
parent transid verify failed on 5340295839744 wanted 57354 found 55983
parent transid verify failed on 5340295839744 wanted 57354 found 55983
parent transid verify failed on 5340295843840 wanted 57354 found 55983
parent transid verify failed on 8520777674752 wanted 57362 found 57240
parent transid verify failed on 8520491139072 wanted 57359 found 55974
parent transid verify failed on 8520218828800 wanted 57343 found 55967
leaf parent key incorrect 8520220254208
bad block 8520220254208
leaf parent key incorrect 8520486453248
bad block 8520486453248
leaf parent key incorrect 8520489959424
bad block 8520489959424
leaf parent key incorrect 8520490131456
bad block 8520490131456
bad block 8520773492736
Extent back ref already exists for 4478103113728 parent 0 root 2 
Extent back ref already exists for 8520469598208 parent 0 root 2 
Extent back ref already exists for 8519937826816 parent 0 root 2 
Extent back ref already exists for 8519937830912 parent 0 root 2 
Extent back ref already exists for 8521415835648 parent 0 root 2 
leaf parent key incorrect 8520774410240
bad block 8520774410240
parent transid verify failed on 8520775753728 wanted 57347 found 55978
leaf parent key incorrect 8521083891712
bad block 8521083891712
leaf parent key incorrect 8521314054144
bad block 8521314054144
parent transid verify failed on 5340296237056 wanted 57354 found 42286
parent transid verify failed on 8519939354624 wanted 57355 found 55960
parent transid verify failed on 8519939211264 wanted 57355 found 57322
parent transid verify failed on 5340295839744 wanted 57354 found 55983
leaf parent key incorrect 21094400
bad block 21094400
leaf parent key incorrect 4478083121152
bad block 4478083121152
bad block 4478083129344
Extent back ref already exists for 4478083346432 parent 0 root 7 
Extent back ref already exists for 7039505383424 parent 0 root 7 

[...]

Extent back ref already exists for 4776267329536 parent 0 root 7 
Extent back ref already exists for 4776268664832 parent 0 root 7 
Extent back ref already exists for 4776268619776 parent 0 root 7 
leaf parent key incorrect 4478084227072
bad block 4478084227072
warning, start mismatch 4782494081024 4782475907072
btrfsck: btrfsck.c:2611: run_next_block: Assertion `!(ret)' failed.
sh: line 57:  8083 Aborted                 btrfsck /dev/sdb1

--=_Bw$00WiD1u3Yl4AS8sJjdB5cwZacs9NklUd9q4A4Nq60mBhfsPKECEH--
