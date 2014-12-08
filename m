Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1029 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750964AbaLHBTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 20:19:45 -0500
Message-ID: <5484FD65.7010207@cn.fujitsu.com>
Date: Mon, 8 Dec 2014 09:22:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <kreijack@inwind.it>, Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: System/single + Metadata/single as leftover cruft of mkfs?
References: <CAH-HCWUp0yOZRsW2p2kDjw=eeK4_BQ9DgtKCM2MEC4G=9QtM3w@mail.gmail.com> <5480A8C6.8010201@inwind.it>
In-Reply-To: <5480A8C6.8010201@inwind.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: System/single + Metadata/single as leftover cruft of mkfs?
From: Goffredo Baroncelli <kreijack@inwind.it>
To: Shriramana Sharma <samjnaa@gmail.com>, linux-btrfs 
<linux-btrfs@vger.kernel.org>
Date: 2014年12月05日 02:32
> On 12/04/2014 02:53 PM, Shriramana Sharma wrote:
>> I observe that whenever I create a BtrFS instance using mkfs.btrfs,
>> there is always the leftover cruft of two System/Metadata-Single
>> allocation profiles:
>>
>> btrfs fi df /run/media/samjnaa/BRIHATII/
>> Data, single: total=460.01GiB, used=458.47GiB
>> System, DUP: total=8.00MiB, used=80.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, DUP: total=1.50GiB, used=736.86MiB
>> Metadata, single: total=8.00MiB, used=0.00B
>> GlobalReserve, single: total=256.00MiB, used=0.00B
> Time, to time this question returns:
> this was a explanation from Hugo Mills
> 	http://permalink.gmane.org/gmane.comp.file-systems.btrfs/38205
>
>
> : I believe it comes from mkfs creating a trivial basic filesystem
> : (with the single profiles), and then setting enough flags on it that the
> : kernel can bootstrap it with the desired chunks in it -- but I may be
> : wrong about that.
>
Yes, Hugo's explain is right.
mkfs.btrfs will make a basic file system(empty one) with SINGLE as 8M 
metadata and 4M system.(numbers may differ)
And then *add* new chunks with the raid level passed by  -m/-d options,
which makes mkfs.btrfs codes short and clean.

So, you can see the single system and metadata.

Also, if you have any raid level that has duplication(raid1 or dup), 
then kernel will not use such unsafe(single/raid0)
so in fact, they will never be used if using default DUP metadata like 
output

BTW, the latest kernel should have the patch  Josef committed, which 
will automatically remove the empty
chunks, so after rw mount with latest kernel, they should disappear.

Thasnk,
Qu
>> Doing btrfs balance eventually removes these (but since I forgot to do
>> it *before* copying 400+ G of data to the drive it's still running)
>> but I don't understand why these have to be created in the first
>> place? (I just used SuSE Tumbleweed's default mkfs.btrfs without any
>> -m or -d options.)
>>
>
>
>

