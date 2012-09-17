Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:41410 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab2IQRPy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 13:15:54 -0400
Date: Mon, 17 Sep 2012 13:15:51 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dave@jikos.cz" <dave@jikos.cz>
Subject: Re: [PATCH 2/2 v3] Btrfs: snapshot-aware defrag
Message-ID: <20120917171551.GC3143@localhost.localdomain>
References: <1347875936-14165-1-git-send-email-bo.li.liu@oracle.com>
 <1347875936-14165-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1347875936-14165-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 03:58:56AM -0600, Liu Bo wrote:
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
> Originally patch by Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

I was trying to fixup the rejects on this patch when I noticed there were no
tabs, only spaces.  Thats not going to work and now I have to go back and make
sure none of your other patches did this.  Thanks,

Josef
