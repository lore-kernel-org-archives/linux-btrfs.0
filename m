From: John McCabe-Dansted <gmatht@gmail.com>
Subject: Compress=lzo a good idea for Swapfiles on SSD?
Date: Sat, 26 Mar 2011 11:47:02 +0800
Message-ID: <AANLkTi=b9hzJ5zs2qNm1ZbbkQLdmua8zQfJJhpVs4nYd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I understand that modern SSDs can withstand a significant amount of
writes, and so using an SSD for swap seems like a reasonable
proposition. However minimising writes still seems like a good idea.
My experience with compcache/ramzswap suggests that swap compresses
quite well, I tend to get a 4:1 compression ratio. Furthermore, I
understand that we can work around the data corruption that usually
occurs when using a swapfile on a btrfs partion, by using a loopback
device. Given this, my question is:

Does it sound like a good idea to use compress=lzo for swapfiles to
reduce the amount of data written to the SSD, when using SSD drives
that do not use compression internally?

-- 
John C. McCabe-Dansted
