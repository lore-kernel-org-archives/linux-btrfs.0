Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:42535 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaKLIiP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 03:38:15 -0500
Received: from [85.19.192.9] (port=44899 helo=[172.20.1.92])
	by smtp.domeneshop.no with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <lists@skagestad.org>)
	id 1XoTJA-0003cu-0s
	for linux-btrfs@vger.kernel.org; Wed, 12 Nov 2014 09:29:44 +0100
Message-ID: <54631A84.2000500@skagestad.org>
Date: Wed, 12 Nov 2014 09:29:56 +0100
From: =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: 3.18.0-rc4 - WARNING: CPU: 3 PID: 3889 at fs/btrfs/extent-tree.c:3785
 btrfs_free_reserved_data_space+0xc8/0xe0 [btrfs]()
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

After upgrade to 3.18.0-rc4 get a lot of these warnings.
The system seems to otherwise behave normally. I have not observed any 
actual issues.

I have a total of 4 different btrfs filesystems on the server.
A subvolume on storage has a nocow directory where I keep kvm-images. 
The kvm-instances are using btrfs on those images.

If I can provide any other useful info, or run some tests, let me know.

Label: 'root'  uuid: 6a681300-faef-4195-a1b3-6699c7a5aa5e
     Total devices 2 FS bytes used 48.31GiB
     devid    1 size 298.09GiB used 124.03GiB path /dev/sda1
     devid    2 size 298.09GiB used 124.03GiB path /dev/sdb1

Label: 'storage'  uuid: 5dad88b9-25e0-4b30-a563-69868ca86d32
     Total devices 11 FS bytes used 9.43TiB
     devid    1 size 1.82TiB used 1.79TiB path /dev/mapper/sdh
     devid    2 size 1.82TiB used 1.79TiB path /dev/mapper/sdi
     devid    3 size 1.82TiB used 1.79TiB path /dev/mapper/sdj
     devid    4 size 1.82TiB used 1.79TiB path /dev/mapper/sdl
     devid    5 size 1.82TiB used 1.79TiB path /dev/mapper/sdg
     devid    6 size 1.82TiB used 1.79TiB path /dev/mapper/sdm
     devid    7 size 1.82TiB used 1.79TiB path /dev/mapper/sdo
     devid    8 size 1.82TiB used 1.79TiB path /dev/mapper/sdr
     devid    9 size 1.82TiB used 1.79TiB path /dev/mapper/sds
     devid   10 size 1.82TiB used 1.79TiB path /dev/mapper/sdt
     devid   11 size 1.82TiB used 1.79TiB path /dev/mapper/sdu

Label: 'restore'  uuid: fac394ae-6774-470b-b637-32f1034a6c93
     Total devices 3 FS bytes used 1.92TiB
     devid    1 size 1.82TiB used 683.01GiB path /dev/mapper/sdk
     devid    2 size 1.82TiB used 693.01GiB path /dev/mapper/sdn
     devid    3 size 1.82TiB used 697.01GiB path /dev/mapper/sdp

Label: 'private'  uuid: ecdcc9ef-38c0-4f9b-8fb7-a8b749fb2673
     Total devices 4 FS bytes used 1.86TiB
     devid    1 size 1.82TiB used 953.01GiB path /dev/mapper/sdq
     devid    2 size 1.82TiB used 953.01GiB path /dev/mapper/sdd
     devid    3 size 1.82TiB used 953.01GiB path /dev/mapper/sde
     devid    4 size 1.82TiB used 953.01GiB path /dev/mapper/sdf

Btrfs v3.17.1

btrfs filesystem df /mnt/storage/
Data, RAID10: total=9.82TiB, used=9.42TiB
System, RAID10: total=7.81MiB, used=816.00KiB
Metadata, RAID10: total=13.17GiB, used=11.88GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

btrfs filesystem df /mnt/restore/
Data, single: total=2.01TiB, used=1.92TiB
System, RAID1: total=8.00MiB, used=272.00KiB
Metadata, RAID1: total=5.00GiB, used=2.98GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

btrfs filesystem df /mnt/private/
Data, RAID10: total=1.86TiB, used=1.86TiB
System, RAID10: total=16.00MiB, used=208.00KiB
Metadata, RAID10: total=4.00GiB, used=2.85GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

btrfs filesystem df /
Data, RAID1: total=112.00GiB, used=47.39GiB
System, RAID1: total=32.00MiB, used=24.00KiB
Metadata, RAID1: total=12.00GiB, used=940.83MiB
GlobalReserve, single: total=316.00MiB, used=0.00B


