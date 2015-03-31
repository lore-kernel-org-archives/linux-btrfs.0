Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35857 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbbCaSMP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 14:12:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yd0dw-00080R-Ma
	for linux-btrfs@vger.kernel.org; Tue, 31 Mar 2015 20:12:04 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 20:12:04 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 20:12:04 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: ERROR: error removing the device '/dev/sdXN' - Inappropriate
 ioctl for device
Date: Tue, 31 Mar 2015 19:11:47 +0100
Message-ID: <mfeo14$sib$1@ger.gmane.org>
References: <mfcdep$d97$1@ger.gmane.org> <20150331173756.GF6821@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20150331173756.GF6821@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 31/03/15 18:37, David Sterba wrote:
> On Mon, Mar 30, 2015 at 09:59:05PM +0100, Martin wrote:
>> btrfs device delete /dev/sdf5 /mnt/data2
>>
>> ERROR: error removing the device '/dev/sdf5' - Inappropriate ioctl for
>> device
> 
> Strange, that would mean that the ioctl number is not handled at all. I
> haven't found any change in device delete on the userspace side. This
> would mean that /mnt/data2 is not mounted. Did you try to do lazy
> unmount?

Nope, that filesystem is still mounted and in use, but still a very good
deduction...

Trying smartmonctl just now on that drive (/dev/sdf) gives errors
suggesting that the drive is no longer responding at all :-(

There is also a steady repeat of:

kernel: sd 7:0:0:0: [sdf] CDB:
kernel: cdb[0]=0x2a: 2a 00 04 02 45 80 00 00 08 00
kernel: sd 7:0:0:0: [sdf] Unhandled error code
kernel: sd 7:0:0:0: [sdf]
kernel: Result: hostbyte=0x04 driverbyte=0x00

(Must watch that lot doesn't fill the log.)


Should I try a:

btrfs device delete missing /mnt/data2

or do I need to unmount or remount first?


... And the system is live and not to be rebooted if at all possible
until the weekend...

Thanks,
Martin

