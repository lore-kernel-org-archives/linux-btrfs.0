Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933197AbcKGRzt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 12:55:49 -0500
Date: Mon, 7 Nov 2016 18:55:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 1/2] btrfs: Add WARN_ON for qgroup reserved underflow
Message-ID: <20161107175546.GT12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161020022842.27328-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161020022842.27328-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 20, 2016 at 10:28:41AM +0800, Qu Wenruo wrote:
> Goldwyn Rodrigues has exposed and fixed a bug which underflows btrfs
> qgroup reserved space, and leads to non-writable fs.
> 
> This reminds us that we don't have enough underflow check for qgroup
> reserved space.
> 
> For underflow case, we should not really underflow the numbers but warn
> and keeps qgroup still work.
> 
> So add more check on qgroup reserved space and add WARN_ON() and
> btrfs_warn() for any underflow case.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
