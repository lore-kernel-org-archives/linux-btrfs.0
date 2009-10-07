From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Warning and BUG using btrfs-vol -b
Date: Wed, 7 Oct 2009 15:45:29 -0400
Message-ID: <20091007194529.GN3757@think>
References: <200910062048.32381.diegocg@gmail.com>
 <200910071551.46430.diegocg@gmail.com>
 <20091007143309.GF3757@think>
 <200910072110.28958.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910072110.28958.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 07, 2009 at 09:10:28PM +0200, Diego Calleja wrote:
> On Wednesday 07 October 2009 16:33:09 Chris Mason escribi=F3:
> > Ok, in this case you ended up with raid0 on the data.  If you:
> >=20
> > mkfs.btrfs -d raid1 /dev/loop0 /dev/loop1 you'll get data raid1.
>=20
> I got a BUG...but it may be a different bug. Unlike the last time,
> I didn't even need to zero one of the "disks", the second I
> rebalanced it oopsed:

I'm afraid this is good old enospc.  Balancing still needs some work to
be completely safe.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
