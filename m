Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60051 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbcCUN7c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 09:59:32 -0400
Received: from localhost
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 21 Mar 2016 23:59:29 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH V2] _btrfs_stress_subvolume: Fix race condition by making 'subvolume stress' task to exit gracefully
Date: Mon, 21 Mar 2016 19:27:49 +0530
Message-ID: <2067159.W4Pk9hPgLa@localhost.localdomain>
In-Reply-To: <20160321120706.GE11419@eguan.usersys.redhat.com>
References: <1458545992-32114-1-git-send-email-chandan@linux.vnet.ibm.com> <20160321120706.GE11419@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 21 Mar 2016 20:07:06 Eryu Guan wrote:
> > diff --git a/common/rc b/common/rc
> > index 16f5a43..7d971ea 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -3280,9 +3280,10 @@ _btrfs_stress_subvolume()
> > 
> >  	local btrfs_mnt=$2
> >  	local subvol_name=$3
> >  	local subvol_mnt=$4
> > 
> > +	local stop_file=$stop_file
> 
> This should be "local stop_file=$5"
> 
> Otherwise looks good to me, at least there's no regression, all affected
> tests still pass for me and no other tests fail because of unclean exit
> from previous test.
> 
> Reviewed-by: Eryu Guan <eguan@redhat.com>

Sorry, I will fix it and send V3.

-- 
chandan

