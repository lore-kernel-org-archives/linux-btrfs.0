Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:3337 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488AbaFLBVb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 21:21:31 -0400
Date: Thu, 12 Jun 2014 11:21:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: kreijack@inwind.it
Cc: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Slow startup of systemd-journal on BTRFS
Message-ID: <20140612012104.GO9508@dastard>
References: <5398CA16.3030609@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5398CA16.3030609@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 11, 2014 at 11:28:54PM +0200, Goffredo Baroncelli wrote:
> Hi all,
> 
> I would like to share a my experience about a slowness of systemd when used on BTRFS.
> 
> My boot time was very high (about ~50 seconds); most of time it was due to NetworkManager which took about 30-40 seconds to start (this data came from "systemd-analyze plot").
> 
> I make several attempts to address this issue. Also I noticed that sometime this problem disappeared; but I was never able to understand why.
> 
> However this link
> 
> 	https://bugzilla.redhat.com/show_bug.cgi?id=1006386
> 
> suggested me that the problem could be due to a bad interaction between systemd and btrfs. NetworkManager was innocent. 

systemd has a very stupid journal write pattern. It checks if there
is space in the file for the write, and if not it fallocates the
small amount of space it needs (it does *4 byte* fallocate calls!)
and then does the write to it.  All this does is fragment the crap
out of the log files because the filesystems cannot optimise the
allocation patterns.

Yup, it fragments journal files on XFS, too.

http://oss.sgi.com/archives/xfs/2014-03/msg00322.html

IIRC, the systemd developers consider this a filesystem problem and
so refused to change the systemd code to be nice to the filesystem
allocators, even though they don't actually need to use fallocate...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
