Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56039 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbdIEBFl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 21:05:41 -0400
Date: Mon, 4 Sep 2017 18:05:31 -0700
From: Marc MERLIN <marc@merlins.org>
To: quwenruo@cn.fujitsu.com, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Message-ID: <20170905010531.rfvun5isjwrb5ur5@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: btrfs check --repair now runs in minutes instead of hours? aborting
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, I don't want to sound like I'm complaining :) but I updated
btrfs-progs to top of tree in git, installed it, and ran it on an 8TiB
filesystem that used to take 12H or so to check.

It finished in maybe 10mn, just 10mn! :)
gargamel:/var/local/src/btrfs-progs# btrfs check --repair /dev/mapper/dshelf1
enabling repair mode
Checking filesystem on /dev/mapper/dshelf1
UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 11674263347200 bytes used, no error found
total csum bytes: 11384482936
total tree bytes: 13704495104
total fs tree bytes: 724729856
total extent tree bytes: 482639872
btree space waste bytes: 1167025205
file data blocks allocated: 12041456693248
 referenced 12063146434560

This is great news, but can I trust that the program worked properly and
indeed that my filesystem is fully clean?
Or at this point if I'm not running --mode=lowmem, the regular mode is
really doesn't check much and only lowmem can do a proper check? (even
though it can't fix problems once it finds them)

Thanks
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
