Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47992 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbcBWR1F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 12:27:05 -0500
Date: Tue, 23 Feb 2016 09:26:35 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>, Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        Alexander Fougner <fougner89@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20160223172635.GI22487@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGGqMYS=O=zzZE2pK=Stx6OwrZn1Fz59oYBS+jbSHfu4Ovv68Q@mail.gmail.com>
 <04df0eaf-9dc8-b9fa-05cb-020507940bed@mokrynskyi.com>
 <pan$9ab32$bee891f3$832766e9$6d69ce8@cox.net>
Subject: Re: Major HDD performance degradation on btrfs receive
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well, since we're on the topic, my backup server btrfs FS has become so
slow that it hangs my system a few seconds here and there and causes
some of my cron jobs to fail.

I'm going to re-create it for a 3 time (in 3 years), adding bcache this
time, but clearly there is a good chance that this filesystem is indeed
going to crap performance wise because all it does is receive btrfs
receive and rsync backups, with snapshot rotations (daily snapshots, and
they expire after a couple of weeks).

I'm currently doing a very slow defrag to see if it'll help (looks like
it's going to take days).
I'm doing this:
for i in dir1 dir2 debian32 debian64 ubuntu dir4 ; do echo $i; time btrfs fi defragment -v -r $i; done

But, just to be clear, is there a way I missed to see how fragmented my
filesystem is without running filefrag on millions of files and parsing
the output?

Label: 'dshelf2'  uuid: d4a51178-c1e6-4219-95ab-5c5864695bfd
        Total devices 1 FS bytes used 4.25TiB
        devid    1 size 7.28TiB used 4.44TiB path /dev/mapper/dshelf2

btrfs fi df /mnt/btrfs_pool2/
Data, single: total=4.29TiB, used=4.18TiB
System, DUP: total=64.00MiB, used=512.00KiB
Metadata, DUP: total=77.50GiB, used=73.31GiB
GlobalReserve, single: total=512.00MiB, used=31.22MiB

Currently, it's btrfs on top of dmcrpyt on top of swraid5

Since I'm about to recreate this after a very slow backup/restore
process, if you have suggestions on how I could better build this
(outside of using a 4.4 kernel this time), they would be appreciated.

Also, should I try running defragment -r from cron from time to time?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
