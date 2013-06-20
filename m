Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36816 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098Ab3FTR2u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 13:28:50 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 344F37C041B
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 11:28:50 -0600 (MDT)
Date: Thu, 20 Jun 2013 13:28:47 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@redhat.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: use a percpu to keep track of possibly pinned
 bytes
Message-ID: <20130620172847.GD4288@localhost.localdomain>
References: <1371670655-18309-1-git-send-email-jbacik@fusionio.com>
 <20130620162615.GB32674@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130620162615.GB32674@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 20, 2013 at 09:26:15AM -0700, Zach Brown wrote:
> > @@ -3380,6 +3382,10 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
> >  	if (!found)
> >  		return -ENOMEM;
> >  
> > +	ret = percpu_counter_init(&found->total_bytes_pinned, 0);
> > +	if (ret)
> > +		return ret;
> > +
> 
> Leaks *found if percpu_counter_init() fails.
> 

Right thanks.

> > -	if (space_info->bytes_pinned + delayed_rsv->size < bytes) {
> > +	bytes_pinned = percpu_counter_sum(&space_info->total_bytes_pinned);
> > +	if (bytes_pinned + delayed_rsv->size < bytes) {
> 
> This stood out as being different from the rest of the comparisons.
> 
> Why manually sum the counters instead of letting _compare() optimize it
> away if it can?  _compare(&, bytes - delayed_rsv->size)?
> 

Cause negative numbers bother me?

Josef
