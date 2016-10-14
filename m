Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33696 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752840AbcJNO5x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 10:57:53 -0400
Date: Fri, 14 Oct 2016 16:57:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Btrfs-convert: Add support to copy common inode
 flags
Message-ID: <20161014145739.GA11398@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161011024446.16546-1-quwenruo@cn.fujitsu.com>
 <20161013141558.GW11398@twin.jikos.cz>
 <41c42235-ef89-1f5c-28cc-bf3275045737@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <41c42235-ef89-1f5c-28cc-bf3275045737@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 14, 2016 at 08:50:31AM +0800, Qu Wenruo wrote:
> > I can pull the branches from you, either to devel or integration. Please
> > base them on the last release point (ie. master) if there are no other
> > dependencies. Otherwise, I'll publish a branch that contains the desired
> > patches and will promise not to change it with rebases.
> 
> Sorry I'm not very familiar with when to send a pull request and when to 
> send normal patches, and to which branch it should be rebased to.

It's no required, just would make a few things easier. The pull is
additional to mailinglist patches, so send patches as usual.  If you put
the patches to a branch that I can pull, I'll do that eventually. This
happens if the patches are in a state that I don't need to touch them at
all or do just minor modifications.

>  From my understanding, for large patchset pull request is preferred(and 
> patchse should still be sent out for review) and for small changes, 
> normal mail should be good enough.

Basically yes. Single patches or very short series do not need to go
through git (just mails).

> And normally I rebase all my branches/patches to your devel branch.
> Or should I rebase them to the master branch?

As the devel branch could be rebased, it's not suitable as a starting
point. Even if you rebase it, I might not be able to pull it if
something changes in the meantime. As I don't process progs patches
every day, this is likely to happen.

If you don't want to do the git way now, no big deal. It's a long term
goal, but this requires to do the things right, so both parties,
develoeprs and maintainers, know what to expect and get it. I'll also
write that to wiki for future reference.
