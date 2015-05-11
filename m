Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34195 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbbEKEFV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 00:05:21 -0400
Received: by qkgx75 with SMTP id x75so80030588qkg.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2015 21:05:21 -0700 (PDT)
Message-ID: <55502A8A.4000707@gmail.com>
Date: Mon, 11 May 2015 00:05:30 -0400
From: Remi Rampin <remirampin@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: remirampin@gmail.com
Subject: Aborted transaction on invalid snapshot -i
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

I'm checking out the accounting/quota facilities of Btrfs, and stumbled 
on this crash. While I am technically misspelling arguments to the btrfs 
tool, it seems that getting an unknown error during the transaction and 
emergency RO remount is a bit much.

Basically, "btrfs subvolume snapshot -i 0/100 /mnt/root /mnt/snap" is 
causing the error (I meant to type 1/100).

Attached is a simple session reproducing the crash (every time on my 
machine), with output from btrfs commands and dmesg.

Regards


----- session -----

remram@missy:~$ uname -a
Linux missy 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt9-3~deb8u1 
(2015-04-24) x86_64 GNU/Linux
remram@missy:~$ /sbin/btrfs --version
Btrfs v3.17
remram@missy:~$ touch btdisk
remram@missy:~$ chattr +C btdisk
remram@missy:~$ truncate -s 200M btdisk
remram@missy:~$ sudo losetup /dev/loop0 btdisk
remram@missy:~$ sudo mkfs.btrfs /dev/loop0
SMALL VOLUME: forcing mixed metadata/data groups
Btrfs v3.17
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (200.00MiB) ...
Turning ON incompat feature 'mixed-bg': mixed data and metadata block groups
Turning ON incompat feature 'extref': increased hardlink limit per file 
to 65536
Created a data/metadata chunk of size 8388608
fs created label (null) on /dev/loop0
         nodesize 4096 leafsize 4096 sectorsize 4096 size 200.00MiB
