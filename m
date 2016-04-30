Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37126 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbcD3L2n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Apr 2016 07:28:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1awT4j-0007Vf-IP
	for linux-btrfs@vger.kernel.org; Sat, 30 Apr 2016 13:28:41 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Apr 2016 13:28:41 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Apr 2016 13:28:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: receive snapshot, complains about missing file
Date: Sat, 30 Apr 2016 11:28:31 +0000 (UTC)
Message-ID: <pan$6f3dc$4726806a$a5dc5eab$10f59711@cox.net>
References: <CAGGqMYQPVQoKDcuDqp0D=3BCD+oTghew0fyzqo58BSLFrmrEJQ@mail.gmail.com>
	<CAJCQCtTG68BicgFwoyYgM0OzphsVbstgWTNybF3CeBo1VCJhNg@mail.gmail.com>
	<CAGGqMYTso0XNjgfmWfY8g3Xs9xym5gHFcTizzAq1_Y-mMTTx0w@mail.gmail.com>
	<CAJCQCtRk+V0vhdCsyi-3aoNDimV0E4XJjQc9Us35uO59HpjSAQ@mail.gmail.com>
	<CAGGqMYSZ8P=ZVSgL4zWJKi7uuYLxRMZh=XEzPYpT2PykQD58oQ@mail.gmail.com>
	<pan$e4ba4$a250943d$4b67b01a$4a6c9e1c@cox.net>
	<CAGGqMYQH7h4-atS+ecBzngBMLu7iRe4-CehjavUAcJMje+v=wA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander Fougner posted on Sat, 30 Apr 2016 12:55:06 +0200 as excerpted:

>>> Receive side only outputs this:
>>> sudo btrfs check -p /dev/sdc Couldn't open file system
>>
>> It wasn't mounted at the time, right?
> 
> Nope
> 
> 
>> Cuz btrfs check won't work with a mounted filesystem.
>>
>> Of course you'll need to be root to access the device as well,
>> but that's pretty much a given.
> 
> I think sudo should do that, right?

Yes.

I wonder then why it couldn't access it?

Just to be sure, since I didn't think to ask the first time and with 
subvolumes it's possible to mount other subvolumes and possibly forget 
that they're actually part of the same filesystem, you didn't have /any/ 
subvolumes of that filesystem mounted, right?

What does btrfs fi show say about the filesystem?

I'm assuming it's mountable.  Does a mount and umount then let it be 
btrfs checked?  On the other end of things, what about a reboot and btrfs 
device scan, then btrfs check?

If it's not the low-hanging fruit like that, perhaps check is keying off 
the same error that receive is, but I haven't the foggiest what the 
problem would be.

I guess another possibility would be that btrfs check is violating some 
sort of security policy such as selinux.  I don't run anything of that 
nature here so know little more about it beyond the possibility, but from 
previous posts I think Chris Murphy has at some experience in that area.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

