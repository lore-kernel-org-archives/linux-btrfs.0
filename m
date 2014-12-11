Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35922 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758334AbaLKENi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 23:13:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xyv8C-0003Aw-3P
	for linux-btrfs@vger.kernel.org; Thu, 11 Dec 2014 05:13:36 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 05:13:36 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 05:13:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Date: Thu, 11 Dec 2014 04:13:23 +0000 (UTC)
Message-ID: <pan$9d017$6b6f7730$ca681fe6$b4a6c4a2@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
	<54878210.8030807@pobox.com>
	<CAA7pwKPYwq73m4j-1-rf+-2owEvrDAaUJgxrGaY9uLm16Gs__Q@mail.gmail.com>
	<548839EE.6080404@pobox.com>
	<pan$adbdd$de0c5a95$a95c46aa$74eda7e0@cox.net>
	<5488C8FA.2070405@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Wed, 10 Dec 2014 14:28:10 -0800 as excerpted:

> On 12/10/2014 10:56 AM, Patrik Lundquist wrote:
>> On 10 December 2014 at 14:11, Duncan <1i5t5.duncan@cox.net> wrote:
>>> Assuming no snapshots still contain the file, of course, and that the
>>> ext* saved subvolume has already been deleted.
>>
>> Got no snapshots or subvolumes. Keeping it simple for now.
> 
> Does that mean that you have already manually removed the subvolume that
> was automatically created by btrfs-convert?

Yes, he had.

Patrik correct me if I have this wrong, but filling in the history as I 
believe I have it...

If I'm keeping my cases straight, he had actually posted a thread some 
weeks ago with the initial problem, saying he had followed the conversion 
instructions to the letter -- conversion, delete-saved, defrag, balance, 
and ran into this problem with balance.  The conclusion at that time was 
that he'd try successively larger balance -dusage=N figures, hoping to 
work thru it that way.

That original thread could well have been shortly before you appeared on 
the list, however, and you may not have seen it.  Either that, or you saw 
it but didn't connect that case with this one.

Anyway, yes, assuming I haven't gotten my casefiles mixed up, and 
evidence so far is that I haven't, he did everything he was supposed to 
and still ended up with this issue.  Obviously there's still a bug 
somewhere.

And now he's back.  The incrementally increasing usage= balances reaching 
99%, but that last 1% is the sticking point and he, and the rest of us, 
are trying to figure out what happened and how to get him past it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

