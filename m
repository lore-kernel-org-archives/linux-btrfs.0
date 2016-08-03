Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:56838 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbcHCUhT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Aug 2016 16:37:19 -0400
Date: Wed, 3 Aug 2016 22:37:08 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Graham Cobb <g.btrfs@cobb.uk.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Extents for a particular subvolume
Message-ID: <20160803203708.GA26505@angband.pl>
References: <57A24C51.2050302@cobb.uk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57A24C51.2050302@cobb.uk.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 03, 2016 at 08:56:01PM +0100, Graham Cobb wrote:
> Are there any btrfs commands (or APIs) to allow a script to create a
> list of all the extents referred to within a particular (mounted)
> subvolume?  And is it a reasonably efficient process (i.e. doesn't
> involve backrefs and, preferably, doesn't involve following directory
> trees)?

Since the size of your output is linear to the number of extents which is
between the number of files and sum of their sizes, I see no gain in
trying to avoid following the directory tree.

And that can be done with FIEMAP on any filesystem, not just btrfs.

> I am not looking to relate the extents to files/inodes/paths.  My
> particular need, at the moment, is to work out how much of two snapshots
> is shared data, but I can think of other uses for the information.

Thus, unlike the question you asked above, you're not interested in _all_
extents, merely those which changed.

You may want to look at "btrfs subv find-new" and "btrfs send --no-data".


Meow!
-- 
An imaginary friend squared is a real enemy.
