Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35961 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaEUD7h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 23:59:37 -0400
Date: Tue, 20 May 2014 20:59:28 -0700
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Scott Middleton <scott@assuretek.com.au>, linux-btrfs@vger.kernel.org,
        Mark Fasheh <mfasheh@suse.de>
Subject: Re: historical backups with hardlinks vs cp --reflink vs snapshots
Message-ID: <20140521035928.GW10656@merlins.org>
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com>
 <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net>
 <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com>
 <20140519010705.GI10566@merlins.org>
 <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com>
 <537A2AD5.9050507@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537A2AD5.9050507@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 19, 2014 at 06:01:25PM +0200, Brendan Hide wrote:
> On 19/05/14 15:00, Scott Middleton wrote:
> >On 19 May 2014 09:07, Marc MERLIN <marc@merlins.org> wrote:
> >>On Wed, May 14, 2014 at 11:36:03PM +0800, Scott Middleton wrote:
> >>>I read so much about BtrFS that I mistaked Bedup with Duperemove.
> >>>Duperemove is actually what I am testing.
> >>I'm currently using programs that find files that are the same, and
> >>hardlink them together:
> >>http://marc.merlins.org/perso/linux/post_2012-05-01_Handy-tip-to-save-on-inodes-and-disk-space_-finddupes_-fdupes_-and-hardlink_py.html
> >>
> >>hardlink.py actually seems to be the faster (memory and CPU) one event
> >>though it's in python.
> >>I can get others to run out of RAM on my 8GB server easily :(
> 
> Interesting app.
> 
> An issue with hardlinking (with the backups use-case, this problem isn't likely to happen), is that if you modify a file, all the hardlinks get changed along with it - including the ones that you don't want changed.
> 
> @Marc: Since you've been using btrfs for a while now I'm sure you've already considered whether or not a reflink copy is the better/worse option.

Yes, I have indeed considered it :)

I just wrote a blog post about the 3 way of doing historical snapshots:
http://marc.merlins.org/perso/btrfs/post_2014-05-20_Historical-Snapshots-With-Btrfs.html
 
I love reflink, but that forces me to use btrfs send as the only way to
copy a filesystem without losing the reflink relationship, and I have no
good way from user space to see the blocks shared to see how many are
shared or whether some just got duped in a copy.
As a result, for now I still use hardlinks.

Once bedup is a bit more ready, I may switch.

That said, duperemove is another dedup I wasn't aware of and I should
look at indeed:
https://github.com/markfasheh/duperemove/blob/master/README

Does it basically do the same work then bedup and tell btrfs to
consolidate blocks it indentified as dupes?
Does it work across subvolumes?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
