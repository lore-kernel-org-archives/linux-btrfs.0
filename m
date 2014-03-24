Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40547 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaCXWEK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 18:04:10 -0400
Date: Mon, 24 Mar 2014 15:04:09 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-tools missing "btrfs device delete devid=x path" ?
Message-ID: <20140324220409.GD11533@merlins.org>
References: <20140323152516.GJ12833@merlins.org> <20140323161843.GD25400@carfax.org.uk> <20140323162506.GL12833@merlins.org> <pan$5c9a9$34404310$3c11d99a$22bd163f@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$5c9a9$34404310$3c11d99a$22bd163f@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 24, 2014 at 06:38:30PM +0000, Duncan wrote:
> Marc MERLIN posted on Sun, 23 Mar 2014 09:25:06 -0700 as excerpted:
> 
> > On Sun, Mar 23, 2014 at 04:18:43PM +0000, Hugo Mills wrote:
> >> On Sun, Mar 23, 2014 at 08:25:17AM -0700, Marc MERLIN wrote:
> >>> 
> >>> What's the syntax for removing a drive that isn't there?
> >> 
> >>    btrfs dev del missing /path
> >> 
> >>    Removes all the missing devices.
> > 
> > Aaah, this worked, thank you.
> > This isn't documented in the 3.12 man page, but I'm guessing it'll be in
> > the upcoming 3.14.
> > 
> > I'll document this in the raid5 page I'm currently writing.
> 
> It's on the wiki as I remembered, covered on the multiple devices page.
> https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Removing_devices

So, I did read the entire wiki, but it's been a while, and either some
things got added since then, or some I just didn't remember because I didn't
need them at the time.
The problem, and we've talked about this before (my plea to make btrfsck put
a "--really-I-read-the-wiki-and-want-this" :) option as well as minimal
instructions in its usage that tell the unsuspecting user it's not what
they're looking for, here too, I carefully re-read the man page for btrfs
and this wasn't mentioned in it, or at least in my copy.
Out of sync docs happens, but I'm hopeful that the man page and tools --help
info can be the canonical place for info, even if they can point to a wiki
link since the average admin will always fail back to --help/--usage and the
man page first before looking for a missing option in a wiki somewhere else.
 
Does that sound reasonable?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
