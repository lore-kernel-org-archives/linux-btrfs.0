Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:48687 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751940AbaB1EiL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 23:38:11 -0500
Date: Fri, 28 Feb 2014 15:38:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BUG: >16TB Btrfs volumes are mountable on 32 bit kernels
Message-ID: <20140228043807.GC13647@dastard>
References: <994B6F86-9AF0-4826-8352-8573EE8003B6@colorremedies.com>
 <530FA8FA.9020700@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530FA8FA.9020700@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 27, 2014 at 04:07:06PM -0500, Josef Bacik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 02/27/2014 04:05 PM, Chris Murphy wrote:
> > User reports successfully formatting and using an ~18TB Btrfs
> > volume on hardware raid5 using i686 kernel for over a year, and
> > then suddenly the file system starts behaving weirdly:
> > 
> > https://urldefense.proofpoint.com/v1/url?u=http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg31856.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=6eUt5RgBggFh930oFrH19iR4z%2BFVzT%2F0%2F4dYPt3g48U%3D%0A&s=5ac126734d7fa1d3238ab09a2ddc021a8dcc8fff7b022560a4d068be2de37c00
> >
> > 
> > 
> > I think this is due to the kernel page cache address space being
> > 16TB limited on 32-bit kernels, as mentioned by Dave Chinner in
> > this thread:
> > 
> > https://urldefense.proofpoint.com/v1/url?u=http://oss.sgi.com/pipermail/xfs/2014-February/034588.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=6eUt5RgBggFh930oFrH19iR4z%2BFVzT%2F0%2F4dYPt3g48U%3D%0A&s=3e45f9288e6a77bc1a24dded368802c2ab46b812bf59953f74d4ee1d4141f7d2
> >
> >  So it sounds like it shouldn't be possible to mount a Btrfs volume
> > larger than 16TB on 32-bit kernels. This is consistent with ext4
> > and XFS which refuse to mount large file systems.
> > 
> > 
> 
> Well that's not good, I'll fix this up.  Thanks,

Well, don't go assuming there's a problem just because I made an
off-hand comment. i.e my comment was simply "maybe it hasn't been
tested", and not an assertion that there is a bug or a problem....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
