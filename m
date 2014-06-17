Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33887 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873AbaFQOkL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 10:40:11 -0400
Date: Tue, 17 Jun 2014 07:40:09 -0700
From: Marc MERLIN <marc@merlins.org>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.15-rc5 deadlocked a 2nd time after I was copying photos from an sdcard + common code path that deadlocks all btrfs filesystems
Message-ID: <20140617144009.GG19071@merlins.org>
References: <20140519134915.GA27432@merlins.org> <539FE03F.5030306@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <539FE03F.5030306@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 17, 2014 at 03:29:19PM +0900, Satoru Takeuchi wrote:
> Hi Marc,
> 
> (2014/05/19 22:49), Marc MERLIN wrote:
> >Ok, that's 2 out of 2.
> >
> >I was copying pictures from an sdcard (through mmcblk0), and the
> >filesystem deadlocked.
> >
> >Unfortunately, when this happens, I copied my pictures (which were still
> >in RAM) to my 2nd drive which was also btrfs.
> 
> From your sysrq capture, your sd card is formatted as VFAT, is it correct?

Yes, typical camera sdcard :)
 
> ===
> [194790.140892] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some 
> data may be corrupt. Please run fsck.
> ===
> 
> Did you try mkfs.fsck? In addition, does this problem happen
> after that? Here try to reproduce with 3.16-rc1 is desirable.

Tat was almost a month ago. The card has been reformatted since then, but
the problem was not with the sdcard or vfat FS. All the data was read fine,
ended up in the page cache, and btrfs failed to actually commit it to disk.
 
> If it's easy to reproduce,
> 
>  - run fsck.vfat (as I described before),
>  - change SD card,
>  - change copy target to other filesystem than btrfs
> 
> is useful to find out the root cause.

I wish I could reproduce this at will, but I can't. In some way, that's good
since I lost actual pictures (from Japan at the time) each time this
happened.

Either way, thanks for having a look.

I'll answer the rest in another message since it warrants another thread.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
