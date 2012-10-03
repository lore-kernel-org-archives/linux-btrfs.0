Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:34577 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab2JCODC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 10:03:02 -0400
Date: Wed, 3 Oct 2012 10:02:59 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Mitch Harder <mitch.harder@sabayonlinux.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dave@jikos.cz" <dave@jikos.cz>
Subject: Re: [PATCH 2/2 v3] Btrfs: snapshot-aware defrag
Message-ID: <20121003140259.GA4458@shiny>
References: <1347875936-14165-1-git-send-email-bo.li.liu@oracle.com>
 <1347875936-14165-2-git-send-email-bo.li.liu@oracle.com>
 <CAKcLGm_4iUB1B8DPOx1D7i8eMa7po9fWFUYVOqp1N9nmZ1ExHQ@mail.gmail.com>
 <50625569.9040102@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50625569.9040102@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 25, 2012 at 07:07:53PM -0600, Liu Bo wrote:
> On 09/26/2012 01:39 AM, Mitch Harder wrote:
> > On Mon, Sep 17, 2012 at 4:58 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >> This comes from one of btrfs's project ideas,
> >> As we defragment files, we break any sharing from other snapshots.
> >> The balancing code will preserve the sharing, and defrag needs to grow this
> >> as well.
> >>
> >> Now we're able to fill the blank with this patch, in which we make full use of
> >> backref walking stuff.
> >>
> >> Here is the basic idea,
> >> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
> >> o  at endio, after we finish updating fs tree, we use backref walking to find
> >>    all parents of the ranges and re-link them with the new COWed file layout by
> >>    adding corresponding backrefs.
> >>
> >> Originally patch by Li Zefan <lizf@cn.fujitsu.com>
> >> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > 
> > I'm hitting the WARN_ON in record_extent_backrefs() indicating a
> > problem with the return value from iterate_inodes_from_logical().

Me too.  It triggers reliably with mount -o autodefrag, and then crashes
a in the next function ;)

-chris
