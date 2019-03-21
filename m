Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19785C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 23:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C111821874
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 23:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="RA5E5Fkl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfCUXXh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 19:23:37 -0400
Received: from mout.web.de ([212.227.15.4]:43315 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbfCUXXh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 19:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1553210615;
        bh=9AjbOs1O4rkR1wqM003rVzkki6HkIoFPyk/tHAKuaoM=;
        h=X-UI-Sender-Class:From:To:Subject:Date:References;
        b=RA5E5FklhAdw1m6qQxbGDQt3VPjsdI+neNsGUatVe64as7ZPcZpE3punEPldbf44k
         Q7uj3NRWfYCNR31BgXkcVSUN1u4sHBXVXggJHoNmKH1yT5IU2yGAK6SzUkgDSAqUm/
         hz1cakozEL/VOUqq3HcjJl6gm0YP1nIAUuTpt+yo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [178.203.184.97] ([178.203.184.97]) by web-mail.web.de
 (3c-app-webde-bs36.server.lan [172.19.170.36]) (via HTTP); Fri, 22 Mar 2019
 00:23:34 +0100
MIME-Version: 1.0
Message-ID: <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>
From:   "Thorsten Hirsch" <T.Hirsch@web.de>
To:     linux-btrfs@vger.kernel.org
Subject: Fw: kernel oops when mounting btrfs
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 22 Mar 2019 00:23:34 +0100
Importance: normal
Sensitivity: Normal
References: <trinity-49be13bc-b1ea-4ab2-81a5-6d32096c62fb-1553194614498@3c-app-webde-bap65>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:SOyt2Lg9Ji/K9+zMq8EsbNsk0d+rYoPesZ93kVUsvGSb1zkNG8dHP6FHzdNuD18hLpOXH
 MpWuO7N85adcoYWphsQd4U7VYG1z8/GIhj0xixUBBV/7RhiViI9v2xFlUAOCwXB9MADorc2eeXs/
 y/7ga5QNzDa/AURO7dZ0+P7AVbQH7sa1CO5vDmzyvi2usxWXOCThstsJUB4MUic2jgsKwGf8rznG
 5mRCIZB2Hf/K2EP/cKThi+7NGI1jnRAqzJof2WO1Irvdqam3FzwZHctbcSxduhUAGz/AaCAsi3Sl
 h8=
X-UI-Out-Filterresults: notjunk:1;V03:K0:43Xs2SQ1rPc=:2dDC787gWcp28MDTigvnf7
 iif/vmqRbT+APyCObcHWX+HUfq4yo18rYTis2avDoolEkmgywZHr3bXdh/Ug3yfNnSw9Y+a9z
 DiQQ1QO9Cs7TsY6SdwCT2GQ7q6eaXk/WIs+erwGXWq0Ut4C3PFzYd+GhbETjlcd99/BoGhBbW
 Jl5pPP0FNWzA7fyrppksrm81OHzxh6nFN8zlxBzrNbZKpp1GU4Qk9LJvWYdrrJUfKwTTqzhYe
 /7mTkSgi37u87qJTu7x/S4ayti0TVKcIYXo/44DszfP9vfiDDhjtjUoYe5Xx02sRG7bVz5KDX
 eQsvM4pkzDylXScvyHnBVMwUSEFzbcCy0rHt4ovxuUTsJQct3PpA6V5xOqEcENERrijbZmAVG
 jrFRHqMxQ/Wo/Lc3Zj2x3soVTEUc6d3VsDWu0YoXSlKjkoM0pVQzqIW8TXy5r10QjplLr3mLG
 xcn3DBlKdvV6Yhk2GWd+PsvmALaPSij+TuBv5aUq5zHCxc7qZU3gBZJD90yViEs168Zl/hNtX
 pWXxRywHq5AlVD6UJXOZ82fMpmL28S5ZXznerMqy4aoPg+b91XlOLTI2PiAhcDusdhhghszuf
 vFVLkL9tInK/U=
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Meanwhile I upgraded to kernel 5.0, but the problem remained the same. So =
I zeroed the log with btrfs rescue zero-log. The command was successful, h=
owever the problem still remains more or less the same, which means:

- I still get a kernel oops when mounting.
- The stack trace looks a bit different now, e.g. RIP 0010 is not null any=
more, and there's another RIP code: 0033. Maybe "set_page_dirty" is intere=
sting, too. But see for yourserlf below.

Any ideas?

Thorsten Hirsch

P.S.: btrfs check --readonly tells me that everything's fine. But it alrea=
dy did so before zeroing the log.


[   12.400224] BTRFS: device label Linux devid 1 transid 30104 /dev/nvme0n=
1p3
[   12.400523] BTRFS info (device nvme0n1p3): disk space caching is enable=
d
[   12.400524] BTRFS info (device nvme0n1p3): has skinny extents
[   12.427049] BTRFS info (device nvme0n1p3): enabling ssd optimizations
[   12.461362] init_special_inode: bogus i_mode (0) for inode nvme0n1p3:88=
2
[   12.462844] init_special_inode: bogus i_mode (0) for inode nvme0n1p3:80=
2
[   12.515489] BUG: unable to handle kernel NULL pointer dereference at 00=
00000000000001
[   12.515491] #PF error: [normal kernel read fault]
[   12.515492] PGD 0 P4D 0
[   12.515495] Oops: 0000 [#1] SMP NOPTI
[   12.515497] CPU: 8 PID: 487 Comm: exe Not tainted 5.0.0-7-generic #8-Ub=
untu
[   12.515499] Hardware name: Gigabyte Technology Co., Ltd. AB350M-DS3H/AB=
350M-DS3H-CF, BIOS F24 12/25/2018
[   12.515504] RIP: 0010:__set_page_dirty_buffers+0x4c/0x100
[   12.515506] Code: 84 00 00 00 49 89 c5 4c 89 e7 e8 df 71 73 00 48 8b 03=
 f6 c4 20 74 28 48 8b 03 f6 c4 20 0f 84 ae 00 00 00 48 8b 43 28 48 89 c2 <=
48> 8b 0a 83 e1 02 75 04 f0 80 0a 02 48 8b 52 08 48 39 d0 75 eb 48
[   12.515507] RSP: 0018:ffffa9d2c28e7688 EFLAGS: 00010202
[   12.515509] RAX: 0000000000000001 RBX: ffffe34f45261300 RCX: 0000000000=
000000
[   12.515510] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8fc1b8=
0b784c
[   12.515512] RBP: ffffa9d2c28e76a0 R08: 0000000000028200 R09: ffffffffc0=
7af588
[   12.515513] R10: ffff8fc1cc594000 R11: ffff8fc1ba605ff0 R12: ffff8fc1b8=
0b784c
[   12.515514] R13: ffff8fc1b80b77c8 R14: ffff8fc1bc255600 R15: 0000000000=
000040
[   12.515516] FS:  00007f2fafc505c0(0000) GS:ffff8fc1cec00000(0000) knlGS=
:0000000000000000
[   12.515517] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.515518] CR2: 0000000000000001 CR3: 00000003fe150000 CR4: 0000000000=
3406e0
[   12.515520] Call Trace:
[   12.515524]  set_page_dirty+0x5e/0xb0
[   12.515541]  btrfs_dirty_pages+0x11f/0x2a0 [btrfs]
[   12.515562]  ? io_ctl_set_crc+0x5e/0xf0 [btrfs]
[   12.515576]  __btrfs_write_out_cache+0x3aa/0x470 [btrfs]
[   12.515590]  btrfs_write_out_cache+0x9a/0xf0 [btrfs]
[   12.515600]  btrfs_write_dirty_block_groups+0x293/0x3a0 [btrfs]
[   12.515611]  ? btrfs_run_delayed_refs+0xa7/0x190 [btrfs]
[   12.515622]  commit_cowonly_roots+0x21a/0x2c0 [btrfs]
[   12.515634]  btrfs_commit_transaction+0x32e/0x8c0 [btrfs]
[   12.515647]  btrfs_recover_log_trees+0x392/0x430 [btrfs]
[   12.515660]  ? replay_dir_deletes+0x2a0/0x2a0 [btrfs]
[   12.515671]  open_ctree+0x1b2c/0x1bb0 [btrfs]
[   12.515681]  btrfs_mount_root+0x4ff/0x650 [btrfs]
[   12.515683]  ? cpumask_next+0x1b/0x20
[   12.515685]  ? pcpu_alloc+0x1bd/0x610
[   12.515687]  mount_fs+0x51/0x165
[   12.515689]  vfs_kern_mount.part.38+0x5d/0x110
[   12.515691]  vfs_kern_mount+0x13/0x20
[   12.515700]  btrfs_mount+0x16f/0x860 [btrfs]
[   12.515702]  ? pcpu_block_update_hint_alloc+0x1af/0x200
[   12.515703]  ? pcpu_alloc_area+0xed/0x140
[   12.515704]  ? pcpu_next_unpop+0x3c/0x50
[   12.515706]  ? cpumask_next+0x1b/0x20
[   12.515707]  ? pcpu_alloc+0x1bd/0x610
[   12.515708]  mount_fs+0x51/0x165
[   12.515709]  ? mount_fs+0x51/0x165
[   12.515711]  vfs_kern_mount.part.38+0x5d/0x110
[   12.515712]  do_mount+0x22f/0xd50
[   12.515714]  ? __check_object_size+0x166/0x192
[   12.515716]  ? memdup_user+0x4f/0x80
[   12.515717]  ksys_mount+0xb6/0xd0
[   12.515718]  __x64_sys_mount+0x25/0x30
[   12.515720]  do_syscall_64+0x5a/0x110
[   12.515722]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   12.515723] RIP: 0033:0x7f2fafb82aca
[   12.515725] Code: 48 8b 0d c9 53 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66=
 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 96 53 0c 00 f7 d8 64 89 01 48
