Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbaLJMhw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 07:37:52 -0500
Date: Wed, 10 Dec 2014 13:37:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 00/13] btrfs-progs:fsck: Add inode nlink mismatch and
Message-ID: <20141210123750.GA27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 09, 2014 at 04:27:19PM +0800, Qu Wenruo wrote:
> The patchset introduce two new repair function and some helpers to
> archive a huge goal:
>   Repair btrfs whose fs tree's non-root leaf/node is corrupted when no
>   duplication is valid.
> 
> The two new repair functions are:
>   repair_inode_nlinks():
>     Repair any inode nlink related problem.
>     From fixing the nlink number and related
>     inode_ref/dir_index/dir_item to recovering file name and file type
>     and salvage them into the lost+found dir.
>     This does not only fix a case that some users reported but also
>     cooperate with repair_inode_no_item() function to salvaged heavily
>     damaged inode to lost+found dir.
> 
>   repair_inode_no_item():
>     Repair case for inode_item missing case, which is quite common when
>     fs tree leaf/node is missing.
>     This only does the inode item rebuild. Later recovery like move it
>     to lost+found dir is done by repair_inode_nlinks().
> 
> The main helper is the repair_btree() function, which will drops the
> corrupted non-root leaf/node and rebalance the tree to keep the
> correctness of the btree.

Sounds a bit intrusive, but under the circumstances I don't see anything
better to do.

> With this patchset, even a non-root leaf/node is corrupted and no
> duplication survived, btrfsck can still repair it to a mountable status.
> (And normal rw should also be OK,)
> 
> The remaining unfixable problems will be inode nbytes error with file
> extent discounts error, which may be fixed in next patchset.
> 
> Cc David:
> Sorry for the huge change in the patchset and merge the old inode nlink
> repair with new inode item rebuild patchset.

No problem, the incremental changelogs helped a lot.

> Since when developing inode item rebuild patchset, I found the old nlink
> cooperated very bad with item rebuild and there is some duplicated codes
> between the two patchset, no to mention the math lib introduced by nlink
> repair patch.
> So I decided to somewhat rebase the nlink repair patchset to provide
> better generality.

Great, the patchset looks good for merge, I'm adding it to 3.18. From
now on please send only incremental changes and not the whole patchset.
Thanks.
