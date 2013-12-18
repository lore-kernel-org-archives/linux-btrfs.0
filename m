Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58599 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab3LRRRX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 12:17:23 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]) by mail.gmx.com
 (mrgmx101) with ESMTPSA (Nemesis) id 0LpwZn-1VGxnS32Ax-00ffYQ for
 <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 18:17:21 +0100
Received: by mail-wi0-f178.google.com with SMTP id bz8so969130wib.11
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 09:17:21 -0800 (PST)
MIME-Version: 1.0
From: eb <eab@gmx.ch>
Date: Wed, 18 Dec 2013 18:17:01 +0100
Message-ID: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
Subject: btrfs on bcache
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've recently setup a system (Kernel 3.12.5-1-ARCH) which is layered as follows:

/dev/sdb3 - cache0 (80 GB Intel SSD)
/dev/sdc1 - backing device (2 TB WD HDD)

sdb3+sdc1 => /dev/bcache0

On /dev/bcache0, there's a btrfs filesystem with 2 subvolumes, mounted
as / and /home. What's been bothering me are the following entries in
my kernel log:

[13811.845540] incomplete page write in btrfs with offset 1536 and length 2560
[13870.326639] incomplete page write in btrfs with offset 3072 and length 1024

The offset/length values are always either 1536/2560 or 3072/1024,
they sum up nicely to 4K. There are 607 of those in there as I am
writing this, the machine has been up 18 hours and been under no
particular I/O strain (it's a desktop).

Trying to fix this, I unattached the cache (still using /dev/bcache0,
but without /dev/sdb3 attached), causing these errors to disappear. As
soon as I re-attached /dev/sdb3 they started again, so I am fairly
sure it's an unfavorable interaction between bcache and btrfs.

Is this something I should be worried about (they're only emitted with
KERN_INFO?) or just an alignment problem? The underlying HDD is using
4K-Sectors, while the block_size of bcache seems to be 512, could that
be the issue here?

I've also encountered incomplete reads and a few csum errors, but I
have not been able to trigger these regularly. I have a feeling that
the error is more likely  o be on the bcache end (I've mailed to that
list as well), however any insight into the matter would be much
appreciated.

Thanks,

- eb
