Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56332 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbbETGpx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 02:45:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YuxlH-0007B3-LJ
	for linux-btrfs@vger.kernel.org; Wed, 20 May 2015 08:45:51 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2015 08:45:51 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2015 08:45:51 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs and integration with GNU ++
Date: Wed, 20 May 2015 06:45:46 +0000 (UTC)
Message-ID: <pan$8ff95$312d4182$ef2f2f68$85c7080f@cox.net>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
	<pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
	<1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
	<5559D3D7.4020405@gmail.com>
	<229772989.47330.1432055382498.JavaMail.zimbra@karlsbakk.net>
	<CAJCQCtRdQMt9w0svBGnWU0t8AbWEJ=s7i_z7namCXK_u5A4Brw@mail.gmail.com>
	<555B91D0.2060609@redhat.com>
	<CAJCQCtSENLFXdBAxTRe74prRpqyHi5wCoy4--Y-Zr4SFA_YHBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 19 May 2015 14:04:56 -0600 as excerpted:

> On Tue, May 19, 2015 at 1:41 PM, Eric Sandeen <sandeen@redhat.com>
> wrote:
>> On 5/19/15 1:09 PM, Chris Murphy wrote:
>>> Also, those CentOS/RHEL 7 kernels are old by Btrfs standards.
>>> [U]se XFS instead with those 3.10.x kernels.
>>
>> FWIW, I have been keeping the btrfs codebase in RHEL7 as up to date as
>> possible, given release frequency constraints.
>>
>> The kernel is based on 3.10, but the btrfs code is much newer.
> 
> That's good to know. Thanks for that!

Indeed good to know.

I'd say it's common knowledge that RHEL backports major bits of 
functionality from newer kernels such that for RHEL kernels the reported 
version isn't a reliable indicator of the age of the code in question 
against mainstream, but this is the first I've seen confirming 
specifically that btrfs is one such newer-code subsystem, such that for 
RHEL/CentOS users we should be able to quit pressing kernel upgrades so 
hard.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

