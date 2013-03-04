Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33295 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab3CDNuQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 08:50:16 -0500
Received: by mail-lb0-f182.google.com with SMTP id gg6so3974213lbb.27
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Mar 2013 05:50:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPsrAuCGwDCuWJ-NUt8vZGOgav779=KaF+32kf4A1bW7pZSF5g@mail.gmail.com>
References: <CAPsrAuCGwDCuWJ-NUt8vZGOgav779=KaF+32kf4A1bW7pZSF5g@mail.gmail.com>
Date: Mon, 4 Mar 2013 14:50:14 +0100
Message-ID: <CAPsrAuCk52oLpxyOfs8VyjKAoFZ3f8JqADRm=TVFuP4AWPkEHw@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/extent_map.c:78 free_extent_map+0x6e/0x90
 [btrfs]() [linux 3.8.0]
From: Joeri Vanthienen <mail@joerivanthienen.be>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Same problem occurs on linux kernel 3.9.0-rc1
I'll try if I can reproduce it without the use of the enhanceIO driver
from STEC.

this is my scst config file:

linux-testsan:~ # cat /etc/scst.conf
HANDLER vdisk_fileio {
        DEVICE disk01 {
                filename /btrfs/lun0.img
                nv_cache 0
                write_through 1
        }
}

TARGET_DRIVER iscsi {
        enabled 1

        TARGET iqn.2006-10.net.vlnb:tgt {
                LUN 0 disk01

                enabled 1
        }
}


[ 4313.975750] ------------[ cut here ]------------
[ 4313.975779] WARNING: at fs/btrfs/extent_map.c:77
free_extent_map+0x74/0x90 [btrfs]()
[ 4313.975785] Hardware name: Veriton M67WS
[ 4313.975786] Modules linked in: iscsi_scst(O) scst_vdisk(O) scst(O)
enhanceio_lru enhanceio_fifo enhanceio
dm_mod af_packet cpufreq_conservative cpufreq_userspace
cpufreq_powersave acpi_cpufreq mperf gpio_ich coretemp
serio_raw btrfs i2c_i801 pcspkr tpm_tis via_rhine usb_storage ehci_pci
kvm_intel kvm raid6_pq zlib_deflate
tpm tpm_bios iTCO_wdt iTCO_vendor_support e1000e ptp lpc_ich mei
mfd_core pps_core xor libcrc32c snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_timer snd soundcore snd_page_alloc sg microcode
 wmi autofs4 hid_generic usbhid uhci_hcd ehci_hcd usbcore usb_common
i915 drm_kms_helper drm i2c_algo_bit video button
 processor thermal_sys scsi_dh_alua scsi_dh_emc scsi_dh_rdac
