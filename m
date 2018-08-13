Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:55609 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbeHMOFd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Aug 2018 10:05:33 -0400
Received: by mail-it0-f43.google.com with SMTP id d10-v6so12600954itj.5
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Aug 2018 04:23:43 -0700 (PDT)
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
 <CAJCQCtQS+yiSQ4Cu-F_Spi5_6fEw_FuGdXCafJLxBe1swacabQ@mail.gmail.com>
 <pan$37ed4$1f39572a$7dd0a77a$b6954c8@cox.net>
 <CAJCQCtR9mYzFSHheyjK6sSf-KKeXtibArw9UcpH9Bh-ptXTVcg@mail.gmail.com>
 <5bcd7922-9820-ac9d-5dc2-77a8a4618f91@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <63818cfd-a7c6-3fdf-9e3b-3eedd1b63b34@gmail.com>
Date: Mon, 13 Aug 2018 07:23:38 -0400
MIME-Version: 1.0
In-Reply-To: <5bcd7922-9820-ac9d-5dc2-77a8a4618f91@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-12 03:04, Andrei Borzenkov wrote:
> 12.08.2018 06:16, Chris Murphy пишет:
>> On Fri, Aug 10, 2018 at 9:29 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> Chris Murphy posted on Fri, 10 Aug 2018 12:07:34 -0600 as excerpted:
>>>
>>>> But whether data is shared or exclusive seems potentially ephemeral, and
>>>> not something a sysadmin should even be able to anticipate let alone
>>>> individual users.
>>>
>>> Define "user(s)".
>>
>> The person who is saving their document on a network share, and
>> they've never heard of Btrfs.
>>
>>
>>> Arguably, in the context of btrfs tool usage, "user" /is/ the admin,
>>
>> I'm not talking about btrfs tools. I'm talking about rational,
>> predictable behavior of a shared folder.
>>
>> If I try to drop a 1GiB file into my share and I'm denied, not enough
>> free space, and behind the scenes it's because of a quota limit, I
>> expect I can delete *any* file(s) amounting to create 1GiB free space
>> and then I'll be able to drop that file successfully without error.
>>
>> But if I'm unwittingly deleting shared files, my quota usage won't go
>> down, and I still can't save my file. So now I somehow need a secret
>> incantation to discover only my exclusive files and delete enough of
>> them in order to save this 1GiB file. It's weird, it's unexpected, I
>> think it's a use case failure. Maybe Btrfs quotas isn't meant to work
>> with samba or NFS shares. *shrug*
>>
> 
> That's how both NetApp and ZFS work as well. I doubt anyone can
> seriously call NetApp "not meant to work with NFS or CIFS shares".
> 
> On NetApp space available to NFS/CIFS user is volume size minus space
> frozen in snapshots. If file, captured in snapshot, is deleted in active
> file system, it does not make a single byte available to external user.
> That's what surprised most every first time NetApp users.
> 
> On ZFS snapshots are contained in dataset and you limit total dataset
> space consumption including all snapshots. Thus end effect is the same -
> deleting data that is itself captured in snapshot does not make a single
> byte available. ZFS allows you to additionally restrict active file
> system size ("referenced" quota in ZFS) - this more closely matches your
> expectation - deleting file in active file system decreases its
> "referenced" size thus allowing user to write more data (as long as user
> does not exceed total dataset quota). This is different from btrfs
> "exculsive" and "shared". This should not be hard to implement in btrfs,
> as "referenced" simply means all data in current subvolume, be it
> exclusive or shared.
> 
> IOW ZFS allows to place restriction on both how much data user can use
> and how much data user is allowed additionally to protect (snapshot).
Except user created snapshots are kind of irrelevant here.  If we're 
talking about NFS/CIFS/SMB, there is no way for the user to create a 
snapshot (at least, not in-band), so provided the admin is sensible and 
only uses the referenced quota for limiting space usage by users, things 
behave no differently on  ZFS than they do on ext4 or XFS using user quotas.

Note also that a lot of storage appliances that use ZFS as the 
underlying storage don't expose any way for the admin to use anything 
other than the referenced quota (and usually space reservations).  They 
do this because it makes the system behave as pretty much everyone 
intuitively expects, and it ensures that users don't have to go to an 
admin to remedy their free space issues.
> 
>>
>>>
>>> "Regular users" as you use the term, that is the non-admins who just need
>>> to know how close they are to running out of their allotted storage
>>> resources, shouldn't really need to care about btrfs tool usage in the
>>> first place, and btrfs commands in general, including btrfs quota related
>>> commands, really aren't targeted at them, and aren't designed to report
>>> the type of information they are likely to find useful.  Other tools will
>>> be more appropriate.
>>
>> I'm not talking about any btrfs commands or even the term quota for
>> regular users. I'm talking about saving a file, being denied, and how
>> does the user figure out how to free up space?
>>
> 
> Users need to be educated. Same as with NetApp and ZFS. There is no
> magic, redirect-on-write filesystems work differently than traditional
> and users need to adapt.
> 
> Of course devil is in details, and usability of btrfs quota is far lower
> than NetApp/ZFS. In those space consumption information is first class
> citizen integrated into the very basic tools, not something bolted on
> later and mostly incomprehensible to end user.
Except that this _CAN_ be made to work and behave just like classic 
quotas.  Your example of ZFS above proves it (referenced quotas behave 
just like classic VFS quotas).  Yes, we need to educate users regarding 
qgroups, but we need a _WORKING_ alternative so they can do things like 
they always have, and like most stuff that uses ZFS as part of a 
pre-built system (FreeNAS for example) does.
> 
>> Anyway, it's a hypothetical scenario. While I have Samba running on a
>> Btrfs volume with various shares as subvolumes, I don't have quotas
>> enabled.
> 
> Given all performance issues with quota reported on this list it is
> probably just as good for you.
> 
