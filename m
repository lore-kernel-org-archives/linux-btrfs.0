Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54120 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755426AbeCSNEs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 09:04:48 -0400
Date: Mon, 19 Mar 2018 14:02:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of
 FS_TREE
Message-ID: <20180319130222.GE6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7ca269db-a724-5938-f4d8-b85e893fd558@jp.fujitsu.com>
 <20180319082010.GC17966@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180319082010.GC17966@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 19, 2018 at 08:20:10AM +0000, Hugo Mills wrote:
> On Mon, Mar 19, 2018 at 05:16:42PM +0900, Misono, Tomohiro wrote:
> > Currently, the top-level subvolume lacks the UUID. As a result, both
> > non-snapshot subvolume and snapshot of top-level subvolume do not have
> > Parent UUID and cannot be distinguisued. Therefore "fi show" of
> > top-level lists all the subvolumes which lacks the UUID in
> > "Snapshot(s)" filed.  Also, it lacks the otime information.
> > 
> > Fix this by adding the UUID and otime at the mkfs time.  As a
> > consequence, snapshots of top-level subvolume now have a Parent UUID and
> > UUID tree will create an entry for top-level subvolume at mount time.
> > This should not cause the problem for current kernel, but user program
> > which relies on the empty Parent UUID may be affected by this change.
> 
>    Is there any way of adding a UUID to the top level subvol on an
> existing filesystem? It would be helpful not to have to rebuild every
> filesystem in the world to fix this.

We can do that by a special purpose tool. The easiest way is to set the
uuid on an unmouted filesystem, but as this is a one-time action I hope
this is acceptable. Added to todo, thanks for the suggestion.
