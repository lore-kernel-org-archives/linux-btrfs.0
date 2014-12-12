Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:50023 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944AbaLLGBI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 01:01:08 -0500
Message-ID: <548A84A2.4000501@pobox.com>
Date: Thu, 11 Dec 2014 22:01:06 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: mkfs.btrfs limits "odd" [and maybe a "failed" phantom device?]
References: <5488C6CF.1080608@pobox.com> <20141212035651.GD22023@hungrycats.org>
In-Reply-To: <20141212035651.GD22023@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/2014 07:56 PM, Zygo Blaxell wrote:
> On Wed, Dec 10, 2014 at 02:18:55PM -0800, Robert White wrote:
>> (3) why can I make a raid5 out of two devices? (I understand that we
>> are currently just making mirrors, but the standard requires three
>> devices in the geometry etc. So I would expect a two device RAID5 to
>> be considered degraded with all that entails. It just looks like its
>> asking for trouble to allow this once the support is finalized as
>> suddenly a working RAID5 thats really a mirror would become
>> something that can only be mounted with the degraded flag.)
>
> RAID5 with even parity and two devices should be exactly the same as
> RAID1 (i.e. disk1 ^ disk2 == 0, therefore disk1 == disk2, the striping
> is irrelevant because there is no difference in disk contents so the
> disks are interchangeable), except with different behavior when more
> devices are added (RAID1 will mirror chunks on pairs of disks, RAID5
> should start writing new chunks with N stripes instead of two).

That's not correct. A RAID5 with three elements presents two _different_ 
sectors in each stripe. When one element is lost, it would still present 
two different sectors, but the safety is gone.

I understand that the XOR collapses into a mirror if only two datum are 
involved, but that's a mathematical fact that is irrelevant to the 
definition of a RAID5 layout. When you take a wheel off of a tricycle it 
doesn't just become a bike. And you can't make a bicycle into a trike by 
just welding on a wheel somewhere. The infrastructure of the two is 
completely different.

So RAID5 with three media M is

M    MM   MMM
D1   D2   P(a)
D3   P(b) D4
P(c) D5   D6

If MMM is lost D1, D2, D3, and D5 are intact
D4 and D6 can be recreated via D3^P(b) and P(c)^D5

M    MM   X
D1   D2   .
D3   P(b) .
P(c) D5   .

So under _no_ circumstances would a two-disk RAID5 be the same as a 
RAID1 since a two disk RAID5 functionally implies disk three because the 
_minimum_ arity of a RAID5 is 3. A two-disk RAID5 has _zero_ data 
protection because the minimum third element is a computational phantom.

In short it is irrational to have a "two disk" RAID5 that is "not 
degraded" in the same way you cannot have a two-wheeled tricycle without 
scraping some part of something along the asphalt.

A RAID1 with two elements presents one sector along the "stripe".

I realize that what has been implemented is what you call a two drive 
RAID5, and done so by really implementing a RAID1, but it's nonsense.

I mean I understand what you are saying you've done, but it makes no 
sense according to the definitions of RAID5. There is no circumstance 
where RAID5 falls back to mirroring. Trying to implement RAID5 as an 
extension of a mirroring paradigm would involve a fundamental conflict 
in definitions. Especially when you reached a failure mode.

This is so fundamental to the design that the "fast" way to assemble a 
RAID5 of N-arity (minimum N being 3) is to just connect the first N-1 
elements, declare the raid valid-but-degraded using (N-1) of the media, 
and then "replacing" the Nth phantom/missing/failed element with the 
real disk and triggering a rebuild. This only works if you don't need 
the initial contents of the array to have a specific value like zero. 
(This involves fewest reads and the array is instantly available while 
it builds.)

As soon as you start writing to the array, the stripes you write 
"repair" the extents if the repair process hadn't gotten to them yet.

Its basically impossible to turn a mirror into a RAID5 if you _ever_ 
expect the code base to to be able to recover an array that's lost an 
element.


>> (4) Same question for raid6 but with three drives instead of the
>> mandated four.
>
> RAID6 with three devices should behave more or less like three-way RAID1,
> except maybe the two parity disks might be different (I forget how the
> function used to calculate the two parity stripes works, and whether
> it can be defined such that F(disk1, disk2, disk3) == disk1).

Uh, no. A raid 6 with three drives, or even two drives, is also degraded 
because the minimum is four.

A   B   C   D
D1  D2  Pa  Qa
D3  Pb  Qb  D4
Pc  Qc  D5  D6
Qd  D7  D8  Pd


You can lose one or two media but the minimum stripe is again [X1,X2] 
for any read (ABCD)(ABC.)(AB..)(A..D) etc.

Minimum arity for RAID6 is 4, maximum lost-but-functional configuration 
is arity-minus-two.

