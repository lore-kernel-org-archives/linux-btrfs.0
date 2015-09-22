Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51779 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520AbbIVFMK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 01:12:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZeFs7-0006HR-Rk
	for linux-btrfs@vger.kernel.org; Tue, 22 Sep 2015 07:12:08 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 07:12:07 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 07:12:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1 storage server won't boot with one disk missing
Date: Tue, 22 Sep 2015 05:12:01 +0000 (UTC)
Message-ID: <pan$24a4a$564d0ff7$8aab1bdc$6a9e65ab@cox.net>
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
	<55FAD9CC.5060206@oracle.com>
	<pan$5cdb2$42505f02$e2b552bf$4a4e51e@cox.net>
	<CA+WRLO94UekKmT1cy3+t4+pHSCMj=HRoEF4oqtJDimS=EWnbhA@mail.gmail.com>
	<m49fv27cxyc.fsf@coffee.modeemi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Erkki Seppala posted on Mon, 21 Sep 2015 23:35:39 +0300 as excerpted:

> Gareth Pye <gareth@cerberos.id.au> writes:
> 
>> People tend to be looking at BTRFS for a guarantee that data doesn't
>> die when hardware does. Defaults that defeat that shouldn't be used.
> 
> However, data is no more in danger at startup than it is at the moment
> when btrfs notices a drive dropping, yet it permits IO to proceed. Is
> there not a contradiction?

The problem at runtime is that btrfs _doesn't_ really notice a device 
dropping.  It simply continues writing to the existing devices, and 
buffering the data for the now missing device.  The block device 
management parts of the kernel know it's missing (the device node will 
disappear from devtmpfs, etc), but the btrfs part carries on, oblivious.

At mount, however, btrfs notices (since it must as it's trying to 
assemble the filesystem at that point), and refuses to mount without the 
degraded option if there's too many devices missing.

I'd argue that noticing the problem and requiring admin intervention to 
avoid risk to the data is a feature, not a misfeature, and that the 
runtime behavior is therefore ultimately a lacking feature, ultimately a 
bug which should be fixed, while you seem to be arguing that carrying on 
oblivious is the feature, and requiring admin intervention when there's a 
risk to data is a misfeature, ultimately a bug that should be fixed.

=:^\

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

