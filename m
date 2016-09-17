Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35488 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754787AbcIQXKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 19:10:31 -0400
Received: by mail-wm0-f65.google.com with SMTP id 133so9132088wmq.2
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Sep 2016 16:10:30 -0700 (PDT)
From: =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
Subject: [PATCH] btrfs-progs: change btrfs_csum_final result param type to u8
Date: Sun, 18 Sep 2016 00:10:22 +0100
Message-Id: <1474153823-6671-1-git-send-email-domagoj.trsan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

csum member of struct btrfs_super_block has array type of u8. It makes sense
that function btrfs_csum_final should be also declared to accept u8 *. I
changed the declaration of method void btrfs_csum_final(u32 crc, char *result);
to void btrfs_csum_final(u32 crc, u8 *result);
Also, I changed definitions of various csum variables to be consistent with
kernel code. In kernel code they are defined as u8 result[BTRFS_CSUM_SIZE] but
here was as char result[BTRFS_CSUM_SIZE].

Domagoj Tršan (1):
  btrfs-progs: change btrfs_csum_final result param type to u8

 btrfs-image.c             |  2 +-
 chunk-recover.c           |  2 +-
 cmds-check.c              |  2 +-
 cmds-inspect-dump-super.c |  2 +-
 disk-io.c                 | 10 +++++-----
 disk-io.h                 |  2 +-
 file-item.c               |  2 +-
 free-space-cache.c        |  2 +-
 super-recover.c           |  2 +-
 utils.c                   |  2 +-
 10 files changed, 14 insertions(+), 14 deletions(-)

-- 
2.7.4

