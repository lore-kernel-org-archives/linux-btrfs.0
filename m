Received: from mail-108-mta170.mxroute.com (mail-108-mta170.mxroute.com [136.175.108.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A41343884
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 10:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780310807; cv=none; b=PVdVu0eduWC7InOY0WSvHLXMRfxI0ph9katEpWtnIqqQfTpyJZAq1l/xuY69GJEQCnU+5D6N/LbMrqgbAuQSpUe/yd0Dap72/C4pGvFd3fHyEVyNQw5FMbA4nC9QpVc0Co20F9mBIts9kSMYO0pXTMvfvrIVpmSmR2Rc+tNqahI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780310807; c=relaxed/simple;
	bh=Q+0p2ontU/cegNmOnTdg613VkAwoPp7wSBu4PfOHVkw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t8G5GSkAEL1XwRX+/mv7ePtq/vRW4DEiB34htBJBfdt1cMgelLkrza1CB0TFGzBjocq8zi0jsglBDs80R8ry8VAYsHH+QDyJNaqwOxgxnkG4mxU5J+3VOWFR+LP66kOR1uN7ewYFEGk9WgmO5SeU62jfojzv0p0tTW4yGB8wMDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=Ch73rjtl; arc=none smtp.client-ip=136.175.108.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="Ch73rjtl"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta170.mxroute.com (ZoneMTA) with ESMTPSA id 19e82c6499100067f7.002
 for <linux-btrfs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 01 Jun 2026 10:41:33 +0000
X-Zone-Loop: 470a5d408e2bd3010e86054b9c72b404b55a06e46811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:Subject:To:From:Sender:
	Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Shhf1KCTCdeE3H/nOJZpT7Y0XIvUxJPTlN4+tJGw7mY=; b=Ch73rjtlsqIVMW5B9fEII95Wk5
	VitF/RUSR6tD+xWXOwYa8iTdxW7IHADKELF+xDgCNm9VNxaxoW3F1jJaUxmNtNJ4IThVS+rTmKrwA
	OQUqRWsCFbgzkTBCa9Sd4Mvh8nkepBPUhEbWKUrbdYLvSdeDa+NHR9tmOE3aybsCtjvEnJOxXz4lH
	nDyX5RNqJs4s+lRuFuu6o5scFjZRGmWpVMLpy9nLx0R0IMFMeFlfdnZMfvBmubjn4oxKTm4Cz0QBn
	lETtOn4NRWB8RTLbMQosxC7x/6UPxzQnBKm2sg8NEZsA0l8Uru1GUEGgmWnAfbQnaqWlUcskty+CS
	OI81pfqQ==;
From: Su Yue <l@damenly.org>
To: linux-btrfs@vger.kernel.org, Su Yue <glass.su@suse.com>
Subject: [BUG report] btrfs/242 triggers kernel NULL pointer dereference
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Mon, 01 Jun 2026 18:41:18 +0800
Message-ID: <wlwir19t.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


Hi, btrfs folks. Recently I found that fstests/btrfs/242 can 
trigger
kernel NULL pointer dereference with 
for-next(27a96ee64c0e0d6131160da98a5485adbbe9dd59) and
openSUSE Tumbleweed kernel(7.0.10-2-default). The probability is 
within 50 rounds.

ENV:
host: mac mini m1 running Asahi linux

VM(new installed):

# uname -r
7.0.10-2-default

# dmesg
[  312.853073 ] [ T121971 ] run fstests btrfs/242 at 2026-06-01 
10:25:08
[  313.417562 ] [ T122570 ] BTRFS: device fsid 
d4d7f234-487c-4787-88e4-47a8b68c9874 devid 1 transid 8 /dev/sdc 
(8:32) scanned by mkfs.btrfs (122570)
[  313.417698 ] [ T122570 ] BTRFS: device fsid 
d4d7f234-487c-4787-88e4-47a8b68c9874 devid 2 transid 8 /dev/sdd 
(8:48) scanned by mkfs.btrfs (122570)
[  313.423953 ] [ T122578 ] BTRFS info (device sdc): first mount 
of filesystem d4d7f234-487c-4787-88e4-47a8b68c9874
[  313.423967 ] [ T122578 ] BTRFS info (device sdc): using crc32c 
checksum algorithm
[  313.428833 ] [ T122578 ] BTRFS info (device sdc): checking UUID 
tree
[  313.428975 ] [ T122578 ] BTRFS info (device sdc): turning on 
async discard
[  313.429097 ] [ T122578 ] BTRFS info (device sdc): enabling free 
space tree
[  313.469504 ] [ T122603 ] BTRFS info (device sdc): last unmount 
of filesystem d4d7f234-487c-4787-88e4-47a8b68c9874
[  313.513398 ] [ T122609 ] BTRFS: device fsid 
d4d7f234-487c-4787-88e4-47a8b68c9874 devid 1 transid 9 /dev/sdc 
(8:32) scanned by mount (122609)
[  313.513820 ] [ T122609 ] BTRFS info (device sdc): first mount 
of filesystem d4d7f234-487c-4787-88e4-47a8b68c9874
[  313.513845 ] [ T122609 ] BTRFS info (device sdc): using crc32c 
checksum algorithm
[  313.515223 ] [ T122609 ] BTRFS warning (device sdc): devid 2 
uuid fbe72d72-3272-482d-80fb-ab88ed398192 is missing
[  313.515523 ] [ T122609 ] BTRFS warning (device sdc): devid 2 
uuid fbe72d72-3272-482d-80fb-ab88ed398192 is missing
[  313.518615 ] [ T122609 ] BTRFS info (device sdc): allowing 
degraded mounts
[  313.518630 ] [ T122609 ] BTRFS info (device sdc): turning on 
async discard
[  313.518635 ] [ T122609 ] BTRFS info (device sdc): enabling free 
space tree
[  313.523827 ] [ T122625 ] Unable to handle kernel NULL pointer 
dereference at virtual address 0000000000000018
[  313.523858 ] [ T122625 ] Mem abort info:
[  313.523865 ] [ T122625 ]   ESR = 0x0000000096000004
[  313.523871 ] [ T122625 ]   EC = 0x25: DABT (current EL), IL = 
32 bits
[  313.523877 ] [ T122625 ]   SET = 0, FnV = 0
[  313.523883 ] [ T122625 ]   EA = 0, S1PTW = 0
[  313.523889 ] [ T122625 ]   FSC = 0x04: level 0 translation 
fault
[  313.523894 ] [ T122625 ] Data abort info:
[  313.523899 ] [ T122625 ]   ISV = 0, ISS = 0x00000004, ISS2 = 
0x00000000
[  313.523905 ] [ T122625 ]   CM = 0, WnR = 0, TnD = 0, TagAccess 
= 0
[  313.523911 ] [ T122625 ]   GCS = 0, Overlay = 0, DirtyBit = 0, 
Xs = 0
[  313.523916 ] [ T122625 ] user pgtable: 4k pages, 48-bit VAs, 
pgdp=000000013fd6b000
[  313.523924 ] [ T122625 ] [0000000000000018] 
pgd=0000000000000000, p4d=0000000000000000
[  313.523940 ] [ T122625 ] Internal error: Oops: 0000000096000004 
[#1]  SMP
[  313.534094 ] [ T122625 ] Modules linked in: af_packet rfkill 
dm_mod nls_iso8859_1 nls_cp437 vfat fat binfmt_misc btrfs xor 
xor_neon libblake2b virtio_net virtio_balloon net_failover 
failover button raid6_pq vsock_loopback vmw_vsock_virtio_transport 
vmw_vsock_virtio_transport_common vsock xfs sr_mod cdrom 
aes_ce_blk ghash_ce gf128mul virtio_scsi sd_mod sm4 sg scsi_mod 
scsi_common xhci_pci virtio_mmio xhci_hcd usbcore usb_common 
virtio_blk efivarfs dmi_sysfs qemu_fw_cfg virtiofs fuse virtio_rng
[  313.540774 ] [ T122625 ] CPU: 4 UID: 0 PID: 122625 Comm: fstrim 
Not tainted 7.0.10-2-default #1 PREEMPT(full) openSUSE Tumbleweed 
e9a5f6b24978fba3bf015a992f865837fdfff3dd
[  313.544026 ] [ T122625 ] Hardware name: QEMU KVM Virtual 
Machine, BIOS edk2-20250812-19.fc42 08/12/2025
[  313.545160 ] [ T122625 ] pstate: 01400005 (nzcv daif +PAN -UAO 
-TCO +DIT -SSBS BTYPE=--)
[  313.546134 ] [ T122625 ] pc : btrfs_trim_fs+0x34c/0xa00 [btrfs]
[  313.548443 ] [ T122625 ] lr : btrfs_trim_fs+0x1f0/0xa00 [btrfs]
[  313.549248 ] [ T122625 ] sp : ffff80008addbb70
[  313.549760 ] [ T122625 ] x29: ffff80008addbbf0 x28: 
0000000000000000 x27: ffff80008addbc50
[  313.550826 ] [ T122625 ] x26: 000000002e300000 x25: 
0000000200000000 x24: ffff0000c0c35490
[  313.551819 ] [ T122625 ] x23: ffff0000c0c35400 x22: 
ffff0000c0d7bc00 x21: ffff0000c0d7bc00
[  313.553453 ] [ T122625 ] x20: 0000000000000000 x19: 
000000004fdb8000 x18: 0000000000000000
[  313.555099 ] [ T122625 ] x17: fffffdffc3a6c980 x16: 
ffffc03bf9d70f68 x15: fffffdffbf000000
[  313.557353 ] [ T122625 ] x14: ffff0000e75200d0 x13: 
0000000000000001 x12: 0000000000000000
[  313.559262 ] [ T122625 ] x11: 00000000000000c0 x10: 
16d71b527421a8a2 x9 : ffffc03bf9d70f88
[  313.560500 ] [ T122625 ] x8 : ffff0000e7521268 x7 : 
0000000000000000 x6 : 0000000000000000
[  313.561496 ] [ T122625 ] x5 : 842c1a086c93060f x4 : 
ffff0000c9dafeb0 x3 : ffff0000c0d7bc00
[  313.563063 ] [ T122625 ] x2 : 0000000000000001 x1 : 
0000000000000086 x0 : 0000000000000000
[  313.564057 ] [ T122625 ] Call trace:
[  313.564465 ] [ T122625 ]  btrfs_trim_fs+0x34c/0xa00 [btrfs 
f02c1d570ceea621c69d302ba75dd61868083840] (P)
[  313.565720 ] [ T122625 ]  btrfs_ioctl_fitrim+0xe8/0x178 [btrfs 
f02c1d570ceea621c69d302ba75dd61868083840]
[  313.567140 ] [ T122625 ]  btrfs_ioctl+0xdd4/0x2bd8 [btrfs 
f02c1d570ceea621c69d302ba75dd61868083840]
[  313.568326 ] [ T122625 ]  __arm64_sys_ioctl+0xac/0x108
[  313.568936 ] [ T122625 ]  invoke_syscall.constprop.0+0x5c/0xd0
[  313.569625 ] [ T122625 ]  el0_svc_common.constprop.0+0x40/0xf0
[  313.570320 ] [ T122625 ]  do_el0_svc+0x24/0x40
[  313.570864 ] [ T122625 ]  el0_svc+0x40/0x1d0
[  313.571964 ] [ T122625 ]  el0t_64_sync_handler+0xa0/0xe8
[  313.572614 ] [ T122625 ]  el0t_64_sync+0x1b0/0x1b8
[  313.573184 ] [ T122625 ] Code: 17ffff83 f94017e0 f9002be0 
f9402ea0 (f9400c00)
[  313.574045 ] [ T122625 ] ---[ end trace 0000000000000000  ]---
[  313.617087 ] [ T122648 ] BTRFS info (device sdb): last unmount 
of filesystem 41ba7202-04d0-466e-9130-a89f855aff0c

# cat local.config:

export FSTYPE=btrfs
export TEST_DEV="/dev/sdb"
export TEST_DIR="/mnt//test"
export SCRATCH_DEV_POOL="/dev/sdc /dev/sdd /dev/sde /dev/sdf 
/dev/sdg"
export SCRATCH_MNT="/mnt//scratch"
export KEEP_DMESG=yes


# rpm -qa  btrfsprogs
btrfsprogs-6.19-1.4.aarch64

# cat /etc/os-release
NAME="openSUSE Tumbleweed"
# VERSION="20260527"
ID="opensuse-tumbleweed"
ID_LIKE="opensuse suse"
VERSION_ID="20260527"

# uname -r
7.0.10-2-default
