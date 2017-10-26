Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33411 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932127AbdJZRPB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 13:15:01 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E9E45AC67
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 17:14:59 +0000 (UTC)
Date: Thu, 26 Oct 2017 19:13:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, nborisov@suse.com
Subject: Re: [PATCH v2 0/6] Rootdir refactor and small bug fixes
Message-ID: <20171026171311.GA3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171019054138.13965-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171019054138.13965-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 19, 2017 at 01:41:32PM +0800, Qu Wenruo wrote:
> Sorry for the v2 patchset, just added a new 3-line patch.
> But since it can screw up bisect, I re-send the whole patchset, to make
> the new patch just before mkfs return value fix, so bisect will work as
> it used to do.
> 
> 
> First 4 patches are small bug fixes which can be applied even we don't
> touch the functionality of --rootdir.
> 
> The last two patches will refactor --rootdir related functions ,mainly
> size_sourcedir() and make_image(), to mkfs/rootdir.[ch].
> And rename them to btrfs_mkfs_size_dir() and btrfs_mkfs_fill_dir()
> respectively.
> Functionality is not changed at all, so it will still shrink the device
> or using the first 1M reserved space.
> 
> This moved about 700 lines, which reduced about 1/3 of original mkfs.c.
> 
> And by moving this ancient code to its own files, I also fixed several
> small nits exposed by checkpatch script.
> 
> This provides a clean environment for later rootdir rework.
> 
> changelog:
> v2:
>   Add a new fix, to avoid mkfs return 1. The rest doesn't change.
>   Add reviewed-by tag.
> 
> Qu Wenruo (6):
>   btrfs-progs: Avoid BUG_ON for chunk allocation when ENOSPC happens
>   btrfs-progs: mkfs: Avoid positive return value from
>     cleanup_temp_chunks
>   btrfs-progs: mkfs: Fix overwritten return value for mkfs
>   btrfs-progs: mkfs: Error out gracefully for --rootdir
>   btrfs-progs: mkfs: Move image creation of rootdir to its own files
>   btrfs-progs: mkfs: Move source dir size calculation to its own files

All patches applied, thanks.
