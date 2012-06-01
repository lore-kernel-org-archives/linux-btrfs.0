Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759597Ab2FAMq1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jun 2012 08:46:27 -0400
Date: Fri, 1 Jun 2012 08:46:14 -0400
From: Josef Bacik <josef@redhat.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] Btrfs: track transaction aborted across the fs_info
Message-ID: <20120601124613.GB2652@localhost.localdomain>
References: <1338494656-12232-1-git-send-email-josef@redhat.com>
 <1338494656-12232-2-git-send-email-josef@redhat.com>
 <4FC8196D.8010407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC8196D.8010407@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 01, 2012 at 09:22:53AM +0800, Liu Bo wrote:
> On 06/01/2012 04:04 AM, Josef Bacik wrote:
> 
> > If we abort a transaction during the commit phase we can have people who
> > start new transactions because we nave no way of signaling to them that
> > something went wrong.  So add a trans_aborted flag to the fs_info so the
> > start transaction code can be notified that the last transaction was aborted
> > and it needs to return an error.  Thanks,
> > 
> 
> 
> We already have a (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR),
> why don't just use that?
> 

Ah I missed all of that, will do, thanks,

Josef
