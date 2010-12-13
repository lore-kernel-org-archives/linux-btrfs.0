From: Gordan Bobic <gordan@bobich.net>
Subject: Re: SSD optimizations
Date: Mon, 13 Dec 2010 09:25:21 +0000
Message-ID: <4D05E681.5090004@bobich.net>
References: <1292174654.11248.10.camel@paddy-desktop>	<4D05630E.7070809@bobich.net> <20101213051157.GA19543@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: jarktasaa@gmail.com, linux-btrfs@vger.kernel.org
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101213051157.GA19543@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2010 05:11 AM, Sander wrote:
> Gordan Bobic wrote (ao):
>> On 12/12/2010 17:24, Paddy Steed wrote:
>>> In a few weeks parts for my new computer will be arriving. The storage
>>> will be a 128GB SSD. A few weeks after that I will order three large
>>> disks for a RAID array. I understand that BTRFS RAID 5 support will be
>>> available shortly. What is the best possible way for me to get the
>>> highest performance out of this setup. I know of the option to optimize
>>> for SSD's
>>
>> BTRFS is hardly the best option for SSDs. I typically use ext4
>> without a journal on SSDs, or ext2 if that is not available.
>> Journalling causes more writes to hit the disk, which wears out
>> flash faster. Plus, SSDs typically have much slower writes than
>> reads, so avoiding writes is a good thing.
>
> Gordan, this you wrote is so wrong I don't even know where to begin.
>
> You'd better google a bit on the subject (ssd, and btrfs on ssd) as much
> is written about it already.

I suggest you back your opinion up with some hard data before making 
such statements. Here's a quick test - make an ext2 fs and a btrfs on 
two similar disk partitions (any disk, for the sake of the experiment it 
doesn't have to be an ssd), then check vmstat -d to get a base line. 
Then put the kernel sources on each it, do a full build, then make clean 
and check vmstat -d again. Check the vmstat -d output again. See how 
many writes (sectors) hit the disk with ext2 and how many with btrfs. 
You'll find that there were many more writes with BTRFS. You can't go 
faster when doing more. Journaling is expensive.

Gordan
