Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48675 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754332AbaFLCcy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 22:32:54 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Slow startup of systemd-journal on BTRFS
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140612013728.GP4453@dastard>
Date: Wed, 11 Jun 2014 20:32:52 -0600
Cc: kreijack@inwind.it,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <5E3380D5-FF9F-4152-B115-7D16CD8CC215@colorremedies.com>
References: <5398CA16.3030609@libero.it> <20140612012104.GO9508@dastard> <20140612013728.GP4453@dastard>
To: Dave Chinner <david@fromorbit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Jun 11, 2014, at 7:21 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Jun 11, 2014 at 11:28:54PM +0200, Goffredo Baroncelli wrote:
>> Hi all,
>> 
>> I would like to share a my experience about a slowness of systemd when used on BTRFS.
>> 
>> My boot time was very high (about ~50 seconds); most of time it was due to NetworkManager which took about 30-40 seconds to start (this data came from "systemd-analyze plot").
>> 
>> I make several attempts to address this issue. Also I noticed that sometime this problem disappeared; but I was never able to understand why.
>> 
>> However this link
>> 
>> 	https://bugzilla.redhat.com/show_bug.cgi?id=1006386
>> 
>> suggested me that the problem could be due to a bad interaction between systemd and btrfs. NetworkManager was innocent. 
> 
> systemd has a very stupid journal write pattern. It checks if there
> is space in the file for the write, and if not it fallocates the
> small amount of space it needs (it does *4 byte* fallocate calls!)
> and then does the write to it.  All this does is fragment the crap
> out of the log files because the filesystems cannot optimise the
> allocation patterns.
> 
> Yup, it fragments journal files on XFS, too.
> 
> http://oss.sgi.com/archives/xfs/2014-03/msg00322.html
> 
> IIRC, the systemd developers consider this a filesystem problem and
> so refused to change the systemd code to be nice to the filesystem
> allocators, even though they don't actually need to use fallocate...
> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com

On Jun 11, 2014, at 7:37 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> BTW, the systemd list is subscriber only, so thay aren't going to
> see anything that we comment on from a cross-post to the btrfs list.


Unless a subscriber finds something really interesting, quotes it, and cross posts it.

Chris murphy