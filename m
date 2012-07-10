Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:51862 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab2GJRz2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 13:55:28 -0400
Message-ID: <4FFC6C89.6030303@libero.it>
Date: Tue, 10 Jul 2012 19:55:21 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Arnd Hannemann <arnd@arndnet.de>
CC: Christian Robert <christian.robert@polymtl.ca>,
        linux-btrfs@vger.kernel.org
Subject: Re: 3.5.0-rc6: btrfs and LVM snapshots -> wrong devicename in /proc/mounts
References: <4FFB59BF.1050104@arndnet.de> <4FFBA1C8.9020502@polymtl.ca> <4FFBED3C.3000302@arndnet.de>
In-Reply-To: <4FFBED3C.3000302@arndnet.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/10/2012 10:52 AM, Arnd Hannemann wrote:
> Hi,
> 
> Am 10.07.2012 05:30, schrieb Christian Robert:
>> I agree with you, but you should never mount a snapshot of a btrfs filesystem at the same time the original is,
>> because both the original and the snapshot had same "device fsid 5c3e8ca2-da56-4ade-9fef-103a6a8a70c2"

I think that the kernel should be smarter in this regard.

At kernel level, as golden rule it should be not possible to add a
duplicate fsid if the previous one is mounted. "btrfs dev scan" MUST
return an error in this case. This in any case is an error.

Today it seems that if a device with the same fsid is already
registered, the new one overwrites the old one (or almost the name is
overwritten). This could be acceptable if the filesystem is unmounted. I
think that it is a serious error otherwise.

>>
>> the kernel will tkink twice and fold back to the same device.
> 
> If that is correct the bug is that the kernel lets me mount the same device fsid on different devices twice.
> 
>>
>> btrsf does not behave like other filesystems, you can't snapshot a btrfs filesystem
>> and hope to mount the snapshot somewhere else.
> 
>> snapsoot also duplicate lots of things internally that have no sence in a snapshot (like raid level, single or multiple devies ...)
> 
> I see. However, I expect a "simple" btrfs to just work or fail gracefully.
> 
> Best regards,
> Arnd
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

