Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbbFCK0P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jun 2015 06:26:15 -0400
Date: Wed, 3 Jun 2015 12:26:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Markus Schauler <mschauler@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't invalidate root dentry when subvolume
 deletion fails
Message-ID: <20150603102611.GK6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d901ccc6dbbc8db40962b4b8e4d391a684e88335.1432975901.git.osandov@osandov.com>
 <CAL3q7H6PvooaNWpKCTFgAxc=R0pT1XiwSQvJiYVXiV4iuJHXRA@mail.gmail.com>
 <20150603001914.GA21606@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150603001914.GA21606@mew>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 02, 2015 at 05:19:14PM -0700, Omar Sandoval wrote:
> I also can't figure out what that shrink_dcache_sb() is doing there.
> d_invalidate() already prunes the dentry cache under the deleted
> subvolume, but this clears the dcache for the whole filesystem, which
> could incur unnecessary overhead.

Correct analysis and the penalty is noticeable. In a directory where the
new/deleted subvolume flux is high. A 'ls' can take very long because all
the cached dentries are forcibly dropped and the metadata blocks have to be
read again.

> The call was added by efefb1438be2
> ("Btrfs: remove negative dentry when deleting subvolumne"), which fixes
> a problem in btrfs_dentry_delete(), but the commit message doesn't
> explain what shrink_dcache_sb() had to do with it. I'll send in an
> updated version with d_invalidate() moved and shrink_dcache_sb() removed
> and see if anyone can enlighten me.

I think it's a material for a separate patch.
