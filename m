Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33887 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbbFPOTW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 10:19:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z4rhh-00027m-S9
	for linux-btrfs@vger.kernel.org; Tue, 16 Jun 2015 16:19:05 +0200
Received: from c-73-47-108-123.hsd1.ma.comcast.net ([73.47.108.123])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 16:19:05 +0200
Received: from cdysthe by c-73-47-108-123.hsd1.ma.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 16:19:05 +0200
To: linux-btrfs@vger.kernel.org
From: Christian <cdysthe@gmail.com>
Subject: trim not working and irreparable errors from btrfsck
Date: Tue, 16 Jun 2015 10:18:56 -0400
Message-ID: <mlpb8i$dus$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a btrfs partions on my laptop containing / and /home. Recently I 
noticed that trim (fstrim) didn't work anymore. It always tells me there 
nothing to trim which can not be correct. I then tried to to run btrfsck 
--repair and this is the result:

ubuntu@ubuntu:~$ sudo btrfsck /dev/sda3 --repair
enabling repair mode
Fixed 0 roots.
Checking filesystem on /dev/sda3
UUID: 3d52dc93-c89f-453f-965d-8601d11e7710
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 257 inode 353819 errors 400, nbytes wrong
root 2260 inode 353819 errors 400, nbytes wrong
root 2262 inode 353819 errors 400, nbytes wrong
root 2264 inode 353819 errors 400, nbytes wrong
root 2266 inode 353819 errors 400, nbytes wrong
root 2268 inode 353819 errors 400, nbytes wrong
root 2270 inode 353819 errors 400, nbytes wrong
root 2273 inode 353819 errors 400, nbytes wrong
root 2275 inode 353819 errors 400, nbytes wrong
root 2277 inode 353819 errors 400, nbytes wrong
root 2279 inode 353819 errors 400, nbytes wrong
root 2281 inode 353819 errors 400, nbytes wrong
root 2283 inode 353819 errors 400, nbytes wrong
root 2285 inode 353819 errors 400, nbytes wrong
root 2287 inode 353819 errors 400, nbytes wrong
root 2289 inode 353819 errors 400, nbytes wrong
root 2291 inode 353819 errors 400, nbytes wrong
root 2293 inode 353819 errors 400, nbytes wrong
root 2295 inode 353819 errors 400, nbytes wrong
root 2297 inode 353819 errors 400, nbytes wrong
root 2299 inode 353819 errors 400, nbytes wrong
root 2301 inode 353819 errors 400, nbytes wrong
root 2303 inode 353819 errors 400, nbytes wrong
root 2305 inode 353819 errors 400, nbytes wrong
root 2317 inode 353819 errors 400, nbytes wrong
root 2320 inode 353819 errors 400, nbytes wrong
root 2326 inode 353819 errors 400, nbytes wrong
root 2556 inode 353819 errors 400, nbytes wrong
root 2574 inode 353819 errors 400, nbytes wrong
root 2592 inode 353819 errors 400, nbytes wrong
root 2601 inode 353819 errors 400, nbytes wrong
root 2617 inode 353819 errors 400, nbytes wrong
root 2620 inode 353819 errors 400, nbytes wrong
root 2621 inode 353819 errors 400, nbytes wrong
root 2624 inode 353819 errors 400, nbytes wrong
root 2625 inode 353819 errors 400, nbytes wrong
root 2626 inode 353819 errors 400, nbytes wrong
root 2627 inode 353819 errors 400, nbytes wrong
root 2628 inode 353819 errors 400, nbytes wrong
root 2629 inode 353819 errors 400, nbytes wrong
root 2630 inode 353819 errors 400, nbytes wrong
root 2631 inode 353819 errors 400, nbytes wrong
root 2632 inode 353819 errors 400, nbytes wrong
found 49406146650 bytes used err is 1
total csum bytes: 117817456
total tree bytes: 792248320
total fs tree bytes: 604520448
total extent tree bytes: 52101120
btree space waste bytes: 180897891
file data blocks allocated: 195314843648
  referenced 135991529472
Btrfs v3.17

I get the exact same result every time I run btrfsck --repair. If the 
file system irreparable or is there something I can do to save it?


-- 
//Christian


