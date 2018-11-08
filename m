Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4F6C43441
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 22:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95FB920844
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 22:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XC2tg3Rd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95FB920844
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbeKIISe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 03:18:34 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41514 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbeKIISd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Nov 2018 03:18:33 -0500
Received: by mail-ed1-f67.google.com with SMTP id c25-v6so240117edt.8
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Nov 2018 14:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:openpgp:autocrypt:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=Iltm4RccFqipR5n2X7kgZT0WvsOepLO12Y8t7oX3d74=;
        b=XC2tg3Rdw96Oz8Y93L7FXRge0mkWuewx/zRf0zMsbi66FOYqofq2Q08lYCyWgBcjkB
         QgFBL+1RNaaOnOf40RH86SfX8owJd+X2ki2niyNwa3iaDbcsYYi5eidJI8OM/oufG0eK
         l9UyfX8gBDIbth7TNGJJK/yWlnEh9jbYahAdQCs4mfg89eotV+3a0OXTm/23h52zkgkg
         N6DN1gSvmCxD3/4GC5yiTXcx2Qo+D2yXy0z2gf+ArC9Jlx8bXbZ/BelmTMvyIcYTlzkC
         1F4mRwCUP6b80pXjbswWTQX10lqDXLJRoSZxztNM9ywvdqMoAB3qK4Nl5UOFcNeGD/tN
         7QqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:openpgp:autocrypt:message-id
         :date:user-agent:mime-version:content-transfer-encoding
         :content-language;
        bh=Iltm4RccFqipR5n2X7kgZT0WvsOepLO12Y8t7oX3d74=;
        b=ghEDjty5bg8y+o9eJobZhY+mAs7e/YwQyWyk17DRx5nhkxTMmepA65MhA+loXZmvt7
         xDfxWl37GLKxBewk/XW/8AmddNWGQ8V4IFQVBQ8cB3/RvZv0ahPtqQX3xKQEzk9F7a1s
         Bpy8udO6CfZe9EtxdEZIcPjsRGtPj+UujTHd0fM3ocsdLTxRJ/uCOJlgFAAP4wqIapEp
         spYi5rySJMVYWhjOcLqON3zoPKyZLfdArOMObwp3Z4TcXit4RHOCR88/dd1HlmXL/wHz
         sFLaa1E05Te4a2PSIhzKNXqxkCJODaoQb7ICZyM97v8r0mm56iINpj8Vifm2cC2/8Jk3
         8LdQ==
X-Gm-Message-State: AGRZ1gKB4uiagzqpj+vEhn1XgvEkvK0VlgwQuEphXfFT/od5agEYqIjV
        yHyZaEg44jJcCua7Vu1zzJFCSnLp
X-Google-Smtp-Source: AJdET5cIrsjB7Ht0DN0wE5NEkOsoE9+YpeXQww9MUuE/5LEpwcZayjZkLoP17NWYiM5o10QZJLmANw==
X-Received: by 2002:a50:a824:: with SMTP id j33-v6mr212329edc.230.1541716849000;
        Thu, 08 Nov 2018 14:40:49 -0800 (PST)
