Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:38382 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731556AbeGTTWr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 15:22:47 -0400
Received: by mail-it0-f68.google.com with SMTP id v71-v6so15787570itb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 11:33:17 -0700 (PDT)
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
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
 <00c91e8b-cf9a-e29e-25ea-9667e1300e40@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <df7d41d9-5cbd-46c5-a278-be1df9d23e34@gmail.com>
Date: Fri, 20 Jul 2018 14:33:14 -0400
MIME-Version: 1.0
In-Reply-To: <00c91e8b-cf9a-e29e-25ea-9667e1300e40@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-20 13:13, Goffredo Baroncelli wrote:
> On 07/19/2018 09:10 PM, Austin S. Hemmelgarn wrote:
>> On 2018-07-19 13:29, Goffredo Baroncelli wrote:
> [...]
>>>
>>> So until now you are repeating what I told: the only useful raid profile are
>>> - striping
>>> - mirroring
>>> - striping+paring (even limiting the number of disk involved)
>>> - striping+mirroring
>>
>> No, not quite.  At least, not in the combinations you're saying make sense if you are using standard terminology.  RAID05 and RAID06 are not the same thing as 'striping+parity' as BTRFS implements that case, and can be significantly more optimized than the trivial implementation of just limiting the number of disks involved in each chunk (by, you know, actually striping just like what we currently call raid10 mode in BTRFS does).
> 
> Could you provide more information ?
Just parity by itself is functionally equivalent to a really stupid 
implementation of 2 or more copies of the data.  Setups with only one 
disk more than the number of parities in RAID5 and RAID6 are called 
degenerate for this very reason.  All sane RAID5/6 implementations do 
striping across multiple devices internally, and that's almost always 
what people mean when talking about striping plus parity.

What I'm referring to is different though.  Just like RAID10 used to be 
implemented as RAID1 on top of RAID0, RAID05 is RAID0 on top of RAID5. 
That is, you're striping your data across multiple RAID5 arrays instead 
of using one big RAID5 array to store it all.  As I mentioned, this 
mitigates the scaling issues inherent in RAID5 when it comes to rebuilds 
(namely, the fact that device failure rates go up faster for larger 
arrays than rebuild times do).

Functionally, such a setup can be implemented in BTRFS by limiting 
RAID5/6 stripe width, but that will have all kinds of performance 
limitations compared to actually striping across all of the underlying 
RAID5 chunks.  In fact, it will have the exact same performance 
limitations you're calling out BTRFS single mode for below.
> 
>>>
>>>>
>>>> RAID15 and RAID16 are a similar case to RAID51 and RAID61, except they might actually make sense in BTRFS to provide a backup means of rebuilding blocks that fail checksum validation if both copies fail.
>>> If you need further redundancy, it is easy to implement a parity3 and parity4 raid profile instead of stacking a raid6+raid1
>> I think you're misunderstanding what I mean here.
>>
>> RAID15/16 consist of two layers:
>> * The top layer is regular RAID1, usually limited to two copies.
>> * The lower layer is RAID5 or RAID6.
>>
>> This means that the lower layer can validate which of the two copies in the upper layer is correct when they don't agree.
> 
> This happens only because there is a redundancy greater than 1. Anyway BTRFS has the checksum, which helps a lot in this area
The checksum helps, but what do you do when all copies fail the 
checksum?  Or, worse yet, what do you do with both copies have the 
'right' checksum, but different data?  Yes, you could have one more 
copy, but that just reduces the chances of those cases happening, it 
doesn't eliminate them.

