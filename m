Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaLCTGv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 14:06:51 -0500
Date: Wed, 3 Dec 2014 20:06:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Shriramana Sharma <samjnaa@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141203190650.GY12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <547D663A.3020201@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <547D663A.3020201@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 02, 2014 at 04:11:54PM +0900, Satoru Takeuchi wrote:
> Hi,
> 
> (2014/11/30 12:33), Shriramana Sharma wrote:
> > IIUC with BtrFS while it is possible to easily undelete a file or
> > ordinary directory if a snapshot of the containing subvol exists, it
> > seems that it's not elementary to undelete a subvol itself, because
> > all subvols are under the root-level subvol (id 0 or 5, see my other
> > q) but even snapshotting the root subvol will not snapshot any subvols
> > under it.
> >
> > So is there any way to undo a subvol delete?
> >
> > [If no, then ordinary users should probably prefer regular directories
> > to subvols.]
> >
> 
> One solution is using snapper instead of using btrfs directly.
> Snapper can automatically take a snapshot just before
> taking/deleting snapshots. So, if you delete a snapshot
> by mistake, it's still alive.

Although snapper can create a pre/post pair of snapsthots for a given
command 'snapper create -c "a command"', running subvolume deletion in
place of 'a command' does not make sense to me.

It's not clear how you intend to use snapper here. Let's say I'll
configure it for some subvolume, turn on periodic snapshots and also
create my own snapshots. The periodic (timeline) snapshots are created
every hour, but what if I create my own snapshot, delete it accidentaly
... how does the snapper-snapshots help here?

To be perfectly safe from accidental snapshot deletion in general, I'd
have to always create two instances, and move one somewhere safe.
