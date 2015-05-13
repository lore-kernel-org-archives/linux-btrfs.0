Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56389 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934127AbbEMONm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 10:13:42 -0400
Received: from [192.168.178.24] ([78.54.133.58]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MRoyH-1Ylccc3bGD-00StPT for
 <linux-btrfs@vger.kernel.org>; Wed, 13 May 2015 16:13:39 +0200
Message-ID: <55535C12.3010807@gmx.de>
Date: Wed, 13 May 2015 16:13:38 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: shall I use BTRFS sub-volumes for top-level directories ?
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To support the Gentoo Linux ecosystem I do maintain a server as a tinderbox. I create chroot images based on various Gentoo minmal ISO images. I usually run 4 chroot image jobs in parallel. The chroots are full-filled over days/weeks with the compiled output. Issues during that are filed into Gentoo's bugzilla.

If an image is "full" (~35 GB with many files + directories in it) or completely bricked I create a new one of the same type. The old is kept for weeks/months to further serve to bug reports questions. But old images are rarely accessed usually.

Because deleting a chroot image takes awfully long and b/c I experience iowait spikes even if the 3 TB drive isn't filled by more than 50% I do wonder, if it would make sense to create a btrfs subvolume for each chroot image ?
The deletion of a subvolume should be fast compared to recursivly deleting a 35 GB file system structure, right ?

(And BTW what's about re-balancing of the BTRFS-tree during the daily usage: wouldn't this profit from that too ?

-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E
--
"; the past is all dirty and cruel in the modern popular imagination, with the exception of the Romans, who are just cruel"
Ian Mortimer, 2008, "The Time Traveller's Guide to Medieval England"
