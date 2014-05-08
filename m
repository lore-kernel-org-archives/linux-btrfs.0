Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44775 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaEHAnr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 20:43:47 -0400
Date: Wed, 7 May 2014 17:43:44 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: URGENT: my laptop's boot ssd btrfs crashed, what do you need off
 it?
Message-ID: <20140508004344.GE11401@merlins.org>
References: <20140507233959.GB11401@merlins.org>
 <536AD20E.70004@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <536AD20E.70004@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 08:38:38PM -0400, Chris Mason wrote:
> Looks like you're on 3.14, did this have the fixes from my git tree
> that went into 3.15-rc?
 
You're correct, it's running 3.14.0. Considering that it's my main laptop
that I kind of need to work, I avoid rc kernels if possible :)
But if I had known that 3.14 had corruption problems, I'd have
re-thought that :)
(besides my report, were there other ones I missed? Is 3.14.0 something
to avoid for now?)
(yes, I know 3.14.3 is out now, I should upgrade)

> For now I'd say that if you can make a dd image of the FS, please do
> so.  Otherwise, I don't want to suck down your time right before the
> trip.

A full dd image is not practical, it's 1TB and I have nowhere to put it.
I could do an image if you'd like, and upload it when I have proper
internet (I'm thinking it's likely going to be a 1GB upload)

(by the way, I'm already in the trip, and I have 1h before my next
plane and a bit of time tonight (in 10H my time that is) to upload stuff
or more logs if that helps.

But more importantly, I have my main file server at home running 3.14.0
too. Is there a risk of known corruption, or nothing known yet?

Of if you'd like output of fsck in dry-run mode, I can do that too.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
