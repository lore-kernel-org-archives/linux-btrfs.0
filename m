Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46699 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbbBXPlC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 10:41:02 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YQHbV-0004a4-Rc
	for linux-btrfs@vger.kernel.org; Tue, 24 Feb 2015 16:40:58 +0100
Received: from netz.smurf.noris.de ([213.95.21.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 16:40:57 +0100
Received: from matthias by netz.smurf.noris.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 16:40:57 +0100
To: linux-btrfs@vger.kernel.org
From: Matthias Urlichs <matthias@urlichs.de>
Subject: Read performance problem
Date: Tue, 24 Feb 2015 15:40:46 +0000 (UTC)
Message-ID: <loom.20150224T161600-840@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is 3.19, scanning an otherwise-idle filesystem on otherwise-idle disks,
mounted with noatime and nodatasum.

11:41:51.703418 llistxattr("cpool/0/0/5/00556827384267bee22ab9adfb891807",
"", 1024) = 0 <0.000018>
11:41:51.703472 lstat("cpool/0/0/5/00524ed0f6edbadd2a92f9366bce00c4",
{st_mode=S_IFREG|0640, st_size=1024, ...}) = 0 <0.002519>
11:41:51.706044 getxattr("cpool/0/0/5/00524ed0f6edbadd2a92f9366bce00c4",
"system.posix_acl_access", 0x7fff32f63090, 132) = -1 ENODATA (No data
available) <0.000028>
11:41:51.706125 stat("cpool/0/0/5/00524ed0f6edbadd2a92f9366bce00c4",
{st_mode=S_IFREG|0640, st_size=1024, ...}) = 0 <0.000016>
11:41:51.706170 llistxattr("cpool/0/0/5/00524ed0f6edbadd2a92f9366bce00c4",
"", 1024) = 0 <0.000016>

11:41:51.706218 lstat("cpool/0/0/5/0056f3e500258614f19569d7dc014c80",
{st_mode=S_IFREG|0640, st_size=351, ...}) = 0 <0.214911>

11:41:51.921209 getxattr("cpool/0/0/5/0056f3e500258614f19569d7dc014c80",
"system.posix_acl_access", 0x7fff32f63090, 132) = -1 ENODATA (No data
available) <0.000023>
11:41:51.921294 stat("cpool/0/0/5/0056f3e500258614f19569d7dc014c80",
{st_mode=S_IFREG|0640, st_size=351, ...}) = 0 <0.000008>
11:41:51.921342 llistxattr("cpool/0/0/5/0056f3e500258614f19569d7dc014c80",
"", 1024) = 0 <0.000018>
11:41:51.921397 lstat("cpool/0/0/5/0058f2c720f7567989a0f4d33e5c8eb4",
{st_mode=S_IFREG|0640, st_size=65, ...}) = 0 <0.007500>
11:41:51.928959 getxattr("cpool/0/0/5/0058f2c720f7567989a0f4d33e5c8eb4",
"system.posix_acl_access", 0x7fff32f63090, 132) = -1 ENODATA (No data
available) <0.000027>


0.2sec is not the longest delay I've seen here.

iotop says:
                                                             
 7977 be/4 root      115.70 K/s    0.00 B/s  0.00 % 99.95 % rsync -aPHAX
backup/backuppc/. /d/backup/backuppc/
 7259 be/4 root      160.07 K/s  586.40 K/s  0.00 % 99.14 % [btrfs-transacti]

OK. So how can this even happen when there is no writing process here? And
what's the hold-up anyway, given that the partition easily sustains >20
MByte/s write speed? The kernel thread is in 'D' state whenever I run "ps"
and causes at most 2% of CPU load.

https://bugzilla.kernel.org/show_bug.cgi?id=93801

