Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48850 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaLAAKL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 19:10:11 -0500
Date: Sun, 30 Nov 2014 16:10:08 -0800
From: Marc MERLIN <marc@merlins.org>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20141201001008.GS8916@merlins.org>
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
 <20141130042123.GD8916@merlins.org>
 <CAH-HCWW9LQgTc-rhfbbLJBvGu7uCAFiTr_VJ0c=H_ZjYjDW5gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWW9LQgTc-rhfbbLJBvGu7uCAFiTr_VJ0c=H_ZjYjDW5gA@mail.gmail.com>
Subject: Re: Moving an entire subvol?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 03:57:06PM +0530, Shriramana Sharma wrote:
> On Sun, Nov 30, 2014 at 9:51 AM, Marc MERLIN <marc@merlins.org> wrote:
> >
> >> So the Ubuntu Wiki BtrFS entry advises against using subvol
> >> set-default because it boots its kernel using root=subvol=@ and home
> >> as subvol=@home, and these two subvols are only present under the
> >> subvol with ID 5. But isn't it just possible to move i.e. reparent a
> >> subvol so I can move these two under another subvol and have that as
> >> default?
> >
> > Make a new subvolume called /root and just mount subvol=root
> 
> Sorry if my question wasn't clear: I wanted to know how to move a
> subvol to appear under another subvol other than its original parent.
> Turns out that sudo mv @ @home target/ is quite sufficient. If so why
> would the Ubuntu wiki require that set-default not be used? Just @
> @home need to be moved to the new place, no?

I've never done that. If I had to move them, I'd just change the
mountpoint.
 
> > Note that you can't mount subvols recursively in one mount AFAIK.
> 
> I'm not sure what you mean. I have a few subvols in my external HDD
> which is entirely formatted as BtrFS and if I just mount the external
> HDD /dev/sdc1 I am able to access all the subvols' contents as well.

Yes, if you mount the root, it works of course.
If you mount a subvol, you cannot have it automatically have it mount
other subvols.
Subvols don't really know or care where they are mounted compared to one
another, and who is under whom. It's just mount setup.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
