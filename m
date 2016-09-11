Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh1.e.nsc.no ([193.213.121.72]:38311 "EHLO nmsh1.e.nsc.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753125AbcIKJKU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 05:10:20 -0400
Received: from [10.0.0.10] (ti0210a400-1153.bb.online.no [80.213.43.133])
        (authenticated bits=0)
        by nmsh1.nsc.no (8.14.7/8.14.7) with ESMTP id u8B8tLsE024005
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Sep 2016 10:55:21 +0200 (MEST)
To: linux-btrfs@vger.kernel.org
From: Waxhead <waxhead@online.no>
Subject: Is stability a joke?
Message-ID: <57D51BF9.2010907@online.no>
Date: Sun, 11 Sep 2016 10:55:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have been following BTRFS for years and have recently been starting to 
use BTRFS more and more and as always BTRFS' stability is a hot topic.
Some says that BTRFS is a dead end research project while others claim 
the opposite.

Taking a quick glance at the wiki does not say much about what is safe 
to use or not and it also points to some who are using BTRFS in production.
While BTRFS can apparently work well in production it does have some 
caveats, and finding out what features is safe or not can be problematic 
and I especially think that new users of BTRFS can easily be bitten if 
they do not do a lot of research on it first.

The Debian wiki for BTRFS (which is recent by the way) contains a bunch 
of warnings and recommendations and is for me a bit better than the 
official BTRFS wiki when it comes to how to decide what features to use.

The Nouveau graphics driver have a nice feature matrix on it's webpage 
and I think that BTRFS perhaps should consider doing something like that 
on it's official wiki as well

For example something along the lines of .... (the statuses are taken 
our of thin air just for demonstration purposes)

Kernel version 4.7
+----------------------------+--------+-----+-------+-------+--------+-------+--------+
| Feature / Redundancy level | Single | Dup | Raid0 | Raid1 | Raid10 | 
Raid5 | Raid 6 |
+----------------------------+--------+-----+-------+-------+--------+-------+--------+
| Subvolumes                 | Ok     | Ok  | Ok    | Ok    | Ok   | Bad 
   | Bad    |
+----------------------------+--------+-----+-------+-------+--------+-------+--------+
| Snapshots                  | Ok     | Ok  | Ok    | Ok    | Ok     | 
Bad   | Bad    |
+----------------------------+--------+-----+-------+-------+--------+-------+--------+
| LZO Compression            | Bad(1) | Bad | Bad   | Bad(2)| Bad    | 
Bad   | Bad    |
+----------------------------+--------+-----+-------+-------+--------+-------+--------+
| ZLIB Compression           | Ok     | Ok  | Ok    | Ok    | Ok     | 
Bad   | Bad    |
+----------------------------+--------+-----+-------+-------+--------+-------+--------+
| Autodefrag                 | Ok     | Bad | Bad(3)| Ok    | Ok     | 
Bad   | Bad    |
+----------------------------+--------+-----+-------+-------+--------+-------+--------+

(1) Some explanation here...
(2) Some explanation there....
(3) And some explanation elsewhere...

...etc...etc...

I therefore would like to propose that some sort of feature / stability 
matrix for the latest kernel is added to the wiki preferably somewhere 
where it is easy to find. It would be nice to archive old matrix'es as 
well in case someone runs on a bit older kernel (we who use Debian tend 
to like older kernels). In my opinion it would make things bit easier 
and perhaps a bit less scary too. Remember if you get bitten badly once 
you tend to stay away from from it all just in case, if you on the other 
hand know what bites you can safely pet the fluffy end instead :)
