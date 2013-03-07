Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3CGLz3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Mar 2013 06:55:29 -0500
Date: Thu, 7 Mar 2013 12:55:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: clean snapshots one by one
Message-ID: <20130307115526.GL21081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAOcd+r152Ot9RYjGfCc_sW46BNKuKrhEN=xR_hw_9QKSu5Agpw@mail.gmail.com>
 <1362154654-17655-1-git-send-email-dsterba@suse.cz>
 <CAOcd+r2_8sXRgQ2EnLBQhKR0kOZz-PEOXUhLy7GmS7oS-8y0Dw@mail.gmail.com>
 <20130306180915.GD21081@twin.jikos.cz>
 <20130307031211.GC13323@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130307031211.GC13323@shiny.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 06, 2013 at 10:12:11PM -0500, Chris Mason wrote:
> > > Also, I want to ask, hope this is not inappropriate. Do you also agree
> > > with Josef, that it's ok for BTRFS_IOC_SNAP_DESTROY not to commit the
> > > transaction, but just to detach from it? Had we committed, we would
> > > have ensured that ORPHAN_ITEM is in the root tree, thus preventing
> > > from subvol to re-appear after crash.
> > > It seems a little inconsistent with snap creation, where not only the
> > > transaction is committed, but delalloc flush is performed to ensure
> > > that all data is on disk before creating the snap.
> > 
> > That's another question, can you please point me to the thread where
> > this was discussed?
> 
> That's a really old one.  The original snapshot code expected people to
> run sync first, but that's not very user friendly.  The idea is that if
> you write a file and then take a snapshot, that file should be in the
> snapshot.

The snapshot behaviour sounds ok to me.

That a subvol/snapshot may appear after crash if transation commit did
not happen does not feel so good. We know that the subvol is only
scheduled for deletion and needs to be processed by cleaner.

>From that point I'd rather see the commit to happen to avoid any
unexpected surprises.  A subvolume that re-appears still holds the data
references and consumes space although the user does not assume that.

Automated snapshotting and deleting needs some guarantees about the
behaviour and what to do after a crash. So now it has to process the
backlog of previously deleted snapshots and verify that they're not
there, compared to "deleted -> will never appear, can forget about it".


david
