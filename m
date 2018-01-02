Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:54899 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750736AbeABHvp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 02:51:45 -0500
Received: from _ (localhost [127.0.0.1])
        by synology.com (Postfix) with ESMTPA id 2F1D6ADD0D86
        for <linux-btrfs@vger.kernel.org>; Tue,  2 Jan 2018 15:51:39 +0800 (CST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 02 Jan 2018 15:51:39 +0800
From: robbieko <robbieko@synology.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Btrfs reserve metadata problem
Message-ID: <d74d1cc471fb12f8ea55cba36e82582b@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

When testing Btrfs with fio 4k random write, I found that volume with 
smaller free space available has lower performance.

It seems that the smaller the free space of volume is, the smaller 
amount of dirty page filesystem could have.
There are only 6 MB dirty pages when free space of volume is only 10GB 
with 16KB-nodesize and cow disabled.

btrfs will reserve metadata for every write.
The amount to reserve is calculated as follows: nodesize * 
BTRFS_MAX_LEVEL(8) * 2, i.e., it reserves 256KB of metadata.
The maximum amount of metadata reservation depends on size of metadata 
currently in used and free space within volume(free chunk size /16)
When metadata reaches the limit, btrfs will need to flush the data to 
release the reservation.

1. Is there any logic behind the value (free chunk size /16)

  /*
   * If we have dup, raid1 or raid10 then only half of the free
   * space is actually useable. For raid56, the space info used
   * doesn't include the parity drive, so we don't have to
   * change the math
   */
  if (profile & (BTRFS_BLOCK_GROUP_DUP |
          BTRFS_BLOCK_GROUP_RAID1 |
          BTRFS_BLOCK_GROUP_RAID10))
   avail >>= 1;

  /*
   * If we aren't flushing all things, let us overcommit up to
   * 1/2th of the space. If we can flush, don't let us overcommit
   * too much, let it overcommit up to 1/8 of the space.
   */
  if (flush == BTRFS_RESERVE_FLUSH_ALL)
   avail >>= 3;
  else
   avail >>= 1;

2. Is there any way to improve this problem?

Thanks.
Robbie Ko
