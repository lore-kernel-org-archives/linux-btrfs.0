Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728347AbeITWeX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 18:34:23 -0400
Date: Thu, 20 Sep 2018 18:49:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] rb_first to rb_first_cached conversion
Message-ID: <20180920164958.GA5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 23, 2018 at 03:51:48AM +0800, Liu Bo wrote:
> Several structs in btrfs are using rb_first() in a while loop, it'd be
> more efficient to do this with rb_first_cached() which has the O(1)
> complexity.
> 
> This patch set updates five structs which may have a large rb tree in
> practice
> 
> Liu Bo (5):
>   Btrfs: href_root: use rb_first_cached
>   Btrfs: href->ref_tree: use rb_first_cached
>   Btrfs: delayed_items: use rb_first_cached
>   Btrfs: extent_map: use rb_first_cached
>   Btrfs: preftree: use rb_first_cached

For the record, patches have been merged to misc-next. I've changed the
subject titles to

Btrfs: delayed-refs: use rb_first_cached for href_root
Btrfs: delayed-refs: use rb_first_cached for ref_tree
Btrfs: delayed-inode: use rb_first_cached for ins_root and del_root
Btrfs: extent_map: use rb_first_cached
Btrfs: preftree: use rb_first_cached

added Holger's tested-by and my reviewed-by.
