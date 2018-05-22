Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43263 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbeEVUFo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 16:05:44 -0400
Received: by mail-wr0-f195.google.com with SMTP id r13-v6so10008855wrj.10
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 13:05:43 -0700 (PDT)
Received: from [10.1.1.2] (89-69-130-4.dynamic.chello.pl. [89.69.130.4])
        by smtp.gmail.com with ESMTPSA id h20-v6sm3151367ljj.85.2018.05.22.13.05.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 May 2018 13:05:41 -0700 (PDT)
Message-ID: <5B047817.3040106@gmail.com>
Date: Tue, 22 May 2018 22:05:43 +0200
From: ein <ein.net@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: csum failed root raveled during balance
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello devs,

I tested BTRFS in production for about a month:

21:08:17 up 34 days,  2:21,  3 users,  load average: 0.06, 0.02, 0.00

Without power blackout, hardware failure, SSD's SMART is flawless etc.
The tests ended with:

root@node0:~# dmesg | grep BTRFS | grep warn
185:980:[2927472.393557] BTRFS warning (device dm-0): csum failed root
-9 ino 312 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
186:981:[2927472.394158] BTRFS warning (device dm-0): csum failed root
-9 ino 312 off 608284672 csum 0x7da1b152 expected csum 0x3163a9b7 mirror 1
191:986:[2928224.169814] BTRFS warning (device dm-0): csum failed root
-9 ino 314 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
192:987:[2928224.171433] BTRFS warning (device dm-0): csum failed root
-9 ino 314 off 608284672 csum 0x7da1b152 expected csum 0x3163a9b7 mirror 1
206:1001:[2928298.039516] BTRFS warning (device dm-0): csum failed root
-9 ino 319 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
207:1002:[2928298.043103] BTRFS warning (device dm-0): csum failed root
-9 ino 319 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
208:1004:[2932213.513424] BTRFS warning (device dm-0): csum failed root
5 ino 219962 off 4564959232 csum 0xc616afb4 expected csum 0x5425e489
mirror 1
209:1005:[2932235.666368] BTRFS warning (device dm-0): csum failed root
5 ino 219962 off 16989835264 csum 0xd63ed5da expected csum 0x7429caa1
mirror 1
210:1072:[2936767.229277] BTRFS warning (device dm-0): csum failed root
5 ino 219915 off 82318458880 csum 0x83614341 expected csum 0x0b8706f8
mirror 1
211:1073:[2936767.276229] BTRFS warning (device dm-0): csum failed root
5 ino 219915 off 82318458880 csum 0x83614341 expected csum 0x0b8706f8
mirror 1

Above has been revealed during below command and quite high IO usage by
few VMs (Linux on top Ext4 with firebird database, lots of random
read/writes, two others with Windows 2016 and Windows Update in the
background):

btrfs balance start -dusage=85 ./

Surprisingly without error counter increasing (how this is even possible?!):

