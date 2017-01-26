Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50313 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752838AbdAZRe0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 12:34:26 -0500
Date: Thu, 26 Jan 2017 18:32:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: allow unlink to exceed subvolume quota
Message-ID: <20170126173225.GI11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <a9139e75-cf3f-301a-9de4-a2bcfa718a70@suse.com>
 <985834f8-d5d5-a6b5-39bb-8a18f81bc500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <985834f8-d5d5-a6b5-39bb-8a18f81bc500@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 26, 2017 at 08:48:42AM +0800, Qu Wenruo wrote:
> 
> 
> At 01/25/2017 10:50 PM, Jeff Mahoney wrote:
> > Once a qgroup limit is exceeded, it's impossible to restore normal
> > operation to the subvolume without modifying the limit or removing
> > the subvolume.  This is a surprising situation for many users used
> > to the typical workflow with quotas on other file systems where it's
> > possible to remove files until the used space is back under the limit.
> >
> > When we go to unlink a file and start the transaction, we'll hit
> > the qgroup limit while trying to reserve space for the items we'll
> > modify while removing the file.  We discussed last month how best
> > to handle this situation and agreed that there is no perfect solution.
> > The best principle-of-least-surprise solution is to handle it similarly
> > to how we already handle ENOSPC when unlinking, which is to allow
> > the operation to succeed with the expectation that it will ultimately
> > release space under most circumstances.
> >
> > This patch modifies the transaction start path to select whether to
> > honor the qgroups limits.  btrfs_start_transaction_fallback_global_rsv
> > is the only caller that skips enforcement.  The reservation and tracking
> > still happens normally -- it just skips the enforcement step.
> 
> Thanks for the patch.
> 
> The unlink remains as a concern for me since for qgroup there is nothing 
> like global reserved space for us to do unlink operations unlimitedly.
> 
> So it's very nice for you to address the problem.
> 
> It looks good to me.
> 
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Queued for 4.11.
