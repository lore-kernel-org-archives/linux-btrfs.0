Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42465 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2G0Ek4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jul 2012 00:40:56 -0400
Date: Thu, 26 Jul 2012 21:40:54 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Message-ID: <20120727044054.GA22340@merlins.org>
References: <20120202124241.GW16796@shiny> <20120722224145.GC12951@merlins.org> <20120723064202.GB6931@merlins.org> <201207240956.26495.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201207240956.26495.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 24, 2012 at 09:56:26AM +0200, Martin Steigerwald wrote:
> find is fast, du is much slower:
> 
> merkaba:~> echo 3 > /proc/sys/vm/drop_caches ; time ( find /usr | wc -l )
> 404166
> ( find /usr | wc -l; )  0,03s user 0,07s system 1% cpu 9,212 total
> merkaba:~> echo 3 > /proc/sys/vm/drop_caches ; time ( du -sh /usr )      
> 11G     /usr
> ( du -sh /usr; )  1,00s user 19,07s system 41% cpu 48,886 total
 
You're right.

gandalfthegreat [mc]# time du -sh src
514M	src
real	0m25.159s
gandalfthegreat [mc]# reset_cache 
gandalfthegreat [mc]# time bash -c "find src | wc -l"
15261
real	0m7.614s

But find is still slower the du on my spinning disk for the same tree.
 
> Anyway thats still much faster than your measurements.
 
Right. Your numbers look reasonable for an SSD.

Since then, I did some more tests and I'm also getting slower than normal
speeds with ext4, an indications that it's a problem with the block layer.
I'm working with some folks try to pin down the core problem, but it looks
like it's not an easy one.

Thanks for your data.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
