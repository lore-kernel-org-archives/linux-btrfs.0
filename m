Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752707AbcIIQUW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 12:20:22 -0400
Date: Fri, 9 Sep 2016 18:18:43 +0200
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Graham Cobb <g.btrfs@cobb.uk.net>, linux-btrfs@vger.kernel.org
Subject: Re: Security implications of btrfs receive?
Message-ID: <20160909161843.GY16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
 <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <4a00b682-c674-a46f-798e-d98b3e517f02@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4a00b682-c674-a46f-798e-d98b3e517f02@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 07, 2016 at 07:58:30AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-09-06 13:20, Graham Cobb wrote:
> > Thanks to Austin and Duncan for their replies.
> >
> > On 06/09/16 13:15, Austin S. Hemmelgarn wrote:
> >> On 2016-09-05 05:59, Graham Cobb wrote:
> >>> Does the "path" argument of btrfs-receive mean that *all* operations are
> >>> confined to that path?  For example, if a UUID or transid is sent which
> >>> refers to an entity outside the path will that other entity be affected
> >>> or used?
> >> As far as I know, no, it won't be affected.
> >>> Is it possible for a file to be created containing shared
> >>> extents from outside the path?
> >> As far as I know, the only way for this to happen is if you're
> >> referencing a parent subvolume for a relative send that is itself
> >> sharing extents outside of the path.  From a practical perspective,
> >> unless you're doing deduplication on the receiving end, the this
> >> shouldn't be possible.
> >
> > Unfortunately that is not the case.  I decided to do some tests to see
> > what happens.  It is possible for a receive into one path to reference
> > and access a subvolume from a different path on the same btrfs disk.  I
> > have created a bash script to demonstrate this at:
> >
> > https://gist.github.com/GrahamCobb/c7964138057e4e092a75319c9fb240a3
> >
> > This does require the attacker to know the (source) subvolume UUID they
> > want to copy.  I am not sure how hard UUIDs are to guess.
> Oh, I forgot about the fact that it checks the whole filesystem for 
> referenced source subvolumes.

What if the stream is verified first? Ie. look if there are the
operations using subolumes not owned by the user.
