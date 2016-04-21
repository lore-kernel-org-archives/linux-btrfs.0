Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58575 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbcDUFP4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 01:15:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1at6y2-0001oM-31
	for linux-btrfs@vger.kernel.org; Thu, 21 Apr 2016 07:15:54 +0200
Received: from p50908ea2.dip0.t-ipconnect.de ([80.144.142.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 07:15:54 +0200
Received: from matthias by p50908ea2.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 07:15:54 +0200
To: linux-btrfs@vger.kernel.org
From: Matthias Bodenbinder <matthias@bodenbinder.de>
Subject: Re: Question: raid1 behaviour on failure
Date: Thu, 21 Apr 2016 07:15:48 +0200
Message-ID: <nf9nm4$204$1@ger.gmane.org>
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org> <571784DF.3060800@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <571784DF.3060800@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 20.04.2016 um 15:32 schrieb Anand Jain:
>> 1. mount the raid1 (2 disc with different size)
> 
>> 2. unplug the biggest drive (hotplug)
> 
>   Btrfs won't know that you have plugged-out a disk.
>   Though it experiences IO failures, it won't close the bdev.

Well, as far as I can tell mdadm can handle this use case. I tested that. I have an mdadm raid5 running. I accidentially unplugged a sata cable from one of the devices and the raid still worked. I did not even notice that the cable was unplugged until a few hours later. Then I plugged in the cable agaib and that was it. mdadm recovered the raid5 without any problem. -> This is redunancy!


> 
>> 3. try to copy something to the degraded raid1
> 
>   This will work as long as you do _not_ run unmount/mount.
 
I did not umount the raid1 when I tried to copy something. As you can see from the sequence of events: I removed the drive and immdiately afterwards tried to copy something to the degraded array. This copy failed with a crash of the btrfs module. -> This is NOT redundancy.

The ummount and mount operations are coming afterwards.

In a nutshell I have to say that the btrfs behaviour is by no means compliant with my understanding of redundancy.


Matthias



