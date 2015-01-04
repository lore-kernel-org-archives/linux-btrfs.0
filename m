Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34172 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbbADPSq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Jan 2015 10:18:46 -0500
Date: Sun, 4 Jan 2015 07:18:43 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: ignoring bad blocks
Message-ID: <20150104151843.GX17254@merlins.org>
References: <fab96edbc48bf3f26781ab76dda6f182@pl1.haspere.com>
 <CAJCQCtRYW_S8CDZQH_95RGtsTBHN3gftd9WgsScA7_oCpFYgOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRYW_S8CDZQH_95RGtsTBHN3gftd9WgsScA7_oCpFYgOg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 04, 2015 at 01:45:41AM -0700, Chris Murphy wrote:
> On Sat, Jan 3, 2015 at 10:40 PM, Dyweni - BTRFS <Y4BwxfPC4k5h@dyweni.com> wrote:
> > Hi All,
> >
> > Can BTRFS ignore bad blocks as they are discovered?
> >
> > I want to try BTRFS on some older drives, but they all have a few bad
> > blocks.
> 
> Not currently, and I don't see it in the project ideas list. Right now
> on Btrfs you will just get write errors, but I'm uncertain if it just
> tries a new sector and continues on (indirectly not use the bad sector
> but also not keeping track of it either)? The unreliable disk features
> are still project ideas.

badblocks are a thing of the past, as you hinted drives automatically
remap badblocks so that the filesystem doesn't have to deal with them.

If you have a questionable drive, you can indeed simply dd 0's over it
before you use it with btrfs.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
