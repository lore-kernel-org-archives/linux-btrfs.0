Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41015 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEWXNm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 19:13:42 -0400
Date: Fri, 23 May 2014 16:13:37 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        takeuchi_satoru@jp.fujitsu.com
Subject: Re: 3.15.0-rc5: now sync and mount are hung on
 call_rwsem_down_write_failed
Message-ID: <20140523231337.GC12384@merlins.org>
References: <20140522090921.GA12037@merlins.org>
 <20140522131528.GB22952@merlins.org>
 <pan$ed92c$6d9566f6$dd2041b0$f135597e@cox.net>
 <20140523002243.GE12312@merlins.org>
 <20140523141722.GA11991@merlins.org>
 <537FAE91.20308@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537FAE91.20308@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 23, 2014 at 04:24:49PM -0400, Chris Mason wrote:
> > I was able to kill btrfs send and receive, but mencoder is very hung, and
> > sync does not finish either:
> > 10654 merlin   sync                        sync_inodes_sb
> > 17191 merlin   sync                        call_rwsem_down_read_failed
> > 
> > I'm not posting the sysrq-w every time, but I have it available if needed.
> 
> Hi Marc,
> 
> Can I have the sysrq-w from this one if it's still available?

Argh, just found out that the bug caused none of the 2 copies to ever
be committed to disk (including an ext4 partition), and the remote
syslog lost too much for it to be useful.

What's more weird is the previous one, where I was able to copy the
syslog data that never got committed to disk but was still in the page
cache to another machine, I just realized that this one is missing the
beginning (it starts at cpu #4).

So it looks like the only complete one I have right now is
http://marc.merlins.org/tmp/btrfs-hang.txt

If you need more, please let me know, and I'll make sure that I save
that very carefully next time.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
