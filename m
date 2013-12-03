Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab3LCQnr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Dec 2013 11:43:47 -0500
Date: Tue, 3 Dec 2013 17:43:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        clm@fb.com, jbacik@fb.com
Subject: Re: [PATCH] Btrfs: optimize btrfs_lookup_extent_info() - extent
 refcount mismatches?
Message-ID: <20131203164344.GW25312@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20131129154525.GN25312@twin.jikos.cz>
 <CAL3q7H7CmaKsnQQacpZck3zGV35ikhTwqX=Xg9eAiM97kb5TwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7CmaKsnQQacpZck3zGV35ikhTwqX=Xg9eAiM97kb5TwA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 29, 2013 at 07:55:37PM +0000, Filipe David Manana wrote:
> On Fri, Nov 29, 2013 at 3:45 PM, David Sterba <dsterba@suse.cz> wrote:
> > Hi,
> >
> > On Fri, Jul 05, 2013 at 09:32:05PM +0100, Filipe David Borba Manana wrote:
> >> If we're looking for a metadata item in the tree and the
> >> search fails with return value of 1, and the slot doesn't
> >> point to the first item in the leaf, check if the previous
> >> item in the leaf corresponds to an extent item for the same
> >> object id - if it does, then don't do another tree search
> >> to get it.
> >
> > I'm suspecting this patch to cause some trouble, see
> > https://bugzilla.kernel.org/show_bug.cgi?id=64961
> 
> What makes you believe the problem is exactly in this function?

It was a first guess based on the stacktraces and last patch that
touched the code. I've replied to mailinlist because it has higher
visibility, number of bugreports in balance/relocation has been
increasing lately (not blaming you).

> I read it again, and I can't see how it can miss an extent item that
> it couldn't before, specially without skinny metadata enabled.  Did
> the fs had skinny metadata enabled?

According to the updated bugzilla yes, and that's another possible
cause although we haven't seen bugs with skinny metadata yet. There's
another bugreport that has them enabled,
https://bugzilla.kernel.org/show_bug.cgi?id=66411


david
