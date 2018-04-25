Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from newman.cs.utexas.edu ([128.83.139.110]:35611 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbeDYDKe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 23:10:34 -0400
Received: from mail-yw0-f171.google.com (mail-yw0-f171.google.com [209.85.161.171])
        (authenticated bits=0)
        by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1) with ESMTP id w3P3AX5S010300
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 22:10:33 -0500
Received: by mail-yw0-f171.google.com with SMTP id u10-v6so5895822ywl.11
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 20:10:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT7S9Qb-m3-7EXJPwtMT9nuUJjDykHi915KU+fc4fB-aQ@mail.gmail.com>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <CAJCQCtT7S9Qb-m3-7EXJPwtMT9nuUJjDykHi915KU+fc4fB-aQ@mail.gmail.com>
From: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Date: Tue, 24 Apr 2018 22:10:27 -0500
Message-ID: <CAHWVdUXV+=sqc2deerQj1nhLfOpEvE6=O5jYFjxa+ZJwOxqbPg@mail.gmail.com>
Subject: Re: Inconsistent behavior of fsync in btrfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Jayashree Mohan <jayashree2912@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

We are using software we developed called CrashMonkey [1]. It
simulates the state on storage after a crash (taking into accounts
FLUSH and FUA flags). Talk slides on how it works can be found here
[2].

It is similar to dm-log-writes if you have used that in the past.

[1] https://github.com/utsaslab/crashmonkey
[2] http://www.cs.utexas.edu/~vijay/papers/hotstorage17-crashmonkey-slides.pdf

Thanks,
Vijay Chidambaram

On Tue, Apr 24, 2018 at 10:07 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>
>
> On Tue, Apr 24, 2018 at 8:35 PM, Jayashree Mohan <jayashree2912@gmail.com> wrote:
>>
>> Hi,
>>
>> While investigating crash consistency bugs on btrfs, we came across
>> workloads that demonstrate inconsistent behavior of fsync.
>>
>> Consider the following workload where fsync on the directory did not persist it.
>>
>> Workload 1:
>>
>> mkdir A
>> Sync
>> rename (A, B)
>> creat B/foo
>> fsync B/foo
>> fsync B
>> ---crash---
>>
>> In this case, the directory B as well as file B/foo are missing.
>> What's more worrying is that, on recovery from crash, we expect the
>> contents of directory to be
>>
>> Dir A : should not exist
>> Dir B :
>>     foo
>>
>> But instead, what we see is that:
>> Dir A :
>>     foo
>> Dir B : doesn't exist
>>
>>
>> This state is acceptable if we had created the file foo in dir A and
>> then renamed the directory - in that case it would mean the rename did
>> not persist. However what we see here is that, a file created in
>> directory B falsely appears in A, which is incorrect.
>>
>> However, if we did not persist the initial create of directory A, i.e
>>
>> Workload 2:
>>
>> mkdir A
>> rename (A, B)
>> creat B/foo
>> fsync B/foo
>> fsync B
>> ---crash---
>>
>> the directory B and its entry both get persisted in this case.
>>
>> Is this something to do with the directory entry A being already
>> present in the FS/subvolume tree and then the changes to the directory
>> inode going into the fsync log?
>>
>> We do not clearly understand the reason for such inconsistent
>> behavior, but it does seem incorrect.
>>
>> Consider another case where we found inconsistent behavior in the way
>> fsync is handled.
>>
>> Workload 3:
>>
>> mkdir A
>> mkdir B
>> creat A/foo
>> link (A/foo, B/foo)
>> fsync A/foo
>> fsync B/foo
>> ---crash---
>>
>> In this case,  file A/foo is persisted, but inspite of an explicit
>> fsync on B/foo, the file goes missing.
>>
>> Workload 4:
>>
>> mkdir A
>> mkdir B
>> creat A/foo
>> link (A/foo, B/foo)
>> fsync B/foo
>> fsync A/foo
>> ---crash---
>>
>> Note that, the only difference between workload 3 and 4 is the order
>> of fsync on files A/foo and B/foo. In this case, the file B/foo is
>> persisted, but A/foo is missing.
>>
>> What we interpret from the above workloads is that, the second fsync
>> is behaving like a no-op, and in either cases, only the file that is
>> fsynced first gets persisted. If we insert a sleep(45) between the two
>> fsyncs in the workloads above, we see both the files A/foo and B/foo
>> being persisted.
>>
>> No matter how many more links we create and fsync, only the first
>> fsync persists the file, i.e for example,
>>
>> Workload 5:
>>
>> mkdir A
>> mkdir B
>> mkdir C
>> creat A/foo
>> link (A/foo, B/foo)
>> link (A/foo, C/foo)
>> fsync B/foo
>> fsync A/foo
>> fsync C/foo
>> ---crash---
>>
>> Only file B/foo gets persisted, and both A/foo and C/foo are missing.
>>
>> This seems like inconsistent behavior as only the first fsync persists
>> the file, while all others don't seem to. Do you agree if this is
>> indeed incorrect and needs fixing?
>>
>> All the above tests pass on ext4 and xfs.
>>
>> Please let us know what you feel about such inconsistency.
>>
>
> I don't have answer to your question, but I'm curious exactly how you simulate a crash? For my own really rudimentary testing I've been doing crazy things like:
>
> # grub-mkconfig -o /boot/efi && echo b > /proc/sysrq-trigger
>
> And seeing what makes it to disk - or not. And I'm finding a some non-determinstic results are possible even in a VM which is a bit confusing. I'm sure with real hardware I'd find even more inconsistency.
>
>
> --
> Chris Murphy
