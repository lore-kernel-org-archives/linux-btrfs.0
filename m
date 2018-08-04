Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpoutz25.laposte.net ([194.117.213.100]:44608 "EHLO
        smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728067AbeHDTLp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2018 15:11:45 -0400
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout013 (Postfix) with ESMTP id 736751054A8
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Aug 2018 18:47:52 +0200 (CEST)
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout013 (Postfix) with ESMTP id 64AF5107059
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Aug 2018 18:47:52 +0200 (CEST)
Received: from lpn-prd-vrin002 (lpn-prd-vrin002.prosodie [10.128.63.3])
        by lpn-prd-vrout013 (Postfix) with ESMTP id 5DAD61054A8
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Aug 2018 18:47:52 +0200 (CEST)
Received: from lpn-prd-vrin002 (localhost [127.0.0.1])
        by lpn-prd-vrin002 (Postfix) with ESMTP id 4EB9F5E8205
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Aug 2018 18:47:52 +0200 (CEST)
Received: from [192.168.1.87] (176-131-217-202.abo.bbox.fr [176.131.217.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by lpn-prd-vrin002 (Postfix) with ESMTPSA id 8BE335E820D
        for <linux-btrfs@vger.kernel.org>; Sat,  4 Aug 2018 18:47:51 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Laurent Lauden <laurent.lauden@laposte.net>
Subject: undelete files
Message-ID: <98a3ae94-d6ed-b7ba-34eb-61b9f2db33e8@laposte.net>
Date: Sat, 4 Aug 2018 18:47:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a disk with a database directory that was cleared accidentally.

This disk stay mounted for 3 days but I don't see any writing on it 
after the deletion. The disk was almost full when the deletion occurred.

However, trying to use btrfs-undelete give me no results. :

# sudo btrfs-undelete /dev/sdb1 postgresql /data-restore/

# Didn't find 'postgresql'

And when I try with btrfs tools with -f option, I have errors on 
checksum, etc. especially on the base files

Error copying data for /tmp/postgresql/global/1136
Error mapping block -2

Error copying data for /tmp/postgresql/base/18068/111300
Couldn't map the block 155802124288
Invalid mapping for 155802124288-155802140672, got 249647071232-250183942144
Couldn't map the block 155802124288
bytenr mismatch, want=155802124288, have=0
Error mapping block -2

Error copying data for /tmp/postgresql/base/18068/111298
Couldn't map the block 155802124288
Invalid mapping for 155802124288-155802140672, got 249647071232-250183942144
Couldn't map the block 155802124288
bytenr mismatch, want=155802124288, have=0
Couldn't map the block 155802124288
Invalid mapping for 155802124288-155802140672, got 249647071232-250183942144
Couldn't map the block 155802124288
bytenr mismatch, want=155802124288, have=0
Error searching -5

Tried

for j in `cat b1.txt | awk '{print $3}'`;do export i=${j:0:-5} && btrfs 
restore /dev/sdb1 /data-restore/ --path-regex 
"^(.*(|/postgresql(|/.*)))$" -o -v  -i -t $i; done > restore_test.txt 2>&1

but with -t nothing appears and with -f almost only errors. (b1.txt is 
the result of btrfs-find-root /dev/sdb1)

The btrfs-find-root /dev/sdb1 give me that :

Superblock thinks the generation is 436544
Superblock thinks the level is 0
Found tree root at 131301376 gen 436544 level 0
Well block 129597440(gen: 436541 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 129482752(gen: 436534 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 129286144(gen: 436533 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 129089536(gen: 436532 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 128892928(gen: 436531 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 128696320(gen: 436530 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 128499712(gen: 436529 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 128303104(gen: 436528 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 128106496(gen: 436527 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 127909888(gen: 436526 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 127713280(gen: 436525 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 127516672(gen: 436524 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 127320064(gen: 436523 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 127123456(gen: 436522 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 126926848(gen: 436521 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 126730240(gen: 436520 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 126533632(gen: 436519 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 126337024(gen: 436518 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 126140416(gen: 436517 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 125943808(gen: 436516 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 125747200(gen: 436515 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 125550592(gen: 436514 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 125353984(gen: 436513 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 125157376(gen: 436512 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 124960768(gen: 436511 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 124764160(gen: 436510 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 124567552(gen: 436509 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 124370944(gen: 436508 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 124174336(gen: 436507 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 123977728(gen: 436506 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 123781120(gen: 436505 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 123584512(gen: 436504 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 123387904(gen: 436503 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 123191296(gen: 436502 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 122994688(gen: 436501 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 122798080(gen: 436500 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 122601472(gen: 436499 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 122257408(gen: 436498 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 121880576(gen: 436497 level: 1) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0
Well block 81821696(gen: 436495 level: 0) seems good, but 
generation/level doesn't match, want gen: 436544 level: 0

So, if anyone could help me I would be very grateful.

Thanks

