Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab3FGLw5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Jun 2013 07:52:57 -0400
Date: Fri, 7 Jun 2013 13:52:54 +0200
From: David Sterba <dsterba@suse.cz>
To: George Mitchell <george@chinilu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How do I safely terminate COW on pre-existing files?
Message-ID: <20130607115254.GH18160@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51B14AB0.4040906@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51B14AB0.4040906@chinilu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 06, 2013 at 07:51:28PM -0700, George Mitchell wrote:
> I want to eliminate the COW feature on all of my OS files.  It is a nice
> feature for user files, but I don't see a clear benefit for the actual OS
> files.  And I suspect that COW induced fragmentation is causing or
> aggravating problems with my system including the boot open_ctree problem.

Fragmentation does not cause open_ctree boot problems, it could affect
boot speed.

> I had planned to recursively chattr these files to "nodatacow" status but
> then I ran into this cryptic warning on the chattr man page:
> 
> (Note: For btrfs, the 'C' flag should be set on new or empty files. If it is
> set on a file which already has data blocks, it is undefined when the blocks
> assigned to the file will be fully stable.  If the  'C'  flag  is set on a
> directory, it will have no effect on the directory, but new files created in
> that directory will the No_COW attribute.)
> 
> So what exactly does that mean?  Does it mean that it is unsafe?  Or does it
> mean that it is simply unreliable?  If I run a btrfs balance first will that
> clear out the COW snapshots and enable me to perform the recursive chattrs?
> What is the best way to approach this?

The COW status cannot be changed once a file has data, implementation
reasons. The cryptic message should tell you that doing chattr on a
non-empty file has undefined result, which in practice means that it
does nothing. The file's cow-status is kept intact.

Setting nocow on a directory has clear semantics, it sets nocow on any
new (empty) file just fine.

If you want to switch files between cow<->nocow, set the cow-status in
advance and then do cp.


david