Received: from ?IPv6:2a02:578:4009:0:724d:7bff:fe2e:5963? ([2a02:578:4009:0:724d:7bff:fe2e:5963])
        by smtp.gmail.com with ESMTPSA id h1-v6sm754798eja.45.2018.11.08.14.40.48
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 14:40:48 -0800 (PST)
To:     linux-btrfs@vger.kernel.org
From:   Pieter Maes <maescool@gmail.com>
Subject: Full filesystem btrfs rebalance kernel panic to read-only lock
Openpgp: preference=signencrypt
Autocrypt: addr=maescool@gmail.com; prefer-encrypt=mutual; keydata=
 xsBNBE+ljjwBCADunl07R5VLmI0jI9Zk0uXB9GvRQWQmLjSW2o1SMiU+sLC906cKeYltI2hX
 TSLLsN9TyeDMc3+1Ea0IC86+zSMXnjk/S5iVmYyFNYZXcvelW57KAQgnxTOCyvVYoT3aK45g
 PSF+YoM778raJLviwWTz6PLEjKRPJSHEQPLtikq1uDh8nybymQnhLjhzKOghscr9T9LE5pZ0
 Er0Md82jd4OzTyW5LMAcgLKBl7pyXNgszF0c5wJnHle/XDN2+cykaJ61LazE0gpoiz6fGTwS
 KdOjzZA2Ot/vs0ZUDor8L2joHybC9EnCQggBScwbM1Ypin0Xv1/m4wL5jdDoGVfhqIa9ABEB
 AAHNK1BpZXRlciBNYWVzIChNYWVzY29vbCkgPG1hZXNjb29sQGdtYWlsLmNvbT7CwHgEEwEC
 ACIFAk+ljjwCGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEIeJsZtyvy9KaxUH/1kj
 nJfBwnlIpy3nvxy0lFPuaSEKx5Tb+eFTtfGFMdJ4nGtkOUk2xd6MXLOLc6ycPJBTTTsoLG2Y
 GnLdmSWUHI54vh6HFQKfR8gF73bO+itkLTnyyemlJxrdjqnq2eA5ClmFKAJ6wPC5r2ykZD1E
 lbFamgwTBkbR2/2lkIsjz5UCKb5EhGm5L4KAiAc5JuRRTiSDfCdWOYX98Wy4wq/aH6+bGOwb
 yy/ZVfe6C8fav1/LvEYkQLeAYtvQAdH3sv1erXnIyJ5V9qkagzFQyZb/nG4PDJM1tb9Y75d6
 dOWdImwXaIGEcazN3CYOpfTuZoOgo0FaGsDOXf5s0vU8Vha//QTOwE0ET6WOPAEIAJgnB0Nf
 Q6hErlTqiwYRjvf81XLN/6EvHrmuaLdtpMxqYo/+zSjn+8MpqWQnJhpJGuIWC/CWWdLBF3xQ
 gd08hszhyFoYgWGw4DHvL8f/JsnqlrhQdScGNxPQkttsxfcNEMvmMfoOqoIG6HhYsPeBC2aq
 3/ybUyZbQb5MOWU+U4IpyswnfnD0aVx6sWOGVd6IOqgsb/LcWjVkK9O6PL7mtmnXSpVIs3wX
 /tZ6QN7+iNhGNzPrCkrHx5UqxIRegg52apJ84u8ZlSUPK52rY9dClGDCmiCEOI8mb8RgRkqk
 oP1w9rvwz7hDwao8JfrqVJZUCsX9bcJnK1ppZzyTZfA2KEsAEQEAAcLAXwQYAQIACQUCT6WO
 PAIbDAAKCRCHibGbcr8vSj7aB/44Mg71wdh+DMeQvebP+qW6Eb3bnFCxrCRL1kcPI1cGaISE
 8i7yZhP609+Qoghgl7NuQKQz3VLa4aQSqxQG+wOlAvJrH8HT/z8thmrT8u66aVpbGEVz6FGt
 ob5G63Gd9poCaTZDLBMAAUqHuYddGcnSOOy/Qnh8g88UcGWqQwULBno6VMW4kP+UIbVcnyo2
 GoV6FYH3JH6yIPKz6DBZDp+vYGJzvg2h96eS+Gx12pI8o5rbHTdZ5lsxB29lJWnOxhMDqGy4
 +hidY/pzZUUY7YLsvpW/f7k9Sh6JUfrO9xXSidpnZsmQVvsafPvozPxL5kRmn1lilnLXSGBn
 +331HKrM
Message-ID: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>
Date:   Thu, 8 Nov 2018 23:40:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

So, I've had the full disk issue, so when I tried re-balancing,
I got a panic, that pushed filesystem read-only and I'm unable to
balance or grow the filesystem now.

