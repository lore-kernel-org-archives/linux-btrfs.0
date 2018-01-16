Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34659 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751404AbeAPPO3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 10:14:29 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4943BAE07
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jan 2018 15:14:28 +0000 (UTC)
Date: Tue, 16 Jan 2018 16:12:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Streamline btrfs_delalloc_reserve_metadata
 initial operations
Message-ID: <20180116151219.GG13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515766865-13652-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515766865-13652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 12, 2018 at 04:21:05PM +0200, Nikolay Borisov wrote:
> The behavior of btrfs_delalloc_reserve_metadata depends on whether
> the inode we are allocating for is the freespace inode or not. As it
> stands if we are the free node we set 'flush' and 'delalloc_lock'
> variable to certain values. Subsequently we check the values of those
> vars and act accordingly. Instead, simplify things by having 1 if
> which checks whether we are the freespace inode or not and do any
> specific operation in either branches of that if. This makes the code
> a bit easier to understand, as an added bonus it also shrinks the
> compiled size:
> 
> add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-17 (-17)
> Function                                     old     new   delta
> btrfs_delalloc_reserve_metadata             1876    1859     -17
> Total: Before=85966, After=85949, chg -0.02%

This looks too fine grained and IMHO not useful to mention. The overall
module size delta is interesting when compared between the base nad pull
request, but not for individual patches, namely if it's just 17 bytes.
