Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55113 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdFUEGx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 00:06:53 -0400
Date: Tue, 20 Jun 2017 21:06:31 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 4.11.3: BTRFS critical (device dm-1): unable to add free space :-17 => btrfs check --repair runs clean
Message-ID: <20170621040631.GF5303@merlins.org>
References: <20170620143916.GA22987@merlins.org> <20170620152354.GD7140@carfax.org.uk> <20170620152648.GB22987@merlins.org> <20170620153601.GE7140@carfax.org.uk> <20170620154429.GC22987@merlins.org> <CAJCQCtQJmWaPYvvcApcR6_mVVkFvyALaTpcazhBGSDQAwzcBPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQJmWaPYvvcApcR6_mVVkFvyALaTpcazhBGSDQAwzcBPQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 20, 2017 at 09:26:27PM -0600, Chris Murphy wrote:
> Right now Btrfs isn't scalable if you have to repair it because large
> volumes run into this problem; one of the reasons for the lowmem mode.
> 
> It's a separate bug that it OOMs even with swap, I don't know why it
> won't use that, it should be up to kernel memory management to deal

The thing is that it doesn't even get OOM'ed.
I didn't look at the code, but I'm assuming it must be using kernel RAM
instead of user space RAM, which is why it can't be OOM'ed and why it gets
the kernel to deadlock.

If that is the case, then the user space code should monitor kernel space
usage and cancel the check if it's about to run out of usable RAM (better
than deadlocking the system).

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
