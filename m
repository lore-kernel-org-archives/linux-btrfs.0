Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from corp-mailer.zoner.com ([217.198.120.77]:41874 "EHLO
        corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750934AbeEGQQz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 May 2018 12:16:55 -0400
Subject: Re: metadata_ratio mount option?
To: Chris Mason <clm@fb.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <bd1f9ac2-49ce-7095-7f1f-8a2f905da995@zoner.cz>
 <A77C59EB-BB88-4F12-B8FF-E0C50EBD9750@fb.com>
From: Martin Svec <martin.svec@zoner.cz>
Message-ID: <c18bc0a7-464c-6484-282a-9e8e413de104@zoner.cz>
Date: Mon, 7 May 2018 18:16:50 +0200
MIME-Version: 1.0
In-Reply-To: <A77C59EB-BB88-4F12-B8FF-E0C50EBD9750@fb.com>
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

Dne 7.5.2018 v 16:49 Chris Mason napsal(a):
> On 7 May 2018, at 7:40, Martin Svec wrote:
>
>> Hi,
>>
>> According to man btrfs [1], I assume that metadata_ratio=1 mount option should
>> force allocation of one metadata chunk after every allocated data chunk. However,
>> when I set this option and start filling btrfs with "dd if=/dev/zero of=dummyfile.dat",
>> only data chunks are allocated but no metadata ones. So, how does the metadata_ratio
>> option really work?
>>
>> Note that I'm trying to use this option as a workaround of the bug reported here:
>>
>
> [ urls that FB email server eats, sorry ]

It's link to "Btrfs remounted read-only due to ENOSPC in btrfs_run_delayed_refs" thread :)

>
>>
>> i.e. I want to manually preallocate metadata chunks to avoid nightly ENOSPC errors.
>
>
> metadata_ratio is almost but not quite what you want.  It sets a flag on the space_info to force a
> chunk allocation the next time we decide to call should_alloc_chunk().  Thanks to the overcommit
> code, we usually don't call that until the metadata we think we're going to need is bigger than
> the metadata space available.  In other words, by the time we're into the code that honors the
> force flag, reservations are already high enough to make us allocate the chunk anyway.

Yeah, that's how I understood the code. So I think metadata_ratio man section is quite confusing
because it implies that btrfs guarantees given metadata to data chunk space ratio, which isn't true.

>
> I tried to use metadata_ratio to experiment with forcing more metadata slop space, but really I
> have to tweak the overcommit code first.
> Omar beat me to a better solution, tracking down our transient ENOSPC problems here at FB to
> reservations done for orphans.  Do you have a lot of deleted files still being held open?  lsof
> /mntpoint | grep deleted will list them.

I'll take a look during backup window. The initial bug report describes our rsync workload in
detail, for your reference.

>
> We're working through a patch for the orphans here.  You've got a ton of bytes pinned, which isn't
> a great match for the symptoms we see:
>
> [285169.096630] BTRFS info (device sdb): space_info 4 has 18446744072120172544 free, is not full
> [285169.096633] BTRFS info (device sdb): space_info total=273804165120, used=269218267136,
> pinned=3459629056, reserved=52396032, may_use=2663120896, readonly=131072
>
> But, your may_use count is high enough that you might be hitting this problem.  Otherwise I'll
> work out a patch to make some more metadata chunks while Josef is perfecting his great delayed ref
> update.

As mentioned in the bug report, we have a custom patch that dedicates SSDs for metadata chunks and
HDDs for data chunks. So, all we need is to preallocate metadata chunks to occupy all of the SSD
space and our issues will be gone.
Note that btrfs with SSD-backed metadata works absolutely great for rsync backups, even if there're
billions of files and thousands of snapshots. The global reservation ENOSPC is the last issue we're
struggling with.

Thank you

Martin


