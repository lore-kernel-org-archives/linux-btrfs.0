Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935090Ab3BTN2a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 08:28:30 -0500
Date: Wed, 20 Feb 2013 14:28:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH] btrfs-progs: mkfs: add -O option to specify fs
 features
Message-ID: <20130220132829.GE9521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361272572-6393-1-git-send-email-dsterba@suse.cz>
 <5123A6E9.2080502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5123A6E9.2080502@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 19, 2013 at 10:23:05AM -0600, Eric Sandeen wrote:
> On 2/19/13 5:16 AM, David Sterba wrote:
> > The RFC is for the option name, as there does not seem to be a common name
> > amongst other mkfses.
> 
> What did you find when looking?

I remember that extN uses -O and that was my first choice without much
thinking. While writing the changelog "all other mkfs use -O" I did not
find this correct when looking to xfs and ocfs2 manpages.

> xfsprogs doesn't really have a feature flag option per se; there are just block,
> inode, size, log, data etc. options which may trigger some feature set.

Yeah, and this separation makes sense, as there are several options how
to tune the specific area.

My point is to turn on/off a whole filesystem feature via a single
option that cannot be enabled by a mount option or may make the
filesystem unmountable on older kernels due to incompat bits.

> e2fsprogs has the rather -O feature -E extended-options set, and darned if I could
> tell you the difference ;)
> 
> but I think -O is the right option, unless you found other common mkfs's that
> use something different.  When in doubt, e2fsprogs conventions probably win.  :)

Nothing so far, tried jfs, f2fs, hfs, reiserfs.

Thanks for your comment.


david
