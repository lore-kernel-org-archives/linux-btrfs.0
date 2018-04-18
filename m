Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753179AbeDRIfB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 04:35:01 -0400
Received: from mail-ua0-f178.google.com (mail-ua0-f178.google.com [209.85.217.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 588D2217D6
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 08:35:00 +0000 (UTC)
Received: by mail-ua0-f178.google.com with SMTP id o34so589412uae.9
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 01:35:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+EzBbA=3M29LjxxgjbGHTwgR2cP78emnaZy1SqJ3hvB=O=r1g@mail.gmail.com>
References: <CA+EzBbDv8GKKgSVwAYwQAn5Q3-MMz2BLUeFcjn3uv6eNBKvs5g@mail.gmail.com>
 <CA+EzBbA=3M29LjxxgjbGHTwgR2cP78emnaZy1SqJ3hvB=O=r1g@mail.gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 18 Apr 2018 09:34:58 +0100
Message-ID: <CAL3q7H60ZK3+u4XDcnFBrEOU+CzFFBqr2JY-9yjJ5HEJmr_UeA@mail.gmail.com>
Subject: Re: Hard link not persisted on fsync
To: Jayashree Mohan <jayashree2912@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 1:02 AM, Jayashree Mohan
<jayashree2912@gmail.com> wrote:
> Hi,
>
> A gentle reminder on the crash consistency bug that we found on btrfs:

Why do you call it a consistency bug?
The filesystem does not stay in inconsistent state. The link count
stays 1 and the dentry used for fsync (foo) is persisted.
An inconsistency would be if we ended up with a link count of 2 and
only one of the dentries was persisted, or if we ended up with a link
count of 1 and both dentries were persisted.
Those cases would be detected by an fsck and would could fs operations
to fail unexpectedly (attemping to remove a dentry, etc).

> Link count of a file is not persisted even after a fsync. We believe a
> filesystem that ensures strictly ordered metadata behaviour should be
> able to persist the hard link after a fsync on the original file.

The thing is there's no written specification about what's the
expected and correct behavior.
Yes, I'm aware of Dave's explanation on strictly ordered metadata on
the other thread and transaction details, but things on btrfs work
very differently from xfs (I'm not saying he's wrong).

For me it makes more sense to persist the hard link, but again,
there's a lack of a specification that demands such behaviour, and I'm
not aware of applications needing that behaviour nor user reports
about it.

> Could you comment on why btrfs does not exhibit this behavior, and if
> it's something you'd want to fix?

I don't know the "why", as I am not the original author of the log
tree (what is used to implement fsync on btrfs), so either it's
accidental behavior (the most likely) or intentional.

Since it's not something that causes any corruption, fs inconsistency,
crash, etc, nor there are user reports complaining about this (afaik),
for me it would be far from a priority at the moment as I'm trying to
fix corruptions and similar issues (not necessarily caused by fsync).

Plus, adding such behaviour would have to be done carefully to not
impact performance, as checking if the node has multiple hard links
and which ones need to be persisted (created in the current,
uncommitted, transaction) may have a measurable impact. The current
behaviour it to only guarantee persisting the dentry used for the
fsync call.


>
> Thanks,
> Jayashree Mohan
>
>
>
> On Mon, Apr 16, 2018 at 9:35 AM, Jayashree Mohan
> <jayashree2912@gmail.com> wrote:
>> Hi,
>>
>> The following seems to be a crash consistency bug on btrfs, where in
>> the link count is not persisted even after a fsync on the original
>> file.
>>
>> Consider the following workload :
>> creat foo
>> link (foo, A/bar)
>> fsync(foo)
>> ---Crash---
>>
>> Now, on recovery we expect the metadata of foo to be persisted i.e
>> have a link count of 2. However in btrfs, the link count is 1 and file
>> A/bar is not persisted. The expected behaviour would be to persist the
>> dependencies of inode foo. That is to say, shouldn't fsync of foo
>> persist A/bar and correctly update the link count?
>> Note that ext4, xfs and f2fs recover to the correct link count of 2
>> for the above workload.
>>
>> Let us know what you think about this behavior.
>>
>> Thanks,
>> Jayashree Mohan
