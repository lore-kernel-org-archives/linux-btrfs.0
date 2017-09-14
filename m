Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:49618 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbdINSxF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 14:53:05 -0400
Received: by mail-it0-f47.google.com with SMTP id w204so982919itc.4
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Sep 2017 11:53:05 -0700 (PDT)
Subject: Re: defragmenting best practice?
To: =?UTF-8?Q?Tomasz_K=c5=82oczko?= <kloczko.tomasz@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
 <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
 <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de>
 <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <928da79f-4373-dd95-d458-1b136146b704@gmail.com>
Date: Thu, 14 Sep 2017 14:53:00 -0400
MIME-Version: 1.0
In-Reply-To: <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-14 13:48, Tomasz Kłoczko wrote:
> On 14 September 2017 at 16:24, Kai Krakow <hurikhan77@gmail.com> wrote:
> [..]
>> Getting e.g. boot files into read order or at least nearby improves
>> boot time a lot. Similar for loading applications.
> 
> By how much it is possible to improve boot time?
> Just please some example which I can try to replay which ill be
> showing that we have similar results.
> I still have one one of my laptops with spindle on btrfs root fs ( and
> no other FSess in use) so I could be able to confirm that my numbers
> are enough close to your numbers.
While it's not for BTRFS< a tool called e4rat might be of interest to 
you regarding this.  It reorganizes files on an ext4 filesystem so that 
stuff used by the boot loader is right at the beginning of the device, 
and I've know people to get insane performance improvements (on the 
order of 20x in some pathologicallyb ad cases) in the time taken from 
the BIOS handing things off to GRUB to GRUB handing execution off to the 
kernel.
> 
>> Shake tries to
>> improve this by rewriting the files - and this works because file
>> systems (given enough free space) already do a very good job at doing
>> this. But constant system updates degrade this order over time.
> 
> OK. Please prepare some database, import some data which size will be
> few times of not used RAM (best if this multiplication factor will be
> at least 10). Then do some batch of selects measuring distribution
> latencies of those queries.
> This will give you some data about. not fragmented data.
> Then on next stage try to apply some number of update queries and
> after reboot the system or drop all caches. and repeat the same set of
> selects.
> After this all what you need to do is compare distribution of the latencies.
> 
>> It really doesn't matter if some big file is laid out in 1 allocation
>> of 1 GB or in 250 allocations of 4MB: It really doesn't make a big
>> difference.
>>
>> Recombining extents into bigger once, tho, can make a big difference in
>> an aging btrfs, even on SSDs.
> 
> That it may be an issue with using extents.
> Again: please show some results of some test unit which anyone will be
> able to reply and confirm or not that this effect really exist.
This shouldn't need examples.  It's trivial math combined with basic 
knowledge of hardware behavior.  Every request to a device has a minimum 
amount of overhead.  On traditional hard drives, this is usually 
dominated by seek latency, but on SSD's, the request setup, dispatch, 
and completion are the dominant factor.  Assumign you have a 2 
micro-second overhead per-request (not an exact number, just chosen for 
demonstration purposes because it makes the math easy), and a 1GB file, 
the time difference between reading ten 100MB extents and reading ten 
thousand 100kB extents is just short of 0.02 seconds, or a factor of 
about one thousand (which, no surprise here, is the factor of difference 
between the number of extents).
> 
> If problem really exist and is related ot extents you should have real
> scenario explanation why ZFS is not using extents.
Extents have nothing to do with it.  What matters is how much of the 
file data is contiguous (and therefore can be read as a single request) 
and how smart the FS is about figuring that out.  Extents help figure 
that out, but the primary reason to use them is to save space encoding 
block allocations within a file (go take a look at how ext2 handles 
allocations, and then compare that to ext4, the difference is insane in 
terms of space savings).
> btrfs is not to far from classic approach do FS because it srill uses
> allocation structures.
> This is not the case in context of ZFS because this technology has no
> information about what is already allocates.
> ZFS uses free lists so by negation whatever is not on free list is
> already allocated.
> I'm not trying to point that ZFS is better but only point that by
> changing allocation strategy you may not be blasted by something like
> some extents bottleneck (which sill needs to be proven)
> 
> There are at least few very good reason why it is even necessary to
> change sometimes strategy from allocations structures to free lists.
> First: ZFS free list management is very similar to known from Linux
> memory SLAB allocator.
> Did you heard that someone needs to do system memory defragnentation
> because fragmented memory adds some additional latency to memory
> access?
> Other consequence is that with growing size of the files and number of
> files or directories FS metadata are growing exponentially with size
> and numbers of such objects. In case of free lists there is no such
> growth and all structures are growing with linear correlation.
> Caching in memory free list data takes much less than caching b-trees.
> Last thing is effort on deallocating something in FS with allocation
> structure and with free lists.
> In classic approach number of such operations is growing with depth of b-trees.
> In case free list all hat you need to do is compare ctime of the
> allocated block with volume or snapshot ctime to make decision about
> return or not block to free list.
> No matter how many snapshots, volumes, files or directories allays it
> will be *just one compare* of the block or vol/snapshot ctime.
> With necessity to do just only one compare comes way better
> predictable behavior of whole FS and simplicity of the code making
> such decisions.
> In other words ZFS internally uses well know SLAB allocator with
> caching some data about best possible location to allocate some
> different sizes allocation unit size multiplied by n^2 like you can
> see on Linux in /proc/slabinfo in case of *kmalloc* SLABs.
> This is why in case of ZFS number of volumes, snapshots has zero
> impact on avg speed of interactions over VFS layer.
> 
> If you will be able present real impact of the fragmentation (again
> *if*) this may trigger other actions.
> So AFAIK no one been able to deliver real numbers or scenarios about
> such impact.
> And *if* such impact really exist one of the solutions may be just
> mimic what ZFS is doing (maybe there are other solutions).
> 
> So please show us test unit exposing problem with measurement
> methodology presenting pathology related to fragmentation.
> 
>> Bees is, btw, not about defragmentation: I have some OS containers
>> running and I want to deduplicate data after updates.
> 
> Deduplication done in userspace has natural consequences in form of
> security issues.
> executable doing such things will need full access to everything and
> needs to have exposed some API/ABI allowing fiddle with content of the
> btrfs. Which adds second batch of security related risks.
> 
> Try to have look how deduplication is working in case of ZFS without
> offline deduplication.
You mean how it eats tons of RAM and gives nearly no benefit in most 
cases compared to just using transparent compression?  Online 
deduplication like ZFS offers has issues too.
> 
>>> In other words if someone is thinking that such defragmentation daemon
>>> is solving any problems he/she may be 100% right .. such person is
>>> only *thinking* that this is truth.
>>
>> Bees is not about that.
> 
> I've been only trying to say that I would be really surprised if bees
> will be taking care of such scenarios.
> 
>>> So first show that fragmentation is hurting latency of the
>>> access to btrfs data and it will be possible to measurable such
>>> impact. Before you will start measuring this you need to learn how o
>>> sample for example VFS layer latency. Do you know how to do this to
>>> deliver such proof?
>>
>> You didn't get the point. You only read "defragmentation" and your
>> alarm lights lid up. You even think bees would be a defragmenter. It
>> probably is more the opposite because it introduces more fragments in
>> exchange for more reflinks.
> 
> So you are asking to start investing in the development time
> implementing something without proving or demonstrating that problem
> is real?
> No matter how long someone will be thinking about this it will change nothing.
> 
> [..]
>> Can we please not start a flame war just because you hate defrag tools?
> 
> Really I have no idea where I wrote that I hate defragmentation.
> Using ZFS as working and real example I've only told you that
> necessity to reduce fragmentation is NULL if you are following exact
> path.
> In your world you are trying to tell that you keys do not match to the
> locker in doors.
> I'm only trying to tell you that there are many doors without key hole
> which can be opened and closed.
> 
> I can only repeat that to trigger some actions about defragmentation
> first you need to *present* some case scenario exposing that the
> problem is real. I may even believe you that you may be right but
> engineering it is not something is possible to apply "believe" term.
> 
> Intuition always may be tricking you here that as long as impact is
> non-zero someone should take care of this.
> No. if this impact will be enough small this can be ignored as same as
> we are ignoring some consequences of the quantum physics in our life
> (probability that bucket of water standing on open fire may freeze
> instead boil according to quantum physics is always non-zero and
> despite this fact no one been able to observe something like this).
> In other words you need to show some *real numbers* which will show
> SCALE of the issue.
