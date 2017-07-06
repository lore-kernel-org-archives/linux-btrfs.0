Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41601 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdGFVYX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2017 17:24:23 -0400
Date: Thu, 6 Jul 2017 14:24:22 -0700
From: Marc MERLIN <marc@merlins.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, pwnall@chromium.org
Subject: Re: Leveldb in google-chrome incompatible with btrfs?
Message-ID: <20170706212422.GH30689@merlins.org>
References: <20170706150046.GB12959@merlins.org> <20170706211320.GA12206@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170706211320.GA12206@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 06, 2017 at 02:13:20PM -0700, Omar Sandoval wrote:
> On Thu, Jul 06, 2017 at 08:00:46AM -0700, Marc MERLIN wrote:
> > I don't know who else uses google-chrome here, but for me, for as long as
> > I've used btrfs (3+ years now), I've had no end of troubles recovering from
> > a linux crash, and google-chrome has had problems recovering my tabs and
> > usually cmoplains about plenty of problems, some are corruption looking.
> 
> I've also had issues with chrome and Btrfs, not just you.
> 
> [snip]
> 
> > Does anyone know if it's leveldb relying on non POSIX semantics that just
> > happen to work out on ext4, or if btrfs COW and atomicity doesn't quite
> > handle multi file updates in a way that is expected by a spec, or by
> > application developers?
> 
> A quick google search turned this up: https://github.com/google/leveldb/issues/195.
> Unless anything has changed since that issue was last updated, it does
> sound like LevelDB is making some unsafe assumptions. I'll take a look.

Thanks Omar, this very much looks related indeed.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
