Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33056 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015AbaEKLDI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 07:03:08 -0400
Date: Sun, 11 May 2014 18:59:40 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: bug oops using device delete with seed device
Message-ID: <20140511105938.GA24908@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <B772877F-7296-4F39-83D7-9C01A1C53BC7@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <B772877F-7296-4F39-83D7-9C01A1C53BC7@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Chris,

Thanks for the report, I've figured it out and will send a fix.

This bug is caused by the part of cleanup code of
commit cb517eabba4f109810dba2e5f37b0dcf22103065(Btrfs: cleanup the similar code of the fs root read)

thanks,
-liubo


On Sat, May 10, 2014 at 08:08:28PM -0600, Chris Murphy wrote:
> Summary is, existing btrfs fs is made into a seed device, mounting it mounts read-only, add device to it, unmount, then mount again so it mounts rw, then delete the seed device. I expect that everything on the seed device is moved to the newly added device, while the seed device is unchanged (to later unmake it a seed device). Idea is to make a fairly exactly copy of an existing device including all subvolumes.
> 
> What actually happens is an oops upon device delete.
> 
> Setup:
> kernel 3.15.0-0.rc5.git0.1.fc21.x86_64
> btrfs-progs 3.14
> /dev/sdb2 = existing btrfs fs
> /dev/sdc3 = unformatted partition
> 
> Steps:
> 
> # btrfstune -S1 /dev/sdb2
> # mount /dev/sdb2 /mnt
> mount: /dev/sdb2 is write-protected, mounting read-only
> # btrfs device add /dev/sdc3 /mnt
> Performing full device TRIM (75.90GiB) ...
> # btrfs fi show
> Label: 'rawhide'  uuid: d372e5d1-386f-460c-b036-611469e0155e
> 	Total devices 1 FS bytes used 7.55GiB
> 	devid    1 size 79.31GiB used 11.04GiB path /dev/sda3
> 
> btrfs: utils.c:1769: get_fs_info: Assertion `!(ndevs >= fi_args->num_devices)' failed.  ## previously reported subject "bug adding device to seed device, btrfs fi show fails"
> 
> # umount /mnt
> # mount /dev/sdc3 /mnt
> # btrfs device delete /dev/sdb2 /mnt
> 
> [  778.992693] BTRFS info (device sdb2): relocating block group 20464009216 flags 2
> ##mount rw occurs here
> [ 1200.019460] BTRFS info (device sdc3): disk space caching is enabled
> [ 1200.036656] BTRFS: checking UUID tree
> [ 1200.037194] SELinux: initialized (dev sdc3, type btrfs), uses xattr
> [ 1220.761243] BUG: unable to handle kernel NULL pointer dereference at 00000000000001e8
> [ 1220.761433] IP: [<ffffffffa00d3883>] btrfs_shrink_device+0x33/0x420 [btrfs]
> [ 1220.761614] PGD 7fe9e067 PUD 80379067 PMD 0 
> [ 1220.761758] Oops: 0000 [#1] SMP 
> [ 1220.761979] Modules linked in: fuse msdos xfs libcrc32c xt_CHECKSUM ipt_MASQUERADE tun ip6t_rpfilter ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw vfat fat ppdev sunrpc serio_raw microcode parport_pc parport virtio_net i2c_piix4 i2c_core btrfs xor raid6_pq virtio_pci virtio virtio_ring ata_generic pata_acpi
> [ 1220.761979] CPU: 0 PID: 3469 Comm: btrfs Not tainted 3.15.0-0.rc5.git0.1.fc21.x86_64 #1
> [ 1220.761979] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [ 1220.761979] task: ffff88007ff413a0 ti: ffff88009e376000 task.ti: ffff88009e376000
> [ 1220.761979] RIP: 0010:[<ffffffffa00d3883>]  [<ffffffffa00d3883>] btrfs_shrink_device+0x33/0x420 [btrfs]
> [ 1220.761979] RSP: 0018:ffff88009e377c58  EFLAGS: 00010246
> [ 1220.761979] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [ 1220.761979] RDX: 000000000000000f RSI: 0000000000000000 RDI: ffff88003e04fc00
> [ 1220.761979] RBP: ffff88009e377ce8 R08: 0000000000000000 R09: 00000000000000c1
> [ 1220.761979] R10: ffff88003e04fc00 R11: 0000000000000020 R12: ffff88009453ebc8
> [ 1220.761979] R13: 0000000000000001 R14: 0000000000000000 R15: ffff88003e04fc00
> [ 1220.761979] FS:  00007f18f112e880(0000) GS:ffff88009d400000(0000) knlGS:0000000000000000
> [ 1220.761979] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1220.761979] CR2: 00000000000001e8 CR3: 000000007fd6b000 CR4: 00000000000006f0
> [ 1220.761979] Stack:
> [ 1220.761979]  00000000c3c73881 ffffffff812231fd ffff88009453ebc8 0000000000000082
> [ 1220.761979]  0000000000000000 ffff88009e377d18 ffff88009e377cb8 ffffffffa00ce482
> [ 1220.761979]  ffff88009f3fa900 ffff8800853be020 ffff8800853be10b 0000000000000001
> [ 1220.761979] Call Trace:
> [ 1220.761979]  [<ffffffff812231fd>] ? _submit_bh+0x15d/0x230
> [ 1220.761979]  [<ffffffffa00ce482>] ? __find_device+0x52/0x80 [btrfs]
> [ 1220.761979]  [<ffffffffa00d6784>] btrfs_rm_device+0x2e4/0x880 [btrfs]
> [ 1220.761979]  [<ffffffffa00e0db5>] btrfs_ioctl+0x1f95/0x2880 [btrfs]
> [ 1220.761979]  [<ffffffff811a57cf>] ? handle_mm_fault+0x6bf/0x10f0
> [ 1220.761979]  [<ffffffff811fa692>] ? final_putname+0x22/0x50
> [ 1220.761979]  [<ffffffff811fa949>] ? putname+0x29/0x40
> [ 1220.761979]  [<ffffffff81200f32>] ? user_path_at_empty+0x72/0xd0
> [ 1220.761979]  [<ffffffff8170c2fc>] ? __do_page_fault+0x26c/0x580
> [ 1220.761979]  [<ffffffff811f4427>] ? cp_new_stat+0x157/0x190
> [ 1220.761979]  [<ffffffff81203670>] do_vfs_ioctl+0x2d0/0x4b0
> [ 1220.761979]  [<ffffffff812038d1>] SyS_ioctl+0x81/0xa0
> [ 1220.761979]  [<ffffffff817119e9>] system_call_fastpath+0x16/0x1b
> [ 1220.761979] Code: e5 41 57 41 56 41 55 41 54 49 89 ff 53 48 89 f3 48 83 ec 68 4c 8b 77 28 48 89 75 90 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 <49> 8b 86 e8 01 00 00 48 8b 80 c0 02 00 00 48 89 85 78 ff ff ff 
> [ 1220.761979] RIP  [<ffffffffa00d3883>] btrfs_shrink_device+0x33/0x420 [btrfs]
> [ 1220.761979]  RSP <ffff88009e377c58>
> [ 1220.761979] CR2: 00000000000001e8
> [ 1220.803856] ---[ end trace 8df409055cb58c83 ]---
> 
> 
> Chris Murphy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
