Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33461 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753327AbdCPPzr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 11:55:47 -0400
Date: Thu, 16 Mar 2017 16:54:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 2/2] btrfs-progs: dump-tree: Also output log root tree
Message-ID: <20170316155417.GK14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170314053518.28812-1-quwenruo@cn.fujitsu.com>
 <20170314053518.28812-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170314053518.28812-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 14, 2017 at 01:35:18PM +0800, Qu Wenruo wrote:
> In btrfs-dump-tree, we output any existing log tree, however we don't
> output the log root tree, which records all root items for log trees.
> 
> This makes it confusing for any one who want to know where the log tree
> comes from.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2:
>   Check if log_root_tree exists before printing it in root_only mode

Applied, thanks.
