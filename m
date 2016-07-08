Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbcGHQE7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 12:04:59 -0400
Date: Fri, 8 Jul 2016 18:05:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org, master.b.at.raven@chefmail.de
Subject: Re: [PATCH] Btrfs: fix unexpected balance crash due to BUG_ON
Message-ID: <20160708160516.GQ13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462230062-8053-1-git-send-email-bo.li.liu@oracle.com>
 <CAHji150s7Ha05biMeNyMSuBRh7eMxj5SR7ezck2D2-PfJTL=WQ@mail.gmail.com>
 <20160503233054.GD21008@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160503233054.GD21008@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 03, 2016 at 04:30:54PM -0700, Liu Bo wrote:
> > Just a heads up that this seems to introduce a valid warning, since it now
> > can goto error before the first initializing use of path:
> > 
> > fs/btrfs/volumes.c: In function 'btrfs_balance':
> > fs/btrfs/volumes.c:3601:2: warning: 'path' may be used uninitialized
> > in this function [-Wmaybe-uninitialized]
> >   btrfs_free_path(path);
> >   ^
> > fs/btrfs/volumes.c:3385:21: note: 'path' was declared here
> >   struct btrfs_path *path;
> >                      ^
> > (it's really in __btrfs_balance which got inlined, so gcc thinks it's
> > at the call site).
> > 
> > Simply setting path = NULL at the beginning of __btrfs_balance fixes it, since
> > btrfs_free_path allows NULL values.
> 
> That's right, it's weird that I didn't get this warning while testing it.
> 
> Thanks for catching it, Holger.

Please send a v2, the patch is desiable.