>
>> (5) If I can make a RAID5 or RAID6 device with one missing element,
>> why can't I make a RAID1 out of one drive, e.g. with one missing
>> element?
>
> They're only missing if you believe the minimum number of RAID5 disks
> is not two and the minimum number of RAID6 disks is not three.

I do believe that, because that's what the terms are universally taken 
to mean.

If what BTRFS is promising/planning as raid5 will run non-degraded on 
two disks its... something... but it's not RAID5.

If what BTRFS is promising/planing as raid6 will run non-degraded on 
three disks its... something... bt it's not RAID6.

>
>> (6) If I make a RAID1 out of three devices are there three copies of
>> every extent or are there always two copies that are semi-randomly
>> spread across three devices? (ibid for more than three).
>
> There are always two copies.  RAID1 on 3x1TBdisks gives you 1.5TB
> of mirrored storage.

>> ---
>>
>> It seems to me (very dangerous words in computer science, I know)
>> that we need a "failed" device designator so that a device can be in
>> the geometry (e.g. have a device ID) but not actually exist.
>> Reads/writes to the failed device would always be treated as error
>> returns.
>>
>> The failed device would be subject to replacement with "btrfs dev
>> replace", and could be the source of said replacement to drop a
>> problematic device out of an array.
>>
>> EXAMPLE:
>> Gust t # mkfs.btrfs -f /dev/loop0 failed -d raid1 -m raid1
>> Btrfs v3.17.1
>> See http://btrfs.wiki.kernel.org for more information.
>>
>> Performing full device TRIM (2.00GiB) ...
>> Turning ON incompat feature 'extref': increased hardlink limit per
>> file to 65536
>> Processing explicitly missing device
>> adding device (failed) id 2 (phantom device)
>>
>> mount /dev/loop0 /mountpoint
>>
>> btrfs replace start 2 /dev/loop1 /mountpoint
>>
>> (and so on)
>>
>> Being able to "replace" a faulty device with a phantom "failed"
>> device would nicely disambiguate the whole device add/remove versus
>> replace mistake.
>
> It is a little odd that an array of 3 disks with one missing looks
> like this:

Its correct for a three disk array with one "failed" (e.g. where 
vgtester-d04 is present but bad), it's wrong for a _four_ disk array 
where one disk (vgtester-d03) has been unpluged or otherwise missing (as 
opposed to "deleted").

The entire idea of "three disk array with one missing" doesn't match 
your example below, which is in fact a three disk array with all 
elements present. Your example below started out as a four disk array 
and then you deleted one, making it a three disk array. The point at 
issue would be a four-disk array with one missing. So there'd be four lines.

E.g. a four disk array with one missing _ought_ to look like:

 > Label: none  uuid: dde7fa84-11ed-4281-8d90-3eb0d29b949b
 >          Total devices 3 FS bytes used 256.00KiB
 >          devid    1 size 4.00GiB used 847.12MiB path 
/dev/mapper/vgtester-d01
 >          devid    2 size 4.00GiB used 827.12MiB path /dev/mapper
/vgtester-d02
            devid    3 size 4.00GiB used 0.00B (missing) path ???
 >          devid    4 size 4.00GiB used 0.00B path /dev/mapper/vgtester-d04


The problem here is that the concept of "missing" is, um, missing from 
BTRFS statuses.

For instance the same idea I presume you are going for would be 
expressed in mdadm as with the little status array "UU.U" for "up, up, 
missing, and up".

BTRFS _should_ (big words from a noob, I know) have and display the 
arity of the array with the correct number of expected disks, filled out 
with the information of the available disks.

Were this correct there would be a covariant line for 3 and vgtester-d04 
would be devid 4 like I did to it above.

>
> Label: none  uuid: dde7fa84-11ed-4281-8d90-3eb0d29b949b
>          Total devices 3 FS bytes used 256.00KiB
>          devid    1 size 4.00GiB used 847.12MiB path /dev/mapper/vgtester-d01
>          devid    2 size 4.00GiB used 827.12MiB path /dev/mapper/vgtester-d02
>          devid    3 size 4.00GiB used 0.00B path /dev/mapper/vgtester-d04



That's not odd at all. sort of... (simplified to three lines and names 
changed because of word-wrap here... )

An array of three disks with one missing should look like:

Label: none  uuid: dde7fa84-11ed-4281-8d90-3eb0d29b949b
          Total devices 3 FS bytes used 256.00KiB
          devid    1 size 4.00GiB used 847.12MiB path /dev/sda
          devid    2 size 4.00GiB used 827.12MiB path /dev/sdb
          devid    3 size 4.00GiB used 0.00B (missing)

because, you know, it's like... missing...

An array of three disks with one _failed_ should look like:

