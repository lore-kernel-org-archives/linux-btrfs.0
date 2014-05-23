Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55693 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbaEWIDn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 04:03:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WnkS5-0001Te-D3
	for linux-btrfs@vger.kernel.org; Fri, 23 May 2014 10:03:41 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 May 2014 10:03:41 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 May 2014 10:03:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ditto blocks on ZFS
Date: Fri, 23 May 2014 08:03:29 +0000 (UTC)
Message-ID: <pan$b6a0f$45d818ca$8b3d0aef$d3baead7@cox.net>
References: <2308735.51F3c4eZQ7@xev> <1795587.Ol58oREtZ7@xev>
	<ac1e9fe46f993235f30b4c003210dec8.squirrel@webmail.wanet.net>
	<7834850.9NHERJjFOs@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Fri, 23 May 2014 13:54:46 +1000 as excerpted:

> Is anyone doing research on how much free disk space is required on
> BTRFS for "good performance"?  If a rumor (whether correct or incorrect)
> goes around that you need 20% free space on a BTRFS filesystem for
> performance then that will vastly outweigh the space used for metadata.

Well, on btrfs there's free-space, and then there's free-space.  The 
chunk allocation and both data/metadata fragmentation make a difference.

That said, *IF* you're looking at the right numbers, btrfs doesn't 
actually require that much free space, and should run as efficiently 
right up to just a few GiB free, on pretty much any btrfs over a few GiB 
in size, so at least in the significant fractions of a TiB on up range, 
it doesn't require that much free space /as/ /a/ /percentage/ at all.

**BUT BE SURE YOU'RE LOOKING AT THE RIGHT NUMBERS** as explained below.

Chunks:

On btrfs, both data and metadata are allocated in chunks, 1 GiB chunks 
for data, 256 MiB chunks for metadata.  The catch is that while both 
chunks and space within chunks can be allocated on-demand, deleting files 
only frees space within chunks -- the chunks themselves remain allocated 
to data/metadata whichever they were, and cannot be reallocated to the 
other.  To deallocate unused chunks and to rewrite partially used chunks 
to consolidate usage on to fewer chunks and free the others, btrfs admins 
must currently manually (or via script) do a btrfs balance.

btrfs filesystem show:

For the btrfs filesystem show output, the individual devid lines show 
total filesystem space on the device vs. used, as in allocated to chunks, 
space.[1]  Ideally (assuming equal sized devices) you should keep at 
least 2.5-3.0 GiB free per device, since that will allow allocation of 
two chunks each for data (1 GiB each) and metadata (quarter GiB each, but 
on single-device filesystems they are allocated in pairs by default, so 
half a MiB, see below).  Since the balance process itself will want to 
allocate a new chunk to write into in ordered to rewrite and consolidate 
existing chunks, you don't want to use the last one available, and since 
the filesystem could decide it needs to allocate another chunk for normal 
usage as well, you always want to keep at least two chunks worth of each, 
thus 2.5 GiB (3.0 GiB for single-device-filesystems, see below), 
unallocated, one chunk each data/metadata for the filesystem if it needs 
it, and another to ensure balance can allocate at least the one chunk to 
do its rewrite.

As I said, data chunks are 1 GiB, while metadata chunks are 256 MiB, a 
quarter GiB.  However, on a single-device btrfs, metadata will normally 
default to dup (duplicate, two copies for safety) mode, and will thus 
allocate two chunks, half a GiB at a time.  This is why you want 3 GiB 
minimum free on a single-device btrfs, space for two single-mode data 
chunk allocations (1 GiB * 2 = 2 GiB), plus two dup-mode metadata chunk 
allocations (256 MiB * 2 * 2 = 1 GiB).  But on multi-device btrfs, only a 
single copy is stored per device, so the metadata minimum reserve is only 
half a GiB per device (256 MiB * 2 = 512 MiB = half a GiB).

That's the minimum unallocated space you need free.  More than that is 
nice and lets you go longer between having to worry about rebalances, but 
it really won't help btrfs efficiency that much, since btrfs uses already 
allocated chunk space where it can.

btrfs filesystem df:

Then there's the already chunk-allocated space.  btrfs filesystem df 
reports on this.  In the df output, total means allocated while used 
means used, of that allocated, so the spread between them is the 
allocated but unused.

Since btrfs allocates new chunks on-demand from the unallocated space 
pool, but cannot reallocate chunks between data and metadata on its own, 
and because the used blocks within existing chunks will get fragmented 
over time, it's best to keep the btrfs filesystem df reported spread 
between total and used to a minimum.

