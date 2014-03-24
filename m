Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53585 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbaCXTTk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 15:19:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSAPL-000637-J3
	for linux-btrfs@vger.kernel.org; Mon, 24 Mar 2014 20:19:39 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 20:19:39 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 20:19:39 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Cannot add device "is mounted" for unmounted drive that used to
 be in raidset that is mounted
Date: Mon, 24 Mar 2014 19:19:14 +0000 (UTC)
Message-ID: <pan$22ecd$ee1c4b0f$48d0cc59$d02dd1ad@cox.net>
References: <20140323180907.GA22171@merlins.org>
	<20140323185816.GA3732@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 23 Mar 2014 11:58:16 -0700 as excerpted:

> On Sun, Mar 23, 2014 at 11:09:07AM -0700, Marc MERLIN wrote:
>> I found out that a drive that used to be part of a raid system that is
>> mounted and running without it, btrfs apparently decides that the drive
>> is part of the mounted raidset and in use.
>> As a result, I had to eventually dd 0's over it, btrfs device scan, and
>> finally I was able to use it again.
> 
> I filed a bug for this, it's a bit more minor, but worth fixing
> eventually https://bugzilla.kernel.org/show_bug.cgi?id=72771

The reason for this is the device-scanning that btrfs does, detecting 
btrfs superblocks in ordered to assemble filesystems from multiple 
devices, etc.

The canonical method for wiping such superblocks and thus avoiding btrfs 
detecting it as a btrfs filesystem component is to use wipefs, part of 
the util-linux package.  I think it's covered somewhere on the wiki; let 
me see if I can find it...

Yes.  See the problem-FAQ:

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_to_clean_up_old_superblock_.3F

As you'll note, however, it mentions the dd method as a workaround if 
wipefs isn't available, but all you need to wipe is the 8-byte magic 
string. =:^)  (Tho there's three superblocks and while wiping the first 
is generally enough and is all wipefs does, you can wipe the others too 
if you like as well.  There are also instructions for restoring the magic 
string using dd, if it should be come necessary.)





-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

