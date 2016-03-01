Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31402 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbcCASXr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Mar 2016 13:23:47 -0500
Date: Tue, 1 Mar 2016 13:23:12 -0500
From: Chris Mason <clm@fb.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Tomasz Torcz <tomek@pipebreaker.pl>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] Experimental btrfs encryption
Message-ID: <20160301182312.fdl264cxemz2fy5m@floor.thefacebook.com>
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <20160301162952.GB718307@mother.pipebreaker.pl>
 <20160301164616.dbbeuzccfkzupign@floor.thefacebook.com>
 <20160301175927.GA32354@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160301175927.GA32354@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 01, 2016 at 09:59:27AM -0800, Christoph Hellwig wrote:
> On Tue, Mar 01, 2016 at 11:46:16AM -0500, Chris Mason wrote:
> > We'll definitely move in line with the common API over time.  Thanks
> > Anand for starting this!
> > 
> > I'd prefer that we keep it per-subvolume for now, just because
> > subvolumes are so cheap and because it seems like a better collection
> > point for general use.  But as the other filesystems add features we'll
> > make sure and keep parity with what users expect.
> 
> We already have per-file encryption in f2fs and ext4, and both have
> a compatible userspace API and ABI.  It would be a pitty to deviate
> from that intead of reusing it, and if needed extending it.

I wasn't very clear here sorry.  per-subvolume is my favorite way, but
we'll go with the existing ABIs as well.  There's no reason to be
different.

-chris

