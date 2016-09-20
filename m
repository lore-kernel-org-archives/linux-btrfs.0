Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 204.37-191-141.fiber.lynet.no ([37.191.141.204]:42630 "EHLO
        mail.thehawken.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751579AbcITAqw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 20:46:52 -0400
Received: from [IPv6:2a00:c440:10:1c62:12::80] (unknown [IPv6:2a00:c440:10:1c62:12::80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.thehawken.org (Postfix) with ESMTPSA id DBFFDA40175
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 02:37:57 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: hawken <hawken@thehawken.org>
Subject: super-recover crashing because it found a bad superblock
Message-ID: <dfe1eed9-2aac-a6b6-c681-93d74d4fd83d@thehawken.org>
Date: Tue, 20 Sep 2016 02:38:09 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

In super-recover.c, around line 96, check_super calls 
btrfs_super_csum_size, which then dies because the size was too big.
I have solved this by reimplementing that stub inside super-recover.c 
with error handling rather than crashing:

diff --git a/super-recover.c b/super-recover.c
index adb2c44..2508e06 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -93,7 +93,11 @@ void free_recover_superblock(struct 
btrfs_recover_superblock *recover)

  static int check_super(u64 bytenr, struct btrfs_super_block *sb)
  {
-       int csum_size = btrfs_super_csum_size(sb);
+       int t = btrfs_super_csum_type(sb);
+       if(t >= ARRAY_SIZE(btrfs_csum_sizes))
+               return 0;
+       int csum_size = btrfs_csum_sizes[t];
+
         char result[csum_size];
         u32 crc = ~(u32)0;


(Sorry for bad formatting)
This allowed me to recover my superblocks

I found this bug kind of ironic because a routine made to discover bad 
data, crashed because it encountered bad data :D

- hawken
