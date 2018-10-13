Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542AEC28CF8
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 16:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0968F20659
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 16:27:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dhz8qSov"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0968F20659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbeJNAEy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 20:04:54 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43286 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbeJNAEy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 20:04:54 -0400
Received: by mail-lj1-f193.google.com with SMTP id r8-v6so13887521ljc.10;
        Sat, 13 Oct 2018 09:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=6bNakV+8aLxSypeqYjP8W+3V7VlDif8H+H/RRnO0gKE=;
        b=dhz8qSoviMfpkgB9eD9xMY2YGtRY2opSdEGAh/9GZw3hDALLOuMLe3Up7+GuMv5nyY
         DosaF7gNDuoqIahhHycVxf4pMI2/ElvDlzjoSpW85LZZGr0gBneNsQ+L6csM+QgUbNKI
         MiTQVpYI8jwgfBRNqcVVRMQS6QMreHy4CHR7lpBttNVFEfFExCtrf4lH94mymd5icZFm
         UsAIkhMtWzSVYvxVZujqXiYFfoV+mmRvl7ZpDNdMiirFqnF62KFGllHsx4CXZ8ocpzGW
         2UDUxnO/lVwuTb456VQrfx+fwj77wD2Z0za9RUlH9pwtT3U79Ju5h7uVCLCc+LuTdfqP
         x5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=6bNakV+8aLxSypeqYjP8W+3V7VlDif8H+H/RRnO0gKE=;
        b=e15ZchC/GzES/blf6jFwTnAjndkwtAaFnYwEBQ/PKEFB3uNVThPgdTa/+mIWsBnoxL
         e40HuZ5Zy9tMVpufFORr2UNQ6gnD+dzIl5OfwQZjo3qKXCKMpiDssHYtB+ZzjsskPo6A
         QUovlWwRXYlqF9sg4mMPsJGB4vL/GeKH8vf8gAedp3A9sycEfXojuwrLYQKwSrAzvk2+
         mGYgZs1fJfWUtfise9aKunlypzhQO4DGF8jnAq4otGzInSAu2jRX0AXBkYSalMj1/9tt
         MfOOu6RgV5R5nGXycTLusjaORoCgmSC3X3XtIa6aihifAVqk35qrRhS5qYuPee3bb5H7
         Lmjg==
X-Gm-Message-State: ABuFfogqPkjQ1rLAH/pt8pk3uX5AHBA8nKJm9osujRDKqAqwkY8AKYwO
        nHfuwPUa7Xpyu/anlSvary50ujPywFfQrM2DlJr4UkZa
X-Google-Smtp-Source: ACcGV63NDATBMteJANFMZBqUMC9xwkX2hJaxx+oWgft2IloBTjp9ygi1J0OMKXGFD2hqMmWQPVJI1bU7Hpe/8ORRUDA=
X-Received: by 2002:a2e:8981:: with SMTP id c1-v6mr6924875lji.124.1539448024682;
 Sat, 13 Oct 2018 09:27:04 -0700 (PDT)
MIME-Version: 1.0
From:   Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Date:   Sat, 13 Oct 2018 19:26:53 +0300
Message-ID: <CAE5jQCfRSBC7n4pUTFJcmHh109=gwyT9mFkCOL+NKfzswmR=_Q@mail.gmail.com>
Subject: An assertion triggered with four syscalls on fresh Btrfs image
 (xfstests reproducer)
To:     Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000a9778f05781eac06"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--000000000000a9778f05781eac06
Content-Type: text/plain; charset="UTF-8"

An assertion can be triggered when performing operations on fresh,
non-crafted FS (bug #200413).

How to reproduce with kvm-xfstests:

1) Checkout master branch of torvalds/linux (tested on commit bab5c80b211)
2) Copy fstests/kernel-configs/x86_64-config-4.14 to .config and
compile after `make olddefconfig`
3) Take the attached repro.c and execute the following commands:

$ gcc --static repro.c -o repro # Inside /tmp/kvm-xfstest-$USER
$ kvm-xfstest shell

2) Inside the xfstests shell execute:

# mount /vtmp
# mkfs.btrfs /dev/vdc -O no-holes -b 256M -f
# mount /vdc
# cd /vdc
# /vtmp/repro

What happens:

root@kvm-xfstests:~# mount /vtmp
root@kvm-xfstests:~# mkfs.btrfs /dev/vdc -O no-holes -b 256M -f
btrfs-progs v4.13.3
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               d3d0578c-4a7d-4604-a3ae-ccea8db13de3
Node size:          16384
Sector size:        4096
Filesystem size:    256.00MiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP              32.00MiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata, no-holes
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1   256.00MiB  /dev/vdc

[   21.994083] BTRFS: device fsid d3d0578c-4a7d-4604-a3ae-ccea8db13de3
devid 1 transid 5 /dev/vdc
root@kvm-xfstests:~# mount /vdc
[   41.484960] BTRFS info (device vdc): disk space caching is enabled
[   41.485697] BTRFS info (device vdc): has skinny extents
[   41.486289] BTRFS info (device vdc): flagging fs with big metadata feature
[   41.490678] BTRFS info (device vdc): creating UUID tree
root@kvm-xfstests:~# cd /vdc
root@kvm-xfstests:/vdc# /vtmp/repro
[   50.271476] assertion failed: len == i_size || (len ==
fs_info->sectorsize && btrfs_file_extent_compression(leaf, extent) !=
BTRFS_COMPRESS_NONE), file: fs/btrfs/tree-log.c, line: 4639
[   50.273424] ------------[ cut here ]------------
[   50.273895] kernel BUG at fs/btrfs/ctree.h:3438!
[   50.274366] invalid opcode: 0000 [#1] SMP PTI
[   50.274809] CPU: 1 PID: 389 Comm: repro Not tainted
4.19.0-rc7-xfstests-01009-gbab5c80b211 #1
[   50.275661] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.10.2-1ubuntu1 04/01/2014
[   50.276560] RIP: 0010:btrfs_log_trailing_hole+0x253/0x2b0
[   50.277105] Code: 72 fd ff 84 c0 0f 85 1b fe ff ff b9 1f 12 00 00
48 c7 c2 f9 fc 22 be 48 c7 c6 70 fd 22 be 48 c7 c7 00 92 22 be e8 5f
65 c6 ff <0f> 0b b9 02 12 00 00 48 c7 c2 f9 fc 22 be 48 c7 c6 16 fd 22
be 48
[   50.278962] RSP: 0018:ffff9c8e0094fb70 EFLAGS: 00010282
[   50.279489] RAX: 00000000000000ac RBX: 0000000000000101 RCX: 0000000000000000
[   50.280206] RDX: 0000000000000000 RSI: ffff9907bddd54c8 RDI: ffff9907bddd54c8
[   50.280920] RBP: ffff9907b8aa2410 R08: 000000107a675b89 R09: 0000000000000000
[   50.281635] R10: 0000000000000003 R11: 0000000000000000 R12: 00000000000008da
[   50.282350] R13: 00000000000008da R14: ffff9907b8100000 R15: ffff9907b82b7700
[   50.283065] FS:  000000000163b880(0000) GS:ffff9907bdc00000(0000)
knlGS:0000000000000000
[   50.283873] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   50.284453] CR2: 000000000040dad0 CR3: 0000000079ebc001 CR4: 00000000003606e0
[   50.285173] Call Trace:
[   50.285425]  btrfs_log_inode+0xe64/0xf20
[   50.285851]  btrfs_log_inode_parent+0x295/0xb10
[   50.286301]  btrfs_log_dentry_safe+0x4a/0x70
[   50.286727]  btrfs_sync_file+0x43c/0x4e0
[   50.287119]  ? do_fsync+0x38/0x60
[   50.287477]  ? btrfs_fdatawrite_range+0x50/0x50
[   50.287945]  do_fsync+0x38/0x60
[   50.288300]  __x64_sys_fsync+0x10/0x20
[   50.288698]  do_syscall_64+0x56/0x1a0
[   50.289078]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   50.289593] RIP: 0033:0x44a0d1
[   50.289911] Code: 0f 48 83 c4 28 c3 0f 1f 00 b8 00 01 00 00 eb e1
e8 54 1a 00 00 0f 1f 40 00 8b 05 46 27 27 00 85 c0 75 16 b8 4a 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 3f f3 c3 0f 1f 44 00 00 53 89 fb 48 83
ec 10
[   50.291771] RSP: 002b:00007ffe1c00b9b8 EFLAGS: 00000246 ORIG_RAX:
000000000000004a
[   50.292580] RAX: ffffffffffffffda RBX: 0000000000400400 RCX: 000000000044a0d1
[   50.293279] RDX: 000000000000046d RSI: 0000000000000000 RDI: 0000000000000003
[   50.294014] RBP: 00007ffe1c00b9d0 R08: 00000000006bbe18 R09: 0000000000000000
[   50.294713] R10: 000000000000046d R11: 0000000000000246 R12: 0000000000401920
[   50.295438] R13: 0000000000000000 R14: 00000000006b9018 R15: 0000000000000000
[   50.296211] ---[ end trace f1cccab515ece57c ]---
[   50.296687] RIP: 0010:btrfs_log_trailing_hole+0x253/0x2b0
[   50.297228] Code: 72 fd ff 84 c0 0f 85 1b fe ff ff b9 1f 12 00 00
48 c7 c2 f9 fc 22 be 48 c7 c6 70 fd 22 be 48 c7 c7 00 92 22 be e8 5f
65 c6 ff <0f> 0b b9 02 12 00 00 48 c7 c2 f9 fc 22 be 48 c7 c6 16 fd 22
be 48
[   50.299102] RSP: 0018:ffff9c8e0094fb70 EFLAGS: 00010282
[   50.299635] RAX: 00000000000000ac RBX: 0000000000000101 RCX: 0000000000000000
[   50.300358] RDX: 0000000000000000 RSI: ffff9907bddd54c8 RDI: ffff9907bddd54c8
[   50.301074] RBP: ffff9907b8aa2410 R08: 000000107a675b89 R09: 0000000000000000
[   50.301791] R10: 0000000000000003 R11: 0000000000000000 R12: 00000000000008da
[   50.302515] R13: 00000000000008da R14: ffff9907b8100000 R15: ffff9907b82b7700
[   50.303234] FS:  000000000163b880(0000) GS:ffff9907bdc00000(0000)
knlGS:0000000000000000
[   50.304049] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   50.304637] CR2: 000000000040dad0 CR3: 0000000079ebc001 CR4: 00000000003606e0
Segmentation fault
root@kvm-xfstests:/vdc#

Best regards
Anatoly

--000000000000a9778f05781eac06
Content-Type: text/x-csrc; charset="US-ASCII"; name="repro.c"
Content-Disposition: attachment; filename="repro.c"
Content-Transfer-Encoding: base64
Content-ID: <f_jn7nkoyy0>
X-Attachment-Id: f_jn7nkoyy0

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8c3lzL3R5cGVzLmg+CiNpbmNsdWRlIDxzeXMv
c3RhdC5oPgojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoKaW50IG1haW4o
KSB7CiAgaW50IGZkID0gY3JlYXQoIi4vYWJjIiwgMHgzMCk7CiAgdHJ1bmNhdGUoIi4vYWJjIiwg
MzUwKTsKICBmYWxsb2NhdGUoZmQsIDAsIDExMzMsIDExMzMpOwogIGZzeW5jKGZkKTsKICByZXR1
cm4gMDsKfQo=
--000000000000a9778f05781eac06--