root@node0:/var/lib/libvirt/images# backup_dir="/var/lib/libvirt"; btrfs
fi df $backup_dir; btrfs filesystem usage $backup_dir; btrfs dev stats
$backup_dir
Data, single: total=203.00GiB, used=188.28GiB
System, single: total=32.00MiB, used=48.00KiB
Metadata, single: total=3.00GiB, used=856.27MiB
GlobalReserve, single: total=512.00MiB, used=0.00B
Overall:
    Device size:                 300.00GiB
    Device allocated:            206.03GiB
    Device unallocated:           93.97GiB
    Device missing:                  0.00B
    Used:                        189.12GiB
    Free (estimated):            108.68GiB      (min: 108.68GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:203.00GiB, Used:188.28GiB
   /dev/mapper/raid10-images     203.00GiB

Metadata,single: Size:3.00GiB, Used:856.27MiB
   /dev/mapper/raid10-images       3.00GiB

System,single: Size:32.00MiB, Used:48.00KiB
   /dev/mapper/raid10-images      32.00MiB

Unallocated:
   /dev/mapper/raid10-images      93.97GiB
[/dev/mapper/raid10-images].write_io_errs    0
[/dev/mapper/raid10-images].read_io_errs     0
[/dev/mapper/raid10-images].flush_io_errs    0
[/dev/mapper/raid10-images].corruption_errs  0

Few words about the setup Hardware layout:

/dev/sda Model=Samsung SSD 850 PRO 256GB, FwRev=EXM02B6Q,
SerialNo=S251NX0H822367V
/dev/sdb Model=Samsung SSD 850 PRO 256GB, FwRev=EXM02B6Q,
SerialNo=S251NX0H822370A
/dev/sdc Model=INTEL SSDSC2BP240G4, FwRev=L2010420,
SerialNo=BTJR6141002D240AGN
/dev/sdd Model=INTEL SSDSC2BP240G4, FwRev=L2010420,
SerialNo=BTJR6063000F240AGN

Linux Software RAID layout (mdraid):

md1 : active raid10 sdc1[2] sdb2[1] sdd1[3] sda2[0]
      468596736 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 0/4 pages [0KB], 65536KB chunk

md0 : active raid1 sda1[0] sdb1[1]
      15616000 blocks super 1.2 [2/2] [UU]

Logical layout:

NAME                MAJ:MIN RM   SIZE RO TYPE   MOUNTPOINT
sda                   8:0    0 238.5G  0 disk  
├─sda1                8:1    0  14.9G  0 part  
│ └─md0               9:0    0  14.9G  0 raid1 
│   └─raid1-rootfs  253:2    0  14.9G  0 lvm    /
└─sda2                8:2    0 223.6G  0 part  
  └─md1               9:1    0 446.9G  0 raid10
    ├─raid10-images 253:0    0   300G  0 lvm    /var/lib/libvirt
    └─raid10-swapfs 253:1    0     4G  0 lvm   
sdb                   8:16   0 238.5G  0 disk  
├─sdb1                8:17   0  14.9G  0 part  
│ └─md0               9:0    0  14.9G  0 raid1 
│   └─raid1-rootfs  253:2    0  14.9G  0 lvm    /
└─sdb2                8:18   0 223.6G  0 part  
  └─md1               9:1    0 446.9G  0 raid10
    ├─raid10-images 253:0    0   300G  0 lvm    /var/lib/libvirt
    └─raid10-swapfs 253:1    0     4G  0 lvm   
sdc                   8:32   0 223.6G  0 disk  
└─sdc1                8:33   0 223.6G  0 part  
  └─md1               9:1    0 446.9G  0 raid10
    ├─raid10-images 253:0    0   300G  0 lvm    /var/lib/libvirt
    └─raid10-swapfs 253:1    0     4G  0 lvm   
sdd                   8:48   0 223.6G  0 disk  
└─sdd1                8:49   0 223.6G  0 part  
  └─md1               9:1    0 446.9G  0 raid10
    ├─raid10-images 253:0    0   300G  0 lvm    /var/lib/libvirt
    └─raid10-swapfs 253:1    0     4G  0 lvm   

BTRFS is mounted with below options:

/dev/mapper/raid10-images on /var/lib/libvirt type btrfs
(rw,noatime,nodiratime,compress=lzo:3,ssd,space_cache,autodefrag,subvolid=5,subvol=/)

As you can see KVM VMs reside on BTRFS volume on top of LVM partition on
top of software RAID10 on top of 4 SSD drives. Let's put away
performance point of view which is at least 15-20 times worse (number of
possible IO ops in VM and latency) comparing to the same setup but image
residing on top of Ext4 volume. Do you also see so huge performance
impact in your environment? The VMs lay on preallocated RAW images on
top of BTRFS filesystem.

The filesystem was created and used with the following tools:

root@node0:/var/lib/libvirt/images# uname -a
Linux node0 4.15.0-0.bpo.2-amd64 #1 SMP Debian 4.15.11-1~bpo9+1
(2018-04-07) x86_64 GNU/Linux

root@node0:/var/lib/libvirt/images# btrfs version
btrfs-progs v4.13.3

root@node0:/var/lib/libvirt/images# cat /etc/debian_version
9.4

BTRFS progs and kernel was from backports. After I finished restoring
from backup I ran again btrfs balance:

root@node0:/var/lib/libvirt/images# btrfs balance start ./          
WARNING:

        Full balance without filters requested. This operation is very
        intense and takes potentially very long. It is recommended to
        use the balance filters to narrow down the scope of balance.
        Use 'btrfs balance start --full-balance' option to skip this
        warning. The operation will start in 10 seconds.
        Use Ctrl-C to stop it.
10 9 8 7 6 5 4 3 2 1
Starting balance without any filters.
May 22 21:41:28 node0 kernel: [2948094.226177] BTRFS info (device dm-0):
relocating block group 437201666048 flags data
May 22 21:41:28 node0 kernel: [2948094.818796] BTRFS info (device dm-0):
found 1518 extents
May 22 21:41:30 node0 kernel: [2948096.678234] BTRFS info (device dm-0):
found 1518 extents
May 22 21:41:30 node0 kernel: [2948096.736582] BTRFS info (device dm-0):
relocating block group 436127924224 flags data
May 22 21:41:32 node0 kernel: [2948098.811837] BTRFS info (device dm-0):
found 3932 extents
May 22 21:41:34 node0 kernel: [2948100.397485] BTRFS info (device dm-0):
found 3932 extents
May 22 21:41:34 node0 kernel: [2948100.473214] BTRFS info (device dm-0):
relocating block group 428611731456 flags data
May 22 21:41:37 node0 kernel: [2948103.862030] BTRFS info (device dm-0):
found 3519 extents
May 22 21:41:38 node0 kernel: [2948104.961367] BTRFS info (device dm-0):
found 3519 extents
May 22 21:41:39 node0 kernel: [2948105.026999] BTRFS info (device dm-0):
relocating block group 427537989632 flags data
May 22 21:41:40 node0 kernel: [2948106.155623] BTRFS warning (device
dm-0): csum failed root -9 ino 336 off 608284672 csum 0x7da1b152
expected csum 0x3163a9b7 mirror 1
May 22 21:41:40 node0 kernel: [2948106.156301] BTRFS warning (device
dm-0): csum failed root -9 ino 336 off 608284672 csum 0x7d03a376
expected csum 0x3163a9b7 mirror 1

ERROR: error during balancing './': Input/output error
There may be more info in syslog - try dmesg | tail

root@node0:/var/lib/libvirt/images# backup_dir="/var/lib/libvirt"; btrfs
dev stats $backup_dir
[/dev/mapper/raid10-images].write_io_errs    0
[/dev/mapper/raid10-images].read_io_errs     0
[/dev/mapper/raid10-images].flush_io_errs    0
[/dev/mapper/raid10-images].corruption_errs  0
[/dev/mapper/raid10-images].generation_errs  0

Again no errors in btrfs stats. I am pretty sure that I corrupted the
drive during remount:

mount -o
remount,noatime,nodiratime,rw,ssd,space_cache,compress=lzo,autodefrag
/dev/mapper/raid10-images /var/lib/libvirt

when I changed BTRFS compress parameters. Or during umount (can't recall
now):

May  2 07:15:39 node0 kernel: [1168145.677431] WARNING: CPU: 6 PID: 3763
at /build/linux-8B5M4n/linux-4.15.11/fs/direct-io.c:293
dio_complete+0x1d6/0x220
May  2 07:15:39 node0 kernel: [1168145.678811] Modules linked in: fuse
ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs vhost_net vhost
tap tun ebtable_filter ebtables ip6tab
le_filter ip6_tables iptable_filter binfmt_misc bridge 8021q garp mrp
stp llc snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal
intel_powerclamp coretemp snd_hda_codec_realtek kvm
_intel snd_hda_codec_generic kvm i915 irqbypass crct10dif_pclmul
snd_hda_intel crc32_pclmul ghash_clmulni_intel snd_hda_codec
intel_cstate snd_hda_core iTCO_wdt iTCO_vendor_support
 intel_uncore drm_kms_helper snd_hwdep wmi_bmof intel_rapl_perf joydev
evdev pcspkr snd_pcm snd_timer drm snd soundcore i2c_algo_bit sg mei_me
lpc_ich shpchp mfd_core mei ie31200_e
dac wmi video button ib_iser rdma_cm iw_cm ib_cm ib_core configfs
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables
May  2 07:15:39 node0 kernel: [1168145.685202]  x_tables autofs4 ext4
crc16 mbcache jbd2 fscrypto ecb btrfs zstd_decompress zstd_compress
xxhash raid456 async_raid6_recov async_mem
cpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic
raid0 multipath linear hid_generic usbhid hid dm_mod raid10 raid1 md_mod
sd_mod crc32c_intel ahci i2c_i801 lib
ahci aesni_intel xhci_pci aes_x86_64 ehci_pci libata crypto_simd
xhci_hcd ehci_hcd cryptd glue_helper e1000e scsi_mod ptp usbcore
pps_core usb_common fan thermal
May  2 07:15:39 node0 kernel: [1168145.689057] CPU: 6 PID: 3763 Comm:
kworker/6:2 Not tainted 4.15.0-0.bpo.2-amd64 #1 Debian 4.15.11-1~bpo9+1
May  2 07:15:39 node0 kernel: [1168145.690347] Hardware name: LENOVO
ThinkServer TS140/ThinkServer TS140, BIOS FBKTB3AUS 06/16/2015
May  2 07:15:39 node0 kernel: [1168145.691659] Workqueue: dio/dm-0
dio_aio_complete_work
May  2 07:15:39 node0 kernel: [1168145.692935] RIP:
0010:dio_complete+0x1d6/0x220
May  2 07:15:39 node0 kernel: [1168145.694275] RSP:
0018:ffff9abc68447e50 EFLAGS: 00010286
May  2 07:15:39 node0 kernel: [1168145.695605] RAX: 00000000fffffff0
RBX: ffff8e33712e3480 RCX: ffff9abc68447c88
May  2 07:15:39 node0 kernel: [1168145.697024] RDX: fffff1dcc92e4c1f
RSI: 0000000000000000 RDI: 0000000000000246
May  2 07:15:39 node0 kernel: [1168145.698389] RBP: 0000000000005000
R08: 0000000000000000 R09: ffffffffb7a075c0
May  2 07:15:39 node0 kernel: [1168145.699703] R10: ffff8e33bb4223c0
R11: 0000000000000195 R12: 0000000000005000
May  2 07:15:39 node0 kernel: [1168145.701044] R13: 0000000000000003
R14: 0000000403060000 R15: ffff8e33712e3500
May  2 07:15:39 node0 kernel: [1168145.702238] FS: 
0000000000000000(0000) GS:ffff8e349eb80000(0000) knlGS:0000000000000000
May  2 07:15:39 node0 kernel: [1168145.703475] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
May  2 07:15:39 node0 kernel: [1168145.704733] CR2: 00007ff89915b08e
CR3: 00000005b2e0a005 CR4: 00000000001626e0
May  2 07:15:39 node0 kernel: [1168145.705955] Call Trace:
May  2 07:15:39 node0 kernel: [1168145.707151]  process_one_work+0x177/0x360
May  2 07:15:39 node0 kernel: [1168145.708373]  worker_thread+0x4d/0x3c0
May  2 07:15:39 node0 kernel: [1168145.709501]  kthread+0xf8/0x130
May  2 07:15:39 node0 kernel: [1168145.710603]  ?
process_one_work+0x360/0x360
May  2 07:15:39 node0 kernel: [1168145.711701]  ?
kthread_create_worker_on_cpu+0x70/0x70
May  2 07:15:39 node0 kernel: [1168145.712845]  ? SyS_exit_group+0x10/0x10
May  2 07:15:39 node0 kernel: [1168145.713973]  ret_from_fork+0x35/0x40
May  2 07:15:39 node0 kernel: [1168145.715072] Code: 8b 78 30 48 83 7f
58 00 0f 84 e5 fe ff ff 49 8d 54 2e ff 4c 89 f6 48 c1 fe 0c 48 c1 fa 0c
e8 c2 e0 f3 ff 85 c0 0f 84 c8 fe ff f
f <0f> 0b e9 c1 fe ff ff 8b 47 20 a8 10 0f 84 e2 fe ff ff 48 8b 77
May  2 07:15:39 node0 kernel: [1168145.717349] ---[ end trace
cfa707d6465e13d2 ]---

If someone is interested in investigating then please let me know. The
data is not important. The lack of incrementing read_io_errs is
particularly critical IMHO.




-- 
PGP Public Key (RSA/4096b):
ID: 0xF2C6EA10
SHA-1: 51DA 40EE 832A 0572 5AD8 B3C0 7AFF 69E1 F2C6 EA10


