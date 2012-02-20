From: Olivier Bonvalet <btrfs.list@daevel.fr>
Subject: Re: btrfs-convert processing time
Date: Mon, 20 Feb 2012 14:41:33 +0100
Message-ID: <4F424D8D.4030802@daevel.fr>
References: <4F4241D1.4080506@daevel.fr> <20458953.qbO19NXijp@k85hala03>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20458953.qbO19NXijp@k85hala03>
List-ID: <linux-btrfs.vger.kernel.org>

On 20/02/2012 14:20, Hubert Kario wrote:
> On Monday 20 of February 2012 13:51:29 Olivier Bonvalet wrote:
>> Hi,
>>
>> I'm trying to convert two ext4 FS to btrfs, but I'm surprised by the
>> time needed to do that conversion.
>>
>> The first FS is on a 500GiB block device, and btrfs-convert is running
>> since more than 48h :
>> root      1978 25.6 47.7 748308 732556 ?       D    Feb18 944:44
>> btrfs-convert /dev/vg-backup/backup
>>
>> The second is on a 340GiB block device, and the processing time is similar :
>> root     30192  5.2  3.0  73180 61520 pts/0    R    Feb18 121:04
>> btrfs-convert /dev/vg-balor/backup
>>
>>
>> Is it "normal", or is there a problem during the processing ?
>>
>> Thanks,
>> Olivier
>
> How much free space did those FS have? How many files were on them (was they
> dominated by small or large files)?
>
> Regards,


Lot of small files (like compressed email from Maildir), and lot of 
hardlinks, and probably low free space (near 15% I suppose).


So I think I have my answer :)

Thanks