[Wed Nov 12 09:06:52 2014] ------------[ cut here ]------------
[Wed Nov 12 09:06:52 2014] WARNING: CPU: 3 PID: 3889 at 
fs/btrfs/extent-tree.c:3785 btrfs_free_reserved_data_space+0xc8/0xe0 
[btrfs]()
[Wed Nov 12 09:06:52 2014] Modules linked in: vhost_net(E) vhost(E) 
macvtap(E) macvlan(E) xfs(E) libcrc32c(E) ipmi_devintf(E) ipt_REJECT(E) 
nf_reject_ipv4(E) xt_CHECKSUM(E) ip6table_filter(E) ip6_tables(E) 
ebtable_nat(E) ebtables(E) sch_prio(E) bridge(E) stp(E) llc(E) 
xt_state(E) iptable_filter(E) xt_CLASSIFY(E) xt_tcpudp(E) xt_DSCP(E) 
iptable_mangle(E) iptable_nat(E) nf_conntrack_ipv4(E) nf_defrag_ipv4(E) 
nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) ip_tables(E) x_tables(E) 
dm_crypt(E) netconsole(E) configfs(E) ppdev(E) coretemp(E) kvm_intel(E) 
serio_raw(E) lpc_ich(E) kvm(E) mac_hid(E) video(E) tpm_infineon(E) 
ipmi_si(E) parport_pc(E) ipmi_msghandler(E) aesni_intel(E) nfsd(E) 
aes_x86_64(E) auth_rpcgss(E) nfs_acl(E) glue_helper(E) nfs(E) lrw(E) 
gf128mul(E) lockd(E) ablk_helper(E) grace(E) cryptd(E) sunrpc(E) 
fscache(E) lp(E) parport(E) btrfs(E) raid10(E) raid456(E) 
async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E) 
async_tx(E) xor(E) raid6_pq(E) raid1(E) raid0(E) multipath(E) linear(E) 
hid_generic(E) usbhid(E) hid(E) ahci(E) psmouse(E) libahci(E) e1000e(E) 
mpt2sas(E) ptp(E) raid_class(E) pps_core(E) scsi_transport_sas(E)
[Wed Nov 12 09:06:52 2014] CPU: 3 PID: 3889 Comm: btrfs-transacti 
Tainted: G        W   E  3.18.0-rc4 #82
[Wed Nov 12 09:06:52 2014] Hardware name: To be filled by O.E.M. To be 
filled by O.E.M./P8B-X series, BIOS 2107 05/04/2012
[Wed Nov 12 09:06:52 2014]  0000000000000009 ffff8800c3f77c48 
ffffffff8174001a 0000000000000000
[Wed Nov 12 09:06:52 2014]  0000000000000000 ffff8800c3f77c88 
ffffffff8106fc71 0000000000000000
[Wed Nov 12 09:06:52 2014]  ffff880403aee000 0000000000140000 
0000000000000003 ffff880403252c00
[Wed Nov 12 09:06:52 2014] Call Trace:
[Wed Nov 12 09:06:52 2014]  [<ffffffff8174001a>] dump_stack+0x46/0x58
[Wed Nov 12 09:06:52 2014]  [<ffffffff8106fc71>] 
warn_slowpath_common+0x81/0xa0
[Wed Nov 12 09:06:52 2014]  [<ffffffff8106fd4a>] 
warn_slowpath_null+0x1a/0x20
[Wed Nov 12 09:06:52 2014]  [<ffffffffc0380a08>] 
btrfs_free_reserved_data_space+0xc8/0xe0 [btrfs]
[Wed Nov 12 09:06:52 2014]  [<ffffffffc038800d>] 
btrfs_write_dirty_block_groups+0x5cd/0x6d0 [btrfs]
[Wed Nov 12 09:06:52 2014]  [<ffffffffc040c234>] 
commit_cowonly_roots+0x17b/0x230 [btrfs]
[Wed Nov 12 09:06:52 2014]  [<ffffffffc03985a2>] 
btrfs_commit_transaction+0x432/0xa90 [btrfs]
[Wed Nov 12 09:06:52 2014]  [<ffffffffc0398c93>] ? 
start_transaction+0x93/0x590 [btrfs]
[Wed Nov 12 09:06:52 2014]  [<ffffffffc0394055>] 
transaction_kthread+0x1b5/0x240 [btrfs]
[Wed Nov 12 09:06:52 2014]  [<ffffffffc0393ea0>] ? 
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[Wed Nov 12 09:06:52 2014]  [<ffffffff8108e232>] kthread+0xd2/0xf0
[Wed Nov 12 09:06:52 2014]  [<ffffffff8108e160>] ? 
kthread_create_on_node+0x180/0x180
[Wed Nov 12 09:06:52 2014]  [<ffffffff8174837c>] ret_from_fork+0x7c/0xb0
[Wed Nov 12 09:06:52 2014]  [<ffffffff8108e160>] ? 
kthread_create_on_node+0x180/0x180
[Wed Nov 12 09:06:52 2014] ---[ end trace db1dd7fa3d341df9 ]---

--
Torbjørn
