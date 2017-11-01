Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:51507 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755014AbdKARUY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 13:20:24 -0400
Received: by mail-io0-f181.google.com with SMTP id b186so7624021iof.8
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 10:20:24 -0700 (PDT)
Subject: Re: Several questions regarding btrfs
To: ST <smntov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <1509467017.1662.37.camel@gmail.com>
 <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
 <1509480384.1662.84.camel@gmail.com>
 <ea097624-d485-9423-387f-3c9427508883@gmail.com>
 <1509545153.1662.105.camel@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7e8d6430-01e0-ba8e-5822-510ba1daef9f@gmail.com>
Date: Wed, 1 Nov 2017 13:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <1509545153.1662.105.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-01 10:05, ST wrote:
> 
>>>>> 3. in my current ext4-based setup I have two servers while one syncs
>>>>> files of certain dir to the other using lsyncd (which launches rsync on
>>>>> inotify events). As far as I have understood it is more efficient to use
>>>>> btrfs send/receive (over ssh) than rsync (over ssh) to sync two boxes.
>>>>> Do you think it would be possible to make lsyncd to use btrfs for
>>>>> syncing instead of rsync? I.e. can btrfs work with inotify events? Did
>>>>> somebody try it already?
>>>> BTRFS send/receive needs a read-only snapshot to send from.  This means
>>>> that triggering it on inotify events is liable to cause performance
>>>> issues and possibly lose changes
>>>
>>> Actually triggering doesn't happen on each and every inotify event.
>>> lsyncd has an option to define a time interval within which all inotify
>>> events are accumulated and only then rsync is launched. It could be 5-10
>>> seconds or more. Which is quasi real time sync. Do you  still hold that
>>> it will not work with BTRFS send/receive (i.e. keeping previous snapshot
>>> around and creating a new one)?
>> Okay, I actually didn't know that.  Depending on how lsyncd invokes
>> rsync though (does it call out rsync with the exact paths or just on the
>> whole directory?), it may still be less efficient to use BTRFS send/receive.
> 
> I assume on the whole directory, but I'm not sure...
> 
>>>>> 4. In a case when compression is used - what quota is based on - (a)
>>>>> amount of GBs the data actually consumes on the hard drive while in
>>>>> compressed state or (b) amount of GBs the data naturally is in
>>>>> uncompressed form. I need to set quotas as in (b). Is it possible? If
>>>>> not - should I file a feature request?
>>>> I can't directly answer this as I don't know myself (I don't use
>>>> quotas), but have two comments I would suggest you consider:
>>>>
>>>> 1. qgroups (the BTRFS quota implementation) cause scaling and
>>>> performance issues.  Unless you absolutely need quotas (unless you're a
>>>> hosting company, or are dealing with users who don't listen and don't
>>>> pay attention to disk usage, you usually do not need quotas), you're
>>>> almost certainly better off disabling them for now, especially for a
>>>> production system.
>>>
>>> Ok. I'll use more standard approaches. Which of following commands will
>>> work with BTRFS:
>>>
>>> https://debian-handbook.info/browse/stable/sect.quotas.html
>> None, qgroups are the only option right now with BTRFS, and it's pretty
>> likely to stay that way since the internals of the filesystem don't fit
>> well within the semantics of the regular VFS quota API.  However,
>> provided you're not using huge numbers of reflinks and subvolumes, you
>> should be fine using qgroups.
> 
> I want to have 7 daily (or 7+4) read-only snapshots per user, for ca.
> 100 users. I don't expect users to invoke cp --reflink or take
> snapshots.
Based on what you say below about user access, you should be absolutely 
fine then.

There's one other caveat though, only root can use the qgroup ioctls, 
which means that only root can check quotas.
> 
>>
>> However, it's important to know that if your users have shell access,
>> they can bypass qgroups.  Normal users can create subvolumes, and new
>> subvolumes aren't added to an existing qgroup by default (and unless I'm
>> mistaken, aren't constrained by the qgroup set on the parent subvolume),
>> so simple shell access is enough to bypass quotas.
> 
> I never did it before, but shouldn't it be possible to just whitelist
> commands users are allowed to use in the SSH config (and so block
> creation of subvolumes/cp --reflink)? I actually would have restricted
> users to sftp if I knew how to let them change their passwords once they
> wish to. As far as I know it is not possible with OpenSSH...
Yes, but not with OpenSSH.  Assuming you just want SFTP/SCP, and the 
ability to change passwords, you can use a program called 'scponly' [1]. 
  It's a replacement shell that only allows the things needed for a very 
small set of commands, and it includes support for restricting things to 
just SCP/SFTP, and the passwd command.
> 
> 
>>>>
>>>> 2. Compression and quotas cause issues regardless of how they interact.
>>>> In case (a), the user has no way of knowing if a given file will fit
>>>> under their quota until they try to create it.  In case (b), actual disk
>>>> usage (as reported by du) will not match up with what the quota says the
>>>> user is using, which makes it harder for them to figure out what to
>>>> delete to free up space.  It's debatable which is a less objectionable
>>>> situation for users, though most people I know tend to think in a way
>>>> that the issue with (a) doesn't matter, but the issue with (b) does.
>>>
>>> I think both (a) and (b) should be possible and it should be up to
>>> sysadmin to choose what he prefers. The concerns of the (b) scenario
>>> probably could be dealt with some sort of --real-size to the du command,
>>> while by default it could have behavior (which might be emphasized with
>>> --compressed-size).
>> Reporting anything but the compressed size by default in du would mean
>> it doesn't behave as existing software expect it to.  It's supposed to
>> report actual disk usage (in contrast to the sum of file sizes), which
>> means for example that a 1G sparse file with only 64k of data is
>> supposed to be reported as being 64k by du.
> 
> Yes, it shouldn't be default behavior, but an optional one...
> 
>>> Two more question came to my mind: as I've mentioned above - I have two
>>> boxes one syncs to another. No RAID involved. I want to scrub (or scan -
>>> don't know yet, what is the difference...) the whole filesystem once in
>>> a month to look for bitrot. Questions:
>>>
>>> 1. is it a stable setup for production? Let's say I'll sync with rsync -
>>> either in cron or in lsyncd?
>> Reasonably, though depending on how much data and other environmental
>> constraints, you may want to scrub a bit more frequently.
>>> 2. should any data corruption be discovered - is there any way to heal
>>> it using the copy from the other box over SSH?
>> Provided you know which file is affected, yes, you can fix it by just
>> copying the file back from the other system.
> Ok, but there is no automatic fixing in such a case, right?
Correct.


[1] https://github.com/scponly/scponly/wiki
