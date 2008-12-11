From: jim owens <jowens@hp.com>
Subject: Re: Auto-sparseifying
Date: Thu, 11 Dec 2008 08:54:47 -0500
Message-ID: <49411BA7.8030708@hp.com>
References: <1228989948.17969.24.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228989948.17969.24.camel@mattos-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

... and also Data De-duplication...

A reality check before people go off the deep end here
on these two space saving methods.  It is interesting to
know the "duplicate 512 byte blocks" and "null sequences"
from a statistical point of view.  But it is not practical
to sparse/de-dup at such a small granularity in the FS.

The trade off everyone is missing is that each sparse/dup
is an *extent* that must be tracked in the FS and to do
a read you must send a new *I/O for each disk extent*.

So we blow the metadata structures into unwieldy sizes
and we beat the crap out of the disk.  Even with an SSD
we add tremendous traffic in the I/O pipeline.

Sparse/de-dup on VM page sizes may work OK for small files
but is still not efficient for large files.

jim
