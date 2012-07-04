Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44221 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2GDFF4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 01:05:56 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1SmHml-0006tq-MH
	for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2012 22:05:55 -0700
Date: Tue, 3 Jul 2012 22:05:55 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 3.4.4: BUG: Bad rss-counter state x
Message-ID: <20120704050555.GB6807@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since I heard absolutely nothing on my last but and corruption report, I'm
not sure if they are useful or wanted (please let me know).

The last thing I've seen with 3.4.4 is this:
kernel: [116130.309667] btrfs: unlinked 25 orphans
kernel: [117951.440823] BUG: Bad rss-counter state mm:ffff8801e2a4c080 idx:1 val:-1
kernel: [117951.440832] BUG: Bad rss-counter state mm:ffff8801e2a4c080 idx:2 val:1
kernel: [119720.558186] btrfs: unlinked 12 orphans

Please let me know if you need other info and how bad this 'BUG' is (i.e. do
I need to go back from backup?).
Also, can I tell which partition/btrfs pool was affected?

gandalfthegreat:~# btrfs fi show
Label: 'btrfs_pool2'  uuid: 2d17a045-aaa2-414f-9ef4-de671ae06fae
	Total devices 1 FS bytes used 219.75GB
	devid    1 size 872.51GB used 410.04GB path /dev/dm-1

Label: 'btrfs_pool1'  uuid: 873d526c-e911-4234-af1b-239889cd143d
	Total devices 1 FS bytes used 186.58GB
	devid    1 size 231.02GB used 231.02GB path /dev/dm-0


Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
