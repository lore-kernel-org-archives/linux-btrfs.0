Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52858 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab2IFNL4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 09:11:56 -0400
Date: Thu, 6 Sep 2012 09:11:53 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dave@jikos.cz" <dave@jikos.cz>
Subject: Re: [PATCH v2 2/2] Btrfs: snapshot-aware defrag
Message-ID: <20120906131153.GB18438@localhost.localdomain>
References: <1346893852-9815-1-git-send-email-bo.li.liu@oracle.com>
 <1346893852-9815-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1346893852-9815-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 05, 2012 at 07:10:52PM -0600, Liu Bo wrote:
> This comes from one of btrfs's project ideas,
> As we defragment files, we break any sharing from other snapshots.
> The balancing code will preserve the sharing, and defrag needs to grow this
> as well.
> 
> Now we're able to fill the blank with this patch, in which we make full use of
> backref walking stuff.
> 
> Here is the basic idea,
> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
> o  at endio, after we finish updating fs tree, we use backref walking to find
>    all parents of the ranges and re-link them with the new COWed file layout by
>    adding corresponding backrefs.
> 
> Original-Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v2: rebase against the latest btrfs-repo
> 

Heh well it doesn't apply onto btrfs-next, try again please :).  Thanks,

Josef