Of course, as I said above data chunks are 1 GiB each, so a data 
allocation spread of under a GiB won't be recoverable in any case, and a 
spread of 1-5 GiB isn't a big deal.  But if for instance btrfs filesystem 
df reports data 1.25 TiB total (that is, allocated) but only 250 GiB 
used, that's a spread of roughly a TiB, and running a btrfs balance in 
ordered to recover most of that spread to unallocated is a good idea.

Similarly with metadata, except it'll be allocated in 256 MiB chunks, two 
at a time by default on a single device filesystem so 512 MiB at at time 
in that case.  But again, if btrfs filesystem df is reporting say 10.5 
GiB total metadata but only perhaps 1.75 GiB used, the spread is several 
chunks worth and particularly if your unallocated reserve (as reported by 
btrfs filesystem show in the individual device lines) is getting low, 
it's time to consider rebalancing it to recover the unused metadata space 
to unallocated.

It's also worth noting that btrfs required some metadata space free to 
work with, figure about one chunk worth, so if there's no unallocated 
space left and metadata space gets under 300 MiB or so, you're getting 
real close to ENOSPC errors!  For the same reason, even a full balance 
will likely still leave a metadata chunk or two (so say half a gig) of 
reported spread between metadata total and used, that's not recoverable 
by balance because btrfs actually reserves that for its own use.

Finally, it can be noted that under normal usage and particularly in 
cases where people delete a whole bunch of medium to large files (and 
assuming those same files aren't being saved in a btrfs snapshot, which 
would prevent their deletion actually freeing the space they take until 
all the snapshots that contain them are deleted as well), a lot of 
previously allocated data chunks will become mostly or fully empty, but 
metadata usage won't go down all that much, so relatively less metadata 
space will return to unused.  That means where people haven't rebalanced 
in awhile, they're likely to have a lot of allocated but unused data 
space that can be reused, but rather less unused metadata space to 
reuse.  As a result, when all space is allocated and there's no more to 
allocate to new chunks, it's most commonly metadata space that runs out 
first, *SOMETIMES WITH LOTS OF SPACE STILL REPORTED AS FREE BY ORDINARY 
DF* and lots of data space free as reported by btrfs filesystem df as 
well, simply because all available metadata chunks are full, and all 
remaining space is allocated to data chunks, a significant number of 
which may be mostly free.

But OTOH, if you work with mostly small files, a KiB or smaller, and have 
deleted a bunch of them, it's likely you'll free a lot of metadata space 
because such small files are often stored entirely as metadata.  In that 
case you may run out of data space first, once all space is allocated to 
chunks of some kind.  This is somewhat rarer, but it does happen, and the 
symptoms can look a bit strange as sometimes it'll result in a bunch of 
zero-sized files, because the metadata space was available for them but 
when it came time to write the actual data, there was no space to do so.

But once all space is allocated to chunks so no more chunks can be 
allocated, it's only a matter of time until either data or metadata runs 
out, even if there's plenty of "space" free, because all that "space" is 
tied up in the other one!  As I said above, keep an eye on btrfs 
filesystem show output, and try to do a rebalance when the spread between 
total and used (allocated) gets close to 3 GiB, because once all space is 
actually allocated, you're in a bit of a bind and balance may find it 
hard to free space as well.  There's tricks that can help as described 
below, but it's better not to find yourself in that spot in the first 
place.

Balance and balance filters:

Now let's look at balance and balance filters.  There's a page on the wiki
[2] that explains balance filters in some detail, but for our purposes 
here, it's sufficient to know -m tells balance to only handle metadata 
chunks, while -d tells it to only handle data chunks, and usage=N can be 
used to tell it to only rebalance chunks with that usage or LESS, thus 
allowing you to avoid unnecessarily rebalancing full and almost full 
chunks, while still allowing recovery of nearly empty chunks to the 
unallocated pool.

So if btrfs filesystem df shows a big spread between total and used for 
data, try something like this:

btrfs balance start -dusage=20  (note no space between -d and usage)

That says balance (rewrite and consolidate) only data chunks with usage 
of 20% or less.  That will be MUCH faster than a full rebalance, and 
should be quite a bit faster than simply -d (data chunks only, without 
the usage filter) as well, while still consolidating data chunks with 
usage at or below 20%, which will likely be quite a few if the spread is 
pretty big.

Of course you can adjust the N in that usage=N as needed between 0 and 
100.  As the filesystem really does fill up and there's less room to 
spare to allocated but unused chunks, you'll need to increase that usage= 
toward 100 in ordered to consolidate and recover as many partially used 
chunks as possible.  But while the filesystem is mostly empty and/or if 
the btrfs filesystem df spread between used and total is large (tens or 
hundreds of gigs), a smaller usage=, say usage=5, will likely get you 
very good results, but MUCH faster, since you're only dealing with chunks 
at or under 5% full, meaning far less actual rewriting, while most of the 
time getting a full gig back for every 1/20 gig (5%) gig you rebalance!

