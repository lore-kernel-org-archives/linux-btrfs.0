Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46114 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754371AbcK3NAv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 08:00:51 -0500
Date: Wed, 30 Nov 2016 14:00:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lkml.page@gmail.com
Subject: Re: [PATCH v4 1/3] btrfs: Add WARN_ON for qgroup reserved underflow
Message-ID: <20161130130045.GK12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161128014009.12179-1-quwenruo@cn.fujitsu.com>
 <20161129161053.GI12522@twin.jikos.cz>
 <8b47bfc3-672b-fcab-4f76-df7fed747c76@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8b47bfc3-672b-fcab-4f76-df7fed747c76@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 30, 2016 at 08:24:32AM +0800, Qu Wenruo wrote:
> 
> 
> At 11/30/2016 12:10 AM, David Sterba wrote:
> > On Mon, Nov 28, 2016 at 09:40:07AM +0800, Qu Wenruo wrote:
> >> Goldwyn Rodrigues has exposed and fixed a bug which underflows btrfs
> >> qgroup reserved space, and leads to non-writable fs.
> >>
> >> This reminds us that we don't have enough underflow check for qgroup
> >> reserved space.
> >>
> >> For underflow case, we should not really underflow the numbers but warn
> >> and keeps qgroup still work.
> >>
> >> So add more check on qgroup reserved space and add WARN_ON() and
> >> btrfs_warn() for any underflow case.
> >>
> >> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> >> Reviewed-by: David Sterba <dsterba@suse.com>
> >
> > One of the warnings is visible during xfstests
> > (btrfs_qgroup_free_refroot), is there a fix? Either a patch in
> > mailinglist or work in progress. If not, I'm a bit reluctant to add it
> > to 4.10 as we'd get that reported from users for sure.
> 
> Fix WIP, ETA would be in this week.

Good, thanks.

> At least, this warning is working and helped us to find bugs.

No doubt about that, I'll keep the patch in 4.10 queue but will not add
it to the first pull that I'm about to send today.
