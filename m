Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:48839 "EHLO
	homiemail-a52.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755658Ab3GEDjD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jul 2013 23:39:03 -0400
From: Shridhar Daithankar <ghodechhap@ghodechhap.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unclean shutdown and space cache rebuild
Date: Fri, 05 Jul 2013 09:15:13 +0530
Message-ID: <4656105.EoWWoPheHC@bheem>
In-Reply-To: <14300696.s96c8th5lD@bheem>
References: <11441914.sRzrmH57Vq@bheem> <pan$57f3a$a89b75ab$e2d2d0f4$5964d331@cox.net> <14300696.s96c8th5lD@bheem>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, July 02, 2013 09:19:07 PM Shridhar Daithankar wrote:
> On Tuesday, July 02, 2013 01:00:29 PM Duncan wrote:
> > But I'd still expect there to be some better performance steady state
> > after a few mounts gets the basic filesystem defragged.  Tho if the
> > fileystem is heavily fragmented[2], in practice it may well be easier to
> > backup the filesystem content, do a clean mkfs and mount with autodefrag
> > and restore from backup, thus ensuring autodefrag is on while filling the
> > filesystem in the first place, than to wait for autodefrag to reach a
> > stable system state in normal operation over many mounts.
> 
> well, I think I will bite the bullet and defrag entire / overnight and
> repeat the autodefrag mount option. That should work too.

and that worked. defragged all the mount points including files and dirs, 
enabled autodefrag and reboot. Took about 2 hour to defrag the existing files.

but the filesystem is now extremely smooth. faster than ext4 I might say. sure 
there are occasional stalls but they are more of noticable than annoyance and 
thats pretty much compensated by the significant improvement in latency in 
everything.

fun fact, pg_test_fsync now reports 44 fsyncs per seconds instead of earlier 
20. I don't know if that down to defragmentation or compression.

Also another bigger disk of 500GB, the score is around 24 fsyncs per second. 
So I suspect it has to do with tree size.

anyways, good things overall

thanks for the help and suggestions.


-- 
Regards
 Shridhar
