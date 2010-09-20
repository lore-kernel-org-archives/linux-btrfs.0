From: Dave Cundiff <syshackmin@gmail.com>
Subject: Performance degradation
Date: Mon, 20 Sep 2010 17:24:58 -0400
Message-ID: <AANLkTimhpg22M0UUcfksh1H9oGMweVhwpDvqeu0nfOP0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a btrfs backup system that has been running great. Its been
backing up 6 systems with 500-750 gigs of data using Rsync and
snapshots. Every night I snapshot the backup and overwrite it.
Recently it has been unable to complete the backups. Its running soooo
slow that it can barely finish 1 backup a day. When I first started
backing up the systems they would all complete in at the most 8 hours.
I noticed it started happening after I deleted a large number of
snapshots. This caused the cleaner process to run for a few days.
After it finished the filesystem has still been to slow to use.

I'm running kernel 2.6.36-rc4.

Filesystem was built with -m single -d single and using the compress
mount option.

Block device is an Areca RAID5 with 4 Western Digital 2TB drives.

-- 
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
