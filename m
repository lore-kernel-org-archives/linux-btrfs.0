Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48014 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbbFSUcL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 16:32:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id CE885205FD
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2015 16:32:10 -0400 (EDT)
Date: Fri, 19 Jun 2015 13:32:09 -0700
From: Greg KH <greg@kroah.com>
To: David Sterba <dsterba@suse.cz>
Cc: stable@vger.kernel.org, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs stable updates for 4.0
Message-ID: <20150619203209.GD22717@kroah.com>
References: <cover.1434037853.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1434037853.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 11, 2015 at 06:06:32PM +0200, David Sterba wrote:
> Hi,
> 
> please queue the following patches to 4.0 stable. There are fixes for user
> visible bugs and one usability regression with RAID1 -> single conversion
> during balance.
> 
> One of the patches does not apply cleanly to 4.0.5, there's a minor conflict in
> patch context (153c35b6cccc0c72de9fae06c8e2c8b2c47d79d4, the last one). A reply
> to this mail is the adapted version or you can pull/cherry-pick from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-stable-4.0
> 
> Subjects:
> 	Btrfs: send, add missing check for dead clone root
> 	Btrfs: send, don't leave without decrementing clone root's send_progress
> 	btrfs: incorrect handling for fiemap_fill_next_extent return
> 	btrfs: cleanup orphans while looking up default subvolume
> 	Btrfs: fix range cloning when same inode used as source and destination
> 	Btrfs: fix uninit variable in clone ioctl
> 	Btrfs: fix regression in raid level conversion
> Commits:
> 	5cc2b17e80cf5770f2e585c2d90fd8af1b901258 # 3.14+
> 	2f1f465ae6da244099af55c066e5355abd8ff620 # 3.14+

Because 5cc2b17e80cf5770f2e585c2d90fd8af1b901258 breaks the build,
2f1f465ae6da244099af55c066e5355abd8ff620 does not apply to 3.14 either
:(
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
