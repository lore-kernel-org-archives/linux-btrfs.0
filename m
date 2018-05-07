Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58889 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751976AbeEGRza (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 13:55:30 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C491BAB46
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 17:55:28 +0000 (UTC)
Date: Mon, 7 May 2018 19:52:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/3] Lowmem fsck repair to fix filetype mismatch
Message-ID: <20180507175251.GD6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180117051710.16853-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180117051710.16853-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 17, 2018 at 01:17:07PM +0800, Qu Wenruo wrote:
> Sebastian reported a filesystem corruption where DIR_INDEX has wrong
> filetype against INODE_ITEM.
> 
> Lowmem mode normally handles such problem by checking DIR_INDEX,
> DIR_ITEM and INODE_REF/INODE_ITEM to determine the correct file type.
> In such case, lowmem mode fsck can get the correct filetype.
> 
> When fixing the problem, lowmem mode will try to re-insert correct
> (DIR_INDEX, DIR_ITEM, INODE_REF) tuple, and if existing correct
> DIR_ITEM and INODE_REF is found, btrfs_link() will just skip and only
> insert correct DIR_INDEX.
> 
> However, when inserting correct DIR_INDEX, due to extra DIR_INDEX
> validation, incorrect one will be skiped and correct one will be
> inserted after invalid one.
> 
> This leads to lowmem mode repair to create duplicated DIR_INDEX.
> 
> This patch will fix it by removing the whole (DIR_INDEX, DIR_ITEM,
> INODE_REF) tuple before inserting correct tuple.
> And the removing part, btrfs_unlink(), will be enhanced to handle
> incorrect tuple member more robust.
> 
> Please note that, due a bug in lowmem mode repair, btrfs check will
> still show "error(s) found in fs tree" even repair is done successfully.
> 
> And test case for this repair still needs extra work for original mode
> to support such repair, or test case won't pass original mode test.
> 
> Qu Wenruo (3):
>   btrfs-progs: lowmem fsck: Remove corupted link before re-add correct
>     link
>   btrfs-progs: dir-item: Allow dir item and dir index lookup to ignore
>     found problem
>   btrfs-progs: dir-item: Make btrfs_delete_one_dir_name more robust to
>     handle corrupted name len

Added to devel, thanks. The code has moved so I applied some diff hunks
manually.
