Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58707 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934220AbdJRMXS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 08:23:18 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B235FABED
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Oct 2017 12:23:16 +0000 (UTC)
Subject: Re: [PATCH 0/5] Rootdir refactor and small bug fixes
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171018080054.25509-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <38e45c82-4900-4a11-2fbd-bb2e8310e474@suse.com>
Date: Wed, 18 Oct 2017 15:23:15 +0300
MIME-Version: 1.0
In-Reply-To: <20171018080054.25509-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18.10.2017 11:00, Qu Wenruo wrote:
> First 3 patches are small bug fixes which can be applied even we don't
> touch the functionality of --rootdir.
> 
> The last two patches will refactor --rootdir related functions (mainly
> size_sourcedir and make_image) to mkfs/rootdir.[ch].
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
> Qu Wenruo (5):
>   btrfs-progs: Avoid BUG_ON for chunk allocation when ENOSPC happens
>   btrfs-progs: mkfs: Fix overwritten return value for mkfs
>   btrfs-progs: mkfs: Error out gracefully for --rootdir
>   btrfs-progs: mkfs: Move image creation of rootdir to its own files
>   btrfs-progs: mkfs: Move source dir size calculation to its own files


Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
>  Makefile       |   4 +-
>  extent-tree.c  |   3 +-
>  mkfs/main.c    | 710 +------------------------------------------------------
>  mkfs/rootdir.c | 735 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  mkfs/rootdir.h |  32 +++
>  volumes.c      |  18 +-
>  6 files changed, 792 insertions(+), 710 deletions(-)
>  create mode 100644 mkfs/rootdir.c
>  create mode 100644 mkfs/rootdir.h
> 