remram@missy:~$ sudo mount /dev/loop0 /mnt
remram@missy:~$ sudo btrfs quota enable /mnt
remram@missy:~$ sudo btrfs subvolume create /mnt/root
Create subvolume '/mnt/root'
remram@missy:~$ sudo btrfs qgroup show /mnt
qgroupid rfer excl
-------- ---- ----
0/5      4096 4096
0/256    4096 4096
remram@missy:~$ sudo btrfs subvolume snapshot -i 0/100 /mnt/root /mnt/snap
Create a snapshot of '/mnt/root' in '/mnt/snap'
ERROR: cannot snapshot '/mnt/root' - Invalid argument
remram@missy:~$ mount
...
/dev/loop0 on /mnt type btrfs (ro,relatime,space_cache)
remram@missy:~$ dmesg
...
[33474.410205] ------------[ cut here ]------------
[33474.410244] WARNING: CPU: 4 PID: 18510 at 
/build/linux-RGM_Ed/linux-3.16.7-ckt9/fs/btrfs/super.c:259 
__btrfs_abort_transaction+0x4b/0x110 [btrfs]()
[33474.410247] BTRFS: Transaction aborted (error -22)
[33474.410248] Modules linked in: loop ctr ccm bnep pci_stub vboxpci(O) 
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nfsd auth_rpcgss oid_registry 
nfs_acl nfs lockd fscache sunrpc ecb btusb bluetooth 6lowpan_iphc crc16 
x86_pkg_temp_thermal intel_powerclamp arc4 intel_rapl coretemp joydev 
iwldvm kvm_intel kvm iTCO_wdt iTCO_vendor_support crc32_pclmul mac80211 
msi_wmi ghash_clmulni_intel sparse_keymap aesni_intel aes_x86_64 lrw 
gf128mul glue_helper ablk_helper cryptd rtsx_pci_ms processor memstick 
lpc_ich snd_hda_codec_hdmi ac battery snd_hda_codec_realtek pcspkr 
iwlwifi psmouse serio_raw cfg80211 rfkill mei_me mei i2c_i801 shpchp 
snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec 
evdev snd_hwdep snd_pcm snd_timer snd soundcore fuse parport_pc ppdev lp 
parport autofs4 btrfs xor raid6_pq hid_generic
[33474.410308]  usbhid hid sg sd_mod crc_t10dif sr_mod crct10dif_generic 
cdrom rtsx_pci_sdmmc ahci libahci crct10dif_pclmul nouveau 
crct10dif_common crc32c_intel libata mxm_wmi i915 ttm i2c_algo_bit 
ehci_pci rtsx_pci sdhci_pci drm_kms_helper scsi_mod sdhci ehci_hcd 
xhci_hcd mmc_core drm alx mfd_core mdio usbcore i2c_core usb_common fan 
thermal video wmi thermal_sys button
[33474.410347] CPU: 4 PID: 18510 Comm: btrfs Tainted: G        W  O 
3.16.0-4-amd64 #1 Debian 3.16.7-ckt9-3~deb8u1
[33474.410349] Hardware name: Micro-Star International Co., Ltd. GE60 
0NC/GE60 0ND/MS-16GA, BIOS E16GAIMS.10E 07/11/2012
[33474.410352]  0000000000000009 ffffffff8150ac96 ffff88012c6fba88 
ffffffff81067747
[33474.410356]  00000000ffffffea ffff88012c6fbad8 ffff880122dd0f38 
ffffffffa057b070
[33474.410360]  000000000000051b ffffffff810677ac ffffffffa057eaf8 
ffffffff00000020
[33474.410364] Call Trace:
[33474.410376]  [<ffffffff8150ac96>] ? dump_stack+0x41/0x51
[33474.410383]  [<ffffffff81067747>] ? warn_slowpath_common+0x77/0x90
[33474.410391]  [<ffffffff810677ac>] ? warn_slowpath_fmt+0x4c/0x50
[33474.410406]  [<ffffffffa04d700b>] ? 
__btrfs_abort_transaction+0x4b/0x110 [btrfs]
[33474.410426]  [<ffffffffa0502c88>] ? 
create_pending_snapshot+0x578/0x960 [btrfs]
[33474.410443]  [<ffffffffa050224a>] ? 
btrfs_wait_pending_ordered+0x2a/0x100 [btrfs]
[33474.410449]  [<ffffffff8150f5fe>] ? mutex_lock+0xe/0x2a
[33474.410465]  [<ffffffffa05030f9>] ? 
create_pending_snapshots+0x89/0xb0 [btrfs]
[33474.410482]  [<ffffffffa0504404>] ? 
btrfs_commit_transaction+0x394/0xa10 [btrfs]
[33474.410499]  [<ffffffffa0504b10>] ? start_transaction+0x90/0x570 [btrfs]
[33474.410520]  [<ffffffffa0536fea>] ? 
btrfs_mksubvol.isra.29+0x54a/0x5a0 [btrfs]
[33474.410526]  [<ffffffff810a7930>] ? prepare_to_wait_event+0xf0/0xf0
[33474.410544]  [<ffffffffa05371d1>] ? 
btrfs_ioctl_snap_create_transid+0x191/0x1a0 [btrfs]
[33474.410561]  [<ffffffffa053733e>] ? 
btrfs_ioctl_snap_create_v2+0xee/0x140 [btrfs]
[33474.410578]  [<ffffffffa05393cf>] ? btrfs_ioctl+0xcaf/0x2b10 [btrfs]
[33474.410584]  [<ffffffff8136ebec>] ? pty_write+0x4c/0x50
[33474.410588]  [<ffffffff810a74a2>] ? remove_wait_queue+0x12/0x50
[33474.410592]  [<ffffffff81367c1a>] ? n_tty_write+0x37a/0x4e0
[33474.410598]  [<ffffffff8109cda7>] ? put_prev_entity+0x57/0x350
[33474.410602]  [<ffffffff8109bc16>] ? set_next_entity+0x56/0x70
[33474.410608]  [<ffffffff811ba2ff>] ? do_vfs_ioctl+0x2cf/0x4b0
[33474.410611]  [<ffffffff8150d1b1>] ? __schedule+0x2b1/0x710
[33474.410615]  [<ffffffff811ba561>] ? SyS_ioctl+0x81/0xa0
[33474.410620]  [<ffffffff81510e4d>] ? 
system_call_fast_compare_end+0x10/0x15
[33474.410623] ---[ end trace a44935b638f9b25c ]---
[33474.410627] BTRFS: error (device loop0) in 
create_pending_snapshot:1307: errno=-22 unknown
[33474.410631] BTRFS info (device loop0): forced readonly
[33474.410635] BTRFS warning (device loop0): Skipping commit of aborted 
transaction.
[33474.410637] BTRFS: error (device loop0) in cleanup_transaction:1585: 
errno=-22 unknown
[33474.410640] BTRFS info (device loop0): delayed_refs has NO entry
