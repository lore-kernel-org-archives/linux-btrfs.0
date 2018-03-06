Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750933AbeCFMgY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Mar 2018 07:36:24 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E80C9AF6C
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 12:36:22 +0000 (UTC)
Date: Tue, 6 Mar 2018 13:34:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 3/5] btrfs: Embed sector size check into
 BTRFS_MAX_INLINE_DATA_SIZE()
Message-ID: <20180306123403.GR5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180302052254.7059-4-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 02, 2018 at 01:22:52PM +0800, Qu Wenruo wrote:
> We have extra sector size check in cow_file_range_inline(), but doesn't
> implement it in BTRFS_MAX_INLINE_DATA_SIZE().
> 
> The biggest reason is that btrfs_symlink() also uses this macro to check
> name length.

I'm reading what the standard says about symlink and restrictions,
http://pubs.opengroup.org/onlinepubs/009695399/functions/symlink.html

the maximum length of the symlink contents should not exceed
SYMLINK_MAX, 'getconf SYMLINK_MAX /path/to/btrfs' says undefined and I
can't find any restrictions in manual pages. At least the target should
not exceed PATH_MAX in case is's an absolute path, the rest is up to the
path name resolution to decide if a relative symlink plus the base
directory exceeds PATH_MAX.

IOW, the symlink callback could extend the condition to check against
PATH_MAX, that is independent on the page size and sectorsize.

A larger symlink target is not a bug per se, just that it will never
pass through VFS once it would be used for file access.

> In fact such behavior makes max_inline calculation quite confusing, and
> cause unexpected large extent for symbol link.
> 
> Here we embed sector size check into BTRFS_MAX_INLINE_DATA_SIZE() so
> that it will never exceed sector size.

I don't think it's wise to mix sectorsize and nodesize, here the macro
BTRFS_MAX_INLINE_DATA_SIZE is related only to b-tree nodes.

> The downside is, for symbol link, we will reduce max symbol link length
> from 16K- to 4095, but it won't affect current system using that long
> name, but only prevent later creation.

The page size limit will be hit so >4096 symlink targets can be created
only on systems with big pages.
