Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay01.ispgateway.de ([80.67.31.24]:56730 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbcBCGbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Feb 2016 01:31:14 -0500
Subject: Re: booting from BTRFS works only with one device in the pool
To: Chris Murphy <lists@colorremedies.com>
References: <56AFCEC3.9050803@friedels.name>
 <20160201221120.GD8313@carfax.org.uk> <56B12742.9090101@friedels.name>
 <CAJCQCtS3fQuypTbwTe4=H95rwtN0dMih_nPaBiWUc2s-qE2Xag@mail.gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hendrik Friedel <hendrik@friedels.name>
Message-ID: <56B19EAA.4000702@friedels.name>
Date: Wed, 3 Feb 2016 07:31:06 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS3fQuypTbwTe4=H95rwtN0dMih_nPaBiWUc2s-qE2Xag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
>> I would like to go the sensible way :-)
>> But can you hint me how and where to add the btrfs device scan option to the
>> initramfs?
> If btrfs-progs 4.3.1 is installed already, dracut -f will rebuild the
> initramfs and should just drag in current tools which will include
> 'btrfs device scan'.
>

Yes, 4.3.1 is installed and even in the recovery-mode (i.e. if boot 
fails) btrfs reports version 4.3.1.
Also, in this recovery mode, btrfs dev scan is working. Furthermore, I 
can mount the drive in this recovery mode (which I *suspect* is the 
initramfs).

My understanding is/was, that it is not sufficient that btrfs dev scan 
is available, but also its execution must be triggered.  Is that right?

> Like I said above, just install the distribution's own
> btrfs-progs/btrfs-tools package, and it should do the right thing. You
> may have to tell the distribution to rebuild the initramfs

I have run dracut -f. It does not solve the issue.

 >This is CentOS 7.2 installed to a single VDI file, and then you use
 > 'btrfs dev add' to add another VDI file? I'd like to know how to 
reproduce the conditions
 > so I can figure out what's wrong because it ought to work, seeing as 
it worked for me with
 > Fedora 19 and CentOS 7.x is in the vicinity of Fedora 19/20.

Yes, it is Rockstor (CentOS 7.2  based) installed in the way you mention.

Regards,
Hendrik


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

