Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from corp-mailer.zoner.com ([217.198.120.77]:45429 "EHLO
        corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932297AbeEHIrI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:47:08 -0400
Subject: Btrfs remounted read-only due to ENOSPC in btrfs_run_delayed_refs
 cont. [Was: Re: metadata_ratio mount option?]
To: Chris Mason <clm@fb.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, fdmanana@kernel.org
References: <bd1f9ac2-49ce-7095-7f1f-8a2f905da995@zoner.cz>
 <A77C59EB-BB88-4F12-B8FF-E0C50EBD9750@fb.com>
 <c18bc0a7-464c-6484-282a-9e8e413de104@zoner.cz>
 <9FC056C9-E0EE-4C84-9671-6C396A9617D1@fb.com>
From: Martin Svec <martin.svec@zoner.cz>
Message-ID: <2cd937e3-150e-222e-933b-16a7cb365296@zoner.cz>
Date: Tue, 8 May 2018 10:47:05 +0200
MIME-Version: 1.0
In-Reply-To: <9FC056C9-E0EE-4C84-9671-6C396A9617D1@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

Dne 7.5.2018 v 18:37 Chris Mason napsal(a):
>
>
> On 7 May 2018, at 12:16, Martin Svec wrote:
>
>> Hello Chris,
>>
>> Dne 7.5.2018 v 16:49 Chris Mason napsal(a):
>>> On 7 May 2018, at 7:40, Martin Svec wrote:
>>>
>>>> Hi,
>>>>
>>>> According to man btrfs [1], I assume that metadata_ratio=1 mount option should
>>>> force allocation of one metadata chunk after every allocated data chunk. However,
>>>> when I set this option and start filling btrfs with "dd if=/dev/zero of=dummyfile.dat",
>>>> only data chunks are allocated but no metadata ones. So, how does the metadata_ratio
>>>> option really work?
>>>>
>>>> Note that I'm trying to use this option as a workaround of the bug reported here:
>>>>
>>>
>>> [ urls that FB email server eats, sorry ]
>>
>> It's link to "Btrfs remounted read-only due to ENOSPC in btrfs_run_delayed_refs" thread :)
>
> Oh yeah, the link worked fine, it just goes through this url defense monster that munges it in
> replies.
>
>>
>>>
>>>>
>>>> i.e. I want to manually preallocate metadata chunks to avoid nightly ENOSPC errors.
>>>
>>>
>>> metadata_ratio is almost but not quite what you want.  It sets a flag on the space_info to force a
>>> chunk allocation the next time we decide to call should_alloc_chunk().  Thanks to the overcommit
>>> code, we usually don't call that until the metadata we think we're going to need is bigger than
>>> the metadata space available.  In other words, by the time we're into the code that honors the
>>> force flag, reservations are already high enough to make us allocate the chunk anyway.
>>
>> Yeah, that's how I understood the code. So I think metadata_ratio man section is quite confusing
>> because it implies that btrfs guarantees given metadata to data chunk space ratio, which isn't true.
>>
>>>
>>> I tried to use metadata_ratio to experiment with forcing more metadata slop space, but really I
>>> have to tweak the overcommit code first.
>>> Omar beat me to a better solution, tracking down our transient ENOSPC problems here at FB to
>>> reservations done for orphans.  Do you have a lot of deleted files still being held open?  lsof
>>> /mntpoint | grep deleted will list them.
>>
>> I'll take a look during backup window. The initial bug report describes our rsync workload in
>> detail, for your reference. 

No, there're no trailing deleted files during backup. However, I noticed something interesting in
strace output: rsync does ftruncate() of every transferred file before closing it. In 99.9% cases
the file is truncated to its own size, so it should be a no-op. But these ftruncates are by far the
slowest syscalls according to strace timing and btrfs_truncate() comments itself as "indeed ugly".
Could it be the root cause of global reservations pressure?

I've found this patch from Filipe (Cc'd): https://patchwork.kernel.org/patch/10205013/. Should I
apply it to our 4.14.y kernel and try the impact on intensive rsync workloads?

Thank you
Martin


