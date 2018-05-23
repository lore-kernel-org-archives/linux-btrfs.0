Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45467 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932312AbeEWLMN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 07:12:13 -0400
Subject: Re: csum failed root raveled during balance
To: ein <ein.net@gmail.com>, linux-btrfs@vger.kernel.org
References: <5B047817.3040106@gmail.com>
 <e04ab862-abe3-7187-1519-b89776df9362@suse.com> <5B052068.5000608@gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b7cd5626-bfa7-73c0-0810-a41f1abc4480@suse.com>
Date: Wed, 23 May 2018 14:12:10 +0300
MIME-Version: 1.0
In-Reply-To: <5B052068.5000608@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.05.2018 11:03, ein wrote:
> On 05/23/2018 08:32 AM, Nikolay Borisov wrote:
> 
> Nikolay, thank you for the answer.
> 
>>> [...]
>>> root@node0:~# dmesg | grep BTRFS | grep warn
>>> 185:980:[2927472.393557] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 312 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
>>> 186:981:[2927472.394158] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 312 off 608284672 csum 0x7da1b152 expected csum 0x3163a9b7 mirror 1
>>> 191:986:[2928224.169814] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 314 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
>>> 192:987:[2928224.171433] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 314 off 608284672 csum 0x7da1b152 expected csum 0x3163a9b7 mirror 1
>>> 206:1001:[2928298.039516] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 319 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
>>> 207:1002:[2928298.043103] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 319 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
>>> 208:1004:[2932213.513424] BTRFS warning (device dm-0): csum failed root
>>> 5 ino 219962 off 4564959232 csum 0xc616afb4 expected csum 0x5425e489
>>> mirror 1
>>> 209:1005:[2932235.666368] BTRFS warning (device dm-0): csum failed root
>>> 5 ino 219962 off 16989835264 csum 0xd63ed5da expected csum 0x7429caa1
>>> mirror 1
>>> 210:1072:[2936767.229277] BTRFS warning (device dm-0): csum failed root
>>> 5 ino 219915 off 82318458880 csum 0x83614341 expected csum 0x0b8706f8
>>> mirror 1
>>> 211:1073:[2936767.276229] BTRFS warning (device dm-0): csum failed root
>>> 5 ino 219915 off 82318458880 csum 0x83614341 expected csum 0x0b8706f8
>>> mirror 1
>>>
>>> Above has been revealed during below command and quite high IO usage by
>>> few VMs (Linux on top Ext4 with firebird database, lots of random
>>> read/writes, two others with Windows 2016 and Windows Update in the
>>> background):
>>
>> I believe you are hitting the issue described here:
>>
>> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg25656.html
> 
> It make sense, fsck.ext4, gbak - firebird integrity checking tool,
> chkdsk and sfc /scannow don't show any errors internally within VM. As
> far I can tell the data inside VMs is not corrupted somehow.
> 
>> Essentially the way qemu operates on vm images atop btrfs is prone to
>> producing such errors. As a matter of fact, other filesystems also
>> suffer from this(i.e pages modified while being written, however due to
>> lack of CRC on the data they don't detect it). Can you confirm that
>> those inodes (312/314/319/219962/219915) belong to vm images files?
> 
> root@node0:/var/lib/libvirt# find  ./ -inum 312
> root@node0:/var/lib/libvirt# find  ./ -inum 314
> root@node0:/var/lib/libvirt# find  ./ -inum 319
> root@node0:/var/lib/libvirt# find  ./ -inum 219962
> ./images/rds.raw
> root@node0:/var/lib/libvirt# find  ./ -inum 219915
> ./images/database.raw
> 
> It seems so (219962, 219915):
> - rds.raw - Windows 2016 server, Remote Desktop Server, raw preallocated
> image, NTFS
> database.raw - Linux 3.8, Firebird DB server, raw preallocated image, Ext4
> 
>> IMHO the best course of action would be to disable checksumming for you
>> vm files.
>>
> 
> Do you mean '-o nodatasum' mount flag? Is it possible to disable
> checksumming for singe file by setting some magical chattr? Google
> thinks it's not possible to disable csums for a single file.

You can't disable checksumming for a single file. However, what you
could do is set a the "No CoW" flag via chattr +c /path/to/file since it
also disables checksumming. Bear in mind you can't set this flag to a
file which already has allocated blocks. So you'd have to create an
empty file, set the +C flag and then copy the data with dd for example.

On a different note - for database workloads and generally random
workloads it makes no sense to have CoW since you'd see very spikey io
performance.

> 
>> For some background I suggest you read the following LWN articles:
>>
>> https://lwn.net/Articles/486311/
>> https://lwn.net/Articles/442355/
>>
>>>
>>> when I changed BTRFS compress parameters. Or during umount (can't recall
>>> now):
>>>
>>> May  2 07:15:39 node0 kernel: [1168145.677431] WARNING: CPU: 6 PID: 3763
>>> at /build/linux-8B5M4n/linux-4.15.11/fs/direct-io.c:293
>>> dio_complete+0x1d6/0x220
>>> May  2 07:15:39 node0 kernel: [1168145.678811] Modules linked in: fuse
>>> ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs vhost_net vhost
>>> tap tun ebtable_filter ebtables ip6tab
>>> le_filter ip6_tables iptable_filter binfmt_misc bridge 8021q garp mrp
>>> stp llc snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal
>>> intel_powerclamp coretemp snd_hda_codec_realtek kvm
>>> _intel snd_hda_codec_generic kvm i915 irqbypass crct10dif_pclmul
>>> snd_hda_intel crc32_pclmul ghash_clmulni_intel snd_hda_codec
>>> intel_cstate snd_hda_core iTCO_wdt iTCO_vendor_support
>>>  intel_uncore drm_kms_helper snd_hwdep wmi_bmof intel_rapl_perf joydev
>>> evdev pcspkr snd_pcm snd_timer drm snd soundcore i2c_algo_bit sg mei_me
>>> lpc_ich shpchp mfd_core mei ie31200_e
>>> dac wmi video button ib_iser rdma_cm iw_cm ib_cm ib_core configfs
>>> iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables
>>> May  2 07:15:39 node0 kernel: [1168145.685202]  x_tables autofs4 ext4
>>> crc16 mbcache jbd2 fscrypto ecb btrfs zstd_decompress zstd_compress
>>> xxhash raid456 async_raid6_recov async_mem
>>> cpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic
>>> raid0 multipath linear hid_generic usbhid hid dm_mod raid10 raid1 md_mod
>>> sd_mod crc32c_intel ahci i2c_i801 lib
>>> ahci aesni_intel xhci_pci aes_x86_64 ehci_pci libata crypto_simd
>>> xhci_hcd ehci_hcd cryptd glue_helper e1000e scsi_mod ptp usbcore
>>> pps_core usb_common fan thermal
>>> May  2 07:15:39 node0 kernel: [1168145.689057] CPU: 6 PID: 3763 Comm:
>>> kworker/6:2 Not tainted 4.15.0-0.bpo.2-amd64 #1 Debian 4.15.11-1~bpo9+1
>>> May  2 07:15:39 node0 kernel: [1168145.690347] Hardware name: LENOVO
>>> ThinkServer TS140/ThinkServer TS140, BIOS FBKTB3AUS 06/16/2015
>>> May  2 07:15:39 node0 kernel: [1168145.691659] Workqueue: dio/dm-0
>>> dio_aio_complete_work
>>> May  2 07:15:39 node0 kernel: [1168145.692935] RIP:
>>> 0010:dio_complete+0x1d6/0x220
>>> May  2 07:15:39 node0 kernel: [1168145.694275] RSP:
>>> 0018:ffff9abc68447e50 EFLAGS: 00010286
>>> May  2 07:15:39 node0 kernel: [1168145.695605] RAX: 00000000fffffff0
>>> RBX: ffff8e33712e3480 RCX: ffff9abc68447c88
>>> May  2 07:15:39 node0 kernel: [1168145.697024] RDX: fffff1dcc92e4c1f
>>> RSI: 0000000000000000 RDI: 0000000000000246
>>> May  2 07:15:39 node0 kernel: [1168145.698389] RBP: 0000000000005000
>>> R08: 0000000000000000 R09: ffffffffb7a075c0
>>> May  2 07:15:39 node0 kernel: [1168145.699703] R10: ffff8e33bb4223c0
>>> R11: 0000000000000195 R12: 0000000000005000
>>> May  2 07:15:39 node0 kernel: [1168145.701044] R13: 0000000000000003
>>> R14: 0000000403060000 R15: ffff8e33712e3500
>>> May  2 07:15:39 node0 kernel: [1168145.702238] FS: 
>>> 0000000000000000(0000) GS:ffff8e349eb80000(0000) knlGS:0000000000000000
>>> May  2 07:15:39 node0 kernel: [1168145.703475] CS:  0010 DS: 0000 ES:
>>> 0000 CR0: 0000000080050033
>>> May  2 07:15:39 node0 kernel: [1168145.704733] CR2: 00007ff89915b08e
>>> CR3: 00000005b2e0a005 CR4: 00000000001626e0
>>> May  2 07:15:39 node0 kernel: [1168145.705955] Call Trace:
>>> May  2 07:15:39 node0 kernel: [1168145.707151]  process_one_work+0x177/0x360
>>> May  2 07:15:39 node0 kernel: [1168145.708373]  worker_thread+0x4d/0x3c0
>>> May  2 07:15:39 node0 kernel: [1168145.709501]  kthread+0xf8/0x130
>>> May  2 07:15:39 node0 kernel: [1168145.710603]  ?
>>> process_one_work+0x360/0x360
>>> May  2 07:15:39 node0 kernel: [1168145.711701]  ?
>>> kthread_create_worker_on_cpu+0x70/0x70
>>> May  2 07:15:39 node0 kernel: [1168145.712845]  ? SyS_exit_group+0x10/0x10
>>> May  2 07:15:39 node0 kernel: [1168145.713973]  ret_from_fork+0x35/0x40
>>> May  2 07:15:39 node0 kernel: [1168145.715072] Code: 8b 78 30 48 83 7f
>>> 58 00 0f 84 e5 fe ff ff 49 8d 54 2e ff 4c 89 f6 48 c1 fe 0c 48 c1 fa 0c
>>> e8 c2 e0 f3 ff 85 c0 0f 84 c8 fe ff f
>>> f <0f> 0b e9 c1 fe ff ff 8b 47 20 a8 10 0f 84 e2 fe ff ff 48 8b 77
>>> May  2 07:15:39 node0 kernel: [1168145.717349] ---[ end trace
>>> cfa707d6465e13d2 ]---
>>>
>>> If someone is interested in investigating then please let me know. The
>>> data is not important. The lack of incrementing read_io_errs is
>>> particularly critical IMHO.
>>
>> This warning is due to mixing buffered/dio. For more info check the
>> commit log of :
>>
>> 332391a9935d ("fs: Fix page cache inconsistency when mixing buffered and
>> AIO DIO")
> 
> Reading the BTRFS code is beyond my understanding. Have you thought
> about read_io_errs counter?

I didn't say read the btrfs code but rather read the commit messages.

> 
> Balance reveals IO read error, copying VM file ends with IO read error,
> read_io_errors is unchanged - still shows "0".

Will have to investigate and see whether the current behavior is
intentional or not.

> 
> 
