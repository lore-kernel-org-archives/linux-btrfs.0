Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [37.247.8.11] ([37.247.8.11]:57712 "EHLO mail.southpole.se"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2KFNYA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 08:24:00 -0500
Message-ID: <50990F6E.2090309@southpole.se>
Date: Tue, 06 Nov 2012 14:23:58 +0100
From: Kenneth Johansson <kenneth@southpole.se>
MIME-Version: 1.0
To: Kyle Gates <kylegates@hotmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: no space left on device.
References: <50927A9E.70106@southpole.se> <COL002-W179CC749A18F35284E4D01B0670@phx.gbl>
In-Reply-To: <COL002-W179CC749A18F35284E4D01B0670@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/2012 04:54 PM, Kyle Gates wrote:
>> So I have ended up in a state where I can't delete files with rm.
>>
>> the error I get is no space on device. however I'm not even close to empty.
>> /dev/sdb1 38G 27G 9.5G 75%
>> there is about 800k files/dirs in this filesystem
>>
>> extra strange is that I can in another directory create and delete files.
>>
>> So I tried pretty much all I could google my way to but problem
>> persisted. So I decided to do a backup and a format. But when the backup
>> was done I tried one more time and now it was possible to delete the
>> directory and all content?
>>
>> using the 3.5 kernel in ubuntu 12.10. Is this a known issue ? is it
>> fixed in later kernels?
>>
>> fsck /btrfs scrub and kernel log. nothing indicate any problem of any kind.
>>
> First let's see the output of:
> btrfs fi df /mountpoint
>
> You're probably way over allocated in metadata so a balance should help:
> btrfs bal start -m /mountpoint
> or omit the -m option to run a full balance. 		
I had to use the disk for work so I could not be stuck in that situation 
and thus had to nuke the disk.
maybe I can recreate the state I put back mostly the same data again 
minus some stuff I did not really need.

So under what circumstance can this actually happen ? why could I 
remove/add files in one directory and not another? its the same 
partition. And also the filesystem was just a few days old and no 
snapshots or anything, well I do use lzo compression but other than that 
default values was used to create it.



