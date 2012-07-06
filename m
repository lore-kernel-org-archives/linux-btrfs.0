Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:34082 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030243Ab2GFLz1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 07:55:27 -0400
Date: Fri, 6 Jul 2012 07:55:24 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Alexander Block <ablock84@googlemail.com>
CC: "kreijack@inwind.it" <kreijack@inwind.it>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] Btrfs "sendshots" and hidden snapshots
Message-ID: <20120706115524.GH7159@shiny>
References: <CAB9VWqCnbd-Mqo6Po408uqhbbSyg=W4Huiqs61HLxc8=nkdQdQ@mail.gmail.com>
 <4FF61669.9080605@libero.it>
 <CAB9VWqBcZNc7unKA9sFC9nUrBgCB=G3tsDy89QXiQBmdvzbkwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAB9VWqBcZNc7unKA9sFC9nUrBgCB=G3tsDy89QXiQBmdvzbkwA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 06, 2012 at 02:51:43AM -0600, Alexander Block wrote:
> On Fri, Jul 6, 2012 at 12:34 AM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> > On 07/05/2012 06:51 PM, Alexander Block wrote:
> >> Hello all,
> >>
> >> in IRC we had a discussion on how we could solve sending live
> >> subvolumes and how to send subvolumes without the need to
> >> administrate/keep old snapshots for incremental sends. One of the
> >> ideas was to introduce "sendshots", which are basically snapshots
> >> where no refs are counted for file data. This means, that when file
> >> data is changed in the sendshot origin, we do not consume extra space
> >> for two copies of the data. We would only have the metadata
> >> duplicated.
> >>
> >> For the initial btrfs send we could do this:
> >> 1. Create a hidden read-only snapshot of the subvolume to send. Hidden
> >> means that it's not referenced by any subvolume. It is however still a
> >> normal snapshot (not a sendshot!). Hidden snapshots are not possible
> >> atm so we would have to implement that. This step allows us to send
> >> read-write subvolumes, because we have a freezed version of it.
> >
> > Why we should want/need an hidden snapshot ? We could put this kind of
> > hidden snapshot under a directory dot-prefixed (like /.hidden-subvolumes)
> That would have the problem that the user may modify the subvolume
> in-between (by removing the ro flag). Or he could simple cd into it
> and we would later fail to delete it.

I prefer to make this more explicit.  We could add a hard-readonly flag
that cannot be cleared.  Having the snapshot show in the FS lets the
admin know what things are really using space.

-chris
