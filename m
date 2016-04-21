Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24564 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbcDUHT6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 03:19:58 -0400
Subject: Re: Question: raid1 behaviour on failure
To: Matthias Bodenbinder <matthias@bodenbinder.de>,
        linux-btrfs@vger.kernel.org
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org> <571784DF.3060800@oracle.com>
 <nf9nm4$204$1@ger.gmane.org>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <57187F0A.8060707@oracle.com>
Date: Thu, 21 Apr 2016 15:19:38 +0800
MIME-Version: 1.0
In-Reply-To: <nf9nm4$204$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/21/2016 01:15 PM, Matthias Bodenbinder wrote:
> Am 20.04.2016 um 15:32 schrieb Anand Jain:
>>> 1. mount the raid1 (2 disc with different size)
>>
>>> 2. unplug the biggest drive (hotplug)
>>
>>    Btrfs won't know that you have plugged-out a disk.
>>    Though it experiences IO failures, it won't close the bdev.
>
> Well, as far as I can tell mdadm can handle this use case. I tested that. I have an mdadm raid5 running. I accidentially unplugged a sata cable from one of the devices and the raid still worked. I did not even notice that the cable was unplugged until a few hours later. Then I plugged in the cable agaib and that was it. mdadm recovered the raid5 without any problem. -> This is redunancy!

  Yep. I meant to say its a bug in btrfs that it won't know
  about the missing device (after mount). Pls do test the hot
  spare patch set it has few first steps (yep not a complete)
  to handle the failed device while FS is mounted.


>>> 3. try to copy something to the degraded raid1
>>
>>    This will work as long as you do _not_ run unmount/mount.
>
> I did not umount the raid1 when I tried to copy something. As you can see from the sequence of events: I removed the drive and immdiately afterwards tried to copy something to the degraded array. This copy failed with a crash of the btrfs module. -> This is NOT redundancy.
>
> The ummount and mount operations are coming afterwards.
>
> In a nutshell I have to say that the btrfs behaviour is by no means compliant with my understanding of redundancy.

  A known issue.
  Your testing / validating of hot spare patch set will help.

Thanks, Anand

