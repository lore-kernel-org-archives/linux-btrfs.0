Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:53686 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbeAWHDq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 02:03:46 -0500
Received: from 68.79-160-168.customer.lyse.net ([79.160.168.68]:34545 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1edscS-0003OO-Fy
        for linux-btrfs@vger.kernel.org; Tue, 23 Jan 2018 08:03:44 +0100
Reply-To: waxhead@dirtcellar.net
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: waxhead <waxhead@dirtcellar.net>
Subject: Superblock update: Is there really any benefits of updating
 synchronously?
Message-ID: <2f19aa79-b8f4-294e-5298-3a7ed7fbd67d@dirtcellar.net>
Date: Tue, 23 Jan 2018 08:03:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Note: This have been mentioned before, but since I see some issues 
related to superblocks I think it would be good to bring up the question 
again.

According to the information found in the wiki: 
https://btrfs.wiki.kernel.org/index.php/On-disk_Format#Superblock

The superblocks are updated synchronously on HDD's and one after each 
other on SSD's.

Superblocks are also (to my knowledge) not protected by copy-on-write 
and are read-modify-update.

On a storage device with >256GB there will be three superblocks.

BTRFS will always prefer the superblock with the highest generation 
number providing that the checksum is good.

On the list there seem to be a few incidents where the superblocks have 
gone toast and I am pondering what (if any) benefits there is by 
updating the superblocks synchronously.

The superblock is checkpoint'ed every 30 seconds by default and if 
someone pulls the plug (poweroutage) on HDD's then a synchronous write 
depending on (the quality of) your hardware may perhaps ruin all the 
superblock copies in one go. E.g. Copy A,B and C will all be updated at 30s.

On SSD's, since one superblock is updated after other it would mean that 
using the default 30 second checkpoint Copy A=30s, Copy B=1m, Copy C=1m30s

Why is the SSD method not used on harddrives also?! If two superblocks 
are toast you would at maximum loose 1m30s by default , and if this is 
considered a problem then you can always adjust downwards the commit 
time. If this is set to 15 seconds you would still only loose 30 seconds 
of "action time" and would in my opinion be far better off from a 
reliability point of view than having to update multiple superblocks at 
the same time. I can't see why on earth updating all superblocks at the 
same time would have any benefits.

So this all boils down to the questions three (ere the other side will 
see..... :P )

1. What are the benefits of updating all superblocks at the same time? 
(Just imagine if your memory is bad - you could risk updating all 
superblocks simultaneously with kebab'ed data).

2. What would the negative consequences be by using the SSD scheme also 
for harddisks? Especially if the commit time is set to 15s instead of 30s

3. In a RAID1 / 10 / 5 / 6 like setup. Would a set of corrupt 
superblocks on a single drive be recoverable from other disks or do the 
superblocks need to be intact on the (possibly) damaged drive?
(If the superblocks are needed then why would not SSD mode be better 
especially if the drive is partly working)

