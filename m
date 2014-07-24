Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47438 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134AbaGXBis (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 21:38:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XA7zZ-0002ua-SQ
	for linux-btrfs@vger.kernel.org; Thu, 24 Jul 2014 03:38:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 03:38:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 03:38:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: feature request: consider rw subvols ro for send when volume is
 mounted ro
Date: Thu, 24 Jul 2014 01:38:32 +0000 (UTC)
Message-ID: <pan$9782b$83bda3f0$b4a4f489$5c1b675f@cox.net>
References: <EAC867F7-CBB2-4714-9917-A29566167A21@colorremedies.com>
	<20140723204736.GD17798@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zach Brown posted on Wed, 23 Jul 2014 13:47:36 -0700 as excerpted:

> On Wed, Jul 23, 2014 at 02:10:29PM -0600, Chris Murphy wrote:
>> The use case is when it's possible to mount a Btrfs volume ro, but not
>> rw. Example, a situation where
>> 
>> # mount -o degraded /dev/sdb /mnt
>> [...] BTRFS: too many missing devices, writeable mount is not allowed 
>> 
>> Yet this works:
>> # mount -o degraded,ro /dev/sdb /mnt
>> 
>> It would be great if it were possible to send/receive subvolumes to a
>> different btrfs volume. Currently it's not possible because those
>> subvols aren't ro, and because the mount is ro I can't make ro
>> snapshots first.

In general, btrfs send/receive is great when it works, but because 
there's still corner-cases like this as well as simply broken send/
receive cases popping up from time to time, I strongly recommend not 
relying on it working, and keeping a more conventional backup option 
(like rsync) tested-working and usable as well.
 
> I wonder if that's as easy as the following totally untested hack.  I
> have no idea if a read-only mount would still allow background
> modification that might violate the send code's assumptions.

Hopefully that hack works.

Meanwhile, AFAIK, yes, there's still cases where a read-only mount can 
still allow background mods that would violate send's assumptions.  Tho I 
don't believe they apply in this case.  But certainly, there has been 
recent discussion on the subvolume mount situation, since it's possible 
to access child subvolumes from writable-mount parent (including root/
id5) subvolumes, and currently nothing stops writing into the read-only-
child's mount from the parent's writable mount.

Even without that situation, however, there's bind-mounts, which start 
out with the same mount options as the original, but with a remount allow 
one of the views to be read-only while the other is writable, regardless 
of the filesystem.  Obviously that allows changing the view on the read-
only side from the writable side.

So while having the ability to do a send from a read-only mount is indeed 
a good thing to have in emergency cases such as this, I'd suggest 
requiring a --force option or the like to enable it, since the full 
immutable-read-only guarantees simply aren't there.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

