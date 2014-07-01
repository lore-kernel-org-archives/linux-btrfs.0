Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbaGAX47 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 19:56:59 -0400
Date: Wed, 2 Jul 2014 01:56:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: atomically set inode->i_flags in
 btrfs_update_iflags
Message-ID: <20140701235657.GV1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403732162-22405-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403732162-22405-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 25, 2014 at 10:36:02PM +0100, Filipe David Borba Manana wrote:
> This change is based on the corresponding recent change for ext4:
> 
>   ext4: atomically set inode->i_flags in ext4_set_inode_flags()
> 
> That has the following commit message that applies to btrfs as well:
> 
>   "Use cmpxchg() to atomically set i_flags instead of clearing out the
>    S_IMMUTABLE, S_APPEND, etc. flags and then setting them from the
>    EXT4_IMMUTABLE_FL, EXT4_APPEND_FL flags, since this opens up a race
>    where an immutable file has the immutable flag cleared for a brief
>    window of time."
> 
> Replacing EXT4_IMMUTABLE_FL and EXT4_APPEND_FL with BTRFS_INODE_IMMUTABLE
> and BTRFS_INODE_APPEND, respectively.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