Note that I'm not necessarily saying it makes sense to have support for 
this in BTRFS, just that it's a real-world counter-example to your 
statement that only those combinations make sense.  In the case of 
BTRFS, these would make more sense than RAID51 and RAID61, but they 
still aren't particularly practical.  For classic RAID though, they're 
really important, because you don't have checksumming (unless you have 
T10 DIF capable hardware and a RAID implementation that understands how 
to work with it, but that's rare and expensive) and it makes it easier 
to resize an array than having three copies (you only need 2 new disks 
for RAID15 or RAID16 to increase the size of the array, but you need 3 
for 3-copy RAID1 or RAID10).
> 
>> It doesn't really provide significantly better redundancy (they can technically sustain more disk failures without failing completely than simple two-copy RAID1 can, but just like BTRFS raid10, they can't reliably survive more than one (or two if you're using RAID6 as the lower layer) disk failure), so it does not do the same thing that higher-order parity does.
>>>
>>>>>
>>>>> The fact that you can combine striping and mirroring (or pairing) makes sense because you could have a speed gain (see below).
>>>>> [....]
>>>>>>>>
>>>>>>>> As someone else pointed out, md/lvm-raid10 already work like this.
>>>>>>>> What btrfs calls raid10 is somewhat different, but btrfs raid1 pretty
>>>>>>>> much works this way except with huge (gig size) chunks.
>>>>>>>
>>>>>>> As implemented in BTRFS, raid1 doesn't have striping.
>>>>>>
>>>>>> The argument is that because there's only two copies, on multi-device
>>>>>> btrfs raid1 with 4+ devices of equal size so chunk allocations tend to
>>>>>> alternate device pairs, it's effectively striped at the macro level, with
>>>>>> the 1 GiB device-level chunks effectively being huge individual device
>>>>>> strips of 1 GiB.
>>>>>
>>>>> The striping concept is based to the fact that if the "stripe size" is small enough you have a speed benefit because the reads may be performed in parallel from different disks.
>>>> That's not the only benefit of striping though.  The other big one is that you now have one volume that's the combined size of both of the original devices.  Striping is arguably better for this even if you're using a large stripe size because it better balances the wear across the devices than simple concatenation.
>>>
>>> Striping means that the data is interleaved between the disks with a reasonable "block unit". Otherwise which would be the difference between btrfs-raid0 and btrfs-single ?
>> Single mode guarantees that any file less than the chunk size in length will either be completely present or completely absent if one of the devices fails.  BTRFS raid0 mode does not provide any such guarantee, and in fact guarantees that all files that are larger than the stripe unit size (however much gets put on one disk before moving to the next) will all lose data if a device fails.
>>
>> Stupid as it sounds, this matters for some people.
> 
> I think that even better would be having different filesystems.
Not necessarily.  In fact, quite the opposite in most cases, because 
having separate filesystems pushes the requirement to sort the files 
onto devices to userspace, which should not have to worry about that.

Put in cluster computing terms (where this kind of file layout is the 
norm), why exactly should the application software be the component 
responsible for figuring out what node a given file from a particular 
dataset is on?  Why shouldn't the filesystem itself handle this?
> 
>>>
>>>>
>>>>> With a "stripe size" of 1GB, it is very unlikely that this would happens.
>>>> That's a pretty big assumption.  There are all kinds of access patterns that will still distribute the load reasonably evenly across the constituent devices, even if they don't parallelize things.
>>>>
>>>> If, for example, all your files are 64k or less, and you only read whole files, there's no functional difference between RAID0 with 1GB blocks and RAID0 with 64k blocks.  Such a workload is not unusual on a very busy mail-server.
>>>
>>> I fully agree that 64K may be too much for some workload, however I have to point out that I still find difficult to imagine that you can take advantage of parallel read from multiple disks with a 1GB stripe unit for a *common workload*. Pay attention that btrfs inline in the metadata the small files, so even if the file is smaller than 64k, a 64k read (or more) will be required in order to access it.
> 
>> Again, mail servers. Each file should be written out as a single extent, which means it's all in one chunk.  Delivery and processing need to access _LOTS_ of files on a busy mail server, and the good ones do this with userspace parallelization.  BTRFS doesn't parallelize disk accesses from the same userspace execution context (thread if threads are being used, process if not), but it does parallelize access for separate contexts, so if userspace is doing things from multiple threads, so will BTRFS.
> 
> The parallelization matters only if it is distributed across different disks. So more disks are involved more parallelization is possible. As extreme example, whit a stripe unit of 1GB, until the filesystem is smaller than 1GB, no parallelizzation is possible[*] because all data is in the same disk. And when the filesystem increases its size, the data must be "distant" more than 1GB to be parallelized.First, I think you have things slightly backwards, it should be 'until 
the filesystem is _larger_ than 1GB' here.

That aside, the whole issue of data locality is not one to the degree 
you might think.  for 64k files, that's 16384 files per chunk.  That's a 
minuscule number for a really active mail-server (no, seriously, single 
subsidiary mail-servers in big companies may be handling queuing and 
delivery of more than twice that per-minute).
> 
> [*] Of course it is possible to perform parallel read on the same disk, but the throughput would decrease; may be that the average latency would perform better.
Raw throughput, measured simply as how many bytes you can read or write 
per second, would decrease.  Actual effective throughput will not 
necessarily if you've got a storage device with very low seek times, 
because being able to load and process files in parallel may allow for 
much faster actual processing of the data compared to simple serial 
processing.  Latency would be dependent on
> 
>>
>> FWIW, I actually tested this back when the company I work for still ran their own internal mail server.  BTRFS was significantly less optimized back then, but there was no measurable performance difference from userspace between using single profile for data or raid0 profile for data.
> 
> Despite the btrfs optimization, having a stripe unit of 1GB reduces the likelihood of parallelizing the reads. This because the data to read to be parallelized must be "distant" more than the "stripe unit": having a stripe unit smaller increase the likelihood of a parallel reads.
> 
> Of course this is not sufficient. In any case BTRFS should improve its I/O scheduler
Agreed, we need actual parallel access to devices in BTRFS.
