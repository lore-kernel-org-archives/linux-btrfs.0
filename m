Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51276 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdFVAtH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 20:49:07 -0400
Date: Wed, 21 Jun 2017 17:48:49 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: How to fix errors that check --mode lomem finds, but --mode normal doesn't?
Message-ID: <20170622004849.GV5303@merlins.org>
References: <20170620143916.GA22987@merlins.org> <20170620152354.GD7140@carfax.org.uk> <20170620152648.GB22987@merlins.org> <20170620153601.GE7140@carfax.org.uk> <20170620154429.GC22987@merlins.org> <20170620231202.GB5303@merlins.org> <CAJCQCtQMWKJwWjeM4zEb-W7-tjsZyfCo37YyT2xYi0fNTEzcUQ@mail.gmail.com> <20170621034352.GE5303@merlins.org> <20170621151339.GK5303@merlins.org> <CAJCQCtT0M77onJ=XnnQi9H9Ty_h6v009GhDK5NSTevHh5jFZbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtT0M77onJ=XnnQi9H9Ty_h6v009GhDK5NSTevHh5jFZbA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 21, 2017 at 05:22:15PM -0600, Chris Murphy wrote:
> I don't know what it means. Maybe Qu has some idea. He might want a
> btrfs-image  of this file system to see if it's a bug. There are still
> some bugs found with lowmem mode, so these could be bogus messages.
> But the file system clearly has problems, the question is why does
> such a new file system have these kinds of problems that can't be
> fixed by normal repair because they aren't even being detected; or
> maybe there is no problem on disk per se, the problem might be a bug.
 
Yes, that's indeed the question I was asking myself too :)
Now, I did have a couple of drives that got kicked out of a (mdadm, not
btrfs) raid array, causing the array to go away while btrfs was trying to
write to it, but my understanding of btrfs write journalling is that the new
data that was being written should have been discarded and I should have
ended up at the previous good state.
AFAIK, I'm pretty sure I didn't get any block layer corruption this time, I
just got a drive effectively pulled from a running array (well 2, one went
to degraded, and the 2nd one killed the array. I re-added them carefully and
correctly in the right order and mdadm rebuilt what it needed using the
extent tree)

For what it's worth, I've had no end of trouble with Sata SAS cards and their 4
sata cables in one:
https://www.amazon.com/gp/product/B0050SLTPC/ref=oh_aui_search_detailpage?ie=UTF8&psc=1
https://www.amazon.com/gp/product/B013G4EMH8/ref=oh_aui_search_detailpage?ie=UTF8&psc=1

I have it stable now, but those cables are super sensitive and have caused
drives to get kicked out if they weren't air canned first, and plugged in
just right :-/

> In which case, off chance going back to a substantially older kernel
> might help. Maybe the latest 4.9 series kernel?

If there is reasonable evidence that it will help, I can give it a shot.

Qu, or anyone, given that btrfs-image is going to take a long time (maybe a
day or more), given that I have to use at least -s before I can share the
image, and if I need -ss, then it's even slower from what I remember.

Basically please suggest the fastest image algorithm I can use. It's a quad
core HT machine, so should I use
btrfs-image -c0 -t8 -s /dev/ image
(I'm assuing -c9 will not be faster and that -ss will be even slower)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
