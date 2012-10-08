Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52438 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab2JHNTP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 09:19:15 -0400
Date: Mon, 8 Oct 2012 09:19:12 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Chris Mason <clmason@fusionio.com>,
        Mitch Harder <mitch.harder@sabayonlinux.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dave@jikos.cz" <dave@jikos.cz>
Subject: Re: [PATCH 2/2 v3] Btrfs: snapshot-aware defrag
Message-ID: <20121008131912.GA4132@shiny>
References: <1347875936-14165-1-git-send-email-bo.li.liu@oracle.com>
 <1347875936-14165-2-git-send-email-bo.li.liu@oracle.com>
 <CAKcLGm_4iUB1B8DPOx1D7i8eMa7po9fWFUYVOqp1N9nmZ1ExHQ@mail.gmail.com>
 <50625569.9040102@oracle.com>
 <20121003140259.GA4458@shiny>
 <5072C492.8040205@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5072C492.8040205@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 06:18:26AM -0600, Liu Bo wrote:
> On 10/03/2012 10:02 PM, Chris Mason wrote:
> > On Tue, Sep 25, 2012 at 07:07:53PM -0600, Liu Bo wrote:
> >> On 09/26/2012 01:39 AM, Mitch Harder wrote:
> >>> On Mon, Sep 17, 2012 at 4:58 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >>>> This comes from one of btrfs's project ideas,
> >>>> As we defragment files, we break any sharing from other snapshots.
> >>>> The balancing code will preserve the sharing, and defrag needs to grow this
> >>>> as well.
> >>>>
> >>>> Now we're able to fill the blank with this patch, in which we make full use of
> >>>> backref walking stuff.
> >>>>
> >>>> Here is the basic idea,
> >>>> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
> >>>> o  at endio, after we finish updating fs tree, we use backref walking to find
> >>>>    all parents of the ranges and re-link them with the new COWed file layout by
> >>>>    adding corresponding backrefs.
> >>>>
> >>>> Originally patch by Li Zefan <lizf@cn.fujitsu.com>
> >>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >>>
> >>> I'm hitting the WARN_ON in record_extent_backrefs() indicating a
> >>> problem with the return value from iterate_inodes_from_logical().
> > 
> > Me too.  It triggers reliably with mount -o autodefrag, and then crashes
> > a in the next function ;)
> > 
> > -chris
> > 
> 
> Hi Chris, Mitch,
> 
> I'm afraid that I may need a little more time to fix all bugs in it because there seems to be
> some backref walking bugs mixed in, and at least 4 different crashes make it harder to address bugs.
> 
> I use an 1G random write fio job running in background, following by creating 20 snapshots in background,
> and mount -o autodefrag.
> 
> So if your crash is quite stable in one place, please let me know the steps.

I have a notmuch mail database.  I just receive mail with auto defrag on
and it crashes.  Chrome databases may do it as well.

If it helps, I have compression too.

-chris

