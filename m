Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9EDC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 09:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5775E218AD
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 09:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbfBRJBm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 04:01:42 -0500
Received: from mout.gmx.net ([212.227.15.15]:36479 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727570AbfBRJBm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 04:01:42 -0500
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MH0SI-1gqeqf0ahu-00DpdD for
 <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 10:01:39 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     linux-btrfs@vger.kernel.org
Reply-To: linux-btrfs@vger.kernel.org
Subject: raid1 mount as read only
Date:   Mon, 18 Feb 2019 10:01:38 +0100
Message-ID: <1788794.QoebbjtCvL@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.9.0-8-amd64; KDE/5.28.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:S4G9Pt79NARvb1Y6fp/7aEEKhlflff/HGoj/Ige6+RplDetLj8U
 Tc1EXOBYfBZ+NcQ8Uexj1ozjZz7PJMuEOGCqe75dwMZlZAdV0cwImP8ZYvg0IJ4lC+6c0+J
 Fq9tYv4WVGxnF5Wr8QOVsrOKB59ACxEvAhMmdkc+QgYCUTfd9HqYQNDnNPAtaV4HFoNgRgg
 XHmsSWiDrTxawKmFPd+3g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8isWJRbRbqU=:d7qYTq6mMmqm0mdaeBkcKM
 8IbTRqtgJUhWJn7srGKP/E9He7zxH7OcBzCn1NlnXS3/m2zBGdyey0MrmLsUFbPusjH8oP1fI
 UMXulFGQjUzYYr9x3GJkviFYKkgAi70zxTMhtreXjvIkk+plGe2EnTl0qUulL2ly/Y+2lEIET
 KTzD9yjyoCmaT4XXH4ADpT9oYnDuMO1ncefeq7e7CKnhOiYKazMzNpvyrHUL+YUuiETjnF5Ba
 1mNxj8TngN/tLJg+hTGf4y2IUElN5jn/kyomaSgqZLNuMQHwylrB3mup+LJXNARjADmT20NA9
 8xmcsiD8jOxevf4Njye+0W5oGqPqrGr9nDLidFOVypBnT+Ds5nqb0eitas5lTGcBjBB/aFX3E
 DO2dPxSveIf+ot/L1EJjhoba0gyXIGrYcYJxQA9eJCIaNu0DwOmp7LrPZko/jU2HgDGnY39yj
 z1bjqY3Bbq9UsjCYcMzqSAE6CA13N5oHyC7cdDB4IJS1QTlxpK5hHwMAa9LbB4U+zSTyKdydi
 TZlyr2KE8xCDmSQEGbPKGr7e9EGQ6mgnDPNPG+BLa2HhfNBq/6yRM39ayrP4c4EvIAimnf4Al
 3YGOc1DGK82wqY38RWJd9w/n7CU4xoc7wqTCBSA8RuCQfO/xcEbvFv4DjDMWwQm3xu1ROzgFI
 kgbl/3WbUmivxPh5KLatw8RKSx/T5daDU2Xtq8WB7ft9RQSt5PL++TvTYr555UiNQSex/xDUj
 IMk2YxZZJuWYUZQM38Hsv3kzEuwVJ4RPFgp/BKjJOJo+kjzv4aVSm8BKeN0dn/5/dSjjt2109
 vIc3i6szJRrdZRkdukuAhvCEbvp967cwIiMFumHWRryhU6I+75DrMfAoML/H1srvdvp5Xp49k
 OgbvZ9qPIwru3liKg9PBdRUE4aODRh/kAw09A/Rp44g4n2GDEGAzVKDE5apthlLRSJq+liMsx
 K0d4PCn4QuA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I've played a little bit with raid1:
my steps was:
1. create a raid1 with btrfs (add device; balance start -mconvert=raid1 -dconvert=raid1 /)
2.  after finishing, i shutdown the server and remove a device and start it again,
3. it works (i used degraded options in fstab)
4. I shutdown the server, add the 'old' device, start it and run a btrfs balance
5. until here everything is fine
6. I shutdown the server, remove the other harddisk, and start it, 
7. it works
8. I shutdown the server, add the 'old' device, start it and try a btrfs balance
9. but now the FS is mounted as read only

I got the following messages in dmesg:
[    6.401740] BTRFS: device fsid b997e926-ab95-46d0-a9be-da52aa09203d devid 1 transid 3570 /dev/sda1
[    6.403079] BTRFS info (device sda1): allowing degraded mounts
[    6.403084] BTRFS info (device sda1): disk space caching is enabled
[    6.403086] BTRFS info (device sda1): has skinny extents
[    6.405878] BTRFS warning (device sda1): devid 2 uuid 09a7c9f6-9a13-4852-bca6-2d9120f388d4 missing
[    6.409108] BTRFS info (device sda1): detected SSD devices, enabling SSD mode

[    6.652411] BTRFS info (device sda1): allowing degraded mounts
[    6.652414] BTRFS info (device sda1): disk space caching is enabled
[    6.652416] BTRFS warning (device sda1): too many missing devices, writeable remount is not allowed

but all devices are available:
btrfs fi sh
Label: none  uuid: b997e926-ab95-46d0-a9be-da52aa09203d
        Total devices 2 FS bytes used 895.41MiB
        devid    1 size 223.57GiB used 4.06GiB path /dev/sda1
        devid    2 size 223.57GiB used 2.00GiB path /dev/sdb1

mount | grep btrfs
/dev/sda1 on / type btrfs (ro,relatime,degraded,ssd,space_cache,subvolid=5,subvol=/)

If I try to remount it via, I got the following in dmesg:
mount -o remount,rw b997e926-ab95-46d0-a9be-da52aa09203d /
[  320.048563] BTRFS info (device sda1): disk space caching is enabled
[  356.200552] BTRFS: error (device sda1) in write_all_supers:3752: errno=-5 IO failure (errors while submitting device barriers.)
[  356.200628] BTRFS info (device sda1): forced readonly
[  356.200632] BTRFS warning (device sda1): Skipping commit of aborted transaction.
[  356.200633] ------------[ cut here ]------------
[  356.200677] WARNING: CPU: 0 PID: 1914 at /build/linux-EbeuWA/linux-4.9.130/fs/btrfs/transaction.c:1850 cleanup_transaction+0x1f3/0x2e0 [btrfs]
[  356.200678] BTRFS: Transaction aborted (error -5)
[  356.200679] Modules linked in: intel_rapl skx_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel mgag200 ttm drm_kms_helper intel_uncore sg drm dcdbas mei_me i2c_algo_bit intel_rapl_perf pcspkr joydev iTCO_wdt lpc_ich iTCO_vendor_support mfd_core shpchp mei evdev ipmi_si ipmi_msghandler acpi_power_meter button ip_tables x_tables autofs4 ses enclosure scsi_transport_sas sd_mod hid_generic usbhid hid btrfs crc32c_generic xor raid6_pq crc32c_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd ahci xhci_pci libahci tg3 xhci_hcd ptp megaraid_sas libata pps_core i2c_i801 usbcore bnxt_en i2c_smbus libphy scsi_mod usb_common
[  356.200764] CPU: 0 PID: 1914 Comm: btrfs-transacti Not tainted 4.9.0-8-amd64 #1 Debian 4.9.130-2
[  356.200766] Hardware name: Dell Inc. PowerEdge R840/08XR9M, BIOS 1.2.4 10/18/2018
[  356.200768]  0000000000000000 ffffffff9ef33d74 ffffb9535d70fd50 0000000000000000
[  356.200774]  ffffffff9ec7a59e ffff8ea977b261f8 ffffb9535d70fda8 ffff8e9971cdd500
[  356.200778]  00000000fffffffb ffff8ea97114c980 0000000000000000 ffffffff9ec7a61f
[  356.200783] Call Trace:
[  356.200796]  [<ffffffff9ef33d74>] ? dump_stack+0x5c/0x78
[  356.200801]  [<ffffffff9ec7a59e>] ? __warn+0xbe/0xe0
[  356.200803]  [<ffffffff9ec7a61f>] ? warn_slowpath_fmt+0x5f/0x80
[  356.200828]  [<ffffffffc04ac423>] ? cleanup_transaction+0x1f3/0x2e0 [btrfs]
[  356.200835]  [<ffffffff9ecbd210>] ? prepare_to_wait_event+0xf0/0xf0
[  356.200858]  [<ffffffffc04ade78>] ? btrfs_commit_transaction+0x298/0xa10 [btrfs]
[  356.200879]  [<ffffffffc04ae686>] ? start_transaction+0x96/0x480 [btrfs]
[  356.200900]  [<ffffffffc04a8a8c>] ? transaction_kthread+0x1dc/0x200 [btrfs]
[  356.200919]  [<ffffffffc04a88b0>] ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
[  356.200926]  [<ffffffff9ec9a569>] ? kthread+0xd9/0xf0
[  356.200933]  [<ffffffff9f2190a4>] ? __switch_to_asm+0x34/0x70
[  356.200937]  [<ffffffff9ec9a490>] ? kthread_park+0x60/0x60
[  356.200941]  [<ffffffff9f219137>] ? ret_from_fork+0x57/0x70
[  356.200943] ---[ end trace 17ece06f94583f5a ]---
[  356.200946] BTRFS: error (device sda1) in cleanup_transaction:1850: errno=-5 IO failure
[  356.200997] BTRFS info (device sda1): delayed_refs has NO entry


My question is whats happen and how can I fix this?

uname -a
Linux yamazaki-06 4.9.0-8-amd64 #1 SMP Debian 4.9.130-2 (2018-10-27) x86_64 GNU/Linux

btrfs version
btrfs-progs v4.7.3


