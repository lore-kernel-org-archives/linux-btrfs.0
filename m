Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43373 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbaHFJn1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Aug 2014 05:43:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XExkj-0007vG-9f
	for linux-btrfs@vger.kernel.org; Wed, 06 Aug 2014 11:43:25 +0200
Received: from 195.167.52.143 ([195.167.52.143])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Aug 2014 11:43:25 +0200
Received: from tmjuju by 195.167.52.143 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Aug 2014 11:43:25 +0200
To: linux-btrfs@vger.kernel.org
From: TM <tmjuju@yahoo.com>
Subject: Recovering a 4xhdd RAID10 file system with 2 failed disks
Date: Wed, 6 Aug 2014 09:43:05 +0000 (UTC)
Message-ID: <loom.20140806T113805-883@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Recovering a 4xhdd RAID10 file system with 2 failed disks

Hi all,

  Quick and Dirty:
  4disk RAID10 with 2 missing devices, mounts as degraded,ro ,  readonly
scrub ends with no errors
  Recovery options:
  A/ If you had at least 3 hdds, you could replace/add a device
  B/ If you only have 2 hdds, even if scrub ro is ok, 
 you cannot replace/add a device
  So I guess the best option is:
  B.1/ create a new RAID0 filesystem , copy data over to the new filesystem,
 move the old drives to the new filesystem, re-balance the system as RAID10.
  B.2/ any other ways to recover I am missing ? anything easier/faster ?


  Long story:
  A couple of weeks back I had a failed hdd in a RAID10 4disk btrfs.
  I added a new device, removed the failed, but three days later after the
recovery, I ended up with another 2 failing disks.
  So I physically removed the failing 2 disks from the drive bays. 
  (sent one back to Seagate for replacement, the other one I kept it and
will send it later)
  (please note I do have a backup)

  Good thing is that the two drives I have left in this RAID10 , seem to
hold all data and data seems ok according to a read-only scrub.
  The remaining 2 disks from the RAID can be mounted with –o degraded,ro
  I did a read-only scrub on the filesystem (while mounted as –o
degraded,ro) and scrub ended with no errors. 
  I hope this ro scrub is 100% validation that I have not lost any files,
and all files are ok. 

  Just today I *tried* to inserted a new disk, and add it to the RAID10 setup.
  If I mount the filesystem as degraded,ro I cannot add a new device (btrfs
device add). And I cannot replace a disk (btrfs replace –r start).
  That is because the filesystem is mounted not only as degraded but as
read-only.
  But a two disk RAID10, can only be mounted as ro.
  This is by design
gitorious.org/linux-n900/linux-n900/commit
/bbb651e469d99f0088e286fdeb54acca7bb4ad4e
  
  But again, a RAID10 system should be recoverable somehow if the data is
all there but half of the disks are missing. 
(Ie. the raid0 data is there and only the raid1 part is missing. The
striped volume is ok, the mirror data is missing)
  If it was an ordinary RAID10 , replacing the two mirror disks at the same
time should be acceptable and the RAID should be recoverable.

  Myself I am lucky , since I still have one of the old failing disks in my
hands. (the other one is being RMAd currently)
  I can insert the old failing disk and mount the file system as degraded
(but not ro), and then run a btrfs replace or btrfs device add.

  But in case I did not have the old failing disk in my hands, or if the
disk was damaged beyond recognition/repair (eg not recognized in BIOS),
  as far as I understand it is impossible to add/replace drives in a file
system mounted as read-only.

  Am I missing something ?
  Is there a better and faster way to recover a RAID10 when only the striped
data is there but not the mirror data?

Thanks in advance,
TM


