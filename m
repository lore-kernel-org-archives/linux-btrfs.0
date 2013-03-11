Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62755 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3CKUPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 16:15:49 -0400
Received: by mail-wg0-f48.google.com with SMTP id 16so5257890wgi.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 13:15:48 -0700 (PDT)
From: Remco Hosman <remco@yerf-it.nl>
Content-Type: text/plain; charset=us-ascii
Subject: converting to raid5
Message-Id: <19DDB13F-E8EC-4751-A916-E83555347D7E@hosman.xs4all.nl>
Date: Mon, 11 Mar 2013 21:15:44 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Just installed 3.9.0-rc2 and the latest btrfs-progs. 

filesystem is a 4 disk raid1 array.

first, i did the following: `btrfs val start -dconvert=raid5,usage=1` to convert the mostly empty chunks.
This resulted in a lot of allocated space (10's of gigs), with only a few 100 meg used.
i did `btrfs val start -dusage=75` to clean things up.

then i ran `btrfs bal start -dconvert=raid5,soft`.
I noticed how the difference between total and used for raid5 kept growing. 
My guess is that its taking 1 raid1 chunk (2x1 gig disk space, 1 gig data), and moving it to 1 raid5 chunk (4gig disk space, 3gig data), leaving all chunks 33% used.

This is what 3 calls of `btrfs file df /` looks like a few minutes after each other, with the balance still running:

Data, RAID1: total=807.00GB, used=805.70GB
Data, RAID5: total=543.00GB, used=192.81GB
System, RAID1: total=32.00MB, used=192.00KB
Metadata, RAID1: total=6.00GB, used=3.54GB
--
Data, RAID1: total=800.00GB, used=798.70GB
Data, RAID5: total=564.00GB, used=199.30GB
System, RAID1: total=32.00MB, used=192.00KB
Metadata, RAID1: total=6.00GB, used=3.53GB
--
Data, RAID1: total=795.00GB, used=793.70GB
Data, RAID5: total=579.00GB, used=204.81GB
System, RAID1: total=32.00MB, used=192.00KB
Metadata, RAID1: total=6.00GB, used=3.54GB


Remco