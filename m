Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56908 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755949AbeASSRv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 13:17:51 -0500
Date: Fri, 19 Jan 2018 19:15:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, nborisov@suse.com
Subject: Re: [PATCH v2 09/10] Btrfs: add tracepoint for em's EEXIST case
Message-ID: <20180119181539.GA15713@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180105195117.5131-10-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180105195117.5131-10-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 05, 2018 at 12:51:16PM -0700, Liu Bo wrote:
> This is adding a tracepoint 'btrfs_handle_em_exist' to help debug the
> subtle bugs around merge_extent_mapping.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Nikolay has some concernas about adding the tracepoint, so I'll leave
this patch out of the series for now as we should decide how to proceed.

Thacepoints are considered an ABI by some and not ABI by others. I think
it's a good addition to the debugging aids that also may turn out to be
useful for evaluating performance later.

At minimum we could add some prefix/suffix to the debugging tracepoint
name, so we can let developers add what they need right away.
