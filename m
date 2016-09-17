Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32994 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932119AbcIQXKk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 19:10:40 -0400
Received: by mail-wm0-f66.google.com with SMTP id w84so1970860wmg.0
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Sep 2016 16:10:39 -0700 (PDT)
From: =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
Subject: [PATCH] btrfs: change btrfs_csum_final result param type to u8
Date: Sun, 18 Sep 2016 00:10:34 +0100
Message-Id: <1474153835-6728-1-git-send-email-domagoj.trsan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

csum member of struct btrfs_super_block has array type of u8. It makes sense
that function btrfs_csum_final should be also declared to accept u8 *. I
changed the declaration of method void btrfs_csum_final(u32 crc, char *result);
to void btrfs_csum_final(u32 crc, u8 *result);

Domagoj Tršan (1):
  btrfs: change btrfs_csum_final result param type to u8

 fs/btrfs/disk-io.c | 2 +-
 fs/btrfs/disk-io.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.7.4

