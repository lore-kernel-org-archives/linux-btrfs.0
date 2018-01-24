Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:38782 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752455AbeAXAbc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 19:31:32 -0500
Received: by mail-oi0-f41.google.com with SMTP id m65so1695949oig.5
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 16:31:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEY8F1qBNg=_PszmbEMMTG83zzmpU4Qc=rQhHOjjVCCcOw3X6g@mail.gmail.com>
References: <CAEY8F1qw-6Xa+ESJH0X3zhJcQ1UaoJO4wkPjdDt63JEYHBuAoQ@mail.gmail.com>
 <20180122212250.GY3807@carfax.org.uk> <CAEY8F1pstmMVaypLo31vkvOWZZw0L_-d4U4=3LpoQCcJHyZ91Q@mail.gmail.com>
 <CAEY8F1qBNg=_PszmbEMMTG83zzmpU4Qc=rQhHOjjVCCcOw3X6g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 23 Jan 2018 17:31:30 -0700
Message-ID: <CAJCQCtS_=kK1L4ob1YsOO7G2LAGXBiweEMjuSFXw7NBK2OWoZg@mail.gmail.com>
Subject: Re: bad key ordering - repairable?
To: Claes Fransson <claes.v.fransson@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 23, 2018 at 11:13 AM, Claes Fransson
<claes.v.fransson@gmail.com> wrote:

> I haven't noticed before that there is actually RAM-modules from
> different vendors in the laptop. One 8GB by Samsung, and one 4GB by
> Kingston!

If they have the correct tolerances, I don't think it's a problem.
Some memory controllers use a kind of interleaving if the module sizes
are the same, so worse case you might be leaving a bit of a
performance improvement on the table by the fact they aren't the same
size.

If the memory testing doesn't pan out, you could go down a bit of a
rabbit hole and run each module in production for twice the length of
time you figure you should see a corruption appear.

> I also found that there indeed was a new firmware version for my
> SSD-disk, so I have now updated it's firmware to the newest version.
> Unfortunately I couldn't find any information of what possible issues
> it was supposed to fix. The laptop has already the latest BIOS version
> provided by ASUS for the model.

I don't know enough about the bad key ordering error and its cause. If
that corruption can happen only in memory then the SSD firmware update
may change nothing. If there's some possibility the corruption can be
the result of SSD firmware bugs, then it might make sense to use DUP
metadata in the short term, even on an SSD. Any memory corruption
would affect both copies. Any SSD induced corruption *might* affect
both copies, depending on whether the SSD deduplicates or colocates
the two copies of metadata...but I'd like to think that there's at
least a pretty decent chance one of the copies would be good in which
case you'd get Btrfs self-healing for metadata only.

Anyway, it's a tedious search.

As for Btrfs getting better at handling these kinds of cases. Yeah
it's a valid question. What we know about other file systems is they
can become unrepairable because they don't detect corruption soon
enough. Whereas Btrfs has detected a problem early on yet it's still
damaged enough now that effectively you can no longer mount it rw.
>From a data integrity point of view, at least you can ro mount and get
your data off the volume with a normal file copy operation, not
something that's certain with other file systems.

If you were to try another file system, I'd look at XFS, tools and
kernels in the past couple of years support metadata checksumming with
the V5 format.


-- 
Chris Murphy
