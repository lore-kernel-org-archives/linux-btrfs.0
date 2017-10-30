Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40647 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932181AbdJ3QR6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 12:17:58 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A0DBDAB12
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 16:17:56 +0000 (UTC)
Date: Mon, 30 Oct 2017 17:16:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Make btrfs_async_run_delayed_root use a loop
 rather than multiple labels
Message-ID: <20171030161607.GZ3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1508755909-16838-1-git-send-email-nborisov@suse.com>
 <5ee8b69c-41ce-af48-773d-b8fb8358e5da@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5ee8b69c-41ce-af48-773d-b8fb8358e5da@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 23, 2017 at 07:43:02PM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年10月23日 18:51, Nikolay Borisov wrote:
> > Currently btrfs_async_run_delayed_root's implementation uses 3 goto labels to
> > mimic the functionality of a simple do {} while loop. Refactor the function
> > to use a do {} while construct, making intention clear and code easier to
> > follow. No functional changes
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Looks good to me.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

1-2 added to next.