fs info:
btrfs fi show /
Label: none  uuid: 9b591b6b-6040-437e-9398-6883ca3bf1bb
    Total devices 1 FS bytes used 614.94GiB
    devid    1 size 750.00GiB used 750.00GiB path /dev/mapper/vg0-root

btrfs fi df /
Data, single: total=740.94GiB, used=610.75GiB
System, DUP: total=32.00MiB, used=112.00KiB
Metadata, DUP: total=4.50GiB, used=3.94GiB
GlobalReserve, single: total=512.00MiB, used=255.06MiB

btrfs sub list -ta /
ID    gen    top level    path   
--    ---    ---------    ----   

btrfs --version
btrfs-progs v4.4

Log when booting machine now from root:

----

[   54.746700] ------------[ cut here ]------------
[   54.746701] BTRFS: Transaction aborted (error -28)
[   54.746734] WARNING: CPU: 6 PID: 481 at
/build/linux-hwe-q2wgwz/linux-hwe-4.15.0/fs/btrfs/extent-tree.c:6997
__btrfs_free_extent.isra.62+0x2a7/0xdf0 [btrfs]
[   54.746734] Modules linked in: nfsd auth_rpcgss nfs_acl lockd grace
sunrpc autofs4 btrfs zstd_compress raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid0
multipath linear ast igb ttm drm_kms_helper dca i2c_algo_bit syscopyarea
sysfillrect sysimgblt raid1 fb_sys_fops bcache ahci ptp drm libahci
pps_core nvme nvme_core wmi
[   54.746748] CPU: 6 PID: 481 Comm: mount Not tainted 4.15.0-36-generic
#39~16.04.1-Ubuntu
[   54.746749] Hardware name: ASUSTeK COMPUTER INC. Z10PA-U8
Series/Z10PA-U8 Series, BIOS 3403 03/01/2017
[   54.746757] RIP: 0010:__btrfs_free_extent.isra.62+0x2a7/0xdf0 [btrfs]
[   54.746757] RSP: 0018:ffffb9540d66b858 EFLAGS: 00010286
[   54.746758] RAX: 0000000000000000 RBX: 0000019518102000 RCX:
0000000000000001
[   54.746759] RDX: 0000000000000001 RSI: 0000000000000002 RDI:
0000000000000246
[   54.746759] RBP: ffffb9540d66b900 R08: 0000000000000000 R09:
0000000000000026
[   54.746760] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff995a0b520000
[   54.746760] R13: 00000000ffffffe4 R14: ffff9959f7114230 R15:
0000000000000005
[   54.746761] FS:  00007f467684a840(0000) GS:ffff995a3f380000(0000)
knlGS:0000000000000000
[   54.746762] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   54.746762] CR2: 00007fca430351e4 CR3: 0000003f6dd6a004 CR4:
00000000001606e0
[   54.746763] Call Trace:
[   54.746768]  ? check_preempt_wakeup+0x210/0x240
[   54.746771]  ? tracing_record_taskinfo_skip+0x24/0x50
[   54.746772]  ? tracing_record_taskinfo+0x13/0x90
[   54.746780]  __btrfs_run_delayed_refs+0x322/0x11b0 [btrfs]
[   54.746782]  ? __set_page_dirty_nobuffers+0x11e/0x160
[   54.746791]  ? btree_set_page_dirty+0xe/0x10 [btrfs]
[   54.746800]  ? btrfs_mark_buffer_dirty+0x79/0xa0 [btrfs]
[   54.746808]  btrfs_run_delayed_refs+0xf6/0x1c0 [btrfs]
[   54.746817]  btrfs_truncate_inode_items+0xaf7/0x1000 [btrfs]
[   54.746825]  ? reserve_metadata_bytes+0x2e7/0xb10 [btrfs]
[   54.746835]  btrfs_evict_inode+0x47d/0x5a0 [btrfs]
[   54.746838]  evict+0xca/0x1a0
[   54.746839]  iput+0x1d2/0x220
[   54.746849]  btrfs_orphan_cleanup+0x20f/0x490 [btrfs]
[   54.746858]  btrfs_cleanup_fs_roots+0x11b/0x1c0 [btrfs]
[   54.746868]  ? lookup_extent_mapping+0x13/0x20 [btrfs]
[   54.746879]  ? btrfs_check_rw_degradable+0xf5/0x170 [btrfs]
[   54.746885]  btrfs_remount+0x2f1/0x520 [btrfs]
[   54.746887]  ? shrink_dcache_sb+0x12e/0x180
[   54.746889]  do_remount_sb+0x6d/0x1e0
[   54.746890]  do_mount+0x797/0xd00
[   54.746910]  ? memdup_user+0x4f/0x70
[   54.746912]  SyS_mount+0x95/0xe0
[   54.746914]  do_syscall_64+0x73/0x130
[   54.746916]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[   54.746917] RIP: 0033:0x7f4676129b9a
[   54.746917] RSP: 002b:00007ffc5d515838 EFLAGS: 00000202 ORIG_RAX:
00000000000000a5
[   54.746918] RAX: ffffffffffffffda RBX: 0000000000978030 RCX:
00007f4676129b9a
[   54.746919] RDX: 0000000000978210 RSI: 000000000097a520 RDI:
0000000000978230
[   54.746919] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000014
[   54.746920] R10: 00000000c0ed0020 R11: 0000000000000202 R12:
0000000000978230
[   54.746920] R13: 0000000000978210 R14: 0000000000000000 R15:
0000000000000003
[   54.746921] Code: 8b 45 90 48 8b 40 60 f0 0f ba a8 d8 cd 00 00 02 72
1b 41 83 fd fb 0f 84 5f 03 00 00 44 89 ee 48 c7 c7 58 76 51 c0 e8 a9 55
a2 de <0f> 0b 48 8b 7d 90 44 89 e9 ba 55 1b 00 00 48 c7 c6 80 08 51 c0
[   54.746934] ---[ end trace 18d422c4358ee800 ]---
[   54.746936] BTRFS: error (device dm-0) in __btrfs_free_extent:6997:
errno=-28 No space left
[   54.746937] BTRFS: error (device dm-0) in
btrfs_run_delayed_refs:3082: errno=-28 No space left
[   54.746976] BTRFS error (device dm-0): Error removing orphan entry,
stopping orphan cleanup
[   54.746977] BTRFS error (device dm-0): could not do orphan cleanup -22

