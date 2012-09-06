Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:36926 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab2IFO2P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2012 10:28:15 -0400
Date: Thu, 6 Sep 2012 22:26:24 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dave@jikos.cz" <dave@jikos.cz>
Subject: Re: [PATCH v2 2/2] Btrfs: snapshot-aware defrag
Message-ID: <20120906142624.GB18524@liubo>
References: <1346893852-9815-1-git-send-email-bo.li.liu@oracle.com>
 <1346893852-9815-2-git-send-email-bo.li.liu@oracle.com>
 <20120906131153.GB18438@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120906131153.GB18438@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2012 at 09:11:53AM -0400, Josef Bacik wrote:
> On Wed, Sep 05, 2012 at 07:10:52PM -0600, Liu Bo wrote:
> > This comes from one of btrfs's project ideas,
> > As we defragment files, we break any sharing from other snapshots.
> > The balancing code will preserve the sharing, and defrag needs to grow this
> > as well.
> > 
> > Now we're able to fill the blank with this patch, in which we make full use of
> > backref walking stuff.
> > 
> > Here is the basic idea,
> > o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
> > o  at endio, after we finish updating fs tree, we use backref walking to find
> >    all parents of the ranges and re-link them with the new COWed file layout by
> >    adding corresponding backrefs.
> > 
> > Original-Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > v2: rebase against the latest btrfs-repo
> > 
> 
> Heh well it doesn't apply onto btrfs-next, try again please :).  Thanks,
> 

It's weird but I just pulled btrfs-next and applied it well...

Can you please try it again?

thanks,
liubo

> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
