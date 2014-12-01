Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbaLARfv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 12:35:51 -0500
Date: Mon, 1 Dec 2014 18:35:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Marc MERLIN <marc@merlins.org>, Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141201173549.GJ12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org>
 <547C6922.6030206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <547C6922.6030206@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 01, 2014 at 08:12:02AM -0500, Austin S Hemmelgarn wrote:
> On 2014-11-29 23:23, Marc MERLIN wrote:
> > On Sun, Nov 30, 2014 at 09:03:14AM +0530, Shriramana Sharma wrote:
> >> IIUC with BtrFS while it is possible to easily undelete a file or
> >> ordinary directory if a snapshot of the containing subvol exists, it
> >> seems that it's not elementary to undelete a subvol itself, because
> >> all subvols are under the root-level subvol (id 0 or 5, see my other
> >> q) but even snapshotting the root subvol will not snapshot any subvols
> >> under it.
> >>
> >> So is there any way to undo a subvol delete?
> >
> > If you didn't snapshot that volume before deleting it, you're SOL.
> > If you snapshotted it, rename that snapshot to the other name, and
> > you're done.
> >
> > Btrfs doesn't offer undelete, it only lets you keep multiple copies of
> > your data at very little cost, so you can retrieve a snapshot copy if
> > you deleted your current volume's data.
> >
> > Marc
> >
> Well, in theory, if you unmount the FS _immediately_ after the subvol 
> delete, without writing _anything_ else to it, it _might_ be possible to 
> recover the data using some (probably almost incomprehensible) 
> incantation of btrfs-find-root and btrfs recover/restore.
> 
> In practice though, for anyone who doesn't have expert level knowledge 
> of the on-disk structure and fs internals, deleting a subvolume can't be 
> undone.

Agreed, though there's not so much magic involved. Deleting a subvolume
means removing the directory entry and the backrefrence. Undoing that
can make the subvolume live again, although the dir/name and original
parent tree cannot be reconstructed.

I'll add it to the project ideas.