scsi_dh_hp_sw scsi_dh mpt2sas scsi_transport_sas
raid_class ata_generic pata_acpi [last unloaded: scst]
[ 4313.975844] Pid: 6500, comm: disk010_7 Tainted: G           O
3.9.0-rc1-server-SCST-enhanceIO-1 #1
[ 4313.975846] Call Trace:
[ 4313.975854]  [<ffffffff8104590a>] warn_slowpath_common+0x7a/0xc0
[ 4313.975858]  [<ffffffff81045965>] warn_slowpath_null+0x15/0x20
[ 4313.975874]  [<ffffffffa0579644>] free_extent_map+0x74/0x90 [btrfs]
[ 4313.975891]  [<ffffffffa0576b65>] btrfs_drop_extent_cache+0x365/0x430 [btrfs]
[ 4313.975908]  [<ffffffffa056b898>] __cow_file_range+0xf8/0x4e0 [btrfs]
[ 4313.975924]  [<ffffffffa0564ac3>] ? start_transaction+0x93/0x4e0 [btrfs]
[ 4313.975941]  [<ffffffffa057d2df>] ?
free_extent_state.part.35+0x2f/0x80 [btrfs]
[ 4313.975957]  [<ffffffffa056c820>] cow_file_range+0x90/0xe0 [btrfs]
[ 4313.975974]  [<ffffffffa057daf9>] ? free_extent_state+0x19/0x20 [btrfs]
[ 4313.975990]  [<ffffffffa056cbcb>] run_delalloc_range+0x35b/0x390 [btrfs]
[ 4313.976007]  [<ffffffffa0581459>] __extent_writepage+0x2f9/0x770 [btrfs]
[ 4313.976032]  [<ffffffff8110cba2>] ? unlock_page+0x22/0x30
[ 4313.976055]  [<ffffffffa0581b7a>]
extent_write_cache_pages.isra.30.constprop.47+0x2aa/0x3c0 [btrfs]
[ 4313.976066]  [<ffffffff8111662f>] ? account_page_dirtied+0x8f/0x100
[ 4313.976090]  [<ffffffffa0581ee8>] extent_writepages+0x48/0x60 [btrfs]
[ 4313.976108]  [<ffffffffa0568a50>] ? can_nocow_odirect+0x280/0x280 [btrfs]
[ 4313.976113]  [<ffffffff8107abe6>] ? sched_clock_local+0x26/0xa0
[ 4313.976128]  [<ffffffffa0566583>] btrfs_writepages+0x23/0x30 [btrfs]
[ 4313.976132]  [<ffffffff811173d9>] do_writepages+0x19/0x40
[ 4313.976135]  [<ffffffff8110d569>] __filemap_fdatawrite_range+0x49/0x50
[ 4313.976139]  [<ffffffff8110e36e>] filemap_fdatawrite_range+0xe/0x10
[ 4313.976204]  [<ffffffffa0574c84>] btrfs_sync_file+0x54/0x290 [btrfs]
[ 4313.976209]  [<ffffffff8119d2b8>] generic_write_sync+0x48/0x60
[ 4313.976225]  [<ffffffffa0576619>] btrfs_file_aio_write+0x3c9/0x5b0 [btrfs]
[ 4313.976229]  [<ffffffff81187a11>] ? touch_atime+0x71/0x140
[ 4313.976246]  [<ffffffffa0576250>] ?
__btrfs_buffered_write+0x340/0x340 [btrfs]
[ 4313.976250]  [<ffffffff8116f94b>] do_sync_readv_writev+0x9b/0xe0
[ 4313.976256]  [<ffffffff8116fc1f>] do_readv_writev+0xcf/0x1e0
[ 4313.976262]  [<ffffffffa05fafa3>] ? iscsi_xmit_response+0x103/0x470
[iscsi_scst]
[ 4313.976266]  [<ffffffff8116fd60>] vfs_writev+0x30/0x60
[ 4313.976271]  [<ffffffffa03e6b14>] fileio_exec_write+0x264/0x4b0 [scst_vdisk]
[ 4313.976275]  [<ffffffffa03e1420>] vdev_do_job+0x20/0xa0 [scst_vdisk]
[ 4313.976278]  [<ffffffffa03e14bf>] vdisk_exec+0x1f/0x30 [scst_vdisk]
[ 4313.976286]  [<ffffffffa041eb10>] scst_do_real_exec+0x50/0x1a0 [scst]
[ 4313.976292]  [<ffffffff81580961>] ? _raw_spin_unlock_bh+0x11/0x20
[ 4313.976301]  [<ffffffffa0420fd2>] scst_exec_check_blocking+0xa2/0x110 [scst]
[ 4313.976309]  [<ffffffffa0421769>] scst_process_active_cmd+0xe9/0x1750 [scst]
[ 4313.976319]  [<ffffffff8157f4e8>] ? __schedule+0x3c8/0x7c0
[ 4313.976327]  [<ffffffffa0422e2c>] scst_do_job_active+0x5c/0x80 [scst]
[ 4313.976334]  [<ffffffffa0422f8d>] scst_cmd_thread+0xed/0x300 [scst]
[ 4313.976337]  [<ffffffff81068b10>] ? finish_wait+0x80/0x80
[ 4313.976344]  [<ffffffffa0422ea0>] ? scst_cmd_tasklet+0x50/0x50 [scst]
[ 4313.976346]  [<ffffffff8106818b>] kthread+0xbb/0xc0
[ 4313.976348]  [<ffffffff810680d0>] ? kthread_create_on_node+0x120/0x120
[ 4313.976351]  [<ffffffff8158873c>] ret_from_fork+0x7c/0xb0
[ 4313.976353]  [<ffffffff810680d0>] ? kthread_create_on_node+0x120/0x120
[ 4313.976354] ---[ end trace 9f628fac55cc73ad ]---

