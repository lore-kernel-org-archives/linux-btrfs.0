Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751814AbeAWOsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 09:48:46 -0500
Subject: Re: Superblock update: Is there really any benefits of updating
 synchronously?
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        waxhead@dirtcellar.net, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <2f19aa79-b8f4-294e-5298-3a7ed7fbd67d@dirtcellar.net>
 <f8674469-cb64-ace6-ae08-3c3b360fb8e3@suse.com>
 <e9b4a3f8-7b40-574f-20d0-579f5119a3f6@mendix.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a2a658d6-87ea-e2fc-1d57-825932ad82d9@suse.com>
Date: Tue, 23 Jan 2018 16:48:43 +0200
MIME-Version: 1.0
In-Reply-To: <e9b4a3f8-7b40-574f-20d0-579f5119a3f6@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.01.2018 16:20, Hans van Kranenburg wrote:
> On 01/23/2018 10:03 AM, Nikolay Borisov wrote:
>>
>> On 23.01.2018 09:03, waxhead wrote:
>>> Note: This have been mentioned before, but since I see some issues
>>> related to superblocks I think it would be good to bring up the question
>>> again.
>>>
>>> [...]
>>> https://btrfs.wiki.kernel.org/index.php/On-disk_Format#Superblock
>>>
>>> The superblocks are updated synchronously on HDD's and one after each
>>> other on SSD's.
>>
>> There is currently no distinction in the code whether we are writing to
>> SSD or HDD.
> 
> So what does that line in the wiki mean, and why is it there? "btrfs
> normally updates all superblocks, but in SSD mode it will update only
> one at a time."

It means the wiki is outdated.

> 
>> Also what do you mean by synchronously, if you inspect the
>> code in write_all_supers you will see what for every device we issue
>> writes for every available copy of the superblock and then wait for all
>> of them to be finished via the 'wait_dev_supers'. In that regard sb
>> writeout is asynchronous.
>>
>>> Superblocks are also (to my knowledge) not protected by copy-on-write
>>> and are read-modify-update.
>>>
>>> On a storage device with >256GB there will be three superblocks.
>>>
>>> BTRFS will always prefer the superblock with the highest generation
>>> number providing that the checksum is good.
>>
>> Wrong. On mount btrfs will only ever read the first superblock at 64k.
>> If that one is corrupted it will refuse to mount, then it's expected the
>> user will initiate recovery procedure with btrfs-progs which reads all
>> supers and replaces them with the "newest" one (as decided by the
>> generation number)
> 
> So again, the line "The superblock with the highest generation is used
> when reading." in the wiki needs to go away then?

Yep, for background information you can read the discussion here:
https://www.spinics.net/lists/linux-btrfs/msg71878.html

> 
>>> On the list there seem to be a few incidents where the superblocks have
>>> gone toast and I am pondering what (if any) benefits there is by
>>> updating the superblocks synchronously.
>>>
>>> The superblock is checkpoint'ed every 30 seconds by default and if
>>> someone pulls the plug (poweroutage) on HDD's then a synchronous write
>>> depending on (the quality of) your hardware may perhaps ruin all the
>>> superblock copies in one go. E.g. Copy A,B and C will all be updated at
>>> 30s.
>>>
>>> On SSD's, since one superblock is updated after other it would mean that
>>> using the default 30 second checkpoint Copy A=30s, Copy B=1m, Copy C=1m30s
>>
>> As explained previously there is no notion of "SSD vs HDD" modes.
> 
> We also had a discussion about the "backup roots" that are stored
> besides the superblock, and that they are "better than nothing" to help
> maybe recover something from a borken fs, but never ever guarantee you
> will get a working filesystem back.
> 
> The same holds for superblocks from a previous generation. As soon as
> the transaction for generation X succesfully hits the disk, all space
> that was occupied in generation X-1 but no longer in X is available to
> be overwritten immediately.
> 
