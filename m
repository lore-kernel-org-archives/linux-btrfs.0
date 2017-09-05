Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58980 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdIEEGY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 00:06:24 -0400
Date: Mon, 4 Sep 2017 21:06:14 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: quwenruo@cn.fujitsu.com, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: btrfs check --repair now runs in minutes instead of hours? aborting
Message-ID: <20170905040614.GB6392@merlins.org>
References: <20170905010531.rfvun5isjwrb5ur5@merlins.org> <75b0ebd3-41ea-7f45-bec4-f7d9ec6efee1@gmx.com> <20170905025556.GA6392@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170905025556.GA6392@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, not quite hours, but check takes 88mn, check --repair takes 11mn

gargamel:/var/local/src/btrfs-progs# time btrfs check /dev/mapper/dshelf1
Checking filesystem on /dev/mapper/dshelf1
UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 11674263330816 bytes used, no error found
total csum bytes: 11384482936
total tree bytes: 13704478720
total fs tree bytes: 724729856
total extent tree bytes: 482623488
btree space waste bytes: 1167009013
file data blocks allocated: 12041456693248
referenced 12063146434560

real    88m56.597s
user    2m13.985s
sys     2m7.880s

gargamel:/var/local/src/btrfs-progs# time btrfs check --repair
/dev/mapper/dshelf1
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
found 11674263330816 bytes used, no error found
total csum bytes: 11384482936
total tree bytes: 13704478720
total fs tree bytes: 724729856
total extent tree bytes: 482623488
btree space waste bytes: 1167009013
file data blocks allocated: 12041456693248
referenced 12063146434560

real    11m10.499s
user    1m55.067s
sys     1m31.666s

And lowmem is 24mn:
gargamel:/var/local/src/btrfs-progs# time btrfs check --mode=lowmem
/dev/mapper/dshelf1
Checking filesystem on /dev/mapper/dshelf1
UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 11674263363584 bytes used, no error found
total csum bytes: 11384482936
total tree bytes: 13738770432
total fs tree bytes: 758988800
total extent tree bytes: 482656256
btree space waste bytes: 1171508121
file data blocks allocated: 12888981110784
referenced 12930453286912

real    24m20.493s
user    5m45.749s
sys     1m40.204s


Does this make any sense at all that check without --repair is so much
slower than with --repair or lowmem?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