[   12.515726] RSP: 002b:00007ffde16c06c8 EFLAGS: 00000202 ORIG_RAX: 00000=
000000000a5
[   12.515727] RAX: ffffffffffffffda RBX: 0000000000008401 RCX: 00007f2faf=
b82aca
[   12.515728] RDX: 00007ffde16c2dd5 RSI: 00007ffde16c2df8 RDI: 00007ffde1=
6c2de9
[   12.515728] RBP: 00007f2fafc50540 R08: 0000000000000000 R09: 0000000000=
000000
[   12.515729] R10: 0000000000008401 R11: 0000000000000202 R12: 0000000000=
000000
[   12.515730] R13: 0000000000000000 R14: 00007ffde16c0938 R15: 0000000000=
000000
[   12.515731] Modules linked in: btrfs xor zstd_compress raid6_pq libcrc3=
2c nls_iso8859_1 dm_mirror dm_region_hash dm_log uas usb_storage hid_gener=
ic usbhid hid amdgpu chash amd_iommu_v2 gpu_sched i2c_algo_bit ttm drm_kms=
_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm r8169 i2c_piix4 =
ahci nvme realtek libahci nvme_core wmi gpio_amdpt gpio_generic
[   12.515742] CR2: 0000000000000001
[   12.515744] ---[ end trace 3e026a4bcaf67667 ]---
[   12.515745] RIP: 0010:__set_page_dirty_buffers+0x4c/0x100
[   12.515746] Code: 84 00 00 00 49 89 c5 4c 89 e7 e8 df 71 73 00 48 8b 03=
 f6 c4 20 74 28 48 8b 03 f6 c4 20 0f 84 ae 00 00 00 48 8b 43 28 48 89 c2 <=
48> 8b 0a 83 e1 02 75 04 f0 80 0a 02 48 8b 52 08 48 39 d0 75 eb 48
[   12.515747] RSP: 0018:ffffa9d2c28e7688 EFLAGS: 00010202
[   12.515748] RAX: 0000000000000001 RBX: ffffe34f45261300 RCX: 0000000000=
000000
[   12.515749] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8fc1b8=
0b784c
[   12.515750] RBP: ffffa9d2c28e76a0 R08: 0000000000028200 R09: ffffffffc0=
7af588
[   12.515750] R10: ffff8fc1cc594000 R11: ffff8fc1ba605ff0 R12: ffff8fc1b8=
0b784c
[   12.515751] R13: ffff8fc1b80b77c8 R14: ffff8fc1bc255600 R15: 0000000000=
000040
[   12.515752] FS:  00007f2fafc505c0(0000) GS:ffff8fc1cec00000(0000) knlGS=
:0000000000000000
[   12.515753] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.515754] CR2: 0000000000000001 CR3: 00000003fe150000 CR4: 0000000000=
3406e0
