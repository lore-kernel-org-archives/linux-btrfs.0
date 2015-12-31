Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.mail.nexica.com ([217.13.116.17]:52328 "EHLO
	relay1.mail.nexica.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbLaL1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 06:27:22 -0500
Received: from cl5-smtp.mail.nexica.com (zeus02nex.noc.nexica.com [10.2.0.151])
	by relay1.noc.nexica.com (Postfix) with ESMTP id F349B133343
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 12:27:16 +0100 (CET)
Received: from vnxbcnex02.bcn.nexica.com (unknown [212.92.38.69])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: relay.nexica.com)
	by cl5-smtp.mail.nexica.com (Postfix) with ESMTP id ED50812B5FA
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 12:27:15 +0100 (CET)
From: Xavier Romero <XRomero@nexica.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: quota rescan hangs
Date: Thu, 31 Dec 2015 11:27:14 +0000
Message-ID: <1a346afac4b9446ab93cf8c1a6f4e13a@nex-exchng-01-v.bcn.nexica.com>
References: <785a5727b63b495cabeed26742515a9f@nex-exchng-01-v.bcn.nexica.com>
In-Reply-To: <785a5727b63b495cabeed26742515a9f@nex-exchng-01-v.bcn.nexica.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After restarting and removing all data, "qgroup show " tells me that a rescan is in progress, but "quota rescan -s" tells me the opposite.

[root@nex-dstrg-ctrl-1 btrfs]# btrfs quota rescan -w /mnt/btrfs/
quota rescan started

[root@nex-dstrg-ctrl-1 btrfs]# btrfs quota rescan -s /mnt/btrfs/
no rescan operation in progress

 [root@nex-dstrg-ctrl-1 btrfs]# btrfs qgroup show -pcre /mnt/btrfs/
WARNING: Rescan is running, qgroup data may be incorrect
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          16.00KiB     16.00KiB        0.00B        0.00B ---     ---
0/389           0.00B        0.00B        0.00B        0.00B ---     ---
0/391           0.00B        0.00B     10.00GiB        0.00B ---     ---
0/525         9.99GiB        0.00B        0.00B        0.00B ---     ---
0/599        16.00KiB     16.00KiB      2.00GiB        0.00B ---     ---

[root@nex-dstrg-ctrl-1 btrfs]# btrfs sub list /mnt/btrfs/
ID 599 gen 10754 top level 5 path CLOUD_SSD_02

Not sure how to proceed !

-----Mensaje original-----
De: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] En nombre de Xavier Romero
Enviado el: dijous, 31 de desembre de 2015 11:09
Para: linux-btrfs@vger.kernel.org
Asunto: quota rescan hangs

Hello,

Using BTRFS on CentOS 7, I get the filesystem hung by running btrfs quota rescan  /mnt/btrfs/

After that I could not access to the filesystem anymore until system restart.

I did the scan because BTRFS suggested it:
[root@nex-dstrg-ctrl-1 btrfs]# btrfs qgroup show -F /mnt/btrfs/
WARNING: Qgroup data inconsistent, rescan recommended
qgroupid         rfer         excl
--------         ----         ----
0/5          27.91GiB     27.91GiB
[root@nex-dstrg-ctrl-1 ~]# btrfs qgroup show -pcre /mnt/btrfs/
WARNING: Qgroup data inconsistent, rescan recommended
qgroupid         rfer         excl     max_rfer     max_excl parent  child
--------         ----         ----     --------     -------- ------  -----
0/5          27.91GiB     27.91GiB        0.00B        0.00B ---     ---
0/389         9.77GiB      9.77GiB        0.00B        0.00B ---     ---
0/391        16.00KiB     16.00KiB     10.00GiB        0.00B ---     ---
0/525         9.99GiB        0.00B        0.00B        0.00B ---     ---
0/599        16.00KiB     16.00KiB      2.00GiB        0.00B ---     ---

