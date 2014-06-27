Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59136 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaF0Wdt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 18:33:49 -0400
Date: Fri, 27 Jun 2014 15:33:40 -0700
From: Marc MERLIN <marc@merlins.org>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20140627223340.GC28692@merlins.org>
References: <20140627185009.GA21428@merlins.org>
 <20140627204005.GB28692@merlins.org>
 <CAN05THQznt1=7yDTbJcwZqB149E3VueoTALmfyKJALQR9dPSAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN05THQznt1=7yDTbJcwZqB149E3VueoTALmfyKJALQR9dPSAw@mail.gmail.com>
Subject: Re: Also seeing full deadlocks with 3.15.1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 27, 2014 at 02:50:10PM -0700, ronnie sahlberg wrote:
> > If I don't hear anything by the end of today, I'll just delete the
> > filesystem and start over.
> 
> At some stage it would be nice to see not only fixes but also changes
> to fsck to make it able to repair these problems.
> Blow it away and create a new filesystem from scratch is sub-optimal.

I don't think you'll find disagreement from me or anyone here :)

But I'd go one step further. The filesystem is not corrupted as far as I
can tell, I'm happily copying data off it in ro,recovery mode (to
prevent background btrfs code from trying to do stuff and trip over
itself again).

The problem in my experience so far is that btrfs isn't stabilizing at
all. Some bugs are fixed, other things are changed, and new ones are
added.
I've not had a single version of btrfs in the last 4 kernels that didn't
deadlock and/or trip over itself (apparently from evolving or
balancing/filling filesystems into states where it can't handle them
properly anymore).

I really really wish we had a kernel release with only stabilizations
and where all recent deadlock and corruption problems (on newly created
filesystems) would be handled.
Right now, general state is bad enough that you can't tell if you hit a
new bug, or if it's an old bug that hasn't been fixed yet and developers
can't easily know if newer kernels have introduced regressions or not
since the general state of performance and stability isn't good across
all recent kernel versions.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
