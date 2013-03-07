Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:40975 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3CGDMc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2013 22:12:32 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 86D0F9A0368
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Mar 2013 20:12:32 -0700 (MST)
Date: Wed, 6 Mar 2013 22:12:11 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: David Sterba <dsterba@suse.cz>
CC: Alex Lyakas <alex.btrfs@zadarastorage.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: clean snapshots one by one
Message-ID: <20130307031211.GC13323@shiny.masoncoding.com>
References: <CAOcd+r152Ot9RYjGfCc_sW46BNKuKrhEN=xR_hw_9QKSu5Agpw@mail.gmail.com>
 <1362154654-17655-1-git-send-email-dsterba@suse.cz>
 <CAOcd+r2_8sXRgQ2EnLBQhKR0kOZz-PEOXUhLy7GmS7oS-8y0Dw@mail.gmail.com>
 <20130306180915.GD21081@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130306180915.GD21081@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 06, 2013 at 11:09:15AM -0700, David Sterba wrote:
> On Sat, Mar 02, 2013 at 11:32:07PM +0200, Alex Lyakas wrote:
> > On Fri, Mar 1, 2013 at 6:17 PM, David Sterba <dsterba@suse.cz> wrote:
> > > -               btrfs_kill_all_delayed_nodes(root);
> > > +       btrfs_kill_all_delayed_nodes(root);
> > >
> > > -               if (btrfs_header_backref_rev(root->node) <
> > > -                   BTRFS_MIXED_BACKREF_REV)
> > > -                       ret = btrfs_drop_snapshot(root, NULL, 0, 0);
> > > -               else
> > > -                       ret =btrfs_drop_snapshot(root, NULL, 1, 0);
> > > -               BUG_ON(ret < 0);
> > > -       }
> > > -       return 0;
> > > +       if (btrfs_header_backref_rev(root->node) <
> > > +                       BTRFS_MIXED_BACKREF_REV)
> > > +               ret = btrfs_drop_snapshot(root, NULL, 0, 0);
> > > +       else
> > > +               ret = btrfs_drop_snapshot(root, NULL, 1, 0);
> > > +       /*
> > > +        * If we encounter a transaction abort during snapshot cleaning, we
> > > +        * don't want to crash here
> > > +        */
> > > +       BUG_ON(ret < 0 && (ret != -EAGAIN || ret != -EROFS));
> > > +       return run_again || ret == -EAGAIN;
> > I think that this expression will always evaluate to "true", because
> > "run_again" is set to 1 and never reset.
> 
> That's right, I probably had some intentions in the past, but now it's
> just superflous.
> 
> > So now if btrfs_drop_snapshot() returns -EAGAIN, then
> > btrfs_clean_one_deleted_snapshot() will return 1, thus telling the
> > caller "call me again", like your comment says. However, in this case
> > we are unmounting, so is this ok? Or this is just to avoid the cleaner
> > going to sleep?
> 
> close_ctree calls kthread_stop(cleaner) which would wake cleaner anyway.
> 
> The cases when we want send cleaner to sleep are when there's nothing to
> do or the read-only case which is just a safety check.
> 
> From that point, the last statement should be 'return 1' and run_again
> removed.
> 
> > Also, I want to ask, hope this is not inappropriate. Do you also agree
> > with Josef, that it's ok for BTRFS_IOC_SNAP_DESTROY not to commit the
> > transaction, but just to detach from it? Had we committed, we would
> > have ensured that ORPHAN_ITEM is in the root tree, thus preventing
> > from subvol to re-appear after crash.
> > It seems a little inconsistent with snap creation, where not only the
> > transaction is committed, but delalloc flush is performed to ensure
> > that all data is on disk before creating the snap.
> 
> That's another question, can you please point me to the thread where
> this was discussed?

That's a really old one.  The original snapshot code expected people to
run sync first, but that's not very user friendly.  The idea is that if
you write a file and then take a snapshot, that file should be in the
snapshot.

-chris

