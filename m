Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57842 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750904AbeE3KqO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 06:46:14 -0400
Date: Wed, 30 May 2018 12:43:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: drop unused parameter qgroup_reserved
Message-ID: <20180530104330.GB3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1527649239-22774-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1527649239-22774-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 30, 2018 at 11:00:38AM +0800, Gu Jinxiang wrote:
> From: Gu JinXiang <gujx@cn.fujitsu.com>
> 
> Since commit 7775c8184ec0
> ("btrfs: remove unused parameter from btrfs_subvolume_release_metadata")
> parameter qgroup_reserved is not used by caller
> of function btrfs_subvolume_reserve_metadata.
> So remove it.
> 
> Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>

Nice.

Reviewed-by: David Sterba <dsterba@suse.com>

1 and 2 applied.
