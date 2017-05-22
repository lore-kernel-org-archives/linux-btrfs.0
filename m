Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44787 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752570AbdEVX5z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 19:57:55 -0400
Date: Mon, 22 May 2017 16:57:54 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy memory stalls
Message-ID: <20170522235754.GJ29894@merlins.org>
References: <20170521214733.c62v7el4g66jf63x@merlins.org> <20170521234557.pu3vs3igdx7mqjzb@merlins.org> <20170522013553.hspdrwpmxe5kyoas@merlins.org> <20170522163156.5hcuw5tqfavjkmnm@merlins.org> <CAJCQCtSO5O7Pi-4oLsZNr6r6PLVEL6EXA6wpWPjBSUKYe9m4Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSO5O7Pi-4oLsZNr6r6PLVEL6EXA6wpWPjBSUKYe9m4Gg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 22, 2017 at 05:26:25PM -0600, Chris Murphy wrote:
> On Mon, May 22, 2017 at 10:31 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
> >
> > I already have 24GB of RAM in that machine, adding more for the real
> > fsck repair to run, is going to be difficult and ndb would take days I
> > guess (then again I don't have a machine with 32 or 48 or 64GB of RAM
> > anyway).
> 
> If you can acquire an SSD, you can give the system a bunch of swap,
> and at least then hopefully the check repair can complete. Yes it'll
> be slower than with real RAM but it's not nearly as bad as you might
> think it'd be, based on HDD based swap.

Oh, swap will work, you're sure? 
I already have an SSD, if that's good enough, I can give it a shot.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
