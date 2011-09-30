From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: break out of orphan cleanup if we can't make progress
Date: Fri, 30 Sep 2011 13:50:36 +0200
Message-ID: <20110930115036.GJ22205@twin.jikos.cz>
References: <1317066989-22566-1-git-send-email-josef@redhat.com> <20110927144413.GE22205@twin.jikos.cz> <4E81E78C.80804@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E81E78C.80804@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 27, 2011 at 11:11:08AM -0400, Josef Bacik wrote:
> Really this shouldn't happen at all, but at least this will keep the
> thing from mounting and then we can debug the issue further without
> bringing the users box to a halt.

Is's not easy to say where the problem originates, we see just the
unfixable result. IIRC there were delalloc and enospc involved, and some
kind of race, but it's a guesswork after going through the surrounding
code.

Do you think it's possible to skip the inode rather than stopping the
whole orphan cleanup? Orphan cleanup is called from several places and
during whole lifecycle of a moutned system (open_ctree, recovery,
snapshot, lookup_dentry). The broken inode will be there and prevent
further orphan cleanup and reclaim of the used space (although this may
be not that many bytes). Seems that btrfs_evict_inode fails to remove
the item from the list (via btrfs_orphan_del).


david
