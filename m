Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbaEEQFH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 May 2014 12:05:07 -0400
Date: Mon, 5 May 2014 18:05:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: metadata vs data errors
Message-ID: <20140505160505.GS5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201405041119.17103.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201405041119.17103.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 04, 2014 at 11:19:15AM +1000, Russell Coker wrote:
> To discover whether there were any metadata errors I grepped for "metadata" in 
> the kernel message log and found lots of lines like the above.  Will all 
> errors that involve metadata match a grep for "metadata" in the kernel message 
> log?

Yes, the messages should match the scrub error message by the 'metadata'
keyword, however there's ratelimiting applied so some of the messages
can be lost.

> I think it would be good to have a scrub count of the number of uncorrectable 
> metadata vs data errors.  When there are uncorrectable data errors you know 
> the name of the file (it's in the kernel message log) and can recover just 
> that file.  When there are uncorrectable metadata errors you don't.

Collecting the data/metadata stats is possible, just increment the right
counter in scrub_handle_errored_block(), the type of block is known.

For backward compatibility, 2 new counters would be needed for each type
and keep the existing counter without change of it's meaning.

The stats are collected in struct btrfs_scrub_progress that does not
have any spare bytes left so this would need some work to add the logic
to do the current or extended stats.

> Also would it be possible to log the names of directories that are affected by 
> uncorrectable metadata errors?  When BTRFS scales up to the systems where a 
> "find /" takes days to complete and run 24*7 there won't be an option to just 
> restore from backup.  In this case the root of every subvol appears undamaged 
> so BTRFS should be able to tell me part of the path related to metadata 
> corruption.

Tracing back to the directory names from corrupted metadata can be
tricky, as the path resolving needs to use the metadata blocks for that
purpose. Also, the metadata are spread over several trees, so it depends
which tree is b0rked.

Handling all cases from kernel could be hard to impractically complex,
so we can report all the broken blocks and then let userspace deal with
that. Ie. read the block and decide what to do next based on the block
contents.

This led me to an question, whether we'd like to collect more detailed
information about which tree contains the errors.

> # btrfs subvol list /mnt/backup/                                                                                                                                                                                                                                                                                                               
> ID 823 gen 3212 top level 5 path backup                                                                                                                                                                                                                                                                                                                          
> ID 826 gen 1832 top level 5 path backup-2013-05-21
> 
> Above is the start of the output of a subvol list, there is no ID 2.  What 
> does the "tree 2" in the above kernel error log mean?

Tree with ID 2 is extent tree:

ctree.h
#define BTRFS_EXTENT_TREE_OBJECTID 2ULL

The trees with id >= 256 correspond to subvolumes.
