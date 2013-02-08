Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58789 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946882Ab3BHT5V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 14:57:21 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so2160125eek.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2013 11:57:20 -0800 (PST)
Date: Fri, 8 Feb 2013 21:57:17 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: Ian Kumlien <pomac@demius.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs-progs: add the rescue section to btrfs
Message-ID: <20130208195717.GA2477@zambezi.lan>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-7-git-send-email-pomac@demius.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360283822-23452-7-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 08, 2013 at 01:37:02AM +0100, Ian Kumlien wrote:
> the btrfs command now lists:
>     btrfs rescue select-super -s <number> <device>
>         Select a superblock
>     btrfs rescue dump-super <device>
>         Dump a superblock to disk
>     btrfs rescue debug-tree [options] <device>
>         Debug the filesystem
> 
> btrfs-dump-super.c was imported in to cmds-rescue-super-ops.c
> 
> This patch integrates all the functionality...
> 
> cmds-rescue.c is used to glue cmds-rescue-debug-tree.c,
> cmds-rescue-restore.c and cmds-rescue-super-ops.c together to
> make the source files more managable.

I think btrfs-debug-tree should go under debug -- btrfs debug dump-tree.
Same goes for btrfs-dump-super -- btrfs debug dump-super.  These
commands won't help an average user to rescue a single byte, they are
there to help developers.  I suppose you can also import btrfs-image
under btrfs debug dump-image.

This leaves the question of whether we want select-super under rescue.
Given that it can easily do more harm than good, it might not be the
best place for it..

Thanks,

		Ilya
