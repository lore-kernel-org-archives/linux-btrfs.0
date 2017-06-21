Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:35641 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdFUDs2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 23:48:28 -0400
Received: by mail-wr0-f177.google.com with SMTP id y25so77216840wrd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 20:48:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170620232525.GF7140@carfax.org.uk>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net> <20170620232525.GF7140@carfax.org.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 20 Jun 2017 21:48:26 -0600
Message-ID: <CAJCQCtSMGjsrZ7N0gWQE744w_au7g1nUMXb1wL2nTa9kgmzYrA@mail.gmail.com>
Subject: Re: Exactly what is wrong with RAID5/6
To: Hugo Mills <hugo@carfax.org.uk>, waxhead <waxhead@dirtcellar.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 20, 2017 at 5:25 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Wed, Jun 21, 2017 at 12:57:19AM +0200, waxhead wrote:
>> I am trying to piece together the actual status of the RAID5/6 bit of BTRFS.
>> The wiki refer to kernel 3.19 which was released in February 2015 so
>> I assume that the information there is a tad outdated (the last
>> update on the wiki page was July 2016)
>> https://btrfs.wiki.kernel.org/index.php/RAID56
>>
>> Now there are four problems listed
>>
>> 1. Parity may be inconsistent after a crash (the "write hole")
>> Is this still true, if yes - would not this apply for RAID1 / RAID10
>> as well? How was it solved there , and why can't that be done for
>> RAID5/6
>
>    Yes, it's still true, and it's specific to parity RAID, not the
> other RAID levels. The issue is (I think) that if you write one block,
> that block is replaced, but then the other blocks in the stripe need
> to be read for the parity block to be recalculated, before the new
> parity can be written. There's a read-modify-write cycle involved
> which isn't inherent for the non-parity RAID levels (which would just
> overwrite both copies).

Yeah, there's a lwn article from Neil Brown about how the likelihood
of hitting the write hole is almost impossible. But nevertheless the
md devs implemented a journal to close the write hole.

Also on Btrfs, while the write hole can manifest on disk, it does get
detected on a subsequent read. That is, a bad reconstruction of data
from parity, will not match data csum and you'll get EIO and an path
to the bad file.

What is really not good though I think is metadata raid56. If that
gets hose, the whole fs is going to face plant. And we've seen some
evidence of this. So I really think the wiki could make it more clear
to just not use raid56 for metadata.


>
>    One of the proposed solutions for dealing with the write hole in
> btrfs's parity RAID is to ensure that any new writes are written to a
> completely new stripe. The problem is that this introduces a whole new
> level of fragmentation if the FS has lots of small writes (because
> your write unit is limited to a complete stripe, even for a single
> byte update).

Another possibility is to ensure a new write is written to a new *not*
full stripe, i.e. dynamic stripe size. So if the modification is a 50K
file on a 4 disk raid5; instead of writing 3 64K data strips + 1 64K
parity strip (a full stripe write); write out 1 64K data strip + 1 64K
parity strip. In effect, a 4 disk raid5 would quickly get not just 3
data + 1 parity strip Btrfs block groups; but 1 data + 1 parity, and 2
data + 1 parity chunks, and direct those write to the proper chunk
based on size. Anyway that's beyond my ability to assess how much
allocator work that is. Balance I'd expect to rewrite everything to
max data strips possible; the optimization would only apply to normal
operation COW.

Also, ZFS has a functional equivalent, a variable stripe size for
raid, so it's always doing COW writes for raid56, no RMW.


>
>    There are probably others here who can explain this better. :)
>
>> 2. Parity data is not checksummed
>> Why is this a problem? Does it have to do with the design of BTRFS somehow?
>> Parity is after all just data, BTRFS does checksum data so what is
>> the reason this is a problem?
>
>    It increases the number of unrecoverable (or not-guaranteed-
> recoverable) cases. btrfs's csums are based on individual blocks on
> individual devices -- each item of data is independently checksummed
> (even if it's a copy of something else). On parity RAID
> configurations, if you have a device failure, you've lost a piece of
> the parity-protected data. To repair it, you have to recover from n-1
> data blocks (which are checksummed), and one parity block (which
> isn't). This means that if the parity block happens to have an error
> on it, you can't recover cleanly from the device loss, *and you can't
> know that an error has happened*.

Uhh no I've done quite a number of tests and absolutely if the parity
is corrupt and therefore you get a bad reconstruction, you definitely
get a csum mismatch and EIO. Corrupt data does not propagate upward.

The csums are in the csum tree which is part of metadata block groups.
If those are raid56 and there's a loss of data, now you're at pretty
high risk because you can get a bad reconstruction, which btrfs will
recognize but unable to recover from, and should go read only. We've
seen that on the list.


-- 
Chris Murphy
