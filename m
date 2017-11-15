Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932443AbdKOQR1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 11:17:27 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C1CE8AC88
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 16:17:26 +0000 (UTC)
Date: Wed, 15 Nov 2017 17:15:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 3/3] btrfs: Cleanup existing name_len checks
Message-ID: <20171115161533.GS28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171108005426.17903-1-wqu@suse.com>
 <20171108005426.17903-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171108005426.17903-4-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 08, 2017 at 08:54:26AM +0800, Qu Wenruo wrote:
> Since tree-checker has verified leaf when reading from disk, we don't
> need the existing verify_dir_item() or btrfs_is_name_len_valid().
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
