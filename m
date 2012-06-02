Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:35005 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966278Ab2FBDSO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jun 2012 23:18:14 -0400
Date: Sat, 2 Jun 2012 05:18:11 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at fs/btrfs/extent_map.c:226
 unpin_extent_cache+0x4b/0xa0()
Message-ID: <20120602031811.GA329@x4>
References: <20120602021009.GA332@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120602021009.GA332@x4>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012.06.02 at 04:10 +0200, Markus Trippelsdorf wrote:
> I'm running the latest git kernel with the btrfs updates already merged.
> Today I've hit the following warnings during rsnapshot backup:
> 
> Jun  1 22:26:30 x4 kernel: Adding 1953788k swap on /dev/sda2.  Priority:-1 extents:1 across:1953788k 
> Jun  2 01:52:30 x4 kernel: ------------[ cut here ]------------
> Jun  2 01:52:30 x4 kernel: WARNING: at fs/btrfs/extent_map.c:226 unpin_extent_cache+0x4b/0xa0()

 # btrfsck /dev/sdb1
failed to read /dev/sr0: No medium found
failed to read /dev/sr0: No medium found
root 773 inode 2315 errors 400
root 773 inode 16035 errors 1000
root 773 inode 23441 errors 1000
root 773 inode 23487 errors 400
root 773 inode 23888 errors 400
root 773 inode 27513 errors 1000
root 773 inode 103998 errors 1000
root 773 inode 110549 errors 400
root 773 inode 110922 errors 400
root 773 inode 111092 errors 400
root 773 inode 111204 errors 400
root 773 inode 238989 errors 400
root 773 inode 239005 errors 400
root 773 inode 239006 errors 400
root 773 inode 239007 errors 400
root 773 inode 239155 errors 400
root 773 inode 239238 errors 400
root 773 inode 241169 errors 400
root 773 inode 247072 errors 400
root 773 inode 247076 errors 400
root 773 inode 247078 errors 400
root 773 inode 247079 errors 400
root 773 inode 247082 errors 400
root 773 inode 247084 errors 400
root 773 inode 247085 errors 400
root 773 inode 247086 errors 400
root 773 inode 247087 errors 400
root 773 inode 247088 errors 400
root 773 inode 247092 errors 400
root 773 inode 247094 errors 400
root 773 inode 247096 errors 400
root 773 inode 247099 errors 400
root 773 inode 249924 errors 400
root 773 inode 272199 errors 1000
root 773 inode 274836 errors 400
root 773 inode 275402 errors 400
root 773 inode 279188 errors 400
root 773 inode 279454 errors 400
root 773 inode 279473 errors 400
root 773 inode 280002 errors 1000
root 773 inode 280378 errors 400
root 773 inode 280425 errors 400
root 773 inode 280517 errors 400
root 773 inode 280598 errors 1000
root 773 inode 280721 errors 400
root 773 inode 280828 errors 1000
root 773 inode 281135 errors 400
root 773 inode 281587 errors 400
root 773 inode 282019 errors 400
root 773 inode 282534 errors 1000
root 773 inode 283008 errors 400
root 773 inode 283052 errors 400
root 773 inode 283644 errors 400
root 773 inode 284382 errors 400
root 773 inode 284755 errors 400
root 773 inode 284792 errors 400
root 773 inode 285630 errors 400
root 773 inode 285846 errors 400
root 773 inode 286754 errors 400
root 773 inode 287473 errors 400
root 773 inode 287474 errors 400
root 773 inode 288128 errors 400
root 773 inode 288894 errors 400
root 773 inode 289555 errors 400
root 773 inode 289594 errors 400
root 773 inode 290633 errors 1000
root 773 inode 290886 errors 400
root 773 inode 291418 errors 1000
root 773 inode 291643 errors 1000
root 773 inode 292149 errors 1000
root 773 inode 292654 errors 1000
root 773 inode 304425 errors 400
root 773 inode 306969 errors 1000
root 773 inode 307251 errors 1000
root 773 inode 307254 errors 1000
root 773 inode 307558 errors 400
root 773 inode 307591 errors 400
root 773 inode 308160 errors 400
root 773 inode 308870 errors 400
root 773 inode 308880 errors 1000
root 773 inode 309013 errors 400
root 773 inode 309323 errors 400
root 773 inode 309543 errors 400
root 773 inode 310070 errors 400
root 773 inode 310106 errors 400
root 773 inode 311893 errors 400
root 773 inode 312734 errors 1000
root 773 inode 312736 errors 1000
root 773 inode 313624 errors 400
root 773 inode 313629 errors 400
root 773 inode 313630 errors 400
root 773 inode 314326 errors 1000
root 773 inode 314516 errors 400
root 773 inode 314705 errors 400
root 773 inode 315962 errors 1000
root 773 inode 316073 errors 400
root 773 inode 316323 errors 1000
root 773 inode 316324 errors 1000
root 773 inode 318054 errors 1000
root 773 inode 318932 errors 1000
root 773 inode 319048 errors 1000
root 773 inode 323024 errors 1000
root 773 inode 323183 errors 1000
root 773 inode 323193 errors 1000
root 773 inode 323227 errors 1000
root 773 inode 323624 errors 1000
root 773 inode 323642 errors 1000
root 773 inode 323841 errors 1000
root 773 inode 324579 errors 400
root 773 inode 324806 errors 1000
root 773 inode 335590 errors 1000
root 773 inode 335985 errors 400
root 773 inode 336118 errors 1000
root 773 inode 336173 errors 1000
root 773 inode 338188 errors 1000
root 773 inode 338799 errors 1000
root 773 inode 338839 errors 1000
root 773 inode 347565 errors 400
root 773 inode 347570 errors 400
root 773 inode 347573 errors 400
root 773 inode 347579 errors 400
root 773 inode 347702 errors 1000
found 580033277952 bytes used err is 1
total csum bytes: 562329788
total tree bytes: 2014085120
total fs tree bytes: 1084829696
btree space waste bytes: 429308389
file data blocks allocated: 7079238537216
 referenced 588881031168
Btrfs Btrfs v0.19

-- 
Markus
