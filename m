From: Chris Mason <chris.mason@oracle.com>
Subject: Fixes pushed to the stable tree
Date: Wed, 20 Aug 2008 16:26:15 -0400
Message-ID: <1219263975.7854.14.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've pushed out all my fixes so far from btrfs-unstable to btrfs-stable.

I'll update the hotfixes section of the wiki once Toei Rei confirms this
update fixes her oopsen.

These don't include any disk format changes, but they do fix
checksumming errors and an ugly use after free memory corrupting bug.
They also improve performance over every workload I've tried so far.

-chris


