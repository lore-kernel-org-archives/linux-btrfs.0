Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966405AbbD2RTU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Apr 2015 13:19:20 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B4F75AB1C
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 17:19:18 +0000 (UTC)
Date: Wed, 29 Apr 2015 19:19:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: David Sterba <dsterba@suse.cz>, btrfs <linux-btrfs@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH][RFC] btrfs-progs: add 'du' command
Message-ID: <20150429171918.GC4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150423211206.GQ17170@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150423211206.GQ17170@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 02:12:06PM -0700, Mark Fasheh wrote:
> This patch adds a 'du' subcommand to btrfs. 'btrfs fi du' will
> calculate disk usage of the target files using fiemap. For individual
> files, it will report a count of total bytes, and exclusive (not
> shared) bytes. We also calculate a 'set shared' value which is
> described below.

The functionality is useful, I personally like it and have seen people
on irc to ask about this.

The question is whether we want to add this to a btrfs command or to the
'du' utility itself. AFAICS it's not built around FIEMAP, so I guess
this would be an intrusive change.

> Following this paragraph is a very simple example. I started with a
> clean btrfs fs in which i copied vmlinuz from /boot. I then made a
> snapshot of the fs root in 'snap1'. After the snapshot, I made a 2nd
> copy of vmlinuz into the main fs to give us some not-shared data. The
> output below shows a sum of all the space, and a 'set shared' with len
> exactly equal to that of the single shared file.
> 
> # btrfs fi du .
> total	exclusive	set shared	filename
> 4362240	0			./vmlinuz-4.0.0-rc7
> 4362240	0			./snap1/vmlinuz-4.0.0-rc7
> 4362240	0			./snap1
> 4362240	4362240			./vmlinuz-4.0.0-rc7.copy
> 13086720	4362240	4362240	.

I guess the next thing people will want to see is the compressed size.

> A git tree of the patches can be found here:
> 
> https://github.com/markfasheh/btrfs-progs-patches/tree/du

The file interval_tree.h seems missing and build fails.