root kernel: 4.15.0-36-generic #39~16.04.1-Ubuntu

----

When booting to a net/livecd rescue
First I run a check with repair:

----

enabling repair mode
Checking filesystem on /dev/vg0/root
UUID: 9b591b6b-6040-437e-9398-6883ca3bf1bb
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
reset nbytes for ino 6228034 root 5
checking csums
checking root refs
found 664259596288 bytes used err is 0
total csum bytes: 619404608
total tree bytes: 4237737984
total fs tree bytes: 1692581888
total extent tree bytes: 1461665792
btree space waste bytes: 945044758
file data blocks allocated: 1568329531392
 referenced 537131163648
----

But then when I try to mount the fs:

----

[Thu Nov  8 21:51:11 2018] BTRFS info (device dm-0): disk space caching
is enabled
[Thu Nov  8 21:51:12 2018] BTRFS info (device dm-0): detected SSD
devices, enabling SSD mode
[Thu Nov  8 21:51:12 2018] BUG: unable to handle kernel NULL pointer
dereference at 00000000000001f0
[Thu Nov  8 21:51:12 2018] IP: [<ffffffffa102c32d>]
can_overcommit+0x16/0xe2 [btrfs]
[Thu Nov  8 21:51:12 2018] PGD 0

[Thu Nov  8 21:51:12 2018] Oops: 0000 [#1] SMP
[Thu Nov  8 21:51:12 2018] Modules linked in: btrfs xor zlib_deflate
raid6_pq dm_mod bcache dell_rbu dcdbas sd_mod sg sb_edac
x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm irqbypass
crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw
psmouse glue_helper ablk_helper nvme iTCO_wdt evdev cryptd serio_raw
nvme_core i2c_i801 ahci lpc_ich mfd_core i2c_smbus libahci tpm_tis
tpm_tis_core tpm acpi_pad button ftsteutates(O) nct6775(O) hwmon_vid
coretemp ip_tables x_tables autofs4 igb i2c_algo_bit dca ptp pps_core
[last unloaded: ipmi_msghandler]
[Thu Nov  8 21:51:12 2018] CPU: 3 PID: 6 Comm: kworker/u24:0 Tainted:
G           O    4.9.120 #2
[Thu Nov  8 21:51:12 2018] Hardware name: ASUSTeK COMPUTER INC. Z10PA-U8
Series/Z10PA-U8 Series, BIOS 3403 03/01/2017
[Thu Nov  8 21:51:12 2018] Workqueue: events_unbound
btrfs_async_reclaim_metadata_space [btrfs]
[Thu Nov  8 21:51:12 2018] task: ffff883f65c0be80 task.stack:
ffff883f65c70000
[Thu Nov  8 21:51:12 2018] RIP: 0010:[<ffffffffa102c32d>] 
[<ffffffffa102c32d>] can_overcommit+0x16/0xe2 [btrfs]
[Thu Nov  8 21:51:12 2018] RSP: 0018:ffff883f65c73db8  EFLAGS: 00010246
[Thu Nov  8 21:51:12 2018] RAX: 0000000001000000 RBX: 0000000000000000
RCX: 0000000000000002
[Thu Nov  8 21:51:12 2018] RDX: 0000000000c00000 RSI: ffff883f6267b000
RDI: 0000000000000000
[Thu Nov  8 21:51:12 2018] RBP: ffff883f56681008 R08: 000000000000000c
R09: ffffffff8188fb40
[Thu Nov  8 21:51:12 2018] R10: ffff883f65e17e58 R11: 0000000000002490
R12: ffff883f56681008
[Thu Nov  8 21:51:12 2018] R13: ffff883f6267b0b8 R14: 0000000000000000
R15: ffff883f6267b000
[Thu Nov  8 21:51:12 2018] FS:  0000000000000000(0000)
GS:ffff883f7f2c0000(0000) knlGS:0000000000000000
[Thu Nov  8 21:51:12 2018] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Thu Nov  8 21:51:12 2018] CR2: 00000000000001f0 CR3: 0000000001808000
CR4: 0000000000160630
[Thu Nov  8 21:51:12 2018] Stack:
[Thu Nov  8 21:51:12 2018]  000000000000000c 0000000000000000
ffff883f56681008 ffff883f56681008
[Thu Nov  8 21:51:12 2018]  ffff883f6267b0b8 0000000000000000
ffff883f6267b000 ffffffffa10319bc
[Thu Nov  8 21:51:12 2018]  ffffffff814f7d14 ffff883f65c0be80
ffff883f6267b0a8 ffff883f663cb3c0
[Thu Nov  8 21:51:12 2018] Call Trace:
[Thu Nov  8 21:51:12 2018]  [<ffffffffa10319bc>] ?
btrfs_async_reclaim_metadata_space+0xce/0x331 [btrfs]
[Thu Nov  8 21:51:12 2018]  [<ffffffff814f7d14>] ? __switch_to_asm+0x24/0x60
[Thu Nov  8 21:51:13 2018]  [<ffffffff81064b85>] ?
process_one_work+0x19e/0x2be
[Thu Nov  8 21:51:13 2018]  [<ffffffff81065242>] ? worker_thread+0x2ad/0x395
[Thu Nov  8 21:51:13 2018]  [<ffffffff81064f95>] ?
rescuer_thread+0x2c9/0x2c9
[Thu Nov  8 21:51:13 2018]  [<ffffffff81068ff3>] ? kthread+0xe6/0xee
[Thu Nov  8 21:51:13 2018]  [<ffffffff814f7d14>] ? __switch_to_asm+0x24/0x60
[Thu Nov  8 21:51:13 2018]  [<ffffffff81068f0d>] ? kthread_park+0x4e/0x4e
[Thu Nov  8 21:51:13 2018]  [<ffffffff814f7da7>] ? ret_from_fork+0x57/0x70
[Thu Nov  8 21:51:13 2018] Code: 78 38 0f 95 c0 0f b6 c0 48 8d 44 00 02
48 89 c6 e9 f9 be ff ff f6 46 58 01 0f 85 d5 00 00 00 41 57 41 56 41 55
41 54 55 53 41 50 <4c> 8b af f0 01 00 00 4d 85 ed 75 02 0f 0b 48 89 f5
31 f6 89 4c
[Thu Nov  8 21:51:13 2018] RIP  [<ffffffffa102c32d>]
can_overcommit+0x16/0xe2 [btrfs]
[Thu Nov  8 21:51:13 2018]  RSP <ffff883f65c73db8>
[Thu Nov  8 21:51:13 2018] CR2: 00000000000001f0
[Thu Nov  8 21:51:13 2018] ---[ end trace 9f19e7801339a620 ]---
[Thu Nov  8 21:51:13 2018] BUG: unable to handle kernel NULL pointer
dereference at           (null)
[Thu Nov  8 21:51:13 2018] IP: [<ffffffff8107f905>]
__wake_up_common+0x1d/0x79
[Thu Nov  8 21:51:13 2018] PGD 0