On Mon, Mar 4, 2013 at 9:19 AM, Joeri Vanthienen
<mail@joerivanthienen.be> wrote:
> Hi everyone,
>
> I'm running currently a patched linux 3.8.0 kernel (SCST iscsi target
> patches and STEC enhanceIO driver support)
> I created a btrfs raid10 filesystem with "mkfs.btrfs -m raid10 -d
> raid10 /dev/sdf /dev/sdg /dev/sdh /dev/sdi"
> On this volume I added a sparse file and shared it over iscsi with
> SCST, on the other side I ran an IOmeter test for a couple of hours.
> This happened already twice on a new volume, so I guess we can reproduce it.
> I've seen similar messages on the mailinglist for kernel 3.7.X and
> also we get some CPU stuck messages.
>
> 2013-03-02T00:27:33.830960+01:
> 00 linux-testsan kernel: [29480.367902] WARNING: at
> fs/btrfs/extent_map.c:78 free_extent_map+0x6e/0x90 [btrfs]()
> 2013-03-02T00:27:33.830963+01:00 linux-testsan kernel: [29480.367910]
> Hardware name: Veriton M67WS
> 2013-03-02T00:27:33.830965+01:00 linux-testsan kernel: [29480.367911]
> Modules linked in: iscsi_scst(O) scst_vdisk(O) scst(O) enhanceio_lru
> enhanceio_fifo enhanceio af_packet cpufreq_conservative cpufreq_use$
> 2013-03-02T00:27:33.830967+01:00 linux-testsan kernel: [29480.367969]
> Pid: 12713, comm: disk010_7 Tainted: G        W  O
> 3.8.0-server-SCST-enhanceIO-1 #1
> 2013-03-02T00:27:33.830969+01:00 linux-testsan kernel: [29480.367971]
> Call Trace:
> 2013-03-02T00:27:33.830970+01:00 linux-testsan kernel: [29480.367981]
> [<ffffffff81004658>] dump_trace+0x78/0x2c0
> 2013-03-02T00:27:33.830972+01:00 linux-testsan kernel: [29480.367985]
> [<ffffffff8155d276>] dump_stack+0x69/0x6f
> 2013-03-02T00:27:33.830974+01:00 linux-testsan kernel: [29480.367990]
> [<ffffffff81043d29>] warn_slowpath_common+0x79/0xc0
> 2013-03-02T00:27:33.830975+01:00 linux-testsan kernel: [29480.368002]
> [<ffffffffa041e96e>] free_extent_map+0x6e/0x90 [btrfs]
> 2013-03-02T00:27:33.830981+01:00 linux-testsan kernel: [29480.368083]
> [<ffffffffa041bf3b>] btrfs_drop_extent_cache+0x35b/0x430 [btrfs]
> 2013-03-02T00:27:33.834940+01:00 linux-testsan kernel: [29480.368126]
> [<ffffffffa04117c6>] __cow_file_range+0xe6/0x4b0 [btrfs]
> 2013-03-02T00:27:33.834948+01:00 linux-testsan kernel: [29480.368166]
> [<ffffffffa0412755>] cow_file_range+0x95/0xf0 [btrfs]
> 2013-03-02T00:27:33.834949+01:00 linux-testsan kernel: [29480.368206]
> [<ffffffffa0412b15>] run_delalloc_range+0x365/0x3a0 [btrfs]
> 2013-03-02T00:27:33.834951+01:00 linux-testsan kernel: [29480.368248]
> [<ffffffffa0426829>] __extent_writepage+0x319/0x7b0 [btrfs]
> 2013-03-02T00:27:33.834952+01:00 linux-testsan kernel: [29480.368299]
> [<ffffffffa0426f48>]
> extent_write_cache_pages.isra.29.constprop.46+0x288/0x370 [btrfs]
> 2013-03-02T00:27:33.834954+01:00 linux-testsan kernel: [29480.368351]
> [<ffffffffa042727c>] extent_writepages+0x4c/0x60 [btrfs]
> 2013-03-02T00:27:33.834955+01:00 linux-testsan kernel: [29480.368395]
> [<ffffffff8110cb29>] __filemap_fdatawrite_range+0x49/0x50
> 2013-03-02T00:27:33.834971+01:00 linux-testsan kernel: [29480.368399]
> [<ffffffff8110cb80>] filemap_write_and_wait_range+0x50/0x70
> 2013-03-02T00:27:33.834972+01:00 linux-testsan kernel: [29480.368410]
> [<ffffffffa041a02b>] btrfs_sync_file+0x5b/0x240 [btrfs]
> 2013-03-02T00:27:33.834974+01:00 linux-testsan kernel: [29480.368453]
> [<ffffffffa041ba15>] btrfs_file_aio_write+0x405/0x5d0 [btrfs]
> 2013-03-02T00:27:33.834975+01:00 linux-testsan kernel: [29480.368489]
> [<ffffffff8116cfb8>] do_sync_readv_writev+0x88/0xc0
> 2013-03-02T00:27:33.834976+01:00 linux-testsan kernel: [29480.368492]
> [<ffffffff8116d29f>] do_readv_writev+0xcf/0x1f0
> 2013-03-02T00:27:33.834977+01:00 linux-testsan kernel: [29480.368497]
> [<ffffffffa05b9a34>] fileio_exec_write+0x284/0x4e0 [scst_vdisk]
> 2013-03-02T00:27:33.834978+01:00 linux-testsan kernel: [29480.368507]
> [<ffffffffa05b43a8>] vdev_do_job+0x18/0xa0 [scst_vdisk]
> 2013-03-02T00:27:33.834979+01:00 linux-testsan kernel: [29480.368517]
> [<ffffffffa0546a95>] scst_do_real_exec+0x55/0x1b0 [scst]
> 2013-03-02T00:27:33.834980+01:00 linux-testsan kernel: [29480.368525]
> [<ffffffffa0548de0>] scst_exec_check_blocking+0xa0/0x100 [scst]
> 2013-03-02T00:27:33.834982+01:00 linux-testsan kernel: [29480.368535]
> [<ffffffffa054957a>] scst_process_active_cmd+0xea/0x1720 [scst]
> 2013-03-02T00:27:33.834983+01:00 linux-testsan kernel: [29480.368544]
> [<ffffffffa054ac04>] scst_do_job_active+0x54/0x70 [scst]
> 2013-03-02T00:27:33.834984+01:00 linux-testsan kernel: [29480.368554]
> [<ffffffffa054ad6d>] scst_cmd_thread+0xfd/0x340 [scst]
> 2013-03-02T00:27:33.834985+01:00 linux-testsan kernel: [29480.368562]
> [<ffffffff81066183>] kthread+0xb3/0xc0
> 2013-03-02T00:27:33.834986+01:00 linux-testsan kernel: [29480.368566]
> [<ffffffff8157047c>] ret_from_fork+0x7c/0xb0
> 2013-03-02T00:27:33.834987+01:00 linux-testsan kernel: [29480.368569]
> ---[ end trace 32d79d600d4b3f34 ]---
