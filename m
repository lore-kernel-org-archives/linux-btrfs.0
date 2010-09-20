From: Chris Samuel <chris@csamuel.org>
Subject: Re: Question of stability
Date: Mon, 20 Sep 2010 11:18:58 +1000
Message-ID: <4C96B682.5080900@csamuel.org>
References: <7280394.123.1284845879623.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7280394.123.1284845879623.JavaMail.root@zimbra>
List-ID: <linux-btrfs.vger.kernel.org>

On 19/09/10 07:37, Roy Sigurd Karlsbakk wrote:

> I've been on this list for a year or so, and I have been following
> progress for some more. Are there any chances of btrfs stabilizing,
> as in terms of usability in production? If so, how far are we from this?

I've been using btrfs in anger for a number of years (though not
using snapshots, subvolumes, etc) and am happy with it - though I
always make sure I've got plenty of free space.

However, I've been sufficiently worried about the checksum issues
being reported with newer kernels (still on 2.6.32 in Ubuntu 10.04)
that I'm considering deferring upgrading to 10.10 when it appears
to avoid the newer code.

I can see only one merge of patches to btrfs in the mainline kernel
since 2.6.35 was released on August 1st (merged August 10th), and
those came via the linux-2.6-block tree not from the btrfs devs so
I don't see any prospect of those issues being fixed in 2.6.36 either.

> Also, what about the RAID-[56] parts, they were announced more
> than a year ago, but still I can't see anything in the open.

Those are still out of tree I'm afraid.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
