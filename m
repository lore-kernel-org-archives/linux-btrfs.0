Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:56140 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932312AbeEWLDx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 07:03:53 -0400
Received: by mail-it0-f46.google.com with SMTP id 144-v6so3806124iti.5
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 04:03:53 -0700 (PDT)
Subject: Re: csum failed root raveled during balance
To: ein <ein.net@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <5B047817.3040106@gmail.com>
 <e04ab862-abe3-7187-1519-b89776df9362@suse.com> <5B052068.5000608@gmail.com>
 <pan$d9d06$238f0899$805884d5$1c7cb19b@cox.net> <5B053DF2.4030301@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <34e2ea9c-dc43-af9e-6de1-566e411f7660@gmail.com>
Date: Wed, 23 May 2018 07:03:49 -0400
MIME-Version: 1.0
In-Reply-To: <5B053DF2.4030301@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-23 06:09, ein wrote:
> On 05/23/2018 11:09 AM, Duncan wrote:
>> ein posted on Wed, 23 May 2018 10:03:52 +0200 as excerpted:
>>
>>>> IMHO the best course of action would be to disable checksumming for you
>>>> vm files.
>>>
>>> Do you mean '-o nodatasum' mount flag? Is it possible to disable
>>> checksumming for singe file by setting some magical chattr? Google
>>> thinks it's not possible to disable csums for a single file.
>>
>> You can use nocow (-C), but of course that has other restrictions (like
>> setting it on the files when they're zero-length, easiest done for
>> existing data by setting it on the containing dir and copying files (no
>> reflink) in) as well as the nocow effects, and nocow becomes cow1 after a
>> snapshot (which locks the existing copy in place so changes written to a
>> block /must/ be written elsewhere, thus the cow1, aka cow the first time
>> written after the snapshot but retain the nocow for repeated writes
>> between snapshots).
>>
>> But if you're disabling checksumming anyway, nocow's likely the way to go.
> 
> Disabling checksumming only may be a way to go - we live without it
> every day. But nocow @ VM files defeats whole purpose of using BTRFS for
> me, even with huge performance penalty - backup reasons - I mean few
> snapshots (20-30), send & receive.
> 
Setting NOCOW on a file doesn't prevent it from being snapshotted, it 
just prevents COW operations from happening under most normal 
circumstances.  In essence, it prevents COW from happening except for 
writing right after the snapshot.  More specifically, the first write to 
a given block in a file set for NOCOW after taking a snapshot will 
trigger a _single_ COW operation for _only_ that block (unless you have 
autodefrag enabled too), after which that block will revert to not doing 
COW operations on write.  This way, you still get consistent and working 
snapshots, but you also don't take the performance hits from COW except 
right after taking a snapshot.

