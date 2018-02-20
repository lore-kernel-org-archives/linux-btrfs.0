Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:33884 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbeBTPla (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 10:41:30 -0500
Received: by mail-it0-f50.google.com with SMTP id a203so5925434itd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 07:41:30 -0800 (PST)
Subject: Re: Status of FST and mount times
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
 <b5b93505-13ad-2e30-8daa-b624de5512bd@gmx.com>
 <5743750c-644d-9160-c0f3-599caf92dcb6@panasas.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ccc1f937-1cdd-afdd-d164-99c3ad648387@gmail.com>
Date: Tue, 20 Feb 2018 10:41:23 -0500
MIME-Version: 1.0
In-Reply-To: <5743750c-644d-9160-c0f3-599caf92dcb6@panasas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-20 09:59, Ellis H. Wilson III wrote:
> On 02/16/2018 07:59 PM, Qu Wenruo wrote:
>> On 2018年02月16日 22:12, Ellis H. Wilson III wrote:
>>> $ sudo btrfs-debug-tree -t chunk /dev/sdb | grep CHUNK_ITEM | wc -l
>>> 3454
>>
>> OK, this explains everything.
>>
>> There are too many chunks.
>> This means at mount you need to search for block group item 3454 times.
>>
>> Even each search only needs to iterate 3 tree blocks, multiply it 3454
>> it would still be a big work.
>> Although some tree blocks like the root node and level 1 nodes can be
>> cached, we still need to read about 3500 tree blocks.
>>
>> If the fs is created using 16K nodesize, this means you need to do
>> random read for 54M using 16K blocksize.
>>
>> No wonder it will takes some time.
>>
>> Normally I would expect 1G chunk for each data and metadata chunk.
>>
>> If there is nothing special, it means your filesystem is already larger
>> than 3T.
>> If your used space is way smaller (less than 30%) than 3.5T, then this
>> means your chunk usage is pretty low, and in that case, balance to
>> reduce number of chunks (block groups) would reduce mount time.
> 
> The nodesize is 16K, and the filesystem data is 3.32TiB as reported by 
> btrfs fi df.  So, from what I am hearing, this mount time is normal for 
> a filesystem this size.  Ignoring a more complex and proper fix like the 
> ones we've been discussing, would bumping the nodesize reduce the number 
> of chunks, thereby reducing the mount time?
It would probably not.  Chunk size is only based on the total size of 
the filesystem, with reasonable base values, so you would still need to 
have at least as many chunks to store the same amount of data (increase 
the node size too much though, and you will end up with more chunks, 
because you'll have more empty space wasted).
> 
> I don't see why balance would come into play here -- my understanding 
> was that was for aged filesystems.  The only operations I've done on 
> here was:
> 1. Format filesystem clean
> 2. Create a subvolume
> 3. rsync our home directories into that new subvolume
> 4. Create another subvolume
> 5. rsync our home directories into that new subvolume
> 
> Accordingly, zero (or at least, extremely little) data should have been 
> overwritten, so I would expect things to be fairly well allocated 
> already.  Please correct me if this is naive thinking.
Your logic is in general correct regarding data, but not necessarily 
metadata.  Assuming you did not use the `--inplace` option for rsync, it 
had to issue a rename for each individual file that got copied in, and 
as a result there was likely a lot of metadata being rewritten.

As far as balance being for aged filesystems, that's not exactly true. 
There are four big reasons you might run a balance:

1. As part of reshaping a volume.  You generally want run a balance 
whenever the number of disks in a volume permanently increases (it will 
happen automatically when it permanently decreases, as the device 
deletion operation is a special type of balance under the hood).  It's 
also used for converting chunk profiles.
2. To free up empty space inside chunks when the filesystem is full at 
the chunk level.
3. To redistribute data across multiple disks in a more even manner 
after deleting a lot of data.
4. To reduce the likelihood of 2 or 3 being an issue.

Reasons 2 and 3 are generally more likely to be needed on old volumes. 
Reason 1 is independent of the age of a volume.  Reason 4 is the reason 
for the regular filtered balances that I and some other people recommend 
be run as part of preventative maintenance, and is also generally 
independent of the age of a volume.

Qu's suggestion is actually independent of all the above reasons, but 
does kind of fit in with the fourth as another case of preventative 
maintenance.
> 
>>> I was using btrfs sub del -C for the deletions, so I believe (if that
>>> command truly waits for the subvolume to be utterly gone) it captures
>>> the entirety of the snapshot.
>>
>> No, snapshot deletion is completely delayed in background.
>>
>> -C only ensures that even a powerloss happen after command return, you
>> won't see the snapshot anywhere, but it will still be deleted in 
>> background.
> 
> Ah, I had no idea.  Thank you!  Is there any way to "encourage" 
> btrfs-cleaner to run at specific times, which I presume is the snapshot 
> deletion process you are referring to?  If it can be told to run at a 
> given time, can I throttle how fast it works, such that I avoid some of 
> the high foreground interruption I've seen in the past?
I don't think there's any way to do this right now (though it would be 
nice if there was).  In theory, you could adjust the priority of the 
kernel thread itself, but messing around with kthread priorities is 
seriously dangerous even if you know exactly what you're doing.
