Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:47749 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbaKBETg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Nov 2014 00:19:36 -0400
Message-ID: <5455B0D6.6080405@pobox.com>
Date: Sat, 01 Nov 2014 21:19:34 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: zcoffey@mytech42.com, linux-btrfs@vger.kernel.org
Subject: Re: RAID1 fails to recover chunk tree
References: <544FFD52.6010604@gmail.com> <5451699B.4020507@pobox.com> <54517338.7090606@pobox.com> <54523D86.5040906@gmail.com> <545349C4.2020104@pobox.com> <54537D5D.3020506@gmail.com>
In-Reply-To: <54537D5D.3020506@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2014 05:15 AM, Zack Coffey wrote:
> Sadly I think I understand now.
>
> So by adding the second drive, BTRFS saw it as an extension of data (ala
> JBOD-ish?). Even though I thought I was only adding RAID1 for metadata,
> was also adding to the data storage.
>
> I assume that even though chunk-recover reports healthy chunks, there's
> little to no way to actually get them?

Yes.

The chunks are "good" in that they are well defined, but in your case 
they point to a place that no-longer exists. Sort of like if you took 
the card catalog out of a library and then burned down the library. The 
catalog is still correct, it just no longer has any books to back it up. 
Or more correctly, you bought a second building, moved half of your 
books over there, made a complete copy of the card catalog, put that in 
the second building... and then burned that second building down. So the 
copy of the card catalog is still valid, but half of the books have been 
burned.

You are making a couple of problematic assumptions about what terms 
mean, and what level of abstractions they involve, that may mess you up 
going forward. Here's a "quick" re-primer.

JBOD == Just a Box Of Disks. This is just a designation for putting 
disks in a computer without any special hardware. That is, when you put 
disks in your computer it's JBOD. It only stops being JBOD when you add 
_dedicated_ hardware controllers for things like RAID operation. This 
designation puts it in contrast to dedicated storage systems of much 
higher complexity that are available from specialty manufacturers, such 
as IBM DASD, which stands for (Direct Access Storage Device), a NAS 
(network attached storage) server, or a hardware RAID solution from 
someone like SUN.

RAID == Redundant Array of Inexpensive Disks. The reason "striping" is 
"RAID-0" is that there is no redundancy in that layout. The zero 
definition was created after the original RAID-1 through 3 (or 4?) and 
before 5 and 6.

Pure concatenation was already well known before the whole attempt to 
standardize how to think about and implement the more complex layouts. 
Pure concatenation is how, for instance, one would zip a bunch of stuff 
onto successive floppies. It's also how adding banks of ram worked 
before memory controlers and line-fetch interleaving and all that. Its 
the "longer tape is more storage, second tape is even more storage module".

(They didn't make a "RAID minus 1" designation for concatenation as that 
was getting absurd).

So every linux system you will ever build that has more than zero disks 
(or equivalent slow storage like SSDs) that doesn't have special 
dedicated storage processors is a JBOD.

A Hardware RAID is typically an dedicated appliance with storage 
elements (usually disks, often pricey) that are often matched by size 
and transfer dynamics, and often backed by a substantial block of 
non-volatile or battery-backup-powered RAM that will survive 
reboots/crashes in such a way as to be considered "nonvolatile" over a 
reasonable period of time etc. E.g. it's not _Just_ a box of inexpensive 
disks.

(Disclaimer: arguable statements follow...)

BTRFS is _not_ a RAID at all. Nor is it a storage management system. 
BTRFS is a file system that _can_ selectively implement various RAID 
layout modes and can operate without a separate storage management system.

So a "real storage management system", such as Logical Volume Manager 
does things in layers. In LVM, for instance, to make a RAID Volume, I 
have to adopt the physical storage (lvm pv* commands) associate it with 
its peers (lvm vg* commands) and then create logical volumes (lvm lv* 
commands).

In a "real RAID management system", such as with mdadm, I have to match 
the partitioning or media sizes and then join them into the semantic 
array layouts. That is, I have to design the layout, and pre-match the 
storage "with deliberate intent" before bringing the storage into the 
mix. For instance if I "make a RAID-5 device" the RAID-ness exists 
"before" the storage, at least in concept.

For Example:

mdadm --create md23 --level=raid5 --raid-devices=4 /dev/sda /dev/sdb 
/dev/sdc /dev/sdd

The raid "comes to exist" as /dev/md23
It is given a personality of type raid5
It is given a geometry of four devices
Then that entity is _imposed_ on each of four drives.

Now in practical terms this happens all at once, but in terms of intent 
and design it is in a strict order of declaration. And because I did it 
all at once I didn't have to specify the size of the array or the sizes 
of the chunks of the array. The program got to "peek ahead" at the media 
and back-figure the size and such.

Compare this to what you did with BTRFS.

You made a file system on a storage device.
Then you said "here's some more space".
Then you said "hey file system, rearrange yourself to use this space, 
and while you are at it, go ahead and spread the metadata around as if 
it were a raid."

So the expansion of storage happened first, and separately, in the btrfs 
device add activity. The "balance" operation was a declaration of "don't 
just own the new space, figure out how best to use it."

You just also applied the metadata filter to say, by the way, I want a 
full copy of the metadata on both the old and the new spaces.

A non-trivial storage layout might have a number of disks, with a volume 
manager, an encryption manager, and an array manager, all layered to 
create an expanse of storage that a file system could _then_ be placed 
attop.

BTRFS is _way_ more flexible than mdadm. And it is way less into fixed 
boundaries. It can, for instance, change its mind about how things are 
laid out without having to go offline for a protracted period of time.

BTRFS' design philosophy seems built around the idea of being able to 
add non-volatile storage into a filesystem "naked" (unpartitioned), or 
add partitions of same at will, and have one layer of logic deal with 
the whole mess.

So BTRFS' ideas of RAID/single layout for medatada and data is not "disk 
centric" its pure semantics that are _aware_ of storage boundaries. 
That's why you can have, your metadata at a different RAID level than 
your data.

The idea is that you can take the dedicated layers that exist (such as 
dm-crypt or LVM) as you need them to manage space, but then not need to 
have the hard boundaries that complicate the semantic layout of the 
space if you don't want/need them.

The other systems are still important, for instance (absent hardware 
encryption) its _way_ more efficient to impose a RAID3, 4, 5, or 6 on a 
raw disk, then encrypt that raid, then put a filesystem on top of the 
encryption than it is to encrypt the multiple drives and then build 
those RAIDs above the encryption.

The TL;DR is that you have to be really careful about the semantic 
structures. A lot of the terms and ideas overlap at different layers. 
That means that the terms have a lot of slack in their meanings. Like 
when people talk about "the network", a lot hinges on what different 
people mean by words like "local".
