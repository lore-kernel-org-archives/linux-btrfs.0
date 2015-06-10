Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43437 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbbFJD6m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jun 2015 23:58:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z2X9y-0005fX-Vr
	for linux-btrfs@vger.kernel.org; Wed, 10 Jun 2015 05:58:39 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2015 05:58:38 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2015 05:58:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: rw-mount-problem after raid1-failure
Date: Wed, 10 Jun 2015 03:58:33 +0000 (UTC)
Message-ID: <pan$cff9$37e01034$74a19930$1abaea06@cox.net>
References: <2227931.EqpnWnc32X@malu-aspire-v3-771>
	<557790A9.3080705@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain posted on Wed, 10 Jun 2015 09:19:37 +0800 as excerpted:

> On 06/09/2015 01:10 AM, Martin wrote:
>> Hello!
>>
>> I have a raid1-btrfs-system (Kernel 3.19.0-18-generic, Ubuntu Vivid
>> Vervet, btrfs-tools 3.17-1.1). One disk failed some days ago. I could
>> remount the remaining one with "-o degraded". After one day and some
>> write-operations (with no errrors) I had to reboot the system. And now
>> I can not mount "rw" anymore, only "-o degraded,ro" is possible.
>>
>> In the kernel log I found BTRFS: too many missing devices, writeable
>> mount is not allowed.
>>
>> I read about https://bugzilla.kernel.org/show_bug.cgi?id=60594 but I
>> did no conversion to a single drive.
>>
>> How can I mount the disk "rw" to remove the "missing" drive and add a
>> new one?
>> Because there are many snapshots of the filesystem, copying the system
>> would be only the last alternative ;-)
> 
> How many disks you had in the RAID1. How many are failed ?

The answer is (a bit indirectly) in what you quoted.  Repeating:

>> One disk failed[.] I could remount the remaining one[.]

So it was a two-device raid1, one failed device, one remaining, unfailed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

