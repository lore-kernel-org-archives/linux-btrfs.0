Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755380AbdLOLlI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 06:41:08 -0500
Subject: Re: [PATCH] btrfs: Add enospc_debug printing in
 metadata_reserve_bytes
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1513332337-7068-1-git-send-email-nborisov@suse.com>
 <67c2425e-c182-4223-fd04-603fade3bead@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <022899d1-e7f6-0cab-66f3-9753c6c9ea11@suse.com>
Date: Fri, 15 Dec 2017 13:41:06 +0200
MIME-Version: 1.0
In-Reply-To: <67c2425e-c182-4223-fd04-603fade3bead@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.12.2017 13:36, Qu Wenruo wrote:
> .
> 
> But btrfs_space_reservation() seems to be abused.
> Every type from delalloc to enospc debug will use it.
> 
> What about splitting them into different trace events?

I think trace events form some sort of an ABI so we can't really be
modifying current events, though I'd defer to David on that matter.

OTOH the trace event contains all the information we like - either if
it's an alloc/free operation, whether it's data or metadata and whether
it's enospc or not. Admittedly the last thing is a bit of a pain-point
since if you want to filter enospc you have to do string parsing on the
output from the trace_btrfs_space_reservation. But even this doesn't
sound too compelling to warrant a split. Either ways I'm fine with it.
