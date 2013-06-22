Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [219.239.227.113] ([219.239.227.113]:30787 "EHLO
	mail.act.buaa.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3FVHkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 03:40:51 -0400
From: "ZHANG, Benlong" <zhangbl@act.buaa.edu.cn>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Sat, 22 Jun 2013 15:35:23 +0800
Subject: Filebench varmail can not run in btrfs of kernel 3.8.2
Message-ID: <835012AB67A67C408EEFBCCCC906381E02BDF53E5F3D@mail.lab.act.buaa.edu.cn>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
    When I run filebench varmail test under btrfs of Linux kernel 3.8.2, I got this error:

[11496.552440] WARNING: at fs/btrfs/tree-log.c:3825 btrfs_log_inode_parent+0x28e/0x2f1 [btrfs]()
[11496.552560] Hardware name: PowerEdge R910
[11496.552644] Modules linked in: brd loop dm_crypt mperf coretemp kvm_intel snd_pcm kvm snd_timer snd usb_storage tpm_tis soundcore joydev psmouse snd_page_alloc tpm processor thermal_sys lpc_ich hid_generic serio_raw dcdbas ehci_pci evdev pcspkr tpm_bios microcode mfd_core button ext3 jbd mbcache dm_mod btrfs zlib_deflate crc32c libcrc32c sg sr_mod cdrom ses sd_mod enclosure crc_t10dif ata_generic usbhid hid qla2xxx scsi_transport_fc scsi_tgt crc32c_intel ata_piix uhci_hcd libata ehci_hcd megaraid_sas usbcore scsi_mod usb_common bnx2
[11496.556105] Pid: 4865, comm: filebench Tainted: G      D W    3.8.2-debug #60
[11496.556198] Call Trace:
[11496.556291]  [<ffffffff81040a43>] warn_slowpath_common+0x80/0x98
[11496.556384]  [<ffffffff81040a70>] warn_slowpath_null+0x15/0x17
[11496.556506]  [<ffffffffa027e34c>] btrfs_log_inode_parent+0x28e/0x2f1 [btrfs]
[11496.556634]  [<ffffffffa027e443>] btrfs_log_dentry_safe+0x38/0x51 [btrfs]
[11496.556758]  [<ffffffffa025e597>] btrfs_sync_file+0x162/0x1e5 [btrfs]
[11496.556854]  [<ffffffff8114e37d>] vfs_fsync_range+0x18/0x21
[11496.556944]  [<ffffffff8114e39d>] vfs_fsync+0x17/0x19
[11496.557033]  [<ffffffff8114e558>] do_fsync+0x35/0x53
[11496.557125]  [<ffffffff811ef729>] ? lockdep_sys_exit_thunk+0x35/0x67
[11496.557218]  [<ffffffff8114e593>] sys_fsync+0xb/0xf
[11496.557309]  [<ffffffff813ba7a9>] system_call_fastpath+0x16/0x1b
[11496.557400] ---[ end trace 568976af2f674ce7 ]---

And the benchmark will subsequently terminate in exception.  Is there any path towards this problem?

Thanks.
