Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834AbaLDR1Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 12:27:16 -0500
Date: Thu, 4 Dec 2014 18:27:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] More generic inode nlink repair function
Message-ID: <20141204172715.GH9754@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 03, 2014 at 12:18:26PM +0800, Qu Wenruo wrote:
> Update on patch 4 and 6, other is not changed.
> This nlink repair function is more generic than the original one.
> 
> The old one can only handle a specific case that the inode_ref is
> invalid, either point to a non-exist parent inode or point to a invalid
> inode(not dir or conflicting index/name).
> 
> The new one will reset all the backref, no matter it is valid or not,
> and re-add all the valid backref, this make the nlink handles more
> corrupt cases.
> 
> Qu Wenruo (6):
>   btrfs-progs: print root dir verbose error in fsck
>   btrfs-progs: Import btrfs_insert/del/lookup_extref() functions.
>   btrfs-progs: Import lookup/del_inode_ref() function.
>   btrfs-progs: Add btrfs_unlink() and btrfs_add_link() functions.
>   btrfs-progs: Add btrfs_mkdir() function for the incoming 'lost+found' 
>        fsck mechanism.
>   btrfs-progs: Add fixing function for inodes whose nlink dismatch

Thanks.  All patches queued for 3.18, I made some trivial formatting
chnages.
