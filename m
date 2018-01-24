Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36572 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752234AbeAXTof (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 14:44:35 -0500
Received: by mail-pf0-f171.google.com with SMTP id 23so3928428pfp.3
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jan 2018 11:44:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS_=kK1L4ob1YsOO7G2LAGXBiweEMjuSFXw7NBK2OWoZg@mail.gmail.com>
References: <CAEY8F1qw-6Xa+ESJH0X3zhJcQ1UaoJO4wkPjdDt63JEYHBuAoQ@mail.gmail.com>
 <20180122212250.GY3807@carfax.org.uk> <CAEY8F1pstmMVaypLo31vkvOWZZw0L_-d4U4=3LpoQCcJHyZ91Q@mail.gmail.com>
 <CAEY8F1qBNg=_PszmbEMMTG83zzmpU4Qc=rQhHOjjVCCcOw3X6g@mail.gmail.com> <CAJCQCtS_=kK1L4ob1YsOO7G2LAGXBiweEMjuSFXw7NBK2OWoZg@mail.gmail.com>
From: Claes Fransson <claes.v.fransson@gmail.com>
Date: Wed, 24 Jan 2018 20:44:33 +0100
Message-ID: <CAEY8F1oUdNjvcx0DGqsdZqzfeRKEckf_a2KRAjcESyr1uuH1Xw@mail.gmail.com>
Subject: Re: bad key ordering - repairable?
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Jan 24, 2018 01:31, "Chris Murphy" <lists@colorremedies.com> wrote:

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


So, I have now some results from the PassMark Memtest86! I let the
default automatic tests run for about 19 hours and 16 passes. It
reported zero "Errors", but 4 lines of "[Note] RAM may be vulnerable
to high frequency row hammer bit flips". If I understand it correctly,
it means that some errors were detected when the RAM was tested at
higher rates than guaranteed accurate by the vendors. I am not sure
what that may indicate regarding the performance of the RAM for my
Btrfs filesystem. I "only" got irreparable corruptions maybe once
every couple of months or half a year.

I also forgot that I have been trying using Zswap the last couple of
months with OpenSUSE on the Btrfs-filesystem (and also Fedora on the
Ext4-partition). Maybe that is a source for the last corruption (I am
pretty sure I was not using Zswap during previous corruptions, of
which I think at least one was reporting "transid verify failed" or
similar.) Sometimes, but not when the filesystem went readonly, the
computer has been freezing almost completely (mouse pointer moving
only extremely slowly) when running out of RAM the last months. I have
sometimes waited many hours for the operating system to swap out not
so important memory to the swap-partition, but end up having to force
a reboot. I suspect that it might be Zswap not working optimally,
maybe it also affects Btrfs? I have used pretty low swappiness values,
1 or 10.

I might try using only one of the RAM modules in the future if nothing
else works. I usually use most of my available 12 GB RAM though (and
often even more :) ) when using my laptop.



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

Thanks, I might try metadata DUP in the future.

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


Yes, XFS should also have deduplication as an experimental feature.
Don't know how stable it is yet, I might try it. In the future it is
also supposed to get snapshot feature.

Thanks for all your tips and thoughts.

Claes




--
Chris Murphy
