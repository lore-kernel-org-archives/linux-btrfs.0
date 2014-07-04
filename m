Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24627 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaGDDHl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 23:07:41 -0400
Date: Fri, 4 Jul 2014 11:07:22 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: 3.15.1: kernel BUG at fs/btrfs/locking.c:269
Message-ID: <20140704030721.GE20612@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20140702204152.GI20961@merlins.org>
 <20140703081318.GB20612@localhost.localdomain>
 <53B5125F.4070707@cn.fujitsu.com>
 <20140703134421.GS26932@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140703134421.GS26932@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 03, 2014 at 06:44:21AM -0700, Marc MERLIN wrote:
> Thanks for the patch. Hopefully this will make it to the next 3.15.x
> kernel.
> 
> I also went back to 3.14 anyway since the 'blocked for 120 seconds' look
> like another instance of deadlocks we've been discussing here.
> 
> But just curious:
> 
> > >>[160562.925463] parent transid verify failed on 2776298520576 wanted 41015 found 18120
> 
> What should I be doing about this?
> Does it mean that I do have some kind of corruption/damage on my
> filesystem?
> 

If there is another copy for the block(RAID1, DUP, RAID5/6), it'd try to read
the copy and repair the crc with the good one, it's all we can do about it.

> Also, is it possible to have all these messages state which devid they
> occurred on? I don't even know which device I should be worrying about
> right now, and although I'm running scrub now, my understanding is that
> scrub doesn't actually look at FS structures and is likely to miss this
> anyway.

Yes we can but it'd need a bit more effort, for now, all device msg we've seen
in panic info comes from sb->s_id which points to @fs_info->latest_device.

thanks,
-liubo

> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