dmesg output:
[154385.628385] INFO: task btrfs:22324 blocked for more than 120 seconds.
[154385.629044] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[154385.629648] btrfs           D ffff881fc3bdef20     0 22324   3677 0x00000080
[154385.629652]  ffff88114d01bc60 0000000000000082 ffff880e2fecae00 ffff88114d01bfd8 [154385.629656]  ffff88114d01bfd8 ffff88114d01bfd8 ffff880e2fecae00 ffff881fc3be1100 [154385.629658]  ffff883fc826c9f0 ffff883fc826c9f0 0000000000000001 ffff881fc3bdef20 [154385.629661] Call Trace:
[154385.629673]  [<ffffffff8163a889>] schedule+0x29/0x70 [154385.629690]  [<ffffffffa0707117>] wait_current_trans.isra.20+0xe7/0x130 [btrfs] [154385.629696]  [<ffffffff810a6ae0>] ? wake_up_atomic_t+0x30/0x30 [154385.629704]  [<ffffffffa07089b8>] start_transaction+0x2b8/0x5a0 [btrfs] [154385.629711]  [<ffffffffa0708cf7>] btrfs_join_transaction+0x17/0x20 [btrfs] [154385.629722]  [<ffffffffa0771569>] btrfs_qgroup_rescan+0x39/0x90 [btrfs] [154385.629731]  [<ffffffffa0741d22>] btrfs_ioctl+0x20b2/0x2b70 [btrfs] [154385.629736]  [<ffffffff811d1552>] ? __mem_cgroup_commit_charge+0x152/0x390
[154385.629740]  [<ffffffff81177d5e>] ? lru_cache_add+0xe/0x10 [154385.629745]  [<ffffffff811a1af1>] ? page_add_new_anon_rmap+0x91/0x130 [154385.629750]  [<ffffffff81197290>] ? handle_mm_fault+0x7c0/0xf50 [154385.629752]  [<ffffffff8119bb98>] ? __vma_link_rb+0xb8/0xe0 [154385.629759]  [<ffffffff811f1e85>] do_vfs_ioctl+0x2e5/0x4c0 [154385.629765]  [<ffffffff8128bbfe>] ? file_has_perm+0xae/0xc0 [154385.629769]  [<ffffffff81640d01>] ? __do_page_fault+0xb1/0x450 [154385.629771]  [<ffffffff811f2101>] SyS_ioctl+0xa1/0xc0 [154385.629776]  [<ffffffff816458c9>] system_call_fastpath+0x16/0x1b

Additional Info:

[root@nex-dstrg-ctrl-1 ~]# modinfo btrfs
filename:       /lib/modules/3.10.0-327.3.1.el7.x86_64/kernel/fs/btrfs/btrfs.ko
license:        GPL
alias:          devname:btrfs-control
alias:          char-major-10-234
alias:          fs-btrfs
rhelversion:    7.2
srcversion:     B92059408E7CB90AE2D9A2F
depends:        raid6_pq,xor,zlib_deflate
intree:         Y
vermagic:       3.10.0-327.3.1.el7.x86_64 SMP mod_unload modversions
signer:         CentOS Linux kernel signing key
sig_key:        3D:4E:71:B0:42:9A:39:8B:8B:78:3B:6F:8B:ED:3B:AF:09:9E:E9:A7
sig_hashalgo:   sha256
[root@nex-dstrg-ctrl-1 ~]# btrfs filesystem show /mnt/btrfs/
Label: none  uuid: 6289b7b3-ba25-4c9e-af95-4a5fb18eeea1
        Total devices 12 FS bytes used 29.86GiB
        devid    1 size 894.13GiB used 4.52GiB path /dev/md101
        devid    2 size 894.13GiB used 4.52GiB path /dev/md102
        devid    3 size 894.13GiB used 4.52GiB path /dev/md103
        devid    4 size 894.13GiB used 4.52GiB path /dev/md104
        devid    5 size 894.13GiB used 4.52GiB path /dev/md105
        devid    6 size 894.13GiB used 4.52GiB path /dev/md106
        devid    7 size 894.13GiB used 4.52GiB path /dev/md107
        devid    8 size 894.13GiB used 4.52GiB path /dev/md108
        devid    9 size 894.13GiB used 4.52GiB path /dev/md109
        devid   10 size 894.13GiB used 4.52GiB path /dev/md110
        devid   11 size 894.13GiB used 4.52GiB path /dev/md111
        devid   12 size 894.13GiB used 4.52GiB path /dev/md112

btrfs-progs v3.19.1
[root@nex-dstrg-ctrl-1 ~]# btrfs quota rescan -s /mnt/btrfs/ rescan operation running (current key 0)
[root@nex-dstrg-ctrl-1 ~]# btrfs subvolume list /mnt/btrfs/ ID 389 gen 10663 top level 5 path vol0 ID 391 gen 10514 top level 5 path vol1 ID 599 gen 10664 top level 5 path CLOUD_SSD_02


I'm just starting with BTRFS so I could be doing something wrong! Any ideas?

Best regards,
Xavier Romero

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
