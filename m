Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:33311 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab3A2Nrd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 08:47:33 -0500
Date: Tue, 29 Jan 2013 08:47:30 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>, Jim Schutt <jaschut@sandia.gov>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
Message-ID: <20130129134730.GB3660@localhost.localdomain>
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
 <50E5D19E.3060406@sandia.gov>
 <20130128212331.GG3257@localhost.localdomain>
 <20130129023007.GB15654@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130129023007.GB15654@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 07:30:09PM -0700, Liu Bo wrote:
> On Mon, Jan 28, 2013 at 04:23:31PM -0500, Josef Bacik wrote:
> > On Thu, Jan 03, 2013 at 11:44:46AM -0700, Jim Schutt wrote:
> > > Hi Josef,
> > > 
> > > Thanks for the patch - sorry for the long delay in testing...
> > > 
> > 
> > Jim,
> > 
> > I've been trying to reason out how this happens, could you do a btrfs fi df on
> > the filesystem thats giving you trouble so I can see if what I think is
> > happening is what's actually happening.  Thanks,
> 
> Josef,
> 
> A quick reproducer here: running xfstests 251 with autodefrag,compress=zlib
> 


251      [not run] FSTRIM is not supported

Are you sure its 251?  Thanks,

Josef
