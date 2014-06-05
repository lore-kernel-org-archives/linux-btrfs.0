Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43879 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbaFETyI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 15:54:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wsdjh-0005a4-J4
	for linux-btrfs@vger.kernel.org; Thu, 05 Jun 2014 21:54:05 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 21:54:05 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 21:54:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Very slow filesystem
Date: Thu, 5 Jun 2014 19:53:42 +0000 (UTC)
Message-ID: <pan$95296$7c52a8f8$5f80de1d$977b2dd9@cox.net>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
	<pan$765af$b28af9a8$903ce16b$940baf34@cox.net>
	<CAEezp7sxyEP2Bmp9vWB843pb7VQvWyHmG+1uPU_Dk--hhu2LAw@mail.gmail.com>
	<CAGqmi77dGTaZOT8u=XDMnYnDxhNoWhrhjZtHpD35OB28VvY8YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Timofey Titovets posted on Thu, 05 Jun 2014 19:13:08 +0300 as excerpted:

> 2014-06-05 18:52 GMT+03:00 Igor M <igork20@gmail.com>:
>> One more question. Is there any other way to find out file
>> fragmentation ?
>> I just copied 35Gb file on new btrfs filesystem (compressed) and
>> filefrag reports 282275 extents found. This can't be right ?

> hes, because filefrag show compressed block (128kbite) as one extent.

Correct.  Which is why my original answer had this:

>>> While compression changes things up a bit (filefrag doesn't know 
>>> how to deal with it yet and its report isn't reliable),

I skipped over the "why" at the time as it wasn't necessary for the then-
current discussion, but indeed, the reason is because filefrag counts 
each 128 KiB block as a separate fragment because it doesn't understand 
them, and as a result, it's not (currently) usable for btrfs-compressed 
files.

They (the btrfs, filefrag, and kernel folks) are working on teaching 
filefrag about the problem so it can report correct information, but the 
approach being taken is to setup generic kernel functionality to report 
that information to filefrag, such that other filesystems can use the 
same functionality, which makes it a rather more complicated project than 
a simple one-shot fix for btrfs by itself would be.  So while the problem 
is indeed being actively worked on, it could be some time before we 
actually have a filefrag that's accurate in btrfs-compressed-file 
situations, but once we do, we can be confident the solution is a correct 
one that can be used well into the future by btrfs and other filesystems 
as well, not just a brittle hack of a few minutes to a day that can't be 
used for anything else and that could well break again two kernel cycles 
down the road.

Unfortunately, I know of nothing else that can report that information, 
so the only real suggestion I have is to either turn off compression or 
forget about tracking individual file fragmentation for now and go only 
on performance.

But as it happens, the NOCOW file attribute turns off compression (as 
well as checksumming) for that file anyway, because in-place rewrite 
would otherwise trigger complex issues and race conditions that are a 
risk to the data as well as performance, which is why traditional non-COW 
filesystems don't tend to offer these features in the first place.  
Btrfs' normal COW nature makes these features possible, but as this 
thread already explores, unfortunately simply isn't suitable for certain 
access patterns.

So if the file is properly (that is, at creation) set NOCOW, filefrag 
should indeed be accurate, because the file won't be (btrfs-)compressed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

