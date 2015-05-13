Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965355AbbEMPgA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 11:36:00 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id BC920AAC7
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2015 15:35:58 +0000 (UTC)
Date: Wed, 13 May 2015 17:35:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: dsterba@suse.cz, btrfs <linux-btrfs@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH][RFC] btrfs-progs: add 'du' command
Message-ID: <20150513153558.GM23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150423211206.GQ17170@wotan.suse.de>
 <20150429171918.GC4996@twin.jikos.cz>
 <20150505194614.GX17170@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150505194614.GX17170@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 05, 2015 at 12:46:14PM -0700, Mark Fasheh wrote:
> On Wed, Apr 29, 2015 at 07:19:18PM +0200, David Sterba wrote:
> > The functionality is useful, I personally like it and have seen people
> > on irc to ask about this.
> Cool, I would really like to know how close this gets to answering some
> of those questions regarding disk usage.

IIRC one of the questions was 'how much do these two files share', eg.
after one of the files has been reflinked and modified.

> > > Following this paragraph is a very simple example. I started with a
> > > clean btrfs fs in which i copied vmlinuz from /boot. I then made a
> > > snapshot of the fs root in 'snap1'. After the snapshot, I made a 2nd
> > > copy of vmlinuz into the main fs to give us some not-shared data. The
> > > output below shows a sum of all the space, and a 'set shared' with len
> > > exactly equal to that of the single shared file.
> > > 
> > > # btrfs fi du .
> > > total	exclusive	set shared	filename
> > > 4362240	0			./vmlinuz-4.0.0-rc7
> > > 4362240	0			./snap1/vmlinuz-4.0.0-rc7
> > > 4362240	0			./snap1
> > > 4362240	4362240			./vmlinuz-4.0.0-rc7.copy
> > > 13086720	4362240	4362240	.
> > 
> > I guess the next thing people will want to see is the compressed size.
> 
> I can look into this. Maybe as a switch? How do I even get the compressed
> size?

Not needed for the first implementation. The compressed size can be read
from userspace by iterating the extents. I have the code for that
stashed somewhere, we can add that once this patchset lands.
> 
> > > A git tree of the patches can be found here:
> > > 
> > > https://github.com/markfasheh/btrfs-progs-patches/tree/du
> > 
> > The file interval_tree.h seems missing and build fails.
> 
> If you pull the branch again you should have a fix for this.

I've tested it, works for me, however if you want me to pull the branch
please clean up the patches so the fixups are not in separate commits.
Also cmds-du goes to cmds-filesystem, as it's a subcommand. Patch
subjects should start with 'btrfs-progs'. The rest is the same as if it
were a patchset for kernel. I do fix small things at commit time unless
there are too many of them.
