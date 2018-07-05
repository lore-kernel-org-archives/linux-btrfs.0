Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42800 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753323AbeGEORb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 10:17:31 -0400
Date: Thu, 5 Jul 2018 16:17:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, nborisov@suse.com, quwenruo.btrfs@gmx.com
Subject: Re: [PATCH v3] btrfs: Add chunk type check in read a chunk
Message-ID: <20180705141728.GE3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530699399-23573-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530699399-23573-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2018 at 06:16:39PM +0800, Gu Jinxiang wrote:
> Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199839,
> which has a invalid chunk, not return error opportunlly.
> 
> Add chunk type check in btrfs_check_chunk_valid,
> to make error be returned in advance.
> 
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v3:
> deal with comment by Nikolay Borisov, change the error message
> more appropriate.
> 
> v2:
> deal with comment by Qu, add precise check for chunk type.

Added to misc-next with some updates, thanks.
