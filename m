Received: from mail-108-mta78.mxroute.com (mail-108-mta78.mxroute.com [136.175.108.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA72356770
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 12:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780316251; cv=none; b=Vj8J6gSRFpvQNA39wlQJF8lOTE9ao0B1OsnmCHZOZ0gfYwpoHittxpf7qBNXdkpteOxAoZbP6YVLG/5UrJnsvwgGoOprj6onKoiqp0pc0S3j/EFVu+yXMEiKYk+zex+1/+oeF3kIN30s/qnllDrZIgidGpTyzFYpYmWIkmY/sOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780316251; c=relaxed/simple;
	bh=govUMqIQjzjElXA1sgVQAfJkZsZhd+0+SuNqL737Kz8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dx63yGE2sec4Z+aRsA2aVjrDPbgVzbkRp9/p/W35HFJw/o/727bu6/1qLDtWJvg+C8rAZzPz/PAXR/DNLrpGnv5/cZqVjbIcBIZjaeXIl3vOnk1MUjjuL3e+SR+1PJ2cprxhhCIkx4GvV14Dae4bveHzShpCtrxj5P6/gGHu4J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=HmWMHVIN; arc=none smtp.client-ip=136.175.108.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="HmWMHVIN"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta78.mxroute.com (ZoneMTA) with ESMTPSA id 19e83195ea100067f7.003
 for <linux-btrfs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 01 Jun 2026 12:12:18 +0000
X-Zone-Loop: 030002f05ef6781decdfd489b4e425186ce3a908703c
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BA4Hgckh3Nto1sDHH3Ces/2iYmZeymgFJ59JeZjPY7k=; b=HmWMHVINJBpQONJkPHYuTc7P4W
	lwOb+Pe3Rp4zosBGb/oQalk+5q3+vWjQfWya8JUM8pl0rOFwWLwyROESnuaykbStCbj+SLcoqMo8r
	SKbK2a0BzhmQSTPlhE47llErM5JhG1vwF9gwEm1a2LQTRVoeCoGZzgK2+GIWC3wYTv6RGR3qg2OU/
	/xMgzCUhOABig1Yx3znKw3/2jO9hzrXxQW7K454XkmzGNWTL3x4t5HT1vNeKGY/YpZmclEKITxcX5
	yInHl9duiYImq7rq0LjS/tYUC0NsAyls7XGBNMyLX/1tlOWLfFK0cegZnp4oXxHKsSZOVNMlYO4as
	Zh4BpoWg==;
From: Su Yue <l@damenly.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org,  Su Yue <glass.su@suse.com>
Subject: Re: [BUG report] btrfs/242 triggers kernel NULL pointer dereference
In-Reply-To: <7edd1a98-4683-463d-b789-e75f7cb42de1@gmx.com> (Qu Wenruo's
	message of "Mon, 1 Jun 2026 21:23:20 +0930")
References: <wlwir19t.fsf@damenly.org>
	<7edd1a98-4683-463d-b789-e75f7cb42de1@gmx.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Mon, 01 Jun 2026 20:12:05 +0800
Message-ID: <ik82qx2i.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Mon 01 Jun 2026 at 21:23, Qu Wenruo <quwenruo.btrfs@gmx.com>=20
wrote:

> =E5=9C=A8 2026/6/1 20:11, Su Yue =E5=86=99=E9=81=93:
>> Hi, btrfs folks. Recently I found that fstests/btrfs/242 can=20
>> trigger
>> kernel NULL pointer dereference with for-
>> next(27a96ee64c0e0d6131160da98a5485adbbe9dd59) and
>> openSUSE Tumbleweed kernel(7.0.10-2-default). The probability=20
>> is within 50
>> rounds.
>> ENV:
>> host: mac mini m1 running Asahi linux
>> VM(new installed):
>> # uname -r
>> 7.0.10-2-default
>> # dmesg
>> [=C2=A0 312.853073 ] [ T121971 ] run fstests btrfs/242 at 2026-06-01=20
>> 10:25:08
>> [=C2=A0 313.417562 ] [ T122570 ] BTRFS: device fsid
>> d4d7f234-487c-4787-88e4-47a8b68c9874 devid 1 transid 8 /dev/sdc=20
>> (8:32) scanned
>> by mkfs.btrfs (122570)
>> [=C2=A0 313.417698 ] [ T122570 ] BTRFS: device fsid
>> d4d7f234-487c-4787-88e4-47a8b68c9874 devid 2 transid 8 /dev/sdd=20
>> (8:48) scanned
>> by mkfs.btrfs (122570)
>> [=C2=A0 313.423953 ] [ T122578 ] BTRFS info (device sdc): first=20
>> mount of filesystem
>> d4d7f234-487c-4787-88e4-47a8b68c9874
>> [=C2=A0 313.423967 ] [ T122578 ] BTRFS info (device sdc): using=20
>> crc32c checksum
>> algorithm
>> [=C2=A0 313.428833 ] [ T122578 ] BTRFS info (device sdc): checking=20
>> UUID tree
>> [=C2=A0 313.428975 ] [ T122578 ] BTRFS info (device sdc): turning on=20
>> async discard
>> [=C2=A0 313.429097 ] [ T122578 ] BTRFS info (device sdc): enabling=20
>> free space tree
>> [=C2=A0 313.469504 ] [ T122603 ] BTRFS info (device sdc): last=20
>> unmount of
>> filesystem d4d7f234-487c-4787-88e4-47a8b68c9874
>> [=C2=A0 313.513398 ] [ T122609 ] BTRFS: device fsid
>> d4d7f234-487c-4787-88e4-47a8b68c9874 devid 1 transid 9 /dev/sdc=20
>> (8:32) scanned
>> by mount (122609)
>> [=C2=A0 313.513820 ] [ T122609 ] BTRFS info (device sdc): first=20
>> mount of filesystem
>> d4d7f234-487c-4787-88e4-47a8b68c9874
>> [=C2=A0 313.513845 ] [ T122609 ] BTRFS info (device sdc): using=20
>> crc32c checksum
>> algorithm
>> [=C2=A0 313.515223 ] [ T122609 ] BTRFS warning (device sdc): devid 2=20
>> uuid
>> fbe72d72-3272-482d-80fb-ab88ed398192 is missing
>> [=C2=A0 313.515523 ] [ T122609 ] BTRFS warning (device sdc): devid 2=20
>> uuid
>> fbe72d72-3272-482d-80fb-ab88ed398192 is missing
>> [=C2=A0 313.518615 ] [ T122609 ] BTRFS info (device sdc): allowing=20
>> degraded mounts
>> [=C2=A0 313.518630 ] [ T122609 ] BTRFS info (device sdc): turning on=20
>> async discard
>> [=C2=A0 313.518635 ] [ T122609 ] BTRFS info (device sdc): enabling=20
>> free space tree
>> [=C2=A0 313.523827 ] [ T122625 ] Unable to handle kernel NULL=20
>> pointer dereference
>> at virtual address 0000000000000018
>> [=C2=A0 313.523858 ] [ T122625 ] Mem abort info:
>> [=C2=A0 313.523865 ] [ T122625 ]=C2=A0=C2=A0 ESR =3D 0x0000000096000004
>> [=C2=A0 313.523871 ] [ T122625 ]=C2=A0=C2=A0 EC =3D 0x25: DABT (current =
EL), IL=20
>> =3D 32 bits
>> [=C2=A0 313.523877 ] [ T122625 ]=C2=A0=C2=A0 SET =3D 0, FnV =3D 0
>> [=C2=A0 313.523883 ] [ T122625 ]=C2=A0=C2=A0 EA =3D 0, S1PTW =3D 0
>> [=C2=A0 313.523889 ] [ T122625 ]=C2=A0=C2=A0 FSC =3D 0x04: level 0 trans=
lation=20
>> fault
>> [=C2=A0 313.523894 ] [ T122625 ] Data abort info:
>> [=C2=A0 313.523899 ] [ T122625 ]=C2=A0=C2=A0 ISV =3D 0, ISS =3D 0x000000=
04, ISS2 =3D=20
>> 0x00000000
>> [=C2=A0 313.523905 ] [ T122625 ]=C2=A0=C2=A0 CM =3D 0, WnR =3D 0, TnD =
=3D 0,=20
>> TagAccess =3D 0
>> [=C2=A0 313.523911 ] [ T122625 ]=C2=A0=C2=A0 GCS =3D 0, Overlay =3D 0, D=
irtyBit =3D=20
>> 0, Xs =3D 0
>> [=C2=A0 313.523916 ] [ T122625 ] user pgtable: 4k pages, 48-bit VAs,
>> pgdp=3D000000013fd6b000
>> [=C2=A0 313.523924 ] [ T122625 ] [0000000000000018]=20
>> pgd=3D0000000000000000,
>> p4d=3D0000000000000000
>> [=C2=A0 313.523940 ] [ T122625 ] Internal error: Oops:=20
>> 0000000096000004 [#1]  SMP
>> [=C2=A0 313.534094 ] [ T122625 ] Modules linked in: af_packet rfkill=20
>> dm_mod
>> nls_iso8859_1 nls_cp437 vfat fat binfmt_misc btrfs xor xor_neon=20
>> libblake2b
>> virtio_net virtio_balloon net_failover failover button raid6_pq=20
>> vsock_loopback
>> vmw_vsock_virtio_transport vmw_vsock_virtio_transport_common=20
>> vsock xfs sr_mod
>> cdrom aes_ce_blk ghash_ce gf128mul virtio_scsi sd_mod sm4 sg=20
>> scsi_mod
>> scsi_common xhci_pci virtio_mmio xhci_hcd usbcore usb_common=20
>> virtio_blk
>> efivarfs dmi_sysfs qemu_fw_cfg virtiofs fuse virtio_rng
>> [=C2=A0 313.540774 ] [ T122625 ] CPU: 4 UID: 0 PID: 122625 Comm:=20
>> fstrim Not tainted
>> 7.0.10-2-default #1 PREEMPT(full) openSUSE Tumbleweed
>> e9a5f6b24978fba3bf015a992f865837fdfff3dd
>> [=C2=A0 313.544026 ] [ T122625 ] Hardware name: QEMU KVM Virtual=20
>> Machine, BIOS
>> edk2-20250812-19.fc42 08/12/2025
>> [=C2=A0 313.545160 ] [ T122625 ] pstate: 01400005 (nzcv daif +PAN=20
>> -UAO -TCO +DIT
>> -SSBS BTYPE=3D--)
>> [=C2=A0 313.546134 ] [ T122625 ] pc : btrfs_trim_fs+0x34c/0xa00=20
>> [btrfs]
>
> Since you can reproduce it on the latest for-next, mind to=20
> provide the for-next
> call trace along with the faddr2line output for pc register of=20
> the for-next run?
>
Sure.

# ./scripts/faddr2line  fs/btrfs/btrfs.ko=20
  btrfs_trim_fs+0x36c/0xa48
btrfs_trim_fs+0x36c/0xa48:
bdev_max_discard_sectors at=20
/var/lib/btrfs-linux-for-next/./include/linux/blkdev.h:1449=20
(discriminator 1)
(inlined by) btrfs_trim_free_extents_throttle at=20
/var/lib/btrfs-linux-for-next/fs/btrfs/extent-tree.c:6628=20
(discriminator 1)
(inlined by) btrfs_trim_free_extents at=20
/var/lib/btrfs-linux-for-next/fs/btrfs/extent-tree.c:6762=20
(discriminator 1)
(inlined by) btrfs_trim_fs at=20
/var/lib/btrfs-linux-for-next/fs/btrfs/extent-tree.c:6919=20
(discriminator 1)

[11630.789792] BTRFS info (device sdc): first mount of filesystem=20
5e033cee-fc5a-4e82-b065-e93b53533c2d
[11630.789810] BTRFS info (device sdc): using crc32c checksum=20
algorithm
[11630.803359] BTRFS warning (device sdc): devid 2 uuid=20
ffa87e4a-26a0-4fb8-988d-1a6c8d643134 is missing
[11630.808199] BTRFS warning (device sdc): devid 2 uuid=20
ffa87e4a-26a0-4fb8-988d-1a6c8d643134 is missing
[11630.815475] BTRFS info (device sdc): allowing degraded mounts
[11630.815485] BTRFS info (device sdc): turning on async discard
[11630.815489] BTRFS info (device sdc): enabling free space tree
[11630.836072] Unable to handle kernel NULL pointer dereference at=20
virtual address 0000000000000018
[11630.836118] Mem abort info:
[11630.836121]   ESR =3D 0x0000000096000004
[11630.836124]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[11630.836128]   SET =3D 0, FnV =3D 0
[11630.836130]   EA =3D 0, S1PTW =3D 0
[11630.836133]   FSC =3D 0x04: level 0 translation fault
[11630.836136] Data abort info:
[11630.836138]   ISV =3D 0, ISS =3D 0x00000004, ISS2 =3D 0x00000000
[11630.836141]   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
[11630.836144]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
[11630.836147] user pgtable: 4k pages, 48-bit VAs,=20
pgdp=3D00000001324a7000
[11630.836151] [0000000000000018] pgd=3D0000000000000000,=20
p4d=3D0000000000000000
[11630.836247] Internal error: Oops: 0000000096000004 [#1]  SMP
[11630.836279] Modules linked in: dm_dust(E) dm_flakey(E) ext4(E)=20
crc16(E) mbcache(E) jbd2(E) loop(E) btrfs(E) xor(E) libblake2b(E)=20
raid6_pq(E) dm_mod(E) arm_smccc_trng(E) virtio_balloon(E)=20
virtio_net(E) net_failover(E) failover(E) vfat(E) fat(E) drm(E)=20
fuse(E) xfs(E) virtio_scsi(E) qemu_fw_cfg(E) virtio_pci(E)=20
virtio_pci_legacy_dev(E) virtio_pci_modern_dev(E)=20
virtio_console(E) virtio_rng(E
) rng_core(E)
[11630.836342] CPU: 0 UID: 0 PID: 820669 Comm: fstrim Tainted: G=20
E       7.1.0-rc4-custom+ #1 PREEMPT(full)
[11630.836352] Tainted: [E]=3DUNSIGNED_MODULE
[11630.836356] Hardware name: QEMU KVM Virtual Machine, BIOS=20
edk2-20250812-19.fc42 08/12/2025
[11630.836363] pstate: 01400005 (nzcv daif +PAN -UAO -TCO +DIT=20
-SSBS BTYPE=3D--)
[11630.836370] pc : btrfs_trim_fs+0x36c/0xa48 [btrfs]
[11630.836474] lr : btrfs_trim_fs+0x1f8/0xa48 [btrfs]
[11630.836557] sp : ffff800085ef3ba0
[11630.836561] x29: ffff800085ef3c30 x28: ffff0000ed979cf8 x27:=20
ffff800085ef3c90
[11630.836569] x26: ffff0000f51a9c00 x25: 0000000000000000 x24:=20
0000000000000000
[11630.836577] x23: ffff0000ed979c70 x22: ffff0000ed979c00 x21:=20
ffff0000f51a9c00
[11630.836584] x20: 0000000000000000 x19: 000000004fdb8000 x18:=20
00000a9403d9d8b5
[11630.836592] x17: 0000000000000000 x16: ffffa49477e47e10 x15:=20
0000000000000000
[11630.836600] x14: 0000000000000000 x13: 0000000000000030 x12:=20
0000000800110005
[11630.836607] x11: ffff0000dc9cfc38 x10: 0000000000000000 x9 :=20
ffff800085ef3a10
[11630.836615] x8 : ffffa4947853e848 x7 : 0000000000000000 x6 :=20
ffff0000de710040
[11630.836622] x5 : 0000000000000000 x4 : ffff0000f51a9c00 x3 :=20
0000000000000000
[11630.836629] x2 : 0000000000000001 x1 : 0000000000000086 x0 :=20
0000000000000000
[11630.836645] Call trace:
[11630.836650]  btrfs_trim_fs+0x36c/0xa48 [btrfs] (P)
[11630.836732]  btrfs_ioctl_fitrim+0x138/0x2a0 [btrfs]
[11630.836816]  btrfs_ioctl+0x10d8/0x2910 [btrfs]
[11630.836898]  __arm64_sys_ioctl+0xac/0x108
[11630.836907]  invoke_syscall.constprop.0+0x48/0x120
[11630.836916]  el0_svc_common.constprop.0+0x40/0xe8
[11630.836923]  do_el0_svc+0x24/0x38
[11630.836928]  el0_svc+0x50/0x310
[11630.836937]  el0t_64_sync_handler+0xa0/0xe8
[11630.836943]  el0t_64_sync+0x198/0x1a0
[11630.836951] Code: 17ffff7b f9400fe0 f90033e0 f9402f40=20
(f9400c00)
[11630.836958] ---[ end trace 0000000000000000  ]-=E2=80=94

> Thanks,
> Qu
