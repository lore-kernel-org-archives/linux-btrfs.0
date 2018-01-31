Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44596 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbeAaQYd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 11:24:33 -0500
Date: Wed, 31 Jan 2018 17:22:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, quwenruo.btrfs@gmx.com
Subject: Re: [PATCH v3 7/7] btrfs-progs: Cleanup use of root in leaf_data_end
Message-ID: <20180131162220.GH18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1517368159-12858-1-git-send-email-gujx@cn.fujitsu.com>
 <1517368159-12858-8-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1517368159-12858-8-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 31, 2018 at 11:09:19AM +0800, Gu Jinxiang wrote:
> In function leaf_data_end, root is just used to get fs_info,
> so change the parameter of this function from btrfs_root to
> btrfs_fs_info.
> And also make it consistent with kernel.
> 
> Changelog:
> v3->v2:
> Add const to parameter leaf of function btrfs_item_offset_nr
> to keep type consistent with leaf_data_end.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>

I did not notice the V3, this patch has been added to devel as the
warning is gone, thanks. The was trivial after all.
