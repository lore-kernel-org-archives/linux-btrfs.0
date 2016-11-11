Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37081 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752627AbcKKKoa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 05:44:30 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A747EABFC
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Nov 2016 10:44:28 +0000 (UTC)
Date: Fri, 11 Nov 2016 11:44:26 +0100
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: remove old tree_root dirent processing in
 btrfs_real_readdir()
Message-ID: <20161111104426.GF12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1478366795-27009-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1478366795-27009-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 05, 2016 at 01:26:34PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Commit 3de4586c527 (Btrfs: Allow subvolumes and snapshots anywhere
> in the directory tree) introduced the current system of placing
> snapshots in the directory tree.  It also introduced the behavior of
> creating the snapshot and then creating the directory entries for it.
> 
> We've kept this code around for compatibility reasons, but it turns
> out that no file systems with the old tree_root based snapshots can
> be mounted on newer (>= 2009) kernels anyway.  About a month after the
> above commit, commit 2a7108ad89e (Btrfs: rev the disk format for the
> inode compat and csum selection changes) landed, changing the superblock
> magic number.
> 
> As a result, we know that we'll never encounter tree_root-based dirents
> or have to deal with skipping our own snapshot dirents.  Since that
> also means that we're now only iterating over DIR_INDEX items, which only
> contain one directory entry per leaf item, we don't need to loop over
> the leaf item contents anymore either.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
