Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:55586 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751677AbdI3L5U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 07:57:20 -0400
From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: What means "top level" in "btrfs subvolume list" ?
Reply-To: kreijack@inwind.it
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <762acea0-3f55-4fc0-c5eb-604304152f3e@inwind.it>
Date: Sat, 30 Sep 2017 13:57:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(please ignore my previous email, because I wrote somewhere "top id" instead of "top level")
Hi All,

I am trying to figure out which means "top level" in the output of "btrfs sub list"


ghigo@venice:~$ sudo btrfs sub list /
[sudo] password for ghigo: 
ID 257 gen 548185 top level 5 path debian
ID 289 gen 418851 top level 257 path var/lib/machines
ID 299 gen 537230 top level 5 path boot
ID 532 gen 502364 top level 257 path tmp/test1
ID 533 gen 502277 top level 532 path tmp/test1/test2
ID 534 gen 502407 top level 257 path tmp/test1.snap
ID 535 gen 502363 top level 532 path tmp/test1/test3
ID 536 gen 502407 top level 257 path tmp/test1.snap2
ID 537 gen 537132 top level 5 path test
ID 538 gen 537130 top level 537 path test/sub1

The root filesystem is mounted as

mount -o subvol=debian ....


I think that "btrfs sub list" is buggy, and it outputs a "top level ID" equal to the "parent ID" (on the basis of the code). But I am still asking which would be the RIGHT "top level id". My Hypothesis, it should be the ID of the root subvolume ( or 5 if it is not mounted). So the output should be

 
ghigo@venice:~$ sudo btrfs sub list /
[sudo] password for ghigo: 
ID 257 gen 548185 top level 5 path debian
ID 289 gen 418851 top level 257 path var/lib/machines
ID 299 gen 537230 top level 5 path boot
ID 532 gen 502364 top level 257 path tmp/test1
ID 533 gen 502277 top level 257 path tmp/test1/test2
ID 534 gen 502407 top level 257 path tmp/test1.snap
ID 535 gen 502363 top level 257 path tmp/test1/test3
ID 536 gen 502407 top level 257 path tmp/test1.snap2
ID 537 gen 537132 top level 5 path test
ID 538 gen 537130 top level 5 path test/sub1


The subvolumes in the file system (mounted from /debian) are

/				ID = 5
/debian				ID = 257
/debian/var/lib/machines	ID = 289
/boot				ID = 299
/debian/tmp/test1		ID = 532
/debian/tmp/test1/test2		ID = 533
/debian/tmp/test1.snap		ID = 534
/debian/tmp/test1/test3		ID = 535
/debian/tmp/test1.snap2		ID = 536
/test				ID = 537
/test/sub1			ID = 538

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
