Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:49558 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbcCCM2c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 07:28:32 -0500
Received: from tux.wizards.de (p579D0048.dip0.t-ipconnect.de [87.157.0.72])
	by mail02.iobjects.de (Postfix) with ESMTPSA id 9E9ED4160165
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Mar 2016 13:28:29 +0100 (CET)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 3865811C00A9
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Mar 2016 13:28:29 +0100 (CET)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Stray 4k extents with slow buffered writes
Message-ID: <56D82DED.5030107@googlemail.com>
Date: Thu, 3 Mar 2016 13:28:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Here's an observation that is not a bug (as in data corruption), just
somewhat odd and unnecessary behaviour. It could be considered  a
performance or scalability bug.

I've noticed that slow slow buffered writes create a huge number of
unnecessary 4k sized extents. At first I wrote it off as odd buffering
behaviour of the application (a download manager), but it can be easily
reproduced. For example:

holger>wget --limit-rate=1m https://cdn.kernel.org/pub/linux/kernel/v4.x/testing/linux-4.5-rc6.tar.xz
(..downloads with 1 MB/s..)
holger>sync
holger>filefrag -ek linux-4.5-rc6.tar.xz 
Filesystem type is: 9123683e
File size of linux-4.5-rc6.tar.xz is 88362576 (86292 blocks of 1024 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   14219:  230807476.. 230821695:  14220:            
   1:    14220..   14223:  230838148.. 230838151:      4:  230821696:
   2:    14224..   29215:  230822324.. 230837315:  14992:  230838152:
   3:    29216..   44207:  230838152.. 230853143:  14992:  230837316:
   4:    44208..   44211:  230869576.. 230869579:      4:  230853144:
   5:    44212..   59199:  230853968.. 230868955:  14988:  230869580:
   6:    59200..   74191:  230869588.. 230884579:  14992:  230868956:
   7:    74192..   74195:  230898332.. 230898335:      4:  230884580:
   8:    74196..   86291:  230885620.. 230897715:  12096:  230898336: last,eof
linux-4.5-rc6.tar.xz: 9 extents found

Slower writes will generate even more extents; another ~200MB file
had >900 extents.

As expected defragment will collapse these stray extents with their
successors:

holger>btrfs filesystem defragment linux-4.5-rc6.tar.xz                                              
holger>sync
holger>filefrag -ek linux-4.5-rc6.tar.xz           
Filesystem type is: 9123683e
File size of linux-4.5-rc6.tar.xz is 88362576 (86292 blocks of 1024 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   14219:  230807476.. 230821695:  14220:            
   1:    14220..   29215:  230922128.. 230937123:  14996:  230821696:
   2:    29216..   44207:  230838152.. 230853143:  14992:  230937124:
   3:    44208..   59199:  230937124.. 230952115:  14992:  230853144:
   4:    59200..   74191:  230869588.. 230884579:  14992:  230952116:
   5:    74192..   86291:  230952116.. 230964215:  12100:  230884580: last,eof
linux-4.5-rc6.tar.xz: 6 extents found

The obviously page-sized 4k extents happen to coincide with the 30s tx commit
(2 * ~15 MB at 1 MB/s). It looks like a benign race, as if the last dirty page
gets special treatment instead of being merged into wherever it should go.
That just seems wasteful to me.

Anyone got an idea?

-h
