Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:34029 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024Ab3CMTTV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 15:19:21 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 7ED807C067A
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 13:19:20 -0600 (MDT)
Date: Wed, 13 Mar 2013 15:19:18 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Russell Coker <russell@coker.com.au>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Debian 3.7.1 BTRFS crash
Message-ID: <20130313191918.GF15014@shiny.masoncoding.com>
References: <201303131238.33692.russell@coker.com.au>
 <CALJXSJqNermOKN7KZ_8x2SP0J8-f7F=tRiEMym6UWum7_Vf-4A@mail.gmail.com>
 <5140837A.70409@redhat.com>
 <201303140103.53907.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201303140103.53907.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 13, 2013 at 08:03:53AM -0600, Russell Coker wrote:
> On Thu, 14 Mar 2013, Eric Sandeen <sandeen@redhat.com> wrote:
> > > It seems the SSD has bad blocks now, BTRFS seems to abuse SSD disks, I
> > > burnt 1 SSD disk and 2 USB flash drive since I'm using BTRFS, in about
> > > 2 months for each. ddrescue'ing the SSD would probably give better
> > > chances of recovery and give BTRFS/btrfsck a chance to write correctly
> > > to the newly copied image.
> > 
> > On what do you base that theory?  I suppose it could be, but nothing
> > in the logs necessarily suggests that.  The "IO failure" is because 
> > the fs shut down, went readonly, and subsequent IOs got -EIO,
> > I think.
> 
> I've just used nc to transfer the filesystem to another system, there were no 
> read errors so I don't think that a SSD hardware failure is the problem here.
> 
> I'm now getting similar problems running a 3.8 kernel with the filesystem on a 
> loopback device.  I'll provide more information soon.

Bad key ordering is pretty rare, and it usually means memory
corruptions.  Are you reproducing this on the same machine or a
different one?

-chris

