Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:51636 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753859AbdJRLa7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 07:30:59 -0400
Received: by mail-it0-f68.google.com with SMTP id o135so5566752itb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Oct 2017 04:30:59 -0700 (PDT)
Subject: Re: Is it safe to use btrfs on top of different types of devices?
To: Adam Borowski <kilobyte@angband.pl>
Cc: Zoltan <zoltan1980@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
 <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
 <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
 <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
 <20171017011443.bupcsskm7joc73wb@angband.pl>
 <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
 <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
 <81e1136a-a846-9531-b1bf-9ad2aabb785d@gmail.com>
 <20171017170626.amfrohfyqlujdueu@angband.pl>
 <1d5e9875-1c1e-f67e-1f5b-0741555d9517@gmail.com>
 <20171017202135.xdop4eko6utircmz@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <213a404f-90e6-a3f8-4867-4e9fcf24426c@gmail.com>
Date: Wed, 18 Oct 2017 07:30:55 -0400
MIME-Version: 1.0
In-Reply-To: <20171017202135.xdop4eko6utircmz@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-17 16:21, Adam Borowski wrote:
> On Tue, Oct 17, 2017 at 03:19:09PM -0400, Austin S. Hemmelgarn wrote:
>> On 2017-10-17 13:06, Adam Borowski wrote:
>>> The thing is, reliability guarantees required vary WILDLY depending on your
>>> particular use cases.  On one hand, there's "even an one-minute downtime
>>> would cost us mucho $$$s, can't have that!" -- on the other, "it died?
>>> Okay, we got backups, lemme restore it after the weekend".
>> Yes, but if you are in the second case, you arguably don't need replication,
>> and would be better served by improving the reliability of your underlying
>> storage stack than trying to work around it's problems. Even in that case,
>> your overall reliability is still constrained by the least reliable
>> component (in more idiomatic terms 'a chain is only as strong as it's
>> weakest link').
> 
> MD can handle this case well, there's no reason btrfs shouldn't do that too.
> A RAID is not akin to serially connected chain, it's a parallel connected
> chain: while pieces of the broken second chain hanging down from the first
> don't make it strictly more resilient than having just a single chain, in
> general case it _is_ more reliable even if the other chain is weaker.
My chain analogy is supposed to be relating to the storage stack as a 
whole, RAID is a single link in the chain, with whatever filesystem 
above it, and whatever storage drivers and hardware below.
> 
> Don't we have a patchset that deals with marking a device as failed at
> runtime floating on the mailing list?  I did not look at those patches yet,
> but they are a step in this direction.
There were some disagreements on whether the device should be released 
(that is, the node closed) immediately when we know it's failed, or 
should be held open until remount.
> 
>> Using replication with a reliable device and a questionable device is
>> essentially the same as trying to add redundancy to a machine by adding an
>> extra linkage that doesn't always work and can get in the way of the main
>> linkage it's supposed to be protecting from failure.  Yes, it will work most
>> of the time, but the system is going to be less reliable than it is without
>> the 'redundancy'.
> 
> That's the current state of btrfs, but the design is sound, and reaching
> more than parity with MD is a matter of implementation.
Indeed, however MD is still not perfectly reliable in this situation 
(though they are exponentially better than BTRFS at the moment).
> 
>>> Thus, I switched the machine to NBD (albeit it sucks on 100Mbit eth).  Alas,
>>> the network driver allocates memory with GFP_NOIO which causes NBD
>>> disconnects (somehow, this doesn't ever happen on swap where GFP_NOIO would
>>> be obvious but on regular filesystem where throwing out userspace memory is
>>> safe).  The disconnects happen around once per week.
>> Somewhat off-topic, but you might try looking at ATAoE as an alternative,
>> it's more reliable in my experience (if you've got a reliable network),
>> gives better performance (there's less protocol overhead than NBD, and it
>> runs on top of layer 2 instead of layer 4)
> 
> I've tested it -- not on the Odroid-U2 but on Pine64 (fully working GbE).
> NBD delivers 108MB/sec in a linear transfer, ATAoE is lucky to break
> 40MB/sec, same target (Qnap-253a, spinning rust), both in default
> configuration without further tuning.  NBD is over IPv6 for that extra 20
> bytes per packet overhead.
Interesting, I've seen the the exact opposite in terms of performance.
> 
> Also, NBD can be encrypted or arbitrarily routed.
Yes, though if you're on a local network, neither should matter :).
> 
>>> It's a single-device filesystem, thus disconnects are obviously fatal.  But,
>>> they never caused even a single bit of damage (as scrub goes), thus proving
>>> btrfs handles this kind of disconnects well.  Unlike times past, the kernel
>>> doesn't get confused thus no reboot is needed, merely an unmount, "service
>>> nbd-client restart", mount, restart the rebuild jobs.
>> That's expected behavior though.  _Single_ device BTRFS has nothing to get
>> out of sync most of the time, the only time there's any possibility of an
>> issue is when you die after writing the first copy of a block that's in a
>> dup profile chunk, but even that is not very likely to cause problems
>> (you'll just lose at most the last <commit-time> worth of data).
> 
> How come?  In a DUP profile, the writes are: chunk 1, chunk2, barrier,
> superblock.  The two prior writes may be arbitrarily reordered -- both
> between each other or even individual sectors inside the chunks, but unless
> the disk lies about barriers, there's no way to have any corruption, thus
> running scrub is not needed.
If the device dies after writing chunk 1 but before the barrier, you end 
up needing scrub.  How much of a failure window is present is largely a 
function of how fast the device is, but there is a failure window there.
> 
>> The moment you add another device though, that simplicity goes out the
>> window.
> 
> RAID1 doesn't seem less simple to me: if the new superblock has been
> successfully written on at least one disk, barriers imply that at least one
> copy is correct.  If the other disk was out to lunch before the final
> unmount, those blocks will be degraded, but that's no different from one
> pair of DUP blocks being corrupted.
It's not guaranteed to be just those blocks though, it could be anything 
up to and including the superblock.  It's the handling needed for that 
situation, as well as possibly being so out of sync that generations on 
the old device don't have any data at all any more on the new one, that 
makes replication complex in BTRFS.
> 
> With RAID5, there be dragons, but that's due to implementation deficiencies;
> if an upper layer says "hey you downstairs, the block you gave me has a
> wrong csum/generation, try to recover it", there's no reason it shouldn't
> be able to reliably recover it in all cases that don't involve a double
> (RAID5) or triple (RAID6) failure.

