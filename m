Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbaE1QHe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 12:07:34 -0400
Date: Wed, 28 May 2014 18:07:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, guihc.fnst@cn.fujitsu.com
Subject: Re: [PATCH] btrfs-show-super: don't try to print not-superblocks
Message-ID: <20140528160730.GO5346@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5372CED8.7030404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5372CED8.7030404@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 13, 2014 at 09:03:04PM -0500, Eric Sandeen wrote:
> If we point btrfs-show-super at a not-btrfs-device and
> try to print all superblocks, bad things are apt to happen:
> 
> superblock: bytenr=274877906944, device=/dev/sdc2
> ---------------------------------------------------------
> btrfs-show-super: ctree.h:1984: btrfs_super_csum_size: Assertion `!(t >= (sizeof(btrfs_csum_sizes) / sizeof((btrfs_csum_sizes)[0])))' failed.
> csum			0xAborted
> 
> Don't try to print superblocks that don't look like superblocks,
> and add an "-f" (force) option to try anyway, if the user
> really wants to give it a shot.

The option -f clashes with "add sys_chunk_array and backup roots info to
show-super" from Gui Hecheng. I've merged the changes and renamed yours
to -F.

> Fix some spelling & capitalization while we're at it.

The manpage fixes do not apply to the asciidoc (already there).

> The manpage says that if any problem happens, 1 will
> be returned, but that's already not true today LOL, so
> I didn't bother to make it true when we detect bad
> sb magic, either...
> 
> I figure it's worth continuing and trying all superblocks
> in case just one has a corrupt magic.

Makes sense.
