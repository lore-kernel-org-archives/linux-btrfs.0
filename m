Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39681 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934301AbeBNPjW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 10:39:22 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4142AAB4B
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 15:39:20 +0000 (UTC)
Date: Wed, 14 Feb 2018 16:37:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: convert/ext2: Fix memory leak caused by
 handled ext2_filsys
Message-ID: <20180214153705.GH3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180214080956.9953-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180214080956.9953-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 14, 2018 at 04:09:56PM +0800, Qu Wenruo wrote:
> Exposed convert-test with D=asan.
> 
> Unlike btrfs, ext2fs_close() still leaves its ext2_filsys parameter
> filled with allocated pointers.
> 
> It needs ext2fs_free() to free those pointers.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
