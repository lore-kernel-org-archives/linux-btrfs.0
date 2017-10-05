Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:51732 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbdJENik (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Oct 2017 09:38:40 -0400
Received: by mail-qt0-f170.google.com with SMTP id q4so25355639qtq.8
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Oct 2017 06:38:40 -0700 (PDT)
MIME-Version: 1.0
From: Eric Wolf <19wolf@gmail.com>
Date: Thu, 5 Oct 2017 09:38:18 -0400
Message-ID: <CAJ_hD5D4CUHW1eUour5HJKx2Zk69nm2ypFRiN2UXGt9ah7us6Q@mail.gmail.com>
Subject: Mounting bad btrfs img file
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My OS drive had issues with metadata (disk full even though it wasn't
etc), and so I reinstalled my OS and now I'm learning that my backup
img is bad. What steps should I go through to fix it?


$ sudo mount -o
offset=8999927808,loop,recovery,ro,nospace_cache,nospace_cache
/data/Backup/Nephele.img /mnt

mount: wrong fs type, bad option, bad superblock on /dev/loop0,

       missing codepage or helper program, or other error


       In some cases useful info is found in syslog - try

       dmesg | tail or so.

nephele@Nephele:/data/Backup$ dmesg | tail

[48539.443711] BTRFS error (device loop0): parent transid verify
failed on 98021605376 wanted 85976 found 85978

[48539.473837] BTRFS error (device loop0): parent transid verify
failed on 98021605376 wanted 85976 found 85978

[48539.485032] BTRFS: failed to read tree root on loop0

[48539.494782] BTRFS error (device loop0): parent transid verify
failed on 98049490944 wanted 85975 found 85981

[48539.510541] BTRFS error (device loop0): parent transid verify
failed on 98049490944 wanted 85975 found 85981

[48539.523464] BTRFS: failed to read tree root on loop0

[48539.526374] BTRFS error (device loop0): parent transid verify
failed on 98020917248 wanted 85974 found 85979

[48539.545628] BTRFS error (device loop0): parent transid verify
failed on 98020917248 wanted 85974 found 85979

[48539.560595] BTRFS: failed to read tree root on loop0

[48539.589038] BTRFS: open_ctree failed
