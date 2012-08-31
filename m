Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:53648 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab2HaABD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 20:01:03 -0400
Date: Thu, 30 Aug 2012 20:01:01 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: Martin Steigerwald <Martin@lichtvoll.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Varying Leafsize and Nodesize in Btrfs
Message-ID: <20120831000101.GB5888@shiny.msi.event>
References: <CAKcLGm_MKEdTiHFBd-b-v2sN5gJmgFRqsykzWRXTVqUw4O6Acw@mail.gmail.com>
 <20120830162512.GA2879@localhost.localdomain>
 <201208302334.49399.Martin@lichtvoll.de>
 <20120830215008.GB2879@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120830215008.GB2879@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2012 at 03:50:08PM -0600, Josef Bacik wrote:
> On Thu, Aug 30, 2012 at 03:34:49PM -0600, Martin Steigerwald wrote:
> > I wonder what a good value for SSD might be. I tend to not use anymore 
> > than 16k, but thats just some gut feeling right now. Nothing based on a 
> > well-founded explaination.
> >
> 
> 32k really starts to depend on your workload.  Generally speaking everybody will
> be faster with 16k, but 32k starts to depend on your workload and hardware, and
> then anything about 64k really starts to hurt with memmove().  With this sort of
> thing SSD vs not isn't going to make much of a difference, erase blocks tend to
> be several megs in size so you aren't going to get anywhere close to avoiding
> the internal RMW cycle inside the ssd.  Thanks,

I almost made 16k the default, but the problem is that it does increase
lock contention because bigger nodes mean fewer locks.  You can see this
with dbench and compilebench, especially early in the FS life.

My goal is to make the cow step of btrfs_search_slot really atomic, so
we don't have to switch to a blocking lock.  That will really fix a lot
of contention problems.

-chris

