Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47912 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2GWGmJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jul 2012 02:42:09 -0400
Received: from [173.11.111.150] (port=34153 helo=gandalfthegreat.merlins.org)
	by mail1.merlins.org with esmtpa (Exim 4.77 #2)
	id 1StCLI-00083u-Q7 by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Jul 2012 23:42:08 -0700
Received: from merlin by gandalfthegreat.merlins.org with local (Exim 4.77)
	(envelope-from <merlin@gandalfthegreat.merlins.org>)
	id 1StCLD-0001rG-NG
	for linux-btrfs@vger.kernel.org; Sun, 22 Jul 2012 23:42:03 -0700
Date: Sun, 22 Jul 2012 23:42:03 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: How can btrfs take 23sec to stat 23K files from an SSD?
Message-ID: <20120723064202.GB6931@merlins.org>
References: <20120202124241.GW16796@shiny>
 <20120718220446.GB3888@merlins.org>
 <20120722185848.GA10089@merlins.org>
 <201207222135.11159.Martin@lichtvoll.de>
 <20120202124241.GW16796@shiny>
 <20120718220446.GB3888@merlins.org>
 <20120722185848.GA10089@merlins.org>
 <201207222135.11159.Martin@lichtvoll.de>
 <20120722204428.GC3925@merlins.org>
 <20120722224145.GC12951@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120722224145.GC12951@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just realized that the older thread got a bit confusing, so I'll keep
problems separate and make things simpler :)

On an _unencrypted_ partition on the SSD, running du -sh on a directory
with 15K files, takes 23 seconds on unencrypted SSD and 4 secs on
encrypted spinning drive, both with a similar btrfs filesystem, and 
the same kernel (3.4.4).

Unencrypted btrfs on SSD:
gandalfthegreat:~# mount -o compress=lzo,discard,nossd,space_cache,noatime /dev/sda2 /mnt/mnt2
gandalfthegreat:/mnt/mnt2# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
514M	src
real	0m22.667s

Encrypted btrfs on spinning drive of the same src directory:
gandalfthegreat:/var/local# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
514M	src
real	0m3.881s

I've run this many times and get the same numbers.
I've tried deadline and noop on /dev/sda (the SSD) and du is just as slow.  

I also tried with:
- space_cache and nospace_cache
- ssd and nossd
- noatime didn't seem to help even though I was hopeful on this one.

In all cases, I get:
gandalfthegreat:/mnt/mnt2# echo 3 > /proc/sys/vm/drop_caches; time du -sh src
514M	src
real	0m22.537s


I'm having the same slow speed on 2 btrfs filesystems on the same SSD.
One is encrypted, the other one isnt:
Label: 'btrfs_pool1'  uuid: d570c40a-4a0b-4d03-b1c9-cff319fc224d
	Total devices 1 FS bytes used 144.74GB
	devid    1 size 441.70GB used 195.04GB path /dev/dm-0

Label: 'boot'  uuid: 84199644-3542-430a-8f18-a5aa58959662
	Total devices 1 FS bytes used 2.33GB
	devid    1 size 25.00GB used 5.04GB path /dev/sda2

If instead of stating a bunch of files, I try reading a big file, I do get speeds
that are quite fast (253MB/s and 423MB/s).

22 seconds for 15K files on an SSD is super slow and being 5 times
slower than a spinning disk with the same data.
What's going on?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
