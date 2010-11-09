From: Eldon Koyle <eldon.koyle@usu.edu>
Subject: btrfs_block_rsv_check warning in syslog
Date: Tue, 9 Nov 2010 16:52:58 -0700
Message-ID: <20101109235258.GS4933@esk.cs.usu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I am not on the list, so please include me in any replies.

We seem to have found a bug, but I'm not sure if it is a known issue.
We made this FS with an older version of btrfs-utils.

We are running on a debian sid system.  The FS was created with
btrfs-tools version 0.19+20100601-3 on 2.6.32.  We started having major
issues and upgraded to btrfs-tools 0.19+20100909-2 from experimental and
built a 2.6.26 kernel.

For disk, we have an ATAoE array, an iscsi array, and some random local
disk.  I just thought I'd forward the trace along before we blow it away
and start over tomorrow.  Let me know very soon if you would like any
more debug information.

Trying to delete files, we periodically get no space available messages
which makes me think we are out of space for metadata.  I find it odd
that it claims we should have 1T free on device 3.

vault:/usr/src/linux-2.6.36# btrfs filesystem show
failed to read /dev/hda
failed to read /dev/fd0
Label: none  uuid: 31583898-f420-4d32-ae29-161ce4d2cfa6
        Total devices 4 FS bytes used 6.72TB
        devid    3 size 4.00TB used 2.97TB path /dev/etherd/e0.0
        devid    1 size 112.40GB used 112.39GB path /dev/sda3
        devid    2 size 838.12GB used 838.02GB path /dev/sdb1
        devid    4 size 2.96TB used 2.96TB path /dev/sdc1

Btrfs Btrfs v0.19

vault:/usr/src/linux-2.6.36# btrfs filesystem df /srv
Data: total=6.83TB, used=6.71TB
Metadata: total=11.76GB, used=10.83GB
System: total=20.00MB, used=460.00KB

vault:/usr/src/linux-2.6.36# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1              15G   13G  1.1G  93% /
tmpfs                 3.0G     0  3.0G   0% /lib/init/rw
udev                  3.0G  172K  3.0G   1% /dev
tmpfs                 3.0G     0  3.0G   0% /dev/shm
/dev/sdc1             7.9T  6.8T  1.2T  86% /srv

Our logs are filled with messages like:

[27252.022255] ------------[ cut here ]------------
[27252.022267] WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x12e/0x159 [btrfs]()
[27252.022270] Hardware name: PowerEdge 2850
[27252.022271] Modules linked in: ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc aoe loop shpchp tpm_tis snd_pcm snd_timer pci_hotplug tpm snd soundcore snd_page_alloc rng_core tpm_bios dcdbas e752x_edac edac_core psmouse video output joydev evdev pcspkr serio_raw processor button ext3 jbd mbcache btrfs zlib_deflate crc32c libcrc32c sg sd_mod crc_t10dif usbhid hid ide_cd_mod cdrom ata_generic ata_piix libata megaraid_mbox qla2xxx scsi_transport_fc scsi_tgt thermal uhci_hcd piix ehci_hcd floppy usbcore scsi_mod e1000 ide_core megaraid_mm nls_base thermal_sys [last unloaded: scsi_wait_scan]
[27252.022338] Pid: 5381, comm: rsync Tainted: G        W   2.6.36-p4 #1
[27252.022341] Call Trace:
[27252.022345]  [<ffffffff8103e490>] ? warn_slowpath_common+0x67/0x8e
[27252.022356]  [<ffffffffa0174461>] ? btrfs_block_rsv_check+0x12e/0x159 [btrfs]
[27252.022370]  [<ffffffffa0186b1d>] ? __btrfs_end_transaction+0x19f/0x210 [btrfs]
[27252.022384]  [<ffffffffa018afad>] ? btrfs_dirty_inode+0x71/0xff [btrfs]
[27252.022388]  [<ffffffff81110bed>] ? __mark_inode_dirty+0x27/0x1b6
[27252.022392]  [<ffffffff81105f6e>] ? touch_atime+0xf5/0x12f
[27252.022396]  [<ffffffff81100d20>] ? filldir+0x0/0xbb
[27252.022399]  [<ffffffff81100e83>] ? vfs_readdir+0xa8/0xae
[27252.022403]  [<ffffffff81100fc4>] ? sys_getdents+0x76/0xc6
[27252.022407]  [<ffffffff81002c6b>] ? system_call_fastpath+0x16/0x1b
[27252.022409] ---[ end trace 460ffda2b493569c ]---
[27252.022412] block_rsv size 3879731200 reserved 984068096 freed 32768 0
[27252.132062] ------------[ cut here ]------------
[27252.132098] WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x12e/0x159 [btrfs]()
[27252.132103] Hardware name: PowerEdge 2850
[27252.132106] Modules linked in: ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc aoe loop shpchp tpm_tis snd_pcm snd_timer pci_hotplug tpm snd soundcore snd_page_alloc rng_core tpm_bios dcdbas e752x_edac edac_core psmouse video output joydev evdev pcspkr serio_raw processor button ext3 jbd mbcache btrfs zlib_deflate crc32c libcrc32c sg sd_mod crc_t10dif usbhid hid ide_cd_mod cdrom ata_generic ata_piix libata megaraid_mbox qla2xxx scsi_transport_fc scsi_tgt thermal uhci_hcd piix ehci_hcd floppy usbcore scsi_mod e1000 ide_core megaraid_mm nls_base thermal_sys [last unloaded: scsi_wait_scan]
[27252.132195] Pid: 5381, comm: rsync Tainted: G        W   2.6.36-p4 #1
[27252.132200] Call Trace:
[27252.132212]  [<ffffffff8103e490>] ? warn_slowpath_common+0x67/0x8e
[27252.132230]  [<ffffffffa0174461>] ? btrfs_block_rsv_check+0x12e/0x159 [btrfs]
[27252.132250]  [<ffffffffa0186b1d>] ? __btrfs_end_transaction+0x19f/0x210 [btrfs]
[27252.132270]  [<ffffffffa0186dae>] ? start_transaction+0x1ff/0x208 [btrfs]
[27252.132293]  [<ffffffffa018afba>] ? btrfs_dirty_inode+0x7e/0xff [btrfs]
[27252.132305]  [<ffffffff81110bed>] ? __mark_inode_dirty+0x27/0x1b6
[27252.132310]  [<ffffffff81105f6e>] ? touch_atime+0xf5/0x12f
[27252.132315]  [<ffffffff81100d20>] ? filldir+0x0/0xbb
[27252.132318]  [<ffffffff81100e83>] ? vfs_readdir+0xa8/0xae
[27252.132322]  [<ffffffff81100fc4>] ? sys_getdents+0x76/0xc6
[27252.132327]  [<ffffffff81002c6b>] ? system_call_fastpath+0x16/0x1b
[27252.132330] ---[ end trace 460ffda2b493569d ]---
[27252.132334] block_rsv size 3879731200 reserved 984068096 freed 0 32768



-- 
Eldon Koyle
System Administration Operations
Information Technology
Utah State University
-- 
BOFH excuse #449:
greenpeace free'd the mallocs
