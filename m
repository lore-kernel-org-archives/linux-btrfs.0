Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62502 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaBGAFM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 19:05:12 -0500
Received: by mail-pd0-f178.google.com with SMTP id y13so2388006pdi.37
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 16:05:11 -0800 (PST)
Message-ID: <52F42331.6040008@gmail.com>
Date: Fri, 07 Feb 2014 11:05:05 +1100
From: Thermionix <thermionix@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Anand Jain <Anand.Jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: device delete missing panic
References: <52F30422.8@gmail.com> <52F3112C.3070309@oracle.com> <52F31726.7000200@gmail.com> <0C544B5C-B262-4FEB-8221-4351490E533D@colorremedies.com>
In-Reply-To: <0C544B5C-B262-4FEB-8221-4351490E533D@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

~ # uname -r
3.13.1-12.gfc9498b-pae

~ # btrfs --version
Btrfs v3.12+20131125

~ # mount -o degraded,recovery /pool                                                                                                
Killed

Feb 07 09:53:44 store03 kernel: btrfs: device label pool devid 4 transid 55056 /dev/sde
Feb 07 09:53:44 store03 kernel: btrfs: allowing degraded mounts
Feb 07 09:53:44 store03 kernel: btrfs: enabling auto recovery
Feb 07 09:53:44 store03 kernel: btrfs: disk space caching is enabled
Feb 07 09:53:44 store03 kernel: BTRFS critical (device sde): unable to find logical 1563803254784 len 4096
Feb 07 09:53:44 store03 kernel: BTRFS critical (device sde): unable to find logical 1563803254784 len 4096
Feb 07 09:53:44 store03 kernel: BTRFS critical (device sde): unable to find logical 1563803254784 len 4096
Feb 07 09:53:44 store03 kernel: btrfs: failed to read tree root on sde
Feb 07 09:53:44 store03 kernel: BTRFS critical (device sde): unable to find logical 1563803254784 len 4096
Feb 07 09:53:44 store03 kernel: BTRFS critical (device sde): unable to find logical 1563803254784 len 4096
Feb 07 09:53:44 store03 kernel: BTRFS critical (device sde): unable to find logical 1563803254784 len 4096
Feb 07 09:53:44 store03 kernel: btrfs: failed to read tree root on sde
Feb 07 09:53:44 store03 kernel: btrfs: bdev (null) errs: wr 353, rd 1, flush 17, corrupt 0, gen 0
Feb 07 09:53:44 store03 kernel: BUG: unable to handle kernel NULL pointer dereference at 00000050
Feb 07 09:53:44 store03 kernel: IP: [<f834b7b7>] btrfs_sysfs_add_one+0x1a7/0x280 [btrfs]
Feb 07 09:53:44 store03 kernel: *pdpt = 0000000034fce001 *pde = 0000000000000000 
Feb 07 09:53:44 store03 kernel: Oops: 0000 [#1] SMP 
Feb 07 09:53:44 store03 kernel: Modules linked in: bonding hwmon_vid iTCO_wdt joydev iTCO_vendor_support hid_generic serio_raw lpc_ich pcspk
r coretemp mfd_core i2c_i801 ata_generic e1000e usbhid ptp pps_core mvsas libsas scsi_transport_sas shpchp sg dm_mod autofs4 btrfs raid6_pq 
xor libcrc32c ata_piix uhci_hcd ehci_pci ehci_hcd usbcore usb_common fan thermal processor i915 drm_kms_helper drm i2c_algo_bit button video
 thermal_sys scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh_alua scsi_dh
Feb 07 09:53:44 store03 kernel: CPU: 0 PID: 1893 Comm: mount Not tainted 3.13.1-12.gfc9498b-pae #1
Feb 07 09:53:44 store03 kernel: Hardware name: PhoenixAward 945GM/945GM, BIOS 6.00 PG 08/13/2008
Feb 07 09:53:44 store03 kernel: task: f4fa80d0 ti: f1614000 task.ti: f1614000
Feb 07 09:53:44 store03 kernel: EIP: 0060:[<f834b7b7>] EFLAGS: 00010212 CPU: 0
Feb 07 09:53:44 store03 kernel: EIP is at btrfs_sysfs_add_one+0x1a7/0x280 [btrfs]
Feb 07 09:53:44 store03 kernel: EAX: f4f8eec0 EBX: f6c0e800 ECX: f14063c0 EDX: 00000000
Feb 07 09:53:44 store03 kernel: ESI: f3454374 EDI: 00000000 EBP: f154e000 ESP: f1615d38
Feb 07 09:53:44 store03 kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Feb 07 09:53:44 store03 kernel: CR0: 8005003b CR2: 00000050 CR3: 31470000 CR4: 000007f0
Feb 07 09:53:44 store03 kernel: Stack:
Feb 07 09:53:44 store03 kernel:  f154ea00 f83d10a0 00000000 f83aee16 f154e000 00000000 00000000 f154e000
Feb 07 09:53:44 store03 kernel:  f83d3a60 f154ea00 f83aee1a 00000000 00000000 00000000 f6dbf800 f154e000
Feb 07 09:53:44 store03 kernel:  f4fe3000 f1615e48 f832f099 00001000 0000d70f 00000000 00000003 00000000
Feb 07 09:53:44 store03 kernel: Call Trace:
Feb 07 09:53:44 store03 kernel:  [<f832f099>] open_ctree+0x1409/0x1d80 [btrfs]
Feb 07 09:53:44 store03 kernel:  [<f830675b>] btrfs_mount+0x6ab/0x880 [btrfs]
Feb 07 09:53:44 store03 kernel:  [<c035f1ad>] mount_fs+0x2d/0x170
Feb 07 09:53:44 store03 kernel:  [<c0375af5>] vfs_kern_mount+0x45/0xd0
Feb 07 09:53:44 store03 kernel:  [<c0377a74>] do_mount+0x1f4/0x8e0
Feb 07 09:53:44 store03 kernel:  [<c03783fe>] SyS_mount+0x7e/0xc0
Feb 07 09:53:44 store03 kernel:  [<c070977d>] sysenter_do_call+0x12/0x28
Feb 07 09:53:44 store03 kernel:  [<b76ed424>] 0xb76ed423
Feb 07 09:53:44 store03 kernel: Code: 0c 8d 76 00 89 e8 e8 59 fd ff ff 89 f8 83 c4 38 5b 5e 5f 5d c3 8d b4 26 00 00 00 00 8b 1b 39 de 74 b1 
8b 85 28 0a 00 00 8b 53 50 <8b> 52 50 8b 4a 28 83 c2 28 e8 7b fe 06 c8 85 c0 74 df 89 c7 eb
Feb 07 09:53:44 store03 kernel: EIP: [<f834b7b7>] btrfs_sysfs_add_one+0x1a7/0x280 [btrfs] SS:ESP 0068:f1615d38
Feb 07 09:53:44 store03 kernel: CR2: 0000000000000050
Feb 07 09:53:44 store03 kernel: ---[ end trace 4b34a92ed1b54297 ]---

~ # btrfs-zero-log /dev/sde
warning, device 1 is missing
warning devid 1 not found already
checksum verify failed on 19155989299200 found 42FA71B2 wanted A7E1A39B
checksum verify failed on 19155989299200 found 42FA71B2 wanted A7E1A39B
checksum verify failed on 19155989299200 found 42FA71B2 wanted A7E1A39B
checksum verify failed on 19155989299200 found 42FA71B2 wanted A7E1A39B
Csum didn't match
Couldn't read tree root

~ # mount -o degraded,recovery /pool

Feb 07 10:04:55 store03 kernel: btrfs: device label pool devid 2 transid 55056 /dev/sdc
Feb 07 10:04:55 store03 kernel: btrfs: device label pool devid 4 transid 55056 /dev/sde
Feb 07 10:05:09 store03 kernel: btrfs: device label pool devid 4 transid 55056 /dev/sde
Feb 07 10:06:25 store03 systemd[1]: pool.mount mounting timed out. Stopping.
Feb 07 10:06:34 store03 systemd[1]: Starting Cleanup of Temporary Directories...
Feb 07 10:06:34 store03 systemd[1]: Started Cleanup of Temporary Directories.
Feb 07 10:07:55 store03 systemd[1]: pool.mount mounting timed out. Killing.
Feb 07 10:09:25 store03 systemd[1]: pool.mount mount process still around after SIGKILL. Ignoring.
Feb 07 10:09:25 store03 systemd[1]: Failed to mount /pool.
Feb 07 10:09:25 store03 systemd[1]: Unit pool.mount entered failed state.


On 07/02/14 04:12, Chris Murphy wrote:
> 
> On Feb 5, 2014, at 10:01 PM, Thermionix <thermionix@gmail.com> wrote:
> 
>>  CPU: 0 PID: 3005 Comm: btrfs-worker-1 Tainted: G        W    3.11.6-4-pae #1
> 
> 
> Something happened even before the kernel messages you posted, as this kernel is already tainted. I would honestly try to get a prebuilt 3.14-rc1 kernel from your distro's dev branch, or build from mainline. There are a large pile of bug fixes from just 3.13, let alone 3.11.6.
> 
> And also make sure you're at btrfs-progs 3.12. If the kernel alone isn't able to work around it with a normal mount, or -o recovery, or -o recovery,degraded, then your next step is probably btrfs-zero-log based on the btrfs: failed to read tree root on sdg.
> 
> Let's see if others concur.
> 
> 
> Chris Murphy
> 
