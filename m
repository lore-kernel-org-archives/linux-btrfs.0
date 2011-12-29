From: cwillu <cwillu@cwillu.com>
Subject: Re: fstrim on BTRFS
Date: Wed, 28 Dec 2011 23:29:00 -0600
Message-ID: <CAE5mzvgmG_hnR0hpb2Dpx-DgDJqis0eUeY9vbprxAhQHw=4iqg@mail.gmail.com>
References: <201112281757.16019.Martin@lichtvoll.de>
	<4EFBE668.7030800@cn.fujitsu.com>
	<CAG1y0se+ctBx0YpsCGaW-8TKEN7PZix7PA8Eu-FzfVtkNPkkUQ@mail.gmail.com>
	<20111229103736.26a3a07d@natsu>
	<CAG1y0se5nXPjMz9FWexr-zN-aFRbFgz_DLDvysYuyu8Hn7fvQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Roman Mamedov <rm@romanrm.ru>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0se5nXPjMz9FWexr-zN-aFRbFgz_DLDvysYuyu8Hn7fvQg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 28, 2011 at 10:42 PM, Fajar A. Nugraha <list@fajar.net> wrote:
> On Thu, Dec 29, 2011 at 11:37 AM, Roman Mamedov <rm@romanrm.ru> wrote:
>> On Thu, 29 Dec 2011 11:21:14 +0700
>> "Fajar A. Nugraha" <list@fajar.net> wrote:
>>
>>> I'm trying fstrim and my disk is now pegged at write IOPS. Just
>>> wondering if maybe a "btrfs fi balance" would be more useful, since:
>
>
>> Modern controllers (like the SandForce you mentioned) do their own wear leveling 'under the hood', i.e. the same user-visible sectors DO NOT neccessarily map to the same locations on the flash at all times; and introducing 'manual' wear leveling by additional rewriting is not a good idea, it's just going to wear it out more.
>
> I know that modern controllers have their own wear leveling, but AFAIK
> they basically:
> (1) have reserved a certain size for wear leveling purposes
> (2) when a write request comes, they basically use new sectors from
> the pool, and put the "old" sectors to the pool (doing garbage
> collection like trim/rewrite in the process)
> (3) they can't re-use sectors that are currently being used and not
> rewritten (e.g. sectors used by OS files)
>
> If (3) is still valid, then the only way to reuse the sectors is by
> forcing a rewrite (e.g. using "btrfs fi defrag"). So the question is,
> is (3) still valid?

Erase blocks are generally much larger than logical sectors.  There's nothing
stopping an SSD from shuffling around logical sectors as much as it wants, at
any time, any virtual all SSDs do this behind the scenes already, sufficient to
maintain adequate wear levelling.

The problem isn't levelling, but rather that once the pool of erase blocks with
remaining clear space is gone, any further writes require the SSD to do a
read/erase/rewrite shuffle of the valid data in an erase block to reclaim and
compact the scattered overwritten sectors.  Early SSDs ended up operating in
this mode continuously, which is why their performance would drop off over
time:  every little 512 byte write would require reading several hundred
kilobytes (if not megabytes) first, so that it could be rewritten with the new
data after erasing the whole block (cutting the power during this process would
often cause additional hilarity; SD cards have been especially bad for this).

The later controllers gained some intelligence, such that they would set aside
some erase blocks to perform that compaction in the background, allowing them
to maintain a pool of free erase blocks.  Note that it's trivial at that point
for the drive to move the data from a relatively unworn erase block to one from
the pool if necessary, although I don't know that this is actually used, as
wear levelling really isn't a big deal in practice.

What TRIM does in this mix is tell the SSD that various logical blocks can be
considered to be overwritten (so to speak), and as such, don't need (and
shouldn't!) be rewritten if and when the erase block that holds them is
compacted.  This allows the SSD to compact those sectors into the pool earlier
than it might have been able to otherwise (in the best case), and in the worst
case can prevent that data from being needlessly copied again and again.

Consider if you filled a somewhat naive SSD (specifically, one which held no
spare erase blocks for compaction) to capacity, deleted everything, and then
overwrote the same logical sector repeatedly: without trim, the ssd has no way
of knowing that the rest of the blocks are garbage that can be reused, and so
it'll be stuck  reading an entire erase block's worth of garbage, clearing the
erase block, and writing that garbage back out with the changed 512 bytes.
Even with wear-levelling, you'll still suffer a horrendous write-performance
loss, and will wear through the drive far faster than one might otherwise
expect.

This is why some have said that TRIM support is just a crutch for poor
firmware, and is why many devices (all, the last time I checked :p) have poorly
performing TRIM commands: with a couple erase blocks set aside, that
pathological case won't occur; instead you'll have a couple erase blocks that
gradually get filled up with old copies of the only logical sector that's
changing, which can be efficiently erased and returned to the pool.  Add in
some transparent compression (e.g., OCZ's), and you can probably get away with
very few erase blocks in the free pool and still maintain acceptable write
performance.

In light of this, the problem with just using btrfs's defrag/balance as
currently implemented becomes more apparent:  we're not actually freeing up any
space, we're just overwriting logical sectors with data that was already stored
elsewhere.  In the mythical best case, a magical SSD will notice the duplicated
blocks and just store a reference; in the common case of a half-decent
firmware, the SSD will still get along okay (it's basically the same situation
as the previous example); in the worse case of a naive or misguided SSD, you're
pretty much guaranteeing the worst case behaviour: filling up the drive with
garbage, at which point the writes from the balance/defrag will likely hit the
wear-amplification case described above.

Or something like that anyway :p
--Carey Underwood
