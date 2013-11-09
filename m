Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:32828 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756750Ab3KIUSQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Nov 2013 15:18:16 -0500
Received: from c-68-35-125-242.hsd1.nm.comcast.net ([68.35.125.242]:49504 helo=[192.168.1.140])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VfEz1-001tuK-Cm
	for linux-btrfs@vger.kernel.org; Sat, 09 Nov 2013 13:18:15 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs subvolume list: what is the meaning of "top level"
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <527E7A99.2070207@inwind.it>
Date: Sat, 9 Nov 2013 13:18:14 -0700
Message-Id: <35C9C3FD-BB32-4D8E-ADDA-1A5E23923442@colorremedies.com>
References: <527E7A99.2070207@inwind.it>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 9, 2013, at 11:10 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> 
>     1	ID 256 gen 5 top level 5 path sub1
>     2	ID 257 gen 6 top level 5 path dir/sub2
>     3	ID 258 gen 8 top level 5 path dir/sub3
>     4	ID 259 gen 8 top level 5 path dir/sub3/sub4
>     5	ID 260 gen 10 top level 5 path sub5
>     6	ID 261 gen 10 top level 5 path sub5/sub6

> 
> 
> I expected that in the line 4, the top level should be 258; the same for
> the line 6: top level should be 260. So my question is: what is the
> meaning of the "top level" value ?

If you mount -o subvol=sub5 and then create a new subvolume, and then do a listing, you'll see something like what you describe. It would look something like:

6	ID 262 gen 4 top level 260 path sub6

The "top level" is in a sense a prefix. So top level 5 means there is no prefix, the path listed is the full path. Whereas if the top level is e.g. 260, the implied prefix is sub5/.

If you were to mount subvolid=259 and create a subvolume in at the root of the mountpoint, then do a subvolume listing, it would be listed with top level 259 and a path of merely "newname" rather than dir/sub3/sub4/newname.

So just consider the top level a prefix for the listed path, and if the top level is 5, there is no prefix for path, the path is the full path.


Chris Murphy