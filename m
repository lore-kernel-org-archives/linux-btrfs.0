Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39684 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752268AbdBJQPD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 11:15:03 -0500
Date: Fri, 10 Feb 2017 17:14:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: Better csum error message for data csum mismatch
Message-ID: <20170210161402.GJ16928@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170209024506.22767-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170209024506.22767-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 09, 2017 at 10:45:06AM +0800, Qu Wenruo wrote:
> The original csum error message only outputs inode number, offset, check
> sum and expected check sum.
> 
> However no root objectid is outputted, which sometimes makes debugging
> quite painful under multi-subvolume case (including relocation).
> 
> Also the checksum output is decimal, which seldom makes sense for
> users/developers and is hard to read in most time.
> 
> This patch will add root objectid, which will be %lld for rootid larger
> than LAST_FREE_OBJECTID, and hex csum output for better readability.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2:
>   Output mirror number in both inode.c and compression.c

Reviewed-by: David Sterba <dsterba@suse.com>

Added to 4.11 queue.