[Thu Nov  8 21:51:13 2018] Oops: 0000 [#2] SMP
[Thu Nov  8 21:51:13 2018] Modules linked in: btrfs xor zlib_deflate
raid6_pq dm_mod bcache dell_rbu dcdbas sd_mod sg sb_edac
x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm irqbypass
crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw
psmouse glue_helper ablk_helper nvme iTCO_wdt evdev cryptd serio_raw
nvme_core i2c_i801 ahci lpc_ich mfd_core i2c_smbus libahci tpm_tis
tpm_tis_core tpm acpi_pad button ftsteutates(O) nct6775(O) hwmon_vid
coretemp ip_tables x_tables autofs4 igb i2c_algo_bit dca ptp pps_core
[last unloaded: ipmi_msghandler]
[Thu Nov  8 21:51:13 2018] CPU: 3 PID: 6 Comm: kworker/u24:0 Tainted:
G      D    O    4.9.120 #2
[Thu Nov  8 21:51:13 2018] Hardware name: ASUSTeK COMPUTER INC. Z10PA-U8
Series/Z10PA-U8 Series, BIOS 3403 03/01/2017
[Thu Nov  8 21:51:13 2018] task: ffff883f65c0be80 task.stack:
ffff883f65c70000
[Thu Nov  8 21:51:13 2018] RIP: 0010:[<ffffffff8107f905>] 
[<ffffffff8107f905>] __wake_up_common+0x1d/0x79
[Thu Nov  8 21:51:14 2018] RSP: 0018:ffff883f65c73e70  EFLAGS: 00010046
[Thu Nov  8 21:51:14 2018] RAX: 0000000000000286 RBX: ffff883f65c73f20
RCX: 0000000000000000
[Thu Nov  8 21:51:14 2018] RDX: 0000000000000000 RSI: 0000000000000003
RDI: ffff883f65c73f20
[Thu Nov  8 21:51:14 2018] RBP: ffff883f65c73f28 R08: 0000000000000000
R09: 0000000000000000
[Thu Nov  8 21:51:14 2018] R10: ffff883f65e17e58 R11: 00000000ad55ad55
R12: 0000000000000003
[Thu Nov  8 21:51:14 2018] R13: 0000000000000000 R14: 000000000000000b
R15: 0000000000000001
[Thu Nov  8 21:51:14 2018] FS:  0000000000000000(0000)
GS:ffff883f7f2c0000(0000) knlGS:0000000000000000
[Thu Nov  8 21:51:14 2018] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Thu Nov  8 21:51:14 2018] CR2: 0000000000000028 CR3: 0000000001808000
CR4: 0000000000160630
[Thu Nov  8 21:51:14 2018] Stack:
[Thu Nov  8 21:51:14 2018]  0000000000000000 ffff883f65c73f20
ffff883f65c73f18 0000000000000286
[Thu Nov  8 21:51:14 2018]  0000000000000001 000000000000000b
0000000000000000 ffffffff810800de
[Thu Nov  8 21:51:14 2018]  0000000000000000 ffff883f65c0be80
0000000000000001 ffffffff81050133
[Thu Nov  8 21:51:14 2018] Call Trace:
[Thu Nov  8 21:51:14 2018]  [<ffffffff810800de>] ? complete+0x2b/0x3a
[Thu Nov  8 21:51:14 2018]  [<ffffffff81050133>] ? mm_release+0xe5/0xef
[Thu Nov  8 21:51:14 2018]  [<ffffffff8105552b>] ? do_exit+0x269/0x8c4
[Thu Nov  8 21:51:14 2018]  [<ffffffff814f7d14>] ? __switch_to_asm+0x24/0x60
[Thu Nov  8 21:51:14 2018]  [<ffffffff814f9b17>] ?
rewind_stack_do_exit+0x17/0x20
[Thu Nov  8 21:51:14 2018] Code: 07 00 00 00 00 48 89 47 08 48 89 47 10
c3 41 57 41 56 41 89 d7 41 55 41 54 41 89 cd 55 53 48 8d 6f 08 41 51 48
8b 57 08 41 89 f4 <48> 8b 1a 48 8d 42 e8 48 83 eb 18 48 8d 50 18 48 39
ea 74 3c 4c
[Thu Nov  8 21:51:14 2018] RIP  [<ffffffff8107f905>]
__wake_up_common+0x1d/0x79
[Thu Nov  8 21:51:14 2018]  RSP <ffff883f65c73e70>
[Thu Nov  8 21:51:14 2018] CR2: 0000000000000000
[Thu Nov  8 21:51:14 2018] ---[ end trace 9f19e7801339a621 ]---
[Thu Nov  8 21:51:14 2018] Fixing recursive fault but reboot is needed!
[Thu Nov  8 21:51:14 2018] BUG: unable to handle kernel paging request
at ffffffffffffffd8
[Thu Nov  8 21:51:15 2018] IP: [<ffffffff8106978b>] kthread_data+0x7/0xc
[Thu Nov  8 21:51:15 2018] PGD 180d067
[Thu Nov  8 21:51:15 2018] PUD 180f067
[Thu Nov  8 21:51:15 2018] PMD 0

