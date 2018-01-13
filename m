Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:40790 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbeAMWJL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Jan 2018 17:09:11 -0500
Received: by mail-ot0-f181.google.com with SMTP id d10so7878980oti.7
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jan 2018 14:09:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c4908bdb-cd9c-929d-e681-16311b6adbc5@gmail.com>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com> <c4908bdb-cd9c-929d-e681-16311b6adbc5@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 13 Jan 2018 15:09:09 -0700
Message-ID: <CAJCQCtS4ZKYbZGbpuOcCCuNdcZjNNUf=gkBu6Ky_DdJ-zVB+HQ@mail.gmail.com>
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 12, 2018 at 11:24 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:


> To that end, I propose the following text for the FAQ:
>
> Q: Do I need to run a balance regularly?
>
> A: While not strictly necessary for normal operations, running a filtered
> balance regularly can help prevent your filesystem from ending up with
> ENOSPC issues.  The following command run daily on each BTRFS volume should
> be more than sufficient for most users:
>
> `btrfs balance start -dusage=25 -dlimit=2..10 -musage=25 -mlimit=2..10`


Daily? Seems excessive.

I've got multiple Btrfs file systems that I haven't balanced, full or
partial, in a year. And I have no problems. One is a laptop which
accumulates snapshots until roughly 25% free space remains and then
most of the snapshots are deleted, except the most recent few, all at
one time. I'm not experiencing any problems so far. The other is a NAS
and it's multiple copies, with maybe 100-200 snapshots. One backup
volume is 99% full, there's no more unallocated free space, I delete
snapshots only to make room for btrfs send receive to keep pushing the
most recent snapshot from the main volume to the backup. Again no
problems.

I really think suggestions this broad are just going to paper over
bugs or design flaws, we won't see as many bug reports and then real
problems won't get fixed.

I also thing the time based method is too subjective. What about the
layout means a balance is needed? And if it's really a suggestion, why
isn't there a chron or systemd unit that just does this for the user,
in btrfs-progs, working and enabled by default? I really do not like
all this hand holding of Btrfs, it's not going to make it better.


> A full, unfiltered balance (one without any options passed in) is completely
> unnecessary for normal usage of a filesystem.

That's good advice.



-- 
Chris Murphy
