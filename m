Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55229 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbeEVQGV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 12:06:21 -0400
Date: Tue, 22 May 2018 18:03:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, nborisov@suse.com
Subject: Re: [PATCH 2/2] btrfs: propagate failures of __exclude_logged_extent
 to upper caller
Message-ID: <20180522160337.GU6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526982411-9243-1-git-send-email-gujx@cn.fujitsu.com>
 <1526982411-9243-2-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1526982411-9243-2-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 05:46:51PM +0800, Gu Jinxiang wrote:
> Function btrfs_exclude_logged_extents may call __exclude_logged_extent
> which may fail.
> Propagate the failures of __exclude_logged_extent to upper caller.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>

The whole group of extent exclusion functions needs to be audited for
proper error handling.
