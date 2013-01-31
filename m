Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab3AaReH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 12:34:07 -0500
Date: Thu, 31 Jan 2013 18:34:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Norbert Veber <nveber@pyre.virge.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: extended inode refs
Message-ID: <20130131173404.GN30535@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130131153337.GB14605@pyre.virge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130131153337.GB14605@pyre.virge.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 10:33:37AM -0500, Norbert Veber wrote:
> I looked at Mark Fasheh's patch, and from my rudimentary udnerstanding
> it seems like I need to set BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF in the
> superblock.
> 
> Is there any way to edit the superblock of an existing filesystem to
> enable extended inode refs so that more hard links can be used?

I've once written a one-shot super block "editor" that modified super_flag, if
you feel like updating it to tweak the incompat bits, here it is

http://repo.or.cz/w/btrfs-progs-unstable/devel.git/commit/0c4a8413af17909c6909f8ad96d3cf72c7c3a537

Otherwise, Mark's patches add the incompat bit unconditionally, we need
a way how to make it tunable in the same way as other mkfs do. I'd say
to take them as-is now and extend mkfs later.

david
