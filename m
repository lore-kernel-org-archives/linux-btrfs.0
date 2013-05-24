Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab3EXWi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 18:38:29 -0400
Date: Fri, 24 May 2013 15:38:27 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>, Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 4/4] btrfs: offline dedupe
Message-ID: <20130524223827.GB5639@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1369160908-26195-1-git-send-email-mfasheh@suse.de> <1369160908-26195-5-git-send-email-mfasheh@suse.de> <20130524140536.GQ5187@twin.jikos.cz> <20130524181706.GA5639@wotan.suse.de> <519FC476.1060206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <519FC476.1060206@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 24, 2013 at 09:50:14PM +0200, Gabriel de Perthuis wrote:
> > Sure. Actually, you got me thinking about some sanity checks... I need to
> > add at least this check:
> > 
> > 	if (btrfs_root_readonly(root))
> > 		return -EROFS;
> > 
> > which isn't in there as of now.
> 
> It's not needed and I'd rather do without, read-only snapshots and deduplication go together well for backups.
> Data and metadata are guaranteed to be immutable, extent storage isn't.  This is also the case with raid.

You're absolutely right - I miswrote the check I meant.
Specifically, I was thinking about when the entire fs is readonly due to
either some error or the user mounted with -oro. So something more like:

	if (root->fs_info->sb->s_flags & MS_RDONLY)
		return -EROFS;

I think that should be reasonable and wouldn't affect most use cases,
right?


> > Also I don't really check the open mode (read, write, etc) on files passed
> > in. We do this in the clone ioctl and it makes sense there since data (to
> > the user) can change. With this ioctl though data won't ever change (even if
> > the underlying extent does). So I left the checks out. A part of me is
> > thinking we might want to be conservative to start with though and just add
> > those type of checks in. Basically, I figure the source should be open for
> > read at least and target files need write access.
> 
> I don't know of any privileged files that one would be able to open(2),
> but if this is available to unprivileged users the files all need to be
> open for reading so that it can't be used to guess at their contents. As
> long as root gets to bypass the checks (no btrfs_root_readonly) it doesn't
> hurt my use case.

Oh ok so this seems to make sense. How does this logic sound:

We're not going to worry about write access since it would be entirely
reasonable for the user to want to do this on a readonly submount
(specifically for the purpose of deduplicating backups).

Read access needs to be provided however so we know that the user has access
to the file data.

So basically, if a user can open any files for read, they can check their
contents and dedupe them.

Letting users dedupe files in say, /etc seems kind of weird to me but I'm
struggling to come up with a good explanation of why that should mean we
limit this ioctl to root.
	--Mark

--
Mark Fasheh
