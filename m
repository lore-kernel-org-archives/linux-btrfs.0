Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52811 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757757Ab2JZJCm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 05:02:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TRfoX-0006uh-63
	for linux-btrfs@vger.kernel.org; Fri, 26 Oct 2012 11:02:49 +0200
Received: from cpc2-with5-2-0-cust470.1-4.cable.virginmedia.com ([81.97.59.215])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 11:02:49 +0200
Received: from samtygier by cpc2-with5-2-0-cust470.1-4.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 11:02:49 +0200
To: linux-btrfs@vger.kernel.org
From: sam tygier <samtygier@yahoo.co.uk>
Subject: Re: problem replacing failing drive
Date: Fri, 26 Oct 2012 10:02:31 +0100
Message-ID: <508A51A7.30707@yahoo.co.uk>
References: <k632c9$3df$1@ger.gmane.org>,<k6c9ct$tb5$1@ger.gmane.org> <COL002-W72E3D3908E97F64D9F1866B07F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <COL002-W72E3D3908E97F64D9F1866B07F0@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/10/12 22:37, Kyle Gates wrote:
>> On 22/10/12 10:07, sam tygier wrote:
>>> hi,
>>>
>>> I have a 2 drive btrfs raid set up. It was created first with a single drive, and then adding a second and doing
>>> btrfs fi balance start -dconvert=raid1 /data
>>>
>>> the original drive is showing smart errors so i want to replace it. i dont easily have space in my desktop for an extra disk, so i decided to proceed by shutting down. taking out the old failing drive and putting in the new drive. this is similar to the description at
>>> https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Replacing_Failed_Devices
>>> (the other reason to try this is to simulate what would happen if a drive did completely fail).
>>
>> If i reconnect the failing drive then I can mount the filesystem with no errors, a quick glance suggests that the data is all there.
>>
>> Label: 'bdata' uuid: 1f07081c-316b-48be-af73-49e6f76535cc
>> Total devices 2 FS bytes used 2.50TB
>> devid 2 size 2.73TB used 2.73TB path /dev/sde1 <-- this is the drive that i wish to remove
>> devid 1 size 2.73TB used 2.73TB path /dev/sdd2
>>
>> sudo btrfs filesystem df /mnt
>> Data, RAID1: total=2.62TB, used=2.50TB
>> System, DUP: total=40.00MB, used=396.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=112.00GB, used=3.84GB
>> Metadata: total=8.00MB, used=0.00
>>
>> is the failure to mount when i remove sde due to it being dup, rather than raid1?
> 
> Yes, I would say so.
> Try a
> btrfs balance start -mconvert=raid1 /mnt
> so all metadata is on each drive.

Thanks
btrfs balance start -mconvert=raid1 /mnt
did the trick. It gave "btrfs: 9 enospc errors during balance" errors the first few times i ran it, but got there in the end (smaller number of errors each time). the volume is pretty full, so i'll forgive it, (though is "Metadata, RAID1: total=111.84GB, used=3.83GB" a reasonable ratio?).

i can now successfully remove the failed device and mount the filesystem in degraded mode.

It seems like the system blocks get convert automatically.

i have added an example for how to do this at https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Adding_New_Devices

Thanks,
Sam

