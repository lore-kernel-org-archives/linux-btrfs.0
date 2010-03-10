From: Gordan Bobic <gordan@bobich.net>
Subject: SSD Optimizations
Date: Wed, 10 Mar 2010 19:49:34 +0000
Message-ID: <4B97F7CE.4030405@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm looking to try BTRFS on a SSD, and I would like to know what SSD 
optimizations it applies. Is there a comprehensive list of what ssd 
mount option does? How are the blocks and metadata arranged? Are there 
options available comparable to ext2/ext3 to help reduce wear and 
improve performance?

Specifically, on ext2 (journal means more writes, so I don't use ext3 on 
SSDs, since fsck typically only takes a few seconds when access time is 
< 100us), I usually apply the
-b 4096 -E stripe-width = (erase_block/4096)
parameters to mkfs in order to reduce the multiple erase cycles on the 
same underlying block.

Are there similar optimizations available in BTRFS?

Gordan
