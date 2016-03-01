Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbcCAJUm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Mar 2016 04:20:42 -0500
Date: Tue, 1 Mar 2016 10:20:26 +0100
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs fixes for 4.6
Message-ID: <20160301092026.GX23746@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1456492920-18169-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456492920-18169-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On Fri, Feb 26, 2016 at 01:22:00PM +0000, fdmanana@kernel.org wrote:
> The following changes since commit 0fcb760afa6103419800674e22fb7f4de1f9670b:
> 
>   Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.6 (2016-02-24 10:21:44 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git integration-4.6
> 
> for you to fetch changes up to 97c86c11a5cb9839609a9df195e998c3312e68b0:
> 
>   Btrfs: do not collect ordered extents when logging that inode exists (2016-02-26 04:28:15 +0000)

Filipe's branch is based on some integration snapshot that contains the
'delete device by id' patchset that was removed from the 4.6 queue.

Your branch 'next' merges it back again through Filipe's tree, besides
that the merge commits of the topic branches in my for-next appear
twice. While the duplicated commits are only an esthetic issue, the
extra branch bothers me.

I don't see a nice way how to avoid rebases in this cases. My suggestion
is that Filipe rebases the branch on my for-chris that could have been
an integration at some point.

As we're merging our branches that way for the first time I'd like to
find the workflow also for the next dev cycles so I'm open to other
suggestions.
