From: Chris Mason <chris.mason@oracle.com>
Subject: Re: fallocate overhead
Date: Thu, 13 Aug 2009 10:45:23 -0400
Message-ID: <20090813144523.GG4652@think>
References: <20090813140732.GA1915@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, lkml@rtr.ca
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090813140732.GA1915@phenom2.trippelsdorf.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 13, 2009 at 04:07:32PM +0200, Markus Trippelsdorf wrote:
> I was playing with the new hdparm wiper script (
> http://sourceforge.net/projects/hdparm/files/) on my Vertex SSD and
> it appears that btrfs needs a huge space overhead when dealing with
> fallocate system calls. Basically what the wiper script does is to
> fallocate one huge file using all free space minus a safety margin.
> And this margin has to be about 30% on btrfs, e.g.:

We're actively fixing this ;)  The margin is just a hard coded limit to
try and avoid enospc oopsen.  It should improve in 2.6.32.

-chris