Label: none  uuid: dde7fa84-11ed-4281-8d90-3eb0d29b949b
          Total devices 3 FS bytes used 256.00KiB
          devid    1 size 4.00GiB used 847.12MiB path /dev/sda
          devid    2 size 4.00GiB used 827.12MiB path /dev/sdb
          devid    3 size 4.00GiB used 0.00B (failed) path /dev/sdc

An array of three disks with one freshly replacing a previously missing 
or failed should look like:

Label: none  uuid: dde7fa84-11ed-4281-8d90-3eb0d29b949b
          Total devices 3 FS bytes used 256.00KiB
          devid    1 size 4.00GiB used 847.12MiB path /dev/sda
          devid    2 size 4.00GiB used 827.12MiB path /dev/sdb
          devid    3 size 4.00GiB used x.xxxB (rebuilding) path /dev/sdc

With the used value growing with each subsequent repeat of the inquiry 
until they all had the same numbers.

And I don't know what the status would look like during a "replace" but 
there'd temporarily be a fourth disk in the list, one being a donor and 
one being the new replacement.

That's _exactly_ what a RAID5 with a degraded, failed, or mising member 
should look like. For any extent (A,B,C) any one column (A), (B), or (C) 
can be missing -- shown as (.) such that for a chunk size X there is 
always a return stripe [X1,X2] (e.g. the stripe size is _always_ the 
arity minus one, and the minimum arity is three) returned by any legal 
read (A,B,C) == (.,B,C) == (A,.,C) == (A,B,.); it is this property that 
provides the redundancy.

So nominally, the above would result in all reads [X1,X2] being a result 
of (A,B,.) or by device ID (1,2,.). And each read of (1,2,.) would 
provide the opportunity to repair ID 3's chunk.

The subsequent activity, especially a balance/repair operation would be 
repopulating /dev/mapper/vgtester-d04 to reestablish the parity.

Similarly all writes to a valid extent require two reads, and two writes 
minimum. If you have the parity and the target block in memory (that's 
the two reads), you xor-out the original contents of target block, 
xor-in the new contents of target block, then you have to write _both_ 
the target block and the parity block (preferably in one transaction).

In a degraded RAID5, if you are writing to a "missing" block, you have 
to read all blocks in the stripe calculate the missing block, xor the 
calculated block out of the parity block, then xor the new block into 
the parity and write the parity block back out. If the replacement drive 
is installed and active you and also then just write the new block there 
as well and the block stripe is now no longer degraded.

This is core paradigm for RAID5.

And you need the "empty" device ID in the missing case would cause noop 
read and write events/errors but allow the spanning logic to remain 
intact and that logic is necessary for rational recovery when it ends up 
being

1,2,3-is-bad
1,2,3-is-bad
1,2,3
1,2,3
1,2,3-is bad

As in this case stripes zero, one, and four are improper, still missing, 
whatever and stripes two and three have been balanced/scrubbed back into 
good order.

Its particularly important and valuable to have that device ID allocated 
"failed" in a replace scenario where the logic is now ready to keep the 
good stuff (the extents for tracks 2 and 3 for example) and only 
recalculate the bad.

>
> In the above, "vgtest-d02" was a deleted LV and does not exist, but
> you'd never know that from the output of 'btrfs fi show'...

That would be because "deleted" and "failed" are two inherently 
different conditions and BTRFS doesn't have the ID smarts for a "failed" 
device to be present in the map.



>
>> It would make the degraded status less mysterious.
>
> The 'degraded' status currently protects against some significant data
> corruption risks.  :-O
>
>> A filesystem with an explicitly failed element would also make the
>> future roll-out of full RAID5/6 less confusing.


I also still don't get why the RAID1 with arity grater than two was at 
all hard to construct. It would have been my first step on the way to 
RAID5/6

A
D1
D2
D3

A   B
D1  D1
D2  D2
D3  D3

A   B   C
D1  D1  D1
D2  D2  D2
D3  D3  D3

Is the logical progression right before

A   B   C
D1  D2  Pa
D3  Pb  D4
Pc  D5  D6


Until you have the code base and data structures to "search past B" in a 
mirror of arbitrary arity, you just don't have the means to organize the 
horizontal stripe-as-entity needed to do record the arbitrarily wide 
stripes you need to make a higher-order RAID.

And before _any_ of that you need to be able to explicitly account for a 
missing drive such that you have a RAID1 of

A   x
D1  .
D2  .
D3  .

For all possible read and write events. Without that your rebuild of any 
RAID is "iffy". If you are not ready for

A   x   C
D1  .   D1
D2  .   D2
D3  .   D3

then

A   x   C
D1  .   Pa
D3  .   D4
Pc  .   D6

Is going to ruin your world.

I don't know how to turn this into proper BTRFS speak since I am still 
new to the code base...





