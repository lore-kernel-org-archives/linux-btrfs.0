Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55462 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744AbbEUOjv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 10:39:51 -0400
Message-ID: <555DEE34.9050702@gmx.de>
Date: Thu, 21 May 2015 16:39:48 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: Calvin Walton <calvin.walton@kepstin.ca>
CC: linux-btrfs@vger.kernel.org
Subject: Re: shall I use BTRFS sub-volumes for top-level directories ?
References: <55535C12.3010807@gmx.de> <1431539167.9076.9.camel@kepstin.ca>
In-Reply-To: <1431539167.9076.9.camel@kepstin.ca>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/13/2015 07:46 PM, Calvin Walton wrote:
> On Wed, 2015-05-13 at 16:13 +0200, Toralf Förster wrote:
>> To support the Gentoo Linux ecosystem I do maintain a server as a 
>> tinderbox. I create chroot images based on various Gentoo minmal ISO 
>> images. I usually run 4 chroot image jobs in parallel. The chroots 
>> are full-filled over days/weeks with the compiled output. Issues 
>> during that are filed into Gentoo's bugzilla.
>>
>> If an image is "full" (~35 GB with many files + directories in it) 
>> or completely bricked I create a new one of the same type. The old 
>> is kept for weeks/months to further serve to bug reports questions. 
>> But old images are rarely accessed usually.
>>
>> Because deleting a chroot image takes awfully long and b/c I 
>> experience iowait spikes even if the 3 TB drive isn't filled by more 
>> than 50% I do wonder, if it would make sense to create a btrfs 
>> subvolume for each chroot image ?
>> The deletion of a subvolume should be fast compared to recursivly 
>> deleting a 35 GB file system structure, right ?
> 
> Unfortunately, this isn't entirely the case… Deleting a subvolume 
> actually triggers a background garbage-collecting thread to run in the 
> kernel (named "btrfs-cleaner") which goes recursively through the 
> deleted tree to unallocate the files.
> 
> It will probably save a bit of IO compared to doing it with "rm -r", 
> because there is less metadata updating. (You'll probably see that the 
> "btrfs-transaction" process has high disk io during "rm -r", since it 
> has to commit metadata periodically while the delete is still in 
> progress.)
> 
> Unfortunately the IO scheduling on btrfs-cleaner currently isn't 
> great, so it'll likely still cause io spikes, reducing performance of 
> other applications while it runs.
> 
> As with all things, it's probably best if you just try it and see!
> 

Pff - deleting a directory took over 30 minutes before. Now using subvolumes the same is done in a 1/2 min.
And even if there would be back ground jobs now - the system is still responsive.


>> (And BTW what's about re-balancing of the BTRFS-tree during the 
>> daily usage: wouldn't this profit from that too ?
> 
> All subvolumes share the same allocated space for metadata and data, 
> so using subvolumes vs. directories currently won't make any 
> difference regarding rebalancing.
> 


-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E
--
"; the past is all dirty and cruel in the modern popular imagination, with the exception of the Romans, who are just cruel"
Ian Mortimer, 2008, "The Time Traveller's Guide to Medieval England"
