From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: Poor creat/delete files performance
Date: Wed, 18 Aug 2010 19:00:56 +0800
Message-ID: <4C6BBD68.5040408@cn.fujitsu.com>
References: <4C6BB21E.3000809@cn.fujitsu.com> <AANLkTiktGxrm7KqhCUtts8h_jiX0UGCSygKxi06FpRn=@mail.gmail.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTiktGxrm7KqhCUtts8h_jiX0UGCSygKxi06FpRn=@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 18 Aug 2010 11:49:16 +0100, Leonidas Spyropoulos wrote:
> Have you tried umounting and mounting before the second test to
> eliminate any caching?

Yes, I have done it.
The result is similar to the one I have reported.
(Unit: second)
   Create file performance
		BtrFS		Ext4
   Total times:	2.484392	1.505082
   Average:	0.000050	0.000030

   Delete file performance
		BtrFS		Ext4
   Total times:	3.369469	1.024886
   Average:	0.000067	0.000020


> Which kernel you use?

v2.6.35

Regards
Miao Xie

>
> 2010/8/18 Miao Xie<miaox@cn.fujitsu.com>:
>> Hi,
>>
>> We did some performance test and found the create/delete files performance
>> of btrfs is very poor.
>>
>> The test is that we create 50000 files and measure the file-create time
>> first, and then delete these 50000 files and measure the file-delete time.
>> (The attached file is the reproduce program)
>>
>> The result is following:
>> (Unit: second)
>>   Create file performance
>>                 BtrFS           Ext4
>>   Total times:  2.462625        1.449550
>>   Average:      0.000049        0.000029
>>
>>   Delete file performance
>>                 BtrFS           Ext4
>>   Total times:  3.312796        0.997946
>>   Average:      0.000066        0.000020
>>
>> The results were measured on a x86_64 server with 4 cores and 2 SAS disks.
>> By debuging, we found the btrfs spent a lot of time on searching and
>> inserting/removing items in the ctree.
>>
>> Is anyone looking at this issue?
>>
>> Regards
>> Miao Xie
>>
>
>
>

