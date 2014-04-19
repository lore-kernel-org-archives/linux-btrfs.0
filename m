Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58749 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbaDSCgP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 22:36:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WbL8W-0005iI-MN
	for linux-btrfs@vger.kernel.org; Sat, 19 Apr 2014 04:36:12 +0200
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Apr 2014 04:36:12 +0200
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Apr 2014 04:36:12 +0200
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: Fixing a degraded RAID
Date: Fri, 18 Apr 2014 22:36:00 -0400
Message-ID: <87y4z2avvz.fsf@maru2.md5i.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a disk in my RAID0 die:

  root@maru2:~# /usr/local/src/btrfs-progs/btrfs fi show 8c530f6f-7592-4d57-854d-1fae33ae7cb6
  Label: none  uuid: 8c530f6f-7592-4d57-854d-1fae33ae7cb6
          Total devices 3 FS bytes used 329.66GiB
          devid    1 size 1.79TiB used 357.03GiB path /dev/sdd1
          devid    3 size 931.51GiB used 178.00GiB path /dev/sdf
          *** Some devices missing
  
  Btrfs v3.12-43-gc2081e2-dirty

So, I try to mount it with -o degraded.  That fails, implying that a
degraded mount needs to be read-only.  So I successfully mount it read
only.  Then I want to add a new disk to replace the missing one:

  root@maru2:~# /usr/local/src/btrfs-progs/btrfs dev add /dev/sdg /mnt/
  ERROR: error adding the device '/dev/sdg' - Read-only file system

So I can't add a disk if it's mounted read-only, and can't mount it
read-write?  What am I missing?  What's my way around this?

-- 
Michael Welsh Duggan
(md5i@md5i.com)

