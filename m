Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbbCaRPX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 13:15:23 -0400
Date: Tue, 31 Mar 2015 19:15:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] fstests: test for btrfs cloning of zero length ranges
Message-ID: <20150331171520.GE6821@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1427736284-29469-1-git-send-email-fdmanana@suse.com>
 <1427756698-21338-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427756698-21338-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 12:04:58AM +0100, Filipe Manana wrote:
> Test cloning a file range with a length of zero into a destination offset
> greater than zero.
> 
> This made btrfs create an extent state record with a start offset greater than
> the end offset, resulting in chaos such as an infinite loop when evicting an
> inode.
> 
> This issue was fixed by the following linux kernel patch:
> 
>    Btrfs: fix inode eviction infinite loop after cloning into it
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

> V2: Use an offset of 64Kb so that the test can run on platforms with any
>     page size. In btrfs the fs block size must be a multiple of the page
>     size, so a 4Kb offset would make the test fail on machines with a
>     page size > 4Kb because the clone ioctl only accepts offsets and lengths
>     that are multiples of the block size.

Nice.
