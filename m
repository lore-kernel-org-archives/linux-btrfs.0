Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:54634 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbcFNPaT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 11:30:19 -0400
Received: from tux.wizards.de (pD953E4E5.dip0.t-ipconnect.de [217.83.228.229])
	by mail02.iobjects.de (Postfix) with ESMTPSA id D0E5D416014E
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 17:30:17 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 6BE6511C01D2
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 17:30:17 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Another 'traling page extent' observation
Message-ID: <57602309.601@applied-asynchrony.com>
Date: Tue, 14 Jun 2016 17:30:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have made another observation regarding extra extents; it seems I'm
good at finding these things. Sorry. ;-)

This time it's with rsync. I found it when I started to use the --inplace
option, which doesn't do rsync's usual write-to-temporary/rename cycle, but
instead writes to a destination file directly. All of a sudden many newly
backed up files had a traling 4k extent, for no good reason.

This has nothing to do with extending overwrites (where new extents would
of course be fine); it happens when the file is new. It is also independent
of the file size or the filesystem state: it does not seem to be caused by
fragmented free space.

Reproducer example (current dir is btrfs):

$ls -al /tmp/data
-rw-r--r-- 1 root root 17569552 Jun 14 16:33 /tmp/data

$rm -f data && rsync /tmp/data . && sync && filefrag -ek data
Filesystem type is: 9123683e
File size of data is 17569552 (17160 blocks of 1024 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   17159:   53918020..  53935179:  17160:             last,eof
data: 1 extent found

$rm -f data && rsync --inplace /tmp/data . && sync && filefrag -ek data
Filesystem type is: 9123683e
File size of data is 17569552 (17160 blocks of 1024 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   17155:   48133532..  48150687:  17156:            
   1:    17156..   17159:   36734592..  36734595:      4:   48150688: last,eof
data: 2 extents found

This is repeatable and independent of the file, so I suspect that after
Liu Bo's fix for the previously reported stray extents in the middle
of the file with slow buffered writes [1] there's an edge case where a page
is still treated differently at the end after close()-ing the file - which
rsync does correctly.

This is on my 4.4.x++ kernel with btrfs ~4.7 and space_cache=v2, but since
it also happens on a fresh volume with v1 it's probably just another
off-by-one somewhere in the writeback/page handling.

thanks,
Holger

[1] commit a91326679f aka "Btrfs: make mapping->writeback_index point to the
last written page"
