Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32.italiaonline.it ([212.48.25.160]:44075 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750760AbcKEHXV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 5 Nov 2016 03:23:21 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
Reply-To: Goffredo Baroncelli <kreijack@libero.it>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <f5a26f3c-2519-93b9-841f-4e16438bf458@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <4794dd2c-edca-e161-e4e8-71ca1f2aa3d4@libero.it>
Date: Sat, 5 Nov 2016 08:23:17 +0100
MIME-Version: 1.0
In-Reply-To: <f5a26f3c-2519-93b9-841f-4e16438bf458@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resent because I don't see it in ml
----------------------------
Hi Qu,

On 2016-11-04 03:10, Qu Wenruo wrote:
[...]
> 
> I reproduced your problem and find that seems to be a problem of race.
[...]
[...]> 
> I digged a little further into the case 2) and found:
> a) Kernel is scrubbing correct range
>    So the extra csum error is not caused by checking wrong logical
>    bytenr range
> 
> b) Kernel is scrubbing some pages twice
>    That's the cause of the problem.

For time constraint, I was unable to dig further this issue. I tried to add some printk to check if the code process correctly the data; what I found is 

1) the code seems to process the right data
2) the code seems to produces the correct data (i.e. the code was able to rebuild the correct data on the basis of the check-sums and the parity)
3) As you, I found that the code processed two time the same data

Unfortunately I was unable to figure why the code was unable to write the right data on the platter. Following the write path through the several handler of the bio was a job greater than my capabilities (and my time :-) )

> 
> 
> And unlike most of us assume, in fact scrub full fs is a very racy thing.

On the basis of your (and mine) observation that the code seems to process multiple time the same data, this may be an explanation.

> Scrubbing full fs is split into N scrubbing ioctls for each device.
> 
> So for above script, kernel is doing *3* scrubbing work.
> For other profile it may not be a problem, but for RAID5/6 race can happen easily like:
> 
> Scrub dev1(P)           |  Scrub dev2(D1)        | Scrub dev3(D2)
> ---------------------------------------------------------------
> Read out full stripe    | Read out D1            | Read out D2
>                         | Check Csum for D1      | Check Csum for D2
>                         | Csum mismatch (err++)  | Csum matches
> Cal parity              | Read out full stripe   |
> Parity mismatch         | Do recovery            |
> Check full stripe       |
> D1 csum mismatch (err++)|
> 
> So csum mismatch can be counted twice.
> 
> And since scrubbing for corrupted data stripe can easily race with
> scrubbing for parity, if timing happens in a worse situation, it can
> lead to unrecoverable csum error.

Interesting, I wasn't aware that the scrub is done in parallel on the different disks. This explain a lot of strangeness....




 
> On the other hand, if you only scrub the damaged device only, no race
> will happen so case 2) 3) will just disappear.

> 
> Would you please try to only scrub one device one time?

I do it and I can confirm your hypothesis: if I do the scrub process 1 disk a time, I was unable to reproduce the corruption. Instead if I do the scrub process in parallel on all the disks, I sometime got a corruption: in average each 6 tests I got from 1 to 3 failures.

So the strategy of scrub must be different in case of a RAID6/5 chunk: in this case the parallel scrub must be avoided: the scrub must be performed on per stripe basis.


> 
>>
>> 5) I check the disks at the offsets above, to verify that the data/parity is correct
> 
> You could try the new offline scrub, it can save you a lot of time to find data/parity corruption.
> https://github.com/adam900710/btrfs-progs/tree/fsck_scrub

I will try it

BR
G.Baroncelli


> 
> And of course, more reliable than kernel scrub (single thread, no extra IO no race) :)
> 
> Thanks,
> Qu
> 
>>
>> However I found that:
>> 1) if I corrupt the parity disk (/dev/loop2), scrub don't find any corruption, but recomputed the parity (always correctly);
>>
>> 2) when I corrupted the other disks (/dev/loop[01]) btrfs was able to find the corruption. But I found two main behaviors:
>>
>> 2.a) the kernel repaired the damage, but compute the wrong parity. Where it was the parity, the kernel copied the data of the second disk on the parity disk
>>
>> 2.b) the kernel repaired the damage, and rebuild a correct parity
>>
>> I have to point out another strange thing: in dmesg I found two kinds of messages:
>>
>> msg1)
>>     [....]
>>     [ 1021.366944] BTRFS info (device loop2): disk space caching is enabled
>>     [ 1021.366949] BTRFS: has skinny extents
>>     [ 1021.399208] BTRFS warning (device loop2): checksum error at logical 142802944 on dev /dev/loop0, sector 159872, root 5, inode 257, offset 65536, length 4096, links 1 (path: out.txt)
>>     [ 1021.399214] BTRFS error (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>>     [ 1021.399291] BTRFS error (device loop2): fixed up error at logical 142802944 on dev /dev/loop0
>>
>> msg2)
>>     [ 1017.435068] BTRFS info (device loop2): disk space caching is enabled
>>     [ 1017.435074] BTRFS: has skinny extents
>>     [ 1017.436778] BTRFS info (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>>     [ 1017.463403] BTRFS warning (device loop2): checksum error at logical 142802944 on dev /dev/loop0, sector 159872,     root 5, inode 257, offset 65536, length 4096, links 1 (path: out.txt)
>>     [ 1017.463409] BTRFS error (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
>>     [ 1017.463467] BTRFS warning (device loop2): checksum error at logical 142802944 on dev /dev/loop0, sector 159872, root 5, inode 257, offset 65536, length 4096, links 1 (path: out.txt)
>>     [ 1017.463472] BTRFS error (device loop2): bdev /dev/loop0 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
>>     [ 1017.463512] BTRFS error (device loop2): unable to fixup (regular) error at logical 142802944 on dev /dev/loop0
>>     [ 1017.463535] BTRFS error (device loop2): fixed up error at logical 142802944 on dev /dev/loop0
>>
>>
>> but these seem to be UNrelated to the kernel behavior 2.a) or 2.b)
>>
>> Another strangeness is that SCRUB sometime reports
>>  ERROR: there are uncorrectable errors
>> and sometime reports
>>  WARNING: errors detected during scrubbing, corrected
>>
>> but also these seems UNrelated to the behavior 2.a) or 2.b) or msg1 or msg2
>>
>>
>> Enclosed you can find the script which I used to trigger the bug. I have to rerun it several times to show the problem because it doesn't happen every time. Pay attention that the offset and the loop device name are hard coded. You must run the script in the same directory where it is: eg "bash test.sh".
>>
>> Br
>> G.Baroncelli
>>
>>
>>
>>
> 
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
