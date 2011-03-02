From: Felipe Barriga Richards <fbarriga@algometrics.cl>
Subject: Bug Report: Warning because of multipath ?
Date: Wed, 02 Mar 2011 20:49:05 +0000
Message-ID: <1299098945.5103.198.camel@slave03>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've the following configuration:
Distro: Gentoo
Kernel: vanilla 2.6.38-rc6 AMD64 
Details:
I use btrfs on a Dell MD3000i iSCSI disk. I'm connected with 2 ethernet
cards with multipath to one raid controller.
The mounted partition is also accessed from other servers via nfs.

The mount options are: "rw,compress,thread_pool=15,compress-force"

I think that this error happens when the network is under heavy load and
also the btrfs is having multiple i/o.

Regards,

--- Kernel Message ---

------------[ cut here ]------------
WARNING: at fs/btrfs/disk-io.c:381 __btree_submit_bio_start+0x2c7/0x300
[btrfs]()
Hardware name: PowerEdge R710
Modules linked in: nfsd btrfs zlib_deflate lzo_decompress lzo_compress
ipv6 dm_round_robin dm_multipath iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi cpufreq_stats cpufreq_powersave cpufreq_ondemand
acpi_cpufreq freq_table mperf usbhid dm_mod pata_acpi ata_generic
ehci_hcd ata_piix uhci_hcd bnx2 usbcore dcdbas power_meter sg rtc libata
processor firmware_class thermal_sys hwmon button
Pid: 13939, comm: btrfs-worker-1 Not tainted 2.6.38-rc6 #1
Call Trace:
 [<ffffffff810425bb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffffa0219037>] ? __btree_submit_bio_start+0x2c7/0x300 [btrfs]
 [<ffffffff8104e910>] ? process_timeout+0x0/0x10
 [<ffffffffa0247c98>] ? worker_loop+0x148/0x530 [btrfs]
 [<ffffffffa0247b50>] ? worker_loop+0x0/0x530 [btrfs]
 [<ffffffffa0247b50>] ? worker_loop+0x0/0x530 [btrfs]
 [<ffffffff8105cea6>] ? kthread+0x96/0xa0
 [<ffffffff8100ade4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8105ce10>] ? kthread+0x0/0xa0
 [<ffffffff8100ade0>] ? kernel_thread_helper+0x0/0x10
---[ end trace ebe62be1d938042c ]---