[Thu Nov  8 21:51:15 2018] Oops: 0000 [#3] SMP
[Thu Nov  8 21:51:15 2018] Modules linked in: btrfs xor zlib_deflate
raid6_pq dm_mod bcache dell_rbu dcdbas sd_mod sg sb_edac
x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm irqbypass
crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw
psmouse glue_helper ablk_helper nvme iTCO_wdt evdev cryptd serio_raw
nvme_core i2c_i801 ahci lpc_ich mfd_core i2c_smbus libahci tpm_tis
tpm_tis_core tpm acpi_pad button ftsteutates(O) nct6775(O) hwmon_vid
coretemp ip_tables x_tables autofs4 igb i2c_algo_bit dca ptp pps_core
[last unloaded: ipmi_msghandler]
[Thu Nov  8 21:51:15 2018] CPU: 3 PID: 6 Comm: kworker/u24:0 Tainted:
G      D    O    4.9.120 #2
[Thu Nov  8 21:51:15 2018] Hardware name: ASUSTeK COMPUTER INC. Z10PA-U8
Series/Z10PA-U8 Series, BIOS 3403 03/01/2017
[Thu Nov  8 21:51:15 2018] task: ffff883f65c0be80 task.stack:
ffff883f65c70000
[Thu Nov  8 21:51:15 2018] RIP: 0010:[<ffffffff8106978b>] 
[<ffffffff8106978b>] kthread_data+0x7/0xc
[Thu Nov  8 21:51:15 2018] RSP: 0018:ffff883f65c73e88  EFLAGS: 00010002
[Thu Nov  8 21:51:15 2018] RAX: 0000000000000000 RBX: ffff883f65c0be80
RCX: 0000000000000003
[Thu Nov  8 21:51:15 2018] RDX: ffffffff819cd4c0 RSI: ffff883f65c0be80
RDI: ffff883f65c0be80
[Thu Nov  8 21:51:15 2018] RBP: ffff883f65c73ec8 R08: 0000000000000026
R09: 0000000000000026
[Thu Nov  8 21:51:15 2018] R10: 0000000000000026 R11: 0000000000000000
R12: ffff883f7f2d85c0
[Thu Nov  8 21:51:15 2018] R13: 0000000000000000 R14: ffff883f65c0c340
R15: 00000000000185c0
[Thu Nov  8 21:51:15 2018] FS:  0000000000000000(0000)
GS:ffff883f7f2c0000(0000) knlGS:0000000000000000
[Thu Nov  8 21:51:15 2018] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Thu Nov  8 21:51:15 2018] CR2: 0000000000000028 CR3: 0000000001808000
CR4: 0000000000160630
[Thu Nov  8 21:51:15 2018] Stack:
[Thu Nov  8 21:51:15 2018]  ffffffff8106537c ffffffff814f4883
0000000000000007 ffff883f65c0be80
[Thu Nov  8 21:51:15 2018]  ffff883f65c73dc8 0000000000000000
000000000000000b 0000000000000000
[Thu Nov  8 21:51:15 2018]  0000000000000009 ffffffff814f4cb7
ffff883f65c0be80 ffffffff810553d2
[Thu Nov  8 21:51:16 2018] Call Trace:
[Thu Nov  8 21:51:16 2018]  [<ffffffff8106537c>] ?
wq_worker_sleeping+0x5/0x77
[Thu Nov  8 21:51:16 2018]  [<ffffffff814f4883>] ? __schedule+0xd0/0x48e
[Thu Nov  8 21:51:16 2018]  [<ffffffff814f4cb7>] ? schedule+0x76/0x7f
[Thu Nov  8 21:51:16 2018]  [<ffffffff810553d2>] ? do_exit+0x110/0x8c4
[Thu Nov  8 21:51:16 2018]  [<ffffffff814f7d14>] ? __switch_to_asm+0x24/0x60
[Thu Nov  8 21:51:16 2018]  [<ffffffff814f9b17>] ?
rewind_stack_do_exit+0x17/0x20
[Thu Nov  8 21:51:16 2018] Code: 83 e0 3f 48 c1 e0 04 48 8d 90 10 97 60
81 89 f0 48 c1 e0 03 48 29 c2 48 89 d6 ba 02 00 00 00 e9 50 fe ff ff 48
8b 87 60 04 00 00 <48> 8b 40 d8 c3 50 48 8b b7 60 04 00 00 ba 08 00 00
00 48 89 e7
[Thu Nov  8 21:51:16 2018] RIP  [<ffffffff8106978b>] kthread_data+0x7/0xc
[Thu Nov  8 21:51:16 2018]  RSP <ffff883f65c73e88>
[Thu Nov  8 21:51:16 2018] CR2: ffffffffffffffd8
[Thu Nov  8 21:51:16 2018] ---[ end trace 9f19e7801339a622 ]---
[Thu Nov  8 21:51:16 2018] Fixing recursive fault but reboot is needed!

rescue kernel: 4.9.120

----

I've grown the blockdevice, but there is no way I can grow the fs,
it doesn't want to mount in my rescue system, and it only mounts
read-only when booting from it, so I can't do it from there either 

I hope someone can help me out with this.
Thanks!

