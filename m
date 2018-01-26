Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:42722 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753243AbeAZObH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:31:07 -0500
Received: by mail-qt0-f193.google.com with SMTP id c2so1657236qtn.9
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:31:07 -0800 (PST)
Date: Fri, 26 Jan 2018 09:31:06 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: tree-checker: Replace root parameter with fs_info
Message-ID: <20180126143105.ighlohekgjlh6uwq@destiny>
References: <20180125065618.17501-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125065618.17501-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 02:56:18PM +0800, Qu Wenruo wrote:
> When inspecting the error message with real corruption, the "root=%llu"
> always shows "1" (root tree), instead of correct owner.
> 
> The problem is that we are getting @root from page->mapping->host, which
> points the same btree inode, so we will always get the same root.
> 
> This makes the root owner output meaningless, and harder to port
> tree-checker to btrfs-progs.
> 
> So get rid of the false and meaningless @root parameter and replace it
> with @fs_info.
> To get the owner, we can only rely on btrfs_header_owner() now.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
