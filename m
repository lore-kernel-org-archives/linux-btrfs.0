Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:37523 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731203AbeGTSC2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 14:02:28 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
 <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
 <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
 <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
 <89d20da9-0e80-51d1-3a4f-4cccb44d31ef@libero.it>
 <330020d0-c611-54f6-cbf2-fe9fa6bd3782@gmail.com>
 <d8071de6-7c02-c8cf-074e-9a52ed9f3fac@inwind.it>
 <35080aa5-31df-f2ec-843f-a989fd4bb2de@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <00c91e8b-cf9a-e29e-25ea-9667e1300e40@inwind.it>
Date: Fri, 20 Jul 2018 19:13:12 +0200
MIME-Version: 1.0
In-Reply-To: <35080aa5-31df-f2ec-843f-a989fd4bb2de@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/19/2018 09:10 PM, Austin S. Hemmelgarn wrote:
> On 2018-07-19 13:29, Goffredo Baroncelli wrote:
[...]
>>
>> So until now you are repeating what I told: the only useful raid profile are
>> - striping
>> - mirroring
>> - striping+paring (even limiting the number of disk involved)
>> - striping+mirroring
> 
> No, not quite.  At least, not in the combinations you're saying make sense if you are using standard terminology.  RAID05 and RAID06 are not the same thing as 'striping+parity' as BTRFS implements that case, and can be significantly more optimized than the trivial implementation of just limiting the number of disks involved in each chunk (by, you know, actually striping just like what we currently call raid10 mode in BTRFS does).

Could you provide more information ?

>>
>>>
>>> RAID15 and RAID16 are a similar case to RAID51 and RAID61, except they might actually make sense in BTRFS to provide a backup means of rebuilding blocks that fail checksum validation if both copies fail.
>> If you need further redundancy, it is easy to implement a parity3 and parity4 raid profile instead of stacking a raid6+raid1
> I think you're misunderstanding what I mean here.
> 
> RAID15/16 consist of two layers:
> * The top layer is regular RAID1, usually limited to two copies.
> * The lower layer is RAID5 or RAID6.
> 
> This means that the lower layer can validate which of the two copies in the upper layer is correct when they don't agree.  

This happens only because there is a redundancy greater than 1. Anyway BTRFS has the checksum, which helps a lot in this area

> It doesn't really provide significantly better redundancy (they can technically sustain more disk failures without failing completely than simple two-copy RAID1 can, but just like BTRFS raid10, they can't reliably survive more than one (or two if you're using RAID6 as the lower layer) disk failure), so it does not do the same thing that higher-order parity does.
>>
>>>>
>>>> The fact that you can combine striping and mirroring (or pairing) makes sense because you could have a speed gain (see below).
>>>> [....]
>>>>>>>
>>>>>>> As someone else pointed out, md/lvm-raid10 already work like this.
>>>>>>> What btrfs calls raid10 is somewhat different, but btrfs raid1 pretty
>>>>>>> much works this way except with huge (gig size) chunks.
>>>>>>
>>>>>> As implemented in BTRFS, raid1 doesn't have striping.
>>>>>
>>>>> The argument is that because there's only two copies, on multi-device
>>>>> btrfs raid1 with 4+ devices of equal size so chunk allocations tend to
>>>>> alternate device pairs, it's effectively striped at the macro level, with
>>>>> the 1 GiB device-level chunks effectively being huge individual device
>>>>> strips of 1 GiB.
>>>>
>>>> The striping concept is based to the fact that if the "stripe size" is small enough you have a speed benefit because the reads may be performed in parallel from different disks.
>>> That's not the only benefit of striping though.  The other big one is that you now have one volume that's the combined size of both of the original devices.  Striping is arguably better for this even if you're using a large stripe size because it better balances the wear across the devices than simple concatenation.
>>
>> Striping means that the data is interleaved between the disks with a reasonable "block unit". Otherwise which would be the difference between btrfs-raid0 and btrfs-single ?
> Single mode guarantees that any file less than the chunk size in length will either be completely present or completely absent if one of the devices fails.  BTRFS raid0 mode does not provide any such guarantee, and in fact guarantees that all files that are larger than the stripe unit size (however much gets put on one disk before moving to the next) will all lose data if a device fails.
> 
> Stupid as it sounds, this matters for some people.

I think that even better would be having different filesystems.

>>
>>>
>>>> With a "stripe size" of 1GB, it is very unlikely that this would happens.
>>> That's a pretty big assumption.  There are all kinds of access patterns that will still distribute the load reasonably evenly across the constituent devices, even if they don't parallelize things.
>>>
>>> If, for example, all your files are 64k or less, and you only read whole files, there's no functional difference between RAID0 with 1GB blocks and RAID0 with 64k blocks.  Such a workload is not unusual on a very busy mail-server.
>>
>> I fully agree that 64K may be too much for some workload, however I have to point out that I still find difficult to imagine that you can take advantage of parallel read from multiple disks with a 1GB stripe unit for a *common workload*. Pay attention that btrfs inline in the metadata the small files, so even if the file is smaller than 64k, a 64k read (or more) will be required in order to access it.

> Again, mail servers. Each file should be written out as a single extent, which means it's all in one chunk.  Delivery and processing need to access _LOTS_ of files on a busy mail server, and the good ones do this with userspace parallelization.  BTRFS doesn't parallelize disk accesses from the same userspace execution context (thread if threads are being used, process if not), but it does parallelize access for separate contexts, so if userspace is doing things from multiple threads, so will BTRFS.

The parallelization matters only if it is distributed across different disks. So more disks are involved more parallelization is possible. As extreme example, whit a stripe unit of 1GB, until the filesystem is smaller than 1GB, no parallelizzation is possible[*] because all data is in the same disk. And when the filesystem increases its size, the data must be "distant" more than 1GB to be parallelized.

[*] Of course it is possible to perform parallel read on the same disk, but the throughput would decrease; may be that the average latency would perform better.

> 
> FWIW, I actually tested this back when the company I work for still ran their own internal mail server.  BTRFS was significantly less optimized back then, but there was no measurable performance difference from userspace between using single profile for data or raid0 profile for data.

Despite the btrfs optimization, having a stripe unit of 1GB reduces the likelihood of parallelizing the reads. This because the data to read to be parallelized must be "distant" more than the "stripe unit": having a stripe unit smaller increase the likelihood of a parallel reads.

Of course this is not sufficient. In any case BTRFS should improve its I/O scheduler 


>>
>>>>  
>>>>> At 1 GiB strip size it doesn't have the typical performance advantage of
>>>>> striping, but conceptually, it's equivalent to raid10 with huge 1 GiB
>>>>> strips/chunks.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
