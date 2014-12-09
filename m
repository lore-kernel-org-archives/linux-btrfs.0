Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723AbaLIKzE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Dec 2014 05:55:04 -0500
Date: Tue, 9 Dec 2014 11:55:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: kreijack@inwind.it, dsterba@suse.cz, Dimitri John Ledkov <xnox@debian.org>,
        cwillu <cwillu@cwillu.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zygo Blaxell <zblaxell@furryterror.org>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
Message-ID: <20141209105504.GC20595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <547B5724.1060507@libero.it>
 <CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com>
 <CAE5mzvhOAi_Y2icLHOiUzG121ZALLZCTYhpjY8mkio3AyHrECA@mail.gmail.com>
 <CANBHLUhHktgJRYR5JDjPmvq=299iDR3xmwoPTjFh5ey7DnFxZw@mail.gmail.com>
 <1417793566.21214.11@mail.thefacebook.com>
 <CANBHLUgkY5YkFqe48H=vsS4w2uZr+nU0NBhy8o88A=vv3-nHkQ@mail.gmail.com>
 <20141205164144.GK9754@suse.cz>
 <5481F657.8090307@inwind.it>
 <1417805015.4845.0@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417805015.4845.0@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 05, 2014 at 01:43:35PM -0500, Chris Mason wrote:
> > I have the following reasons to support a mount.btrfs helper:
> > 1) it is in a good point to check that everything is ok (see the 
> > thread
> > related LVM snapshot, due to a dev.uuid conflicts),
> > 2) it is in a good point to issue a good error explanation (missing
> > device....)
> > 3) it may handle case like "degraded" mode, where the filesystem is 
> > not
> > fully functional but even as degraded have "some" functionals..
> 
> Ok, these three things are worth improving, but I'd like to take a 
> slightly different direction.  Instead of recreating chunks of btrfs 
> dev scan, lets extend btrfs dev scan to at the very least understand #1 
> and #2.  As much as possible we want to be leveraging the data in udev 
> instead of recreating that functionality.

Udev provides add/delete/change events, the mount helper would
additionally provide the 'mount' event (although the action wont' be
entirely user-defined).
