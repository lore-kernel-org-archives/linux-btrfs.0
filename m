Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50871 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932298AbdKGU54 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 15:57:56 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 919A2AF00
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Nov 2017 20:57:55 +0000 (UTC)
Date: Tue, 7 Nov 2017 21:56:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs: Cleanup existing name_len checks
Message-ID: <20171107205604.GF27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171101122213.7122-1-wqu@suse.com>
 <20171101122213.7122-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171101122213.7122-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 01, 2017 at 08:22:13PM +0800, Qu Wenruo wrote:
> Since tree-checker has verified leaf when reading from disk, we don't
> need the existing checker.
> 
> This cleanup reverts the following commits:
> fbc326159a01 ("btrfs: Verify dir_item in iterate_object_props")
> 64c7b01446f4 ("btrfs: Check name_len before in btrfs_del_root_ref")
> 488d7c456653 ("btrfs: Check name_len before reading btrfs_get_name")
> 59b0a7f2c7c1 ("btrfs: Check name_len before read in iterate_dir_item")
> 3c1d41844896 ("btrfs: Check name_len in btrfs_check_ref_name_override")
> 8ee8c2d62d5f ("btrfs: Verify dir_item in replay_xattr_deletes")
> 26a836cec2ea ("btrfs: Check name_len on add_inode_ref call path")
> e79a33270d05 ("btrfs: Check name_len with boundary in verify dir_item")
> 19c6dcbfa746 ("btrfs: Introduce btrfs_is_name_len_valid to avoid reading beyond boundary")

Oh well, there it goes, but I like the centralized tree checker more,
so this is a small cost.

Reviewed-by: David Sterba <dsterba@suse.com>
