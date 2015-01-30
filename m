Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55412 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759930AbbA3KCM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 05:02:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YH8Ot-0003sx-FL
	for linux-btrfs@vger.kernel.org; Fri, 30 Jan 2015 11:02:07 +0100
Received: from pd953e675.dip0.t-ipconnect.de ([217.83.230.117])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Jan 2015 11:02:07 +0100
Received: from holger.hoffstaette by pd953e675.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Jan 2015 11:02:07 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Indefinite hang in reserve_metadata_bytes on kernel 3.18.3
Date: Fri, 30 Jan 2015 10:02:01 +0000 (UTC)
Message-ID: <pan.2015.01.30.10.02.01@googlemail.com>
References: <868704D3-B79F-476F-A4CF-33C41274E6D4@opentable.com>
	<54CA06A6.3070108@googlemail.com>
	<3630FFF1-5CE8-4BDD-85BD-A0A1BF671168@opentable.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 29 Jan 2015 22:50:20 +0000, Steven Schlansker wrote:

> Thank you for the suggestion.  I did not find a 3.18.5 presented in any
> form other than as a large number of *.patch files, so I went for
> 3.19-rc6 instead (which I verified has this commit)

3.18.5 is out now but it shouldn't matter, in your case it looks like 
something else is wrong.

> Now I am getting:
> 
> [ 1224.728313] ------------[ cut here ]------------
> [ 1224.728323] kernel BUG at fs/btrfs/extent-tree.c:7362!

That's -ENOMEM in btrfs_alloc_tree_block(), no definite idea what could 
(really) cause that. In any case your first order of business should be 
to get an up-to-date btrfs-progs (= 3.18.2) and see what a check says. 
Your 3.12 is really old.

Another thing that I found helpful is to mount the fs in question at 
least once without the free-space-cache, aka with -o 
clear_cache,nospace_cache options. btrfs tries to detect whether this 
cache is out of sync/corrupted, but I've seen it lead to weird problems 
down the road on rare occasion. So mount the fs without it, maybe do a 
little cleanup/work, cleanly unmount it and then try to remount/work with 
the cache enabled.

If you first created & worked on this fs with 3.13 you may have other yet 
undetected problems lurking.

That's really all I can recommend for now from here. Good luck!

-h

