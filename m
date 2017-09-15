Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:54394 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdIORZx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 13:25:53 -0400
Received: by mail-lf0-f45.google.com with SMTP id k23so3069950lfi.11
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 10:25:52 -0700 (PDT)
Subject: Re: snapshots of encrypted directories?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <20170914145739.GA32347@rus.uni-stuttgart.de>
 <20170914153222.GC7067@carfax.org.uk>
 <ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com>
 <298c5a7b-d8f8-0d37-d157-16bb4939505a@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <22cba966-0803-74ac-013a-3ac7a2f323c7@gmail.com>
Date: Fri, 15 Sep 2017 20:25:49 +0300
MIME-Version: 1.0
In-Reply-To: <298c5a7b-d8f8-0d37-d157-16bb4939505a@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

15.09.2017 15:35, Austin S. Hemmelgarn пишет:
> On 2017-09-14 23:45, Andrei Borzenkov wrote:
>> 14.09.2017 18:32, Hugo Mills пишет:
>>> On Thu, Sep 14, 2017 at 04:57:39PM +0200, Ulli Horlacher wrote:
>>>> I use encfs on top of btrfs.
>>>> I can create btrfs snapshots, but I have no suggestive access to the
>>>> files
>>>> in these snaspshots, because they look like:
>>>>
>>>> drwx------  framstag users        - 2017-09-08 11:47:18
>>>> uHjprldmxo3-nSfLmcH54HMW
>>>> drwxr-xr-x  framstag users        - 2017-09-08 11:47:18
>>>> wNEWaDCgyXTj0d-Myk8wXZfh
>>>> -rw-r--r--  framstag users      377 2015-06-12 14:02:53
>>>> -zDmc7xfobKDkbl8z7oKOHxv
>>>> -rw-r--r--  framstag users    2,367 2012-07-10 14:32:30
>>>> 7pfKs27K9k5zANE4WOQEuFa2
>>>> -rw-------  framstag users      692 2009-10-20 13:45:41
>>>> 8SQElYCph85kDdcFasUHybVr
>>>> -rw-------  framstag users    2,872 2017-08-31 16:21:52
>>>> bm,yNi1e4fsAClDv7lNxxSfJ
>>>> lrwxrwxrwx  framstag users        - 2017-06-01 15:53:00
>>>> GZxNYI0Gy96R18fz40f7k5rl ->
>>>> wvuQKHYzdFbar18fW6jjOerXk2IsS4OAA2fnHalBZjMQ,7Kw0j-zE3IJqxhmmGBN8G9
>>>> -rw-r--r--  framstag users      182 2016-12-01 13:34:31
>>>> rqtNBbiYDym0hPMbBL-VLJZcFZu6nkNxlsjTX-sU88I4I1
>>>>
>>>> I have to mount the snapshot with encfs, to have access to the
>>>> (decrypted)
>>>> files.
>>>>
>>>> Any better ideas?
>>>
>>>     I'd say it's doing exactly what it should be doing. You're making a
>>> copy of an encrypted data store,
>>
>> With all respect - snapshot is not a copy.
> From a userspace perspective, it is, and that's what matters since EncFS
> is a userspace tool.  In fact, part of the point of a snapshot is that
> it's functionally indistinguishable from a direct copy of the data
> unless you start looking at block layouts (which nothing in userspace
> that isn't an administration tool should be doing).
>>
>>> and the result is encrypted. In order
>>> to read it, it needs to have the decrpytion layer applied to it with
>>> the correct key (which is the need to mount the snapshot with encfs).
>>>
>>
>> But snapshot *is* mounted implicitly as it is part of mounted btrfs
>> filesystem. So I can see that this behavior could be rather unexpected.
>>
>>>     Would you _really_ want a system where the encrypted contents of a
>>> subvolume can be decrypted by simply snapshotting it?
>>
>> The actual question is - do you need to mount each individual btrfs
>> subvolume when using encfs? If yes, this behavior is at least
>> consistent. If not - how are snapshots different?
> I think you're not understanding the layering here.  EncFS is a FUSE
> filesystem that is run as a separate layer on top of another filesystem.
>  It is completely agnostic of the underlying data storage
> implementation, provided that said data storage enforces POSIX I/O
> semantics.
> 

I did understand layering but I was not familiar with subtleties. I now
tested encfs with subvolumes and subvolumes, present in encrypted
directory, are not visible in unencrypted directory at all (and of
course I cannot create subvolume on overlay mount). But - if I know
encrypted name I can create subvolume with the same name - and it
becomes visible under cleartext mount:

bor@10:~> /usr/sbin/btrfs sub cre .encfs/CxRowQNCTNP3Bm0DlEFADnj5
Create subvolume '.encfs/CxRowQNCTNP3Bm0DlEFADnj5'
bor@10:~> ll .encfs/
total 0
drwxr-xr-x 1 bor users 0 Sep 15 20:18 CxRowQNCTNP3Bm0DlEFADnj5
drwxr-xr-x 1 bor users 0 Sep 15 20:11 sub2
bor@10:~> encfs ~/.encfs ~/encfs
EncFS Password:
bor@10:~> ll encfs/
total 0
drwxr-xr-x 1 bor users 0 Sep 15 20:18 sub1
bor@10:~> mkdir encfs/sub1/even-deeper
bor@10:~> ll .encfs/
total 0
drwxr-xr-x 1 bor users 48 Sep 15 20:19 CxRowQNCTNP3Bm0DlEFADnj5
drwxr-xr-x 1 bor users  0 Sep 15 20:11 sub2
bor@10:~> ll .encfs/CxRowQNCTNP3Bm0DlEFADnj5/
total 0
drwxr-xr-x 1 bor users 0 Sep 15 20:19 Z4yelS9xOwbOxZ0tGxopma8K
bor@10:~>

That is what I meant - subvolumes themselves are transparent as long as
you can traverse them. So if they remain under the encfs mount root and
have names that encfs can decode, it is possible to reach them.

> To clarify, the procedure for mounting an EncFS volume is:
> 1. Mount the underlying filesystem (usually done at boot by the init
> system).
> 2. Mount the EncFS instance that is using that underlying filesystem as
> storage (usually done on user log-in by the session manager or PAM).
> 
> On BTRFS, step 1 is implicit if it's a subvolume, but step 2 is never
> implicit, regardless of the filesystem.  Hugo's mention of needing
> mounting the snapshot with EncFS refers to the second step here, not the
> first.

