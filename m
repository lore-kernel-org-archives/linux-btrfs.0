Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59810 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966688AbcAZQvU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 11:51:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aO6pn-00044r-9B
	for linux-btrfs@vger.kernel.org; Tue, 26 Jan 2016 17:51:15 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 17:51:15 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 17:51:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: uknown issues - different sha256 hash - files corruption
Date: Tue, 26 Jan 2016 16:51:02 +0000 (UTC)
Message-ID: <pan$63dba$aa63be34$a52be773$95f4b6bc@cox.net>
References: <CAAcrkYJRzvmwdVVYLJ_+LAob=tGQrW3=R7hDfbU_jE3kaD+Kxw@mail.gmail.com>
	<CAA7pwKNoYVUYT6QzGQxiz6jW9zEPvp6DjRxBPun6Z+SpDcuUjg@mail.gmail.com>
	<CAAcrkY+3w--OGYWwben+KYohdqwBBryDn8REJ6tiBk4jM3Tp9w@mail.gmail.com>
	<CAA7pwKP6KXHHkp4pALjbxqOFT2ve5T8r0RNcbmdVWXqLmveDgg@mail.gmail.com>
	<CAAcrkYJKoooUWOOsbqXot=U4voe+V_8iMf1NODbjUqMdn6g0Hg@mail.gmail.com>
	<CAPmG0jahDyaHhh1dZxS_L=0C27R_4GWtZeaGTrL50Gze4BRtKg@mail.gmail.com>
	<CAAcrkYKpSsC+H0BCM9pk=-S6VBF_qPKXMFswoGsVSUzRdTrKBg@mail.gmail.com>
	<CAA7pwKM+OZoF7v3Xq=J=KSpidsGsY4hi6TxxkSAKZAJRODCDSg@mail.gmail.com>
	<CAAcrkYJZnrFZKaEQQi6p48KHcGhkQh0LB_eC7xGAcNgFeLfTHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Smith posted on Tue, 26 Jan 2016 15:32:21 +0100 as excerpted:

> i finished with testing and corruption (different hashes) happens only
> from lvm -> to btrfs, lvm -> lvm.
> 
> Also i count sha256 on the same file on lvm 3x and i got 3 different
> hashes.
> 
> Is it still hw issue or bug in LVM/ext4?

That does seem to clear btrfs, but it could be either ext4 or lvm, or 
under the lvm at the physical volume level, and hardware is still a 
possibility as well, tho rather less likely, as btrfs likely stresses the 
hardware more than lvm or ext4.

The next question is whether it's the ext4 or lvm layer.  There are two 
ways to test it that I can think of.

One would be to run an sha256 hash test directly on the logical volume 
the filesystem is normally created on (with the lvm assembled in read-
only mode and/or without the filesystem on top of it mounted or mounted 
read-only).  Does that return the same hash when run multiple times?

Obviously the problem there is the size of the logical volume; getting a 
hash of the entire raw volume is likely to take some time.  But this 
should be the best test as it eliminates the filesystem from the equation 
entirely.

Another alternative would be trying some filesystem other than ext4 on 
the logical volume, say btrfs, xfs or reiserfs.

Either way, if the errors remain without ext4 being in the picture, 
either because you're hashing the raw device or because you're using some 
other filesystem, then that pretty well clears ext4.  If the errors go 
away, then heading to the ext4 list would probably be best, as ext4 would 
seem to be the culprit.

If there's still errors at the logical volume device level, then the next 
question is whether they appear on the raw physical volumes that the 
logical volume is assembled out of, or not.  Again, I'd suggest hashing 
the raw devices repeatedly and see if they return the same hashes each 
time.  If not, then it's likely either the hardware or the device driver, 
and you'd contact the device driver maintainer.  (Here, I'd probably file 
a bug on kernel bugzilla, YMMV.)  If the raw physical devices hash 
consistently while the LVM logical volume doesn't, then it's time to 
contact the LVM folks.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

