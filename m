Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41831 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaEJNwH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 09:52:07 -0400
Date: Sat, 10 May 2014 06:51:53 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
Message-ID: <20140510135153.GE9276@merlins.org>
References: <2678329.EOSaIZaHNO@quad>
 <0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com>
 <20140510004254.GB9276@merlins.org>
 <20140510010518.GP16185@carfax.org.uk>
 <2AB0814E-BFF4-47A9-832F-2DED825E5763@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2AB0814E-BFF4-47A9-832F-2DED825E5763@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 09, 2014 at 07:54:20PM -0600, Chris Murphy wrote:
> However, I have a recent case in VBox guest, with guest additions
> built. That cause the kernel to be tainted G because it's an out
> of tree kernel module for guest additions. I'm getting a bunch of
> Btrfs errors that aren't reproducible with an untainted kernel. So

Oh, really?

Then considering my crash happened soon after I tried to run vbox but
didn't succeed due to a module that was out of date, I'd say that there
is a decent chance it's related.

That would be a pretty severe bug if it allows it to corrupt data that
btrfs uses, but it's possible.

However, I'm surprised that btrfs would have gotten so damaged that it
can't even reopen its filesystem with btrfs recovery when given the
right find-root value. For that to be possible, if it's not a bug in
btrfs, it must have been some massive corruption :-/

> I'm not filing a bug against Btrfs, instead I've filed a bug against
> VirtualBox because I'm also getting a pile of read write errors with
> /dev/sda which is backed by a VDI. A virtual device producing hardware

Note that in my case, I wasn't trying to run linux inside vbox, just to
start a win7 vm guest on my linux laptop.
Is that a case that also is known to cause problems?

The win7 VM was backed by a vdi image on my btrfs FS, however since the
image never was able to start, I'm not certain it could have done much.
Then again, you never know.

Given the multiple problems in 3.14 that only seem to be fixed in 3.15rc
(that in itself is a bit troubling by the way), I'm going to switch to
3.15rc5, but for the reasons we discussed, this doesn't fill me with joy
:-/

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
