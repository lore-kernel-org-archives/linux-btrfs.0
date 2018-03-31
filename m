Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34991 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752384AbeCaAEg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 20:04:36 -0400
Date: Sat, 31 Mar 2018 02:02:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: print error messages when failing to read trees
Message-ID: <20180331000207.GA30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522275105-60516-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522275105-60516-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 29, 2018 at 06:11:45AM +0800, Liu Bo wrote:
> When mount fails to read trees like fs tree, checksum tree, extent
> tree, etc, there is not enough information about where went wrong.
> 
> With this, messages like
> 
> "BTRFS warning (device sdf): failed to read root (objectid=7): -5"
> 
> would help us a bit.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: David Sterba <dsterba@suse.com>
