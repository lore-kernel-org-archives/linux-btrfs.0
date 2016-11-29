Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750820AbcK2QK6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 11:10:58 -0500
Date: Tue, 29 Nov 2016 17:10:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, lkml.page@gmail.com
Subject: Re: [PATCH v4 1/3] btrfs: Add WARN_ON for qgroup reserved underflow
Message-ID: <20161129161053.GI12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161128014009.12179-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161128014009.12179-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 28, 2016 at 09:40:07AM +0800, Qu Wenruo wrote:
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
> Reviewed-by: David Sterba <dsterba@suse.com>

One of the warnings is visible during xfstests
(btrfs_qgroup_free_refroot), is there a fix? Either a patch in
mailinglist or work in progress. If not, I'm a bit reluctant to add it
to 4.10 as we'd get that reported from users for sure.
