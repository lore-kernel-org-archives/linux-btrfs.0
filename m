Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mirapoint3.brutele.be ([212.68.199.148]:59934 "EHLO
	mirapoint3.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaAJEFw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 23:05:52 -0500
Message-ID: <52CF7032.3090004@oma.be>
Date: Fri, 10 Jan 2014 04:59:46 +0100
From: Peter van Hoof <p.vanhoof@oma.be>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: backpointer mismatch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am using btrfs for my backup RAID. This had been running well for 
about a year. Recently I decided the upgrade the backup server to 
openSUSE 13.1. I checked all filesystems before the upgrade and 
everything was clean. I had several attempts at upgrading the system, 
but all failed (the installation of some rpm would hang indefinitely). 
So I aborted the installation and reverted the system back to openSUSE 
12.3 (with a custom-installed 3.9.7 kernel). Unfortunately, after this 
the backup RAID reported lots of errors.

When I run btrfsck on the filesystem, I get around 1.3M of these messages:

Extent back ref already exists for 1116254208 parent 11145490432 root 0

and around 1.2M of these:

ref mismatch on [90670907392 4096] extent item 11, found 12
Incorrect global backref count on 90670907392 found 11 wanted 12
backpointer mismatch on [90670907392 4096]

Filtering these out, this is the remaining output:

checking extents
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/md2
UUID: 0b6a9d0d-e501-4a23-9d09-259b1f5b5652
found 2213988384746 bytes used err is 0
total csum bytes: 3185850148
total tree bytes: 42770862080
total fs tree bytes: 36787625984
total extent tree bytes: 1643925504
btree space waste bytes: 12475940633
file data blocks allocated: 5269432860672
  referenced 5254870626304
Btrfs v3.12+20131125

(this version of btrfsck comes from openSUSE factory).

I also ran btrfs scrub on the file system. This uncovered 4 checksum 
errors which I could repair manually. I do not know if that is related 
to the problem above. At least it didn't solve it...

The btrfs file system is installed on top of an mdadm RAID5.

How worried should I be about the reported errors? What confuses me is 
that in the end btrfsck reports an error count of 0.

Should I try to repair this? I have had bad experiences in the past with 
"btrfsck --repair", but that was with a much older version...

I can of course recreate the backups, but this would take a long time 
and I would loose my entire snapshot history which I would rather avoid...


Cheers,

Peter.

-- 
Peter van Hoof
Royal Observatory of Belgium
Ringlaan 3
1180 Brussel
Belgium
http://homepage.oma.be/pvh
