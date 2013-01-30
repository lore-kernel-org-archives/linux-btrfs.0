Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:53062 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab3A3PQJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 10:16:09 -0500
Date: Wed, 30 Jan 2013 10:16:06 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Jim Schutt <jaschut@sandia.gov>
CC: Josef Bacik <JBacik@fusionio.com>, Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
Message-ID: <20130130151606.GG3660@localhost.localdomain>
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
 <50E5D19E.3060406@sandia.gov>
 <20130128212331.GG3257@localhost.localdomain>
 <510817C6.5070007@sandia.gov>
 <20130129200415.GE3660@localhost.localdomain>
 <510855AD.2020602@sandia.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <510855AD.2020602@sandia.gov>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 29, 2013 at 04:05:17PM -0700, Jim Schutt wrote:
> On 01/29/2013 01:04 PM, Josef Bacik wrote:
> > On Tue, Jan 29, 2013 at 11:41:10AM -0700, Jim Schutt wrote:
> >> > On 01/28/2013 02:23 PM, Josef Bacik wrote:
> >>> > > On Thu, Jan 03, 2013 at 11:44:46AM -0700, Jim Schutt wrote:
> >>>> > >> Hi Josef,
> >>>> > >>
> >>>> > >> Thanks for the patch - sorry for the long delay in testing...
> >>>> > >>
> >>> > > 
> >>> > > Jim,
> >>> > > 
> >>> > > I've been trying to reason out how this happens, could you do a btrfs fi df on
> >>> > > the filesystem thats giving you trouble so I can see if what I think is
> >>> > > happening is what's actually happening.  Thanks,
> >> > 
> >> > Here's an example, using a slightly different kernel than
> >> > my previous report.  It's your btrfs-next master branch
> >> > (commit 8f139e59d5 "Btrfs: use bit operation for ->fs_state")
> >> > with ceph 3.8 for-linus (commit 0fa6ebc600 from linus' tree).
> >> > 
> >> > 
> >> > Here I'm finding the file system in question:
> >> > 
> >> > # ls -l /dev/mapper | grep dm-93
> >> > lrwxrwxrwx 1 root root       8 Jan 29 11:13 cs53s19p2 -> ../dm-93
> >> > 
> >> > # df -h | grep -A 1 cs53s19p2
> >> > /dev/mapper/cs53s19p2
> >> >                       896G  1.1G  896G   1% /ram/mnt/ceph/data.osd.522
> >> > 
> >> > 
> >> > Here's the info you asked for:
> >> > 
> >> > # btrfs fi df /ram/mnt/ceph/data.osd.522
> >> > Data: total=2.01GB, used=1.00GB
> >> > System: total=4.00MB, used=64.00KB
> >> > Metadata: total=8.00MB, used=7.56MB
> >> > 
> > How big is the disk you are using, and what mount options?  I have a patch to
> > keep the panic from happening and hopefully the abort, could you try this?  I
> > still want to keep the underlying error from happening because it shouldn't be,
> > but no reason I can't fix the error case while you can easily reproduce it :).
> > Thanks,
> > 
> > Josef
> > 
> >>From c50b725c74c7d39064e553ef85ac9753efbd8aec Mon Sep 17 00:00:00 2001
> > From: Josef Bacik <jbacik@fusionio.com>
> > Date: Tue, 29 Jan 2013 15:03:37 -0500
> > Subject: [PATCH] Btrfs: fix chunk allocation error handling
> > 
> > If we error out allocating a dev extent we will have already created the
> > block group and such which will cause problems since the allocator may have
> > tried to allocate out of the block group that no longer exists.  This will
> > cause BUG_ON()'s in the bio submission path.  This also makes a failure to
> > allocate a dev extent a non-abort error, we will just clean up the dev
> > extents we did allocate and exit.  Now if we fail to delete the dev extents
> > we will abort since we can't have half of the dev extents hanging around,
> > but this will make us much less likely to abort.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> 
> Interesting - with your patch applied I triggered the following, just
> bringing up a fresh Ceph filesystem - I didn't even get a chance to
> mount it on my Ceph clients:
> 

Actually nevermind it looks like I figured out how to reproduce.  I'll let you
know when I have something to test.  Thanks,

Josef
