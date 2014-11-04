Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32862 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaKDVo7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 16:44:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XlluM-0002He-3H
	for linux-btrfs@vger.kernel.org; Tue, 04 Nov 2014 22:44:58 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Nov 2014 22:44:58 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Nov 2014 22:44:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: filesystem corruption
Date: Tue, 4 Nov 2014 21:44:46 +0000 (UTC)
Message-ID: <pan$5a988$381c090b$5147d3c1$4b56cdfe@cox.net>
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com>
	<CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com>
	<CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com>
	<CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com>
	<5455B7E7.3020404@pobox.com>
	<1C1C5F8B-DD79-4E4B-A530-D98DABA53E74@colorremedies.com>
	<20141103034337.GM17395@hungrycats.org>
	<935F962F-7DD6-4C18-88F3-65EF614B80E4@colorremedies.com>
	<20141104043130.GN17395@hungrycats.org>
	<BCBD4D38-1631-418A-8F3B-16497BDEB300@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 04 Nov 2014 11:28:39 -0700 as excerpted:

>> It needs to be more than a sequential number.  If one of the disks
>> disappears we need to record this fact on the surviving disks, and also
>> cope with _both_ disks claiming to be the "surviving" one.
> 
> I agree this is also a problem. But the most common case is where we
> know that sda generation is newer (larger value) and most recently
> modified, and sdb has not since been modified but needs to be caught up.
> As far as I know the only way to do that on Btrfs right now is a full
> balance, it doesn't catch up just be being reconnected with a normal
> mount.

I thought it was a scrub that would take care of that, not a balance?

(Maybe do both to be sure?)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

