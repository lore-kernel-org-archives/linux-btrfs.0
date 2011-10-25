From: Myroslav Opyr <myroslav@quintagroup.com>
Subject: Re: [RFC PATCH] Btrfs: do not flush csum items of unchanged file data during treelog
Date: Tue, 25 Oct 2011 23:18:49 +0000 (UTC)
Message-ID: <loom.20111026T010743-539@post.gmane.org>
References: <4DAFE39D.4040309@cn.fujitsu.com> <1303391634-sup-1145@think> <4DB0D20C.9060407@cn.fujitsu.com> <1303435579-sup-6101@think> <4DB545AD.5050908@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


liubo <liubo2009 <at> cn.fujitsu.com> writes:

> 
> On 04/22/2011 09:28 AM, Chris Mason wrote:
> > Right, at the very least we want to just use one bit of that field
> > instead of all 8.  But keeping a sub-transid and putting that in the
> > generation field of the file extent instead can get us the same benefits
> > without stealing the bits.
> > 
> 
> Nice.  This is the first step of my plan.
> 
> > As we push the sub transid into the btree blocks as well, we'll get much
> > faster tree walks too.  The penalty is in complexity in the logging
> > code, since it will have to deal with finding extents in the log tree
> > and merging in the new extents from the file.
> 
> I've been thinking of this extent buffer with sub transid stuff for a while,
> and will give it a try. :)

Hi,

any progress upon this patch? We started experimenting with btrfs and were 
immediately hit by the large file fsync issue.

Each fsync operation to 3.3Gb file that is having several dozens of bytes  
appended is being visualized as 55-58sec long freeze of all filesystem 
operations altogether with 99.9% CPU utilization in the process that caused the 
fsync. Removing fsync calls made several magnitudes difference in operations 
speed.

FYI, we are running 2.6.38.8-32.fc15.i686.PAE with Btrfs v0.19 as XEN DomU and 
btrfs considers virtual xvd device (backed by HDD file on Dom0) to be SSD 
(according to dmesg) if that matters.

Regards,

m.

