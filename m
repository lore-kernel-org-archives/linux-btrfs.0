Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:42886 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbcGHV1m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 17:27:42 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u68LRZg4031583
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Jul 2016 21:27:36 GMT
Date: Fri, 8 Jul 2016 14:26:23 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org, master.b.at.raven@chefmail.de
Subject: Re: [PATCH] Btrfs: fix unexpected balance crash due to BUG_ON
Message-ID: <20160708212623.GB26260@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1462230062-8053-1-git-send-email-bo.li.liu@oracle.com>
 <CAHji150s7Ha05biMeNyMSuBRh7eMxj5SR7ezck2D2-PfJTL=WQ@mail.gmail.com>
 <20160503233054.GD21008@localhost.localdomain>
 <20160708160516.GQ13336@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160708160516.GQ13336@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 08, 2016 at 06:05:16PM +0200, David Sterba wrote:
> On Tue, May 03, 2016 at 04:30:54PM -0700, Liu Bo wrote:
> > > Just a heads up that this seems to introduce a valid warning, since it now
> > > can goto error before the first initializing use of path:
> > > 
> > > fs/btrfs/volumes.c: In function 'btrfs_balance':
> > > fs/btrfs/volumes.c:3601:2: warning: 'path' may be used uninitialized
> > > in this function [-Wmaybe-uninitialized]
> > >   btrfs_free_path(path);
> > >   ^
> > > fs/btrfs/volumes.c:3385:21: note: 'path' was declared here
> > >   struct btrfs_path *path;
> > >                      ^
> > > (it's really in __btrfs_balance which got inlined, so gcc thinks it's
> > > at the call site).
> > > 
> > > Simply setting path = NULL at the beginning of __btrfs_balance fixes it, since
> > > btrfs_free_path allows NULL values.
> > 
> > That's right, it's weird that I didn't get this warning while testing it.
> > 
> > Thanks for catching it, Holger.
> 
> Please send a v2, the patch is desiable.

Oh, I almost forgot this one, thanks for the reminder.

Thanks,

-liubo
