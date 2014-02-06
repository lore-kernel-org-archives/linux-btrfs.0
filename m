Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35163 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaBFEO1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Feb 2014 23:14:27 -0500
Received: by mail-pb0-f46.google.com with SMTP id um1so1235423pbc.5
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Feb 2014 20:14:26 -0800 (PST)
Received: from [0.0.0.0] (115-64-177-136.static.tpgi.com.au. [115.64.177.136])
        by mx.google.com with ESMTPSA id tu3sm82017769pbc.40.2014.02.05.20.14.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 05 Feb 2014 20:14:24 -0800 (PST)
Message-ID: <52F30C1B.8000301@gmail.com>
Date: Thu, 06 Feb 2014 15:14:19 +1100
From: Thermionix <thermionix@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: device delete missing panic
References: <52F30422.8@gmail.com> <52F305E3.1020806@polymtl.ca> <52F307D3.8020404@polymtl.ca>
In-Reply-To: <52F307D3.8020404@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yep, not planning on using btrfsck unless told ;)

hmm now I can't even mount it;

~ # dmesg | tail
[  351.083338] btrfs: failed to read chunk tree on sdg
[  351.088283] btrfs: open_ctree failed
[  392.541465] device label pool devid 7 transid 55056 /dev/sdh
[  393.558496] btrfs: allowing degraded mounts
[  393.558503] btrfs: disk space caching is enabled
[  393.605461] BTRFS critical (device sdg): unable to find logical
1563838812160 len 4096
[  393.605479] BTRFS critical (device sdg): unable to find logical
1563838812160 len 4096
[  393.605491] BTRFS critical (device sdg): unable to find logical
1563838812160 len 4096
[  393.605495] btrfs: failed to read tree root on sdg
[  393.612297] btrfs: open_ctree failed

