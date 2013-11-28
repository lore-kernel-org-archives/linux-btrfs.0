Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab3K1SbX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 13:31:23 -0500
Date: Thu, 28 Nov 2013 19:31:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS-PROG: recursively subvolume snapshot and delete
Message-ID: <20131128183122.GL25312@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 16, 2013 at 06:09:00PM +0100, Goffredo Baroncelli wrote:
> the following patches implement the recursively snapshotting and
> deleting of a subvolume. 

Nice feature, but can we try to make the snapshot creation atomic? This
would need support from kernel of course.

I'm worried about the outcome from the users' perspective, the
consistency of the whole subvolume subtree. As you've implemented it,
there are several operations involved like traversing the subvolume
list, replacing the empty-subvols with the real ones, taking the
snapshots. The assumptions about existing source subvolumes may change
in the meantime: renamed or deleted.

The recursive deletion is safer form this point, I'll look at the
patches closer. Deleting the whole directory subtree with randomly
scattered subvolumes is not easy atm, I'm using wrappers around find and
maxdepth/mindepth to look for subvols and issue delete until it's done.


david