***ANSWER!***

While btrfs shouldn't lose that much operational efficiency as the 
filesystem fills as long as there's unallocated chunks available to 
allocate as it needs them, the closer it is to full, the more frequently 
one will need to rebalance and the closer to 100 the usage= balance 
filter will need to be in ordered to recover all possible space to 
unallocated in ordered to keep it free for allocation as necessary.

Tying up loose ends: Tricks:

Above, I mentioned tricks that can let you balance even if there's no 
space left to allocate the new chunk to rewrite data/metadata from the 
old chunk into, so a normal balance won't work.

The first such trick is the usage=0 balance filter.  Even if you're 
totally out of unallocated space as reported by btrfs filesystem show, if 
btrfs filesystem df shows a large spread between used and total (or even 
if not, if you're lucky, as long as the spread is at least one chunk's 
worth), there's a fair chance that at least one chunk is totally empty.  
In that case, there's nothing in it to rewrite, and balancing that chunk 
will simply free it, without requiring a chunk allocation to do the 
rewrite. Using usage=0 tells balance to only consider such chunks, 
freeing any that it finds without requiring space to rewrite the data, 
since there's nothing there to rewrite.  =:^)

Still, there's no guarantee balance will find any totally empty chunks to 
free, so it's better not to get into that situation to begin with.  As I 
said above, try to keep at least 3 GiB free as reported by the individual 
device lines of btrfs filesystem show (or 2.5 GiB each device of a multi-
device filesystem).

If -dusage=0/-musage=0 doesn't work, the next trick is to try temporarily 
adding another device to the btrfs, using btrfs device add.  This device 
should be at least several GiB (again, I'd say 3 GiB, minimum, but 10 GiB 
or so would be better, no need to make it /huge/) in size, and could be a 
USB thumb drive or the like.  If you have 8 GiB or better memory and 
aren't using it all, even a several GiB loopback file created on top of 
tmpfs can work,  but of course if the system crashes while that temporary 
device is in use, say goodbye to whatever was on it at the time!

The idea is to add the device temporarily, do a btrfs balance with a 
usage filter set as low as possible to free up at least one extra chunk 
worth of space on the permanent device(s), then when balance has 
recovered enough chunks worth of space to do so, do a btrfs device delete 
on the temporary device to return the chunks on it to the newly 
unallocated space on the permanent devices.

The temporary device trick should work where the usage=0 trick fails and 
should allow getting out of the bind, but again, better never to find 
yourself in that bind in the first place, so keep an eye on those btrfs 
filesystem show results!

More loose ends:

Above I assumed all devices of a multi-device btrfs are the same size, so 
they should fill up roughly in parallel and the per-device lines in the 
btrfs filesystem show output should be similar.  If you're using 
different sized devices, depending on your configured raid mode and the 
size of the devices, one will likely fill up first, but there will still 
be room left on the others.  The details are too complex to deal with 
here, but one thing that's worth noting is that for some device sizes and 
raid mode configurations, btrfs will not be able to use the full size of 
the largest device.  Hugo's btrfs device and filesystem layout 
configurator page is a good tool to use when planning a mixed-device-size 
btrfs.

Finally, there's the usage value in the total devices line of btrfs 
filesystem show, which in footnote [1] below I recommend ignoring if you 
don't understand it.  That number is actually the (rounded appropriately) 
sum of all the used values as reported by btrfs filesystem df.  
Basically, add the used values from the data and metadata lines (because 
the other usage lines end up being rounding errors) of btrfs filesystem 
df, and that should (within rounding error) be the number reported by 
btrfs filesystem show as usage in the total devices line.  That's where 
the number comes from and it is in some ways the actual filesystem 
usage.  But in btrfs terms it's relatively unimportant compared to the 
chunk-allocated/unallocated/total values as reported on the individual 
device lines, and the data/metadata values as reported by btrfs 
filesystem df, so for btrfs administration purposes it's generally better 
to simply pretend that btrfs filesystem show total devices line usage 
doesn't even appear at all, as in real life, far more people seem to get 
confused by it than find it actually useful.  But that's where that 
number derives, if you find you can't simply ignore it as I recommend.  
(I know I'd have a hard time ignoring it myself, until I knew where it 
actually came from.)

---
[1] The total devices line used is reporting something entirely 
different, best ignored if you don't understand it as it has deceived a 
lot of people into thinking they have lots of room available when it's 
actually all allocated.

[2] Btrfs wiki, general link: https://btrfs.wiki.kernel.org

Balance filters:
https://btrfs.wiki.kernel.org/index.php/Balance_Filters

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