On 06/02/14 14:56, Christian Robert wrote:
> and also "cat /proc/mounts | fgrep /mountpoint"  # will show most mount
> options, rw/ro status and so.
> 
> and *never* try to btrfsck this filesystem (fsck.btrfs is still broken)
> unless an expert developper tell you to try this.
> 
> Xtian.
> 
> On 2014-02-05 22:47, Christian Robert wrote:
>> ps:
>>
>>    always add a "btrfs file df /mountpoint" to your reporting bug,
>>    so they can figure if it is single dup raid0 raid1 raid10 raid5
>> raid6 and so on... or a mixup
>>
>> my 2 cents.
>>
>> On 2014-02-05 22:40, Thermionix wrote:
>>> openSUSE 13.1 i686 8 device raid 10
>>> when replacing a failed disk (new device is added)
>>>
>>> ~ # uname -r
>>> 3.11.6-4-pae
>>>
>>> ~ # btrfs --version
>>> Btrfs v3.12+20131125
>>>
>>> ~ # mount -o degraded /pool
>>>
>>> ~ # journalctl | tail
>>>
>>> Feb 06 12:22:51 store03 kernel: device label pool devid 4 transid 55050
>>> /dev/sde
>>> Feb 06 12:22:53 store03 kernel: btrfs: allowing degraded mounts
>>> Feb 06 12:22:53 store03 kernel: btrfs: disk space caching is enabled
>>> Feb 06 12:22:53 store03 kernel: btrfs: bdev (null) errs: wr 353, rd 1,
>>> flush 17, corrupt 0, gen 0
>>> Feb 06 12:23:16 store03 kernel: BTRFS debug (device sde): unlinked 1
>>> orphans
>>>
>>> ~ # btrfs filesystem show /dev/disk/by-label/pool
>>> Label: pool  uuid: 3e6ba20f-a4d0-40e4-88e7-a31c4930bcfe
>>>          Total devices 9 FS bytes used 5.19TiB
>>>          devid    1 size 1.36TiB used 169.50GiB path
>>>          devid    2 size 1.82TiB used 1.62TiB path /dev/sdc
>>>          devid    3 size 931.51GiB used 931.51GiB path /dev/sdd
>>>          devid    4 size 931.51GiB used 931.51GiB path /dev/sde
>>>          devid    6 size 1.82TiB used 1.62TiB path /dev/sdg
>>>          devid    7 size 1.82TiB used 1.62TiB path /dev/sdh
>>>          devid    8 size 931.51GiB used 931.51GiB path /dev/sdi
>>>          devid    9 size 1.82TiB used 1.62TiB path /dev/sdf
>>>          devid    10 size 1.82TiB used 1.01TiB path /dev/sdb
>>>
>>> ~ # btrfs device delete missing /pool
>>>
>>> ~ # journalctl -l | tail
>>>
>>> Feb 06 12:25:43 store03 kernel: btrfs: relocating block group
>>> 10590585618432 flags 68
>>> ...
>>> Feb 06 12:47:23 store03 kernel:  [<c025ebd2>] kthread+0x92/0xa0
>>> Feb 06 12:47:23 store03 kernel:  [<c06ece67>]
>>> ret_from_kernel_thread+0x1b/0x28
>>> Feb 06 12:47:23 store03 kernel:  [<c025eb40>]
>>> kthread_create_on_node+0xd0/0xd0
>>> Feb 06 12:47:23 store03 kernel: DWARF2 unwinder stuck at
>>> kthread+0x0/0xa0
>>> Feb 06 12:47:23 store03 kernel: Feb 06 12:47:23 store03 kernel: Leftover
>>> inexact backtrace:
>>> Feb 06 12:47:23 store03 kernel: ---[ end trace c47f82d03f79250d ]---
>>> Feb 06 12:47:23 store03 kernel: ------------[ cut here ]------------
>>> Feb 06 12:47:23 store03 kernel: WARNING: CPU: 0 PID: 3028 at
>>> /home/abuild/rpmbuild/BUILD/kernel-pae-3.11.6/linux-3.11/fs/btrfs/disk-io.c:482
>>>
>>> btree_csum_one_bio.isra.48+0x93/0x110 [btrfs]()
>>> Feb 06 12:47:23 store03 kernel: Modules linked in: bonding hwmon_vid
>>> btrfs raid6_pq zlib_deflate xor libcrc32c joydev hid_generic iTCO_wdt
>>> iTCO_vendor_support coretemp pcspkr serio_raw i2c_i801 ata_generic
>>> lpc_ich mfd_core usbhid mvsas libsas scsi_transport_sas e1000e ptp
>>> pps_core shpchp mperf sg dm_mod autofs4 ata_piix uhci_hcd ehci_pci
>>> ehci_hcd usbcore usb_common i915 fan thermal processor drm_kms_helper
>>> drm i2c_algo_bit button video thermal_sys scsi_dh_hp_sw scsi_dh_emc
>>> scsi_dh_rdac scsi_dh_alua scsi_dh
>>> Feb 06 12:47:23 store03 kernel: CPU: 0 PID: 3028 Comm: btrfs-worker-2
>>> Tainted: G        W    3.11.6-4-pae #1
>>> Feb 06 12:47:23 store03 kernel: Hardware name: PhoenixAward 945GM/945GM,
>>> BIOS 6.00 PG 08/13/2008
>>> Feb 06 12:47:23 store03 kernel:  00000009 c06e075a 00000000 c0242c5e
>>> c085dbc8 00000000 00000bd4 f8a06e34
>>> Feb 06 12:47:23 store03 kernel:  000001e2 f8985503 f8985503 00000002
>>> f5c60304 f2e606d8 c14ca4f0 c0242d1b
>>> Feb 06 12:47:23 store03 kernel:  00000009 00000000 f8985503 ef93d4a0
>>> f5c60304 e62a6c00 16c1f682 f46fe86c
>>> Feb 06 12:47:23 store03 kernel: Call Trace:
>>> Feb 06 12:47:23 store03 kernel:  [<c0204ef9>]
>>> try_stack_unwind+0x179/0x190
>>> Feb 06 12:47:23 store03 kernel:  [<c0203e17>] dump_trace+0x47/0xf0
>>> Feb 06 12:47:23 store03 kernel:  [<c0204f4f>]
>>> show_trace_log_lvl+0x3f/0x50
>>> Feb 06 12:47:23 store03 kernel:  [<c0203f10>]
>>> show_stack_log_lvl+0x50/0xd0
>>> Feb 06 12:47:23 store03 kernel:  [<c0204f9f>] show_stack+0x1f/0x40
>>> Feb 06 12:47:23 store03 kernel:  [<c06e075a>] dump_stack+0x3e/0x4e
>>> Feb 06 12:47:23 store03 kernel:  [<c0242c5e>]
>>> warn_slowpath_common+0x7e/0xa0
>>> Feb 06 12:47:23 store03 kernel:  [<c0242d1b>]
>>> warn_slowpath_null+0x1b/0x20
>>> Feb 06 12:47:23 store03 kernel:  [<f8985503>]
>>> btree_csum_one_bio.isra.48+0x93/0x110 [btrfs]
>>> Feb 06 12:47:23 store03 kernel:  [<f898261f>]
>>> run_one_async_start+0x2f/0x40 [btrfs]
>>> Feb 06 12:47:23 store03 kernel:  [<f89bdcb7>] worker_loop+0x107/0x470
>>> [btrfs]
>>> Feb 06 12:47:23 store03 kernel:  [<c025ebd2>] kthread+0x92/0xa0
>>> Feb 06 12:47:23 store03 kernel:  [<c06ece67>]
>>> ret_from_kernel_thread+0x1b/0x28
>>> Feb 06 12:47:23 store03 kernel:  [<c025eb40>]
>>> kthread_create_on_node+0xd0/0xd0
>>> Feb 06 12:47:23 store03 kernel: DWARF2 unwinder stuck at
>>> kthread+0x0/0xa0
>>> Feb 06 12:47:23 store03 kernel: Feb 06 12:47:23 store03 kernel: Leftover
>>> inexact backtrace:
>>> Feb 06 12:47:23 store03 kernel: ---[ end trace c47f82d03f79250e ]---
>>> Feb 06 12:47:23 store03 kernel: ------------[ cut here ]------------
>>> ...
>>>
>>> kernel soon locks up, any advice on how to proceed?
>>> any other info needed?
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
