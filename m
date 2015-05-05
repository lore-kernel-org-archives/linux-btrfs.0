Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbbEETqQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 15:46:16 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5B5B3ACC2
	for <linux-btrfs@vger.kernel.org>; Tue,  5 May 2015 19:46:14 +0000 (UTC)
Date: Tue, 5 May 2015 12:46:14 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, btrfs <linux-btrfs@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH][RFC] btrfs-progs: add 'du' command
Message-ID: <20150505194614.GX17170@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20150423211206.GQ17170@wotan.suse.de>
 <20150429171918.GC4996@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150429171918.GC4996@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 29, 2015 at 07:19:18PM +0200, David Sterba wrote:
> On Thu, Apr 23, 2015 at 02:12:06PM -0700, Mark Fasheh wrote:
> > This patch adds a 'du' subcommand to btrfs. 'btrfs fi du' will
> > calculate disk usage of the target files using fiemap. For individual
> > files, it will report a count of total bytes, and exclusive (not
> > shared) bytes. We also calculate a 'set shared' value which is
> > described below.
> 
> The functionality is useful, I personally like it and have seen people
> on irc to ask about this.

Cool, I would really like to know how close this gets to answering some
of those questions regarding disk usage.


> The question is whether we want to add this to a btrfs command or to the
> 'du' utility itself. AFAICS it's not built around FIEMAP, so I guess
> this would be an intrusive change.

Yeah internally this is happening much differently than du. Jeff and I had
talked once or twice about counting extent refs as a future enhancement,
which would definitey be out of the scope of anything du does right now.


> > Following this paragraph is a very simple example. I started with a
> > clean btrfs fs in which i copied vmlinuz from /boot. I then made a
> > snapshot of the fs root in 'snap1'. After the snapshot, I made a 2nd
> > copy of vmlinuz into the main fs to give us some not-shared data. The
> > output below shows a sum of all the space, and a 'set shared' with len
> > exactly equal to that of the single shared file.
> > 
> > # btrfs fi du .
> > total	exclusive	set shared	filename
> > 4362240	0			./vmlinuz-4.0.0-rc7
> > 4362240	0			./snap1/vmlinuz-4.0.0-rc7
> > 4362240	0			./snap1
> > 4362240	4362240			./vmlinuz-4.0.0-rc7.copy
> > 13086720	4362240	4362240	.
> 
> I guess the next thing people will want to see is the compressed size.

I can look into this. Maybe as a switch? How do I even get the compressed
size?


> > A git tree of the patches can be found here:
> > 
> > https://github.com/markfasheh/btrfs-progs-patches/tree/du
> 
> The file interval_tree.h seems missing and build fails.

If you pull the branch again you should have a fix for this.

Thanks David,
	--Mark

--
Mark Fasheh
