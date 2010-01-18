From: Jim Faulkner <jfaulkne@ccs.neu.edu>
Subject: Re: worse than expected compression ratios with -o compress
Date: Mon, 18 Jan 2010 17:11:53 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1001181706590.31608@alumni-linux.ccs.neu.edu>
References: <alpine.DEB.2.00.1001161048330.16549@alumni-linux.ccs.neu.edu> <20100118141240.GA10710@localhost.localdomain> <20100118212951.GC4065@think>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100118212951.GC4065@think>
List-ID: <linux-btrfs.vger.kernel.org>


On Mon, 18 Jan 2010, Chris Mason wrote:

>> Currently the only compression algorithm we support is gzip, so try gzipp'ing
>> your database to get a better comparison.  The plan is to eventually support
>> other compression algorithms, but currently we do not.  Thanks,
>
> The compression code backs off compression pretty quickly if parts of
> the file do not compress well.  This is another way of saying it favors
> CPU time over the best possible compression.  If gzip ends up better
> than what you're getting from btrfs, I can give you a patch to force
> compression all the time.

Yes, gzip compresses much better than btrfs.  I'd greatly appreciate a 
patch to force compression all the time.

It would be nice if such an ability were merged in the mainline.  Perhaps 
there could be a mount option or tunable parameter to force compression?
