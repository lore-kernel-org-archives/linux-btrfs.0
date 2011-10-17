From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 11/12 v5] Btrfs: do not iput inode when inode is still in log
Date: Sun, 16 Oct 2011 20:30:07 -0400
Message-ID: <1318811223-sup-6400@shiny>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com> <1312623467-31487-12-git-send-email-liubo2009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1312623467-31487-12-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Liu Bo's message of 2011-08-06 05:37:46 -0400:
> We maintain the inode's logged_trans to avoid reloging it, but if we iput
> the inode and reread it, we'll get logged_trans to zero.
> 
> So when an inode is still in log tree, and transaction is not committed yet,
> we do not iput the inode.

I know you've tried a few different methods for this, but I think this
one will end up leading to OOM, since it pins the inodes in ram and we
don't have a way for the inode shrinker to force a commit.

So I took this code out and couldn't trigger my eexist oops anymore.
I'm going through right now to make sure this isn't because someone took
the BUG_ON out ;)

The big problem was the code wasn't expecting to find previously logged
items for the inode because the last trans field wasn't set.  It seems
like we should just be able to deal with these eexist returns without
any real trouble?

-chris
