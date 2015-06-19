Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbbFSUbc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 16:31:32 -0400
Date: Fri, 19 Jun 2015 13:31:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Sterba <dsterba@suse.cz>
Cc: stable@vger.kernel.org, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs stable updates for 4.0
Message-ID: <20150619203131.GC22717@kroah.com>
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

Does not build on 3.14+, sorry.  Please provide a backported version if
you want to see it there.

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
