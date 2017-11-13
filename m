Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:56212 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753576AbdKMM6D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 07:58:03 -0500
Received: by mail-io0-f175.google.com with SMTP id p186so20489360ioe.12
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 04:58:02 -0800 (PST)
Subject: Re: discard on SSDs quickly causes backup trees to vanish
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Chris Murphy <chris@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>
References: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
 <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com>
 <db513a96-e6d3-84bc-ab39-ce0589258bdf@gmx.com>
 <bec1b500-078b-4ee7-6521-f0878c39f2e9@mendix.com>
 <d8bb0868-e969-c83c-0615-838cbc52232f@gmx.com>
 <14623c86-e452-953f-70cd-603a49de4b63@mendix.com>
 <6c8f20dd-e2b8-3d7c-697a-73d4444ad56b@gmx.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <86767ee5-ce7a-ffba-51ac-e5c6a03a982c@gmail.com>
Date: Mon, 13 Nov 2017 07:57:59 -0500
MIME-Version: 1.0
In-Reply-To: <6c8f20dd-e2b8-3d7c-697a-73d4444ad56b@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-11 19:28, Qu Wenruo wrote:
> 
> 
> On 2017年11月12日 04:12, Hans van Kranenburg wrote:
>> Hi,
>>
>> On 11/11/2017 04:48 AM, Qu Wenruo wrote:
>>>
>>> On 2017年11月11日 11:13, Hans van Kranenburg wrote:
>>>> On 11/11/2017 03:30 AM, Qu Wenruo wrote:
>>>>>
>>>>
>>>>> One more chance to recover is never a bad idea.
>>>>
>>>> It is a bad idea. The *only* case you can recover from is when you
>>>> freeze the filesystem *directly* after writing the superblock. Only in
>>>> that case you have both a consistent last committed and previous
>>>> transaction on disk.
>>>
>>> You're talking about the ideal case.
>>>
>>> The truth is, we're living in a real world where every software has
>>> bugs. And that's why sometimes we get transid error.
>>>
>>> So keeps the backup root still makes sense.
>>>
>>> And further more, different trees have different update frequency.
>>> For root and extent tree, they get updated every transaction, while for
>>> chunk tree it's seldom updated.
>>>
>>> And backup roots are updated per transaction, which means we may have a
>>> high chance to recover at least chunk root and to know the chunk map and
>>> possible to grab some data.
>>
>>      That's entirely right yes. But "possible to grab some data" is a
>> whole different thing than "getting the filesystem back into a fully
>> functional consistent state..."
>>
>>      So it's about expectation management for end users. If the user
>> thinks "Ha! A backup! That's nice of btrfs, it keeps them so I can go
>> back!.", then the user will get disappointed when the backups are unusable.
> 
> Without discard, user should be able to rollback to previous transaction
> (backup_root[0])
Unless BTRFS is going out of it's way to ensure this, that's not 
necessarily true.  I'm fairly certain that we try to reuse empty space 
in already allocated chunks before allocating new ones, which would mean 
that there's a reasonable chance on a filesystem that's got the proper 
ratio of metadata and data chunks and has very little slack space in the 
metadata chunks that the old transactions will get overwritten pretty 
quickly (possibly immediately).
> 
> The last transaction committed with commit_root and root->node switched,
> and as I stated in previous mail, until this swtich, commit_root must be
> fully available.
> 
> And after the last transaction there is no modification (since the last
> trans is for unmount), so backuproot[0] should be fully accessible.
> 
> Discard can break it unless we have method to trace tree block space
> usage for at least 2 transactions.
> 
>>
>> The design of btrfs is that all metadata tree blocks and data extent
>> space that is not used by the last completed transaction are freed to be
>> reused, as soon as possible. For cow-only roots (e.g. root tree, extent
>> tree) this is already done immediately in the transaction code after
>> writing the super block (btrfs_finish_extent_commit, discard is also
>> immediately triggered), and for reference counted roots (subvolume
>> roots) the cleaner will asap do it.
>>
>> So, the design gives zero guarantee that following a backup root will
>> work. But, it's better than nothing when trying to scrape some data off
>> of the borken filesystem.
> 
> Again, only for discard.
> 
>>
>>      Maybe it's enough to change man 5 btrfs with the mount options with
>> a warning for the usebackuproot option to let the user know that doing
>> this might result in a mountable filesystem, but that even in case it
>> does, the result should only be used to get as much data as possible off
>> of it before doing mkfs again. Or, if it succeeds, and if also umounting
>> again and running a full btrfsck and scrub to check all metadata and
>> data succeeds, the user might be pretty confident that nothing
>> referenced by the previous backuproot was already overwritten with new
>> data, in which case the filesystem can be continued to be used.
>>
>> But it puts usebackuproot very much in the same department where tools
>> like btrfs-restore live.
> 
> Isn't it the original design?
> No one sane would use it for daily usage and it's original called
> "recovery", I don't see any problem here.
I agree on this point, it's not something regular users should be using, 
but we don't really need to tell most people that.  The only ones I can 
see being a potential issue are those who actually read the 
documentation but don't really have a good understanding of computers, 
which in my experience is usually less than 1% of users in most cases.
>>
>>>> If you do new writes and then again are able to mount with -o
>>>> usebackuproot and if any of the
>>>> transaction-before-the-last-committed-transaction blocks are overwritten
>>>> you're in a field of land mines and time bombs. Being able to mount
>>>> gives a false sense of recovery to the user in that case, because either
>>>> you're gonna crash into transid problems for metadata, or there are
>>>> files in the filesystem in which different data shows up than should,
>>>> potentially allowing users to see data from other users etc... It's just
>>>> dangerous.
>>>>
>>>>> As you can see, if metadata CoW is completely implemented as designed,
>>>>> there will be no report of transid mismatch at all.
>>>>> And btrfs should be bullet proof from the very beginning, but none of
>>>>> these is true.
>>>>
>>>> It is, it's not a bug. This is about the backup roots thingie, not about
>>>> the data from the last transaction.
>>>
>>> Check the original post.
>>> It only gives the magic number, it's not saying if it's from backup root.
>>>
>>> If it's dumped from running fs (it's completely possible) then it's the
>>> problem I described.
>>>
>>> Anyway, no matter what you think if it's a bug or not, I'll enhance tree
>>> allocator to do extra check if the result overwrites the commit root.
>>>
>>> And I strongly suspect transid related problems reported from mail list
>>> has something to do with it.
>>
> 

