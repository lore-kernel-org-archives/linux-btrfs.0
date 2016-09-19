Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49881 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751608AbcISSPM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 14:15:12 -0400
Date: Mon, 19 Sep 2016 20:13:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <kernel@kyup.com>
Cc: clm@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix handling of -ENOENT from btrfs_uuid_iter_rem
Message-ID: <20160919181315.GS16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b369cabe-9269-800c-cce7-5f5c71147660@fb.com>
 <1473233938-21560-1-git-send-email-kernel@kyup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1473233938-21560-1-git-send-email-kernel@kyup.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 07, 2016 at 10:38:58AM +0300, Nikolay Borisov wrote:
> btrfs_uuid_iter_rem is able to return -ENOENT, however this condition
> is not handled in btrfs_uuid_tree_iterate which can lead to calling
> btrfs_next_item with freed path argument, leading to a null pointer
> dereference. Fix it by redoing the search but with an incremented
> objectid so we don't loop over the same key.
> 
> Signed-off-by: Nikolay Borisov <kernel@kyup.com>
> Suggested-by: Chris Mason <clm@fb.com>
> Link: https://lkml.kernel.org/r/57A473B0.2040203@kyup.com

I'll queue the patch for 4.9, thanks.
