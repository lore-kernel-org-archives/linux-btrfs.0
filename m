Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37875 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaGDGC4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 02:02:56 -0400
Date: Thu, 3 Jul 2014 23:02:53 -0700
From: Marc MERLIN <marc@merlins.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: 3.15.1: kernel BUG at fs/btrfs/locking.c:269
Message-ID: <20140704060253.GV11539@merlins.org>
References: <53B5125F.4070707@cn.fujitsu.com> <20140703134421.GS26932@merlins.org> <53B62481.3030606@cn.fujitsu.com> <20140702204152.GI20961@merlins.org> <20140703081318.GB20612@localhost.localdomain> <53B5125F.4070707@cn.fujitsu.com> <20140703134421.GS26932@merlins.org> <20140704030721.GE20612@localhost.localdomain> <20140704041102.GS11539@merlins.org> <53B63BB9.2020208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53B64022.9050900@cn.fujitsu.com> <53B63BB9.2020208@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 04, 2014 at 01:29:29PM +0800, Wang Shilong wrote:
> >Well, I explained the problem, ext4 and others of course tell me which 
> >devid
> >an error is on, hopefully btrfs will able to do so in the near future.
>
> So it is ok for you to print one of btrfs filesystem device(for example
> device name) ? maybe it is not really physical address the metadata
> locates in, this is easier.

Yes, the device name is great, now I can see which of my 3 filesystems has a
problem, that's a start.
Next would be knowing which filename this occurred in, but I understand this
would be harder to get from that point in the code.
Ideally scrub should be able to find that problem and report it, at least I
would know which filesystem to rescan for errors:

> >Back to the original problem, would you agree that
> >find / -type f -print0 | xargs grep . >/dev/nul?

I'll also have to try this to see if I get lucky with it :)

> +       printk_ratelimited("BTRFS (device: %s) parent transid verify 
> failed on %llu wanted %llu found %llu\n",
> +                       eb->fs_info->sb->s_id, eb->start,
> +                       parent_transid, btrfs_header_generation(eb));

That looks great. Ideally all such errors would look like this.

Thanks for looking into this, I appreciate it.

Best,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
