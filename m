Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39395 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdINURR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 16:17:17 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dsaZP-0001lM-Fs
        for linux-btrfs@vger.kernel.org; Thu, 14 Sep 2017 22:17:07 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: defragmenting best practice?
Date: Thu, 14 Sep 2017 22:17:07 +0200
Message-ID: <20170914221707.54ead089@jupiter.sol.kaishome.de>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
        <20170912162843.GA32233@rus.uni-stuttgart.de>
        <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
        <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
        <20170914172434.39eae89d@jupiter.sol.kaishome.de>
        <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 14 Sep 2017 18:48:54 +0100
schrieb Tomasz Kłoczko <kloczko.tomasz@gmail.com>:

> On 14 September 2017 at 16:24, Kai Krakow <hurikhan77@gmail.com>
> wrote: [..]
> > Getting e.g. boot files into read order or at least nearby improves
> > boot time a lot. Similar for loading applications.  
> 
> By how much it is possible to improve boot time?
> Just please some example which I can try to replay which ill be
> showing that we have similar results.
> I still have one one of my laptops with spindle on btrfs root fs ( and
> no other FSess in use) so I could be able to confirm that my numbers
> are enough close to your numbers.

I need to create a test setup because this system uses bcache. The
difference (according to systemd-analyze) between warm bcache and no
bcache at all ranges from 16-30s boot time vs. 3+ minutes boot time.

I could turn off bcache, do a boot trace, try to rearrange boot files,
boot again. However, that is not very reproducible as the current file
layout is not defined. It'd be better to setup a separate machine where
I could start over from a "well defined" state before applying
optimization steps to see the differences between different strategies.
At least readahead is not very helpful, I tested that in the past. It
reduces boot time just by a few seconds, maybe 20-30, thus going from
3+ minutes to 2+ minutes.

I still have an old laptop lying around: Single spindle, should make a
good test scenario. I'll have to see if I can get it back into shape.
It will take me some time.


> > Shake tries to
> > improve this by rewriting the files - and this works because file
> > systems (given enough free space) already do a very good job at
> > doing this. But constant system updates degrade this order over
> > time.  
> 
> OK. Please prepare some database, import some data which size will be
> few times of not used RAM (best if this multiplication factor will be
> at least 10). Then do some batch of selects measuring distribution
> latencies of those queries.

Well, this is pretty easy. Systemd-journald is a real beast when it
comes to cow fragmentation. Results can be easily generated and
reproduced. There are long traces of discussions in the systemd mailing
list and I simply decided to make the files nocow right from the start
and that fixed it for me. I can simply revert it and create benchmarks.


> This will give you some data about. not fragmented data.

Well, I would probably do it the other way around: Generate a
fragmented journal file (as that is how journald creates the file over
time), then rewrite it by some manner to reduce extents, then run
journal operations again on this file. Does it bother you to turn this
around?


> Then on next stage try to apply some number of update queries and
> after reboot the system or drop all caches. and repeat the same set of
> selects.
> After this all what you need to do is compare distribution of the
> latencies.

Which tool to use to measure which latencies?

Speaking of latencies: What's of interest here is perceived
performance resulting mostly from seek overhead (except probably in the
journal file case which just overwhelmes by the pure amount of
extents). I'm not sure if measuring VFS latencies would provide any
useful insights here. VFS probably works fast enough still in this
case.


> > It really doesn't matter if some big file is laid out in 1
> > allocation of 1 GB or in 250 allocations of 4MB: It really doesn't
> > make a big difference.
> >
> > Recombining extents into bigger once, tho, can make a big
> > difference in an aging btrfs, even on SSDs.  
> 
> That it may be an issue with using extents.

I can't follow why you argue that a file with thousands of extents vs
a file of same size but only a few extents would makes no difference to
operate on. And of course this has to do with extents. But btrfs uses
extents. Do you suggest to use ZFS instead?

Due to how cow works, the effect would probably be less or barely
noticable for writes, but read scanning through the file becomes slow
with clearly more "noise" from the moving heads.


> Again: please show some results of some test unit which anyone will be
> able to reply and confirm or not that this effect really exist.
> 
> If problem really exist and is related ot extents you should have real
> scenario explanation why ZFS is not using extents.

That was never the discussion. You brought in the ZFS point. I read
about the design reasoning behind ZFS when it appeared and started gain
public interest years back.


> btrfs is not to far from classic approach do FS because it srill uses
> allocation structures.
> This is not the case in context of ZFS because this technology has no
> information about what is already allocates.

What about btrfs free space tree? Isn't that more or less the same? But
I don't believe that makes a significant difference for desktop-sized
storages. I think introduction of free space tree was due to
performance of many-TB file systems up to petabyte storage (and beyond
of course).


> ZFS uses free lists so by negation whatever is not on free list is
> already allocated.
> I'm not trying to point that ZFS is better but only point that by
> changing allocation strategy you may not be blasted by something like
> some extents bottleneck (which sill needs to be proven)

Reasoning behind using block-oriented allocation probably has more to
do with providing efficient vdevs and snapshotting. Using extents for
that has some nasty (and obvious) downsides if you think about it, like
slack space from only partially shared extents. I guess that is why
bees rewrites extent and then shares them again using EXTENT_SAME
IOCTL. It generates a lot of writes just to free some unused extent
slack.


> There are at least few very good reason why it is even necessary to
> change sometimes strategy from allocations structures to free lists.
> First: ZFS free list management is very similar to known from Linux
> memory SLAB allocator.
> Did you heard that someone needs to do system memory defragnentation
> because fragmented memory adds some additional latency to memory
> access?

64 bit systems tend to have enough address space that this is not an
issue. But it can easily become an issue if you fill the page tables or
use huge pages a lot. There's really something like memory
fragmentation but you usually don't defragment memory (and yes, such
products existed in the past for unnamed popular "OS"es but that is
snake oil).

And I can totally follow why free lists are better here, you don't need
to explain that.

BTW: Do you really compare RAM to spindle storage now? Latency for RAM
access is clearly more an electrical than a mechanical problem and also
very predictable and thus static, like it is with SSDs.


> Other consequence is that with growing size of the files and number of
> files or directories FS metadata are growing exponentially with size
> and numbers of such objects.

I'm not sure if this holds true for every implementation out there. You
can make it pretty linear if you wanted to (but you don't).


> In case of free lists there is no such
> growth and all structures are growing with linear correlation.

Why is that so? Can you illustrate examples?

Well, of course lists are linear, trees are not. But lists become slow.
So if you implement free lists as trees, I don't think that growth is
strictly linear. That's just not how trees work. And a list will become
slow at some point.

BTW: The slab memory allocator indeed has to handle fragmentation
issues. And it can become slow if used in wrong ways.

Slab uses a triple linked list to keep track of allocations, free items
and mixed times (items that hold allocated and free objects). I think
you can compare btrfs chunks and extents to how slab manages memory. A
full btrfs chunk would be tracked as a full slab item, a free chunk as
free item, and the rest is mixed.

When inserting objects into slab this would compare to btrfs extents.
You will have some slack because you cannot optimally fit all different
sized extents into a chunk. If you deallocate objects (thus remove an
extent), you'll get fragmented free space.

I think btrfs pretty well knows where such free space exists, and it
can find it. But if it has to start looking in the mixed case, it will
be harder to find fitting space (especially an optimal fit).

Slab will struggle the same problem. But is has to move no heads for
this. And I think slab matches objects into different size buckets to
alleviate such problems where possible. I think even ZFS differentiates
block sizes into different buckets for more performant and optimal
handling. Btrfs has to try to fit it with a lot of strategies to
optimize this: Will the extent grow shortly? Should I allocate now or
later? Maybe later would provide a better fit?

But it is a good strategy for most workloads but not the best party
with CoW.


> Caching in memory free list data takes much less than caching b-trees.
> Last thing is effort on deallocating something in FS with allocation
> structure and with free lists.
> In classic approach number of such operations is growing with depth
> of b-trees. In case free list all hat you need to do is compare ctime
> of the allocated block with volume or snapshot ctime to make decision
> about return or not block to free list.

As noted above I can follow why this was chosen. But that's not the
topic here.

Btrfs has b-trees - that's what it is. It's not ZFS. It's not ext4. It
is btrfs. You say "btrfs needs no defragmentation, it makes no
difference in speed" but now you list the many flaws and performance
downsides of things different to ZFS. So maybe there is a benefit in
coalescing many small extents back into few big extents? Or there is a
benefit in coalescing free space all over the place into fewer chunks
as "btrfs balance" would do it?

Why are there these tools if it makes no difference to have them? When
there was no strong benefit, why did anyone bother with the effort of
programming this and putting infrastructure into the kernel for it when
the kernel is already clearly very complex? Why did anyone program
different file systems? We could have gone with ext4, or xfs (which
starts to support reflinks already). What's the point of autodefrag
when it's not needed?


> No matter how many snapshots, volumes, files or directories allays it
> will be *just one compare* of the block or vol/snapshot ctime.
> With necessity to do just only one compare comes way better
> predictable behavior of whole FS and simplicity of the code making
> such decisions.

You almost completely convinced me to ditch btrfs and use ZFS and
recommend it to everyone who feels the urge to "defragment" even only
one if her/his files...

How much RAM do I need again for ZFS to operate with good performance?


> In other words ZFS internally uses well know SLAB allocator with
> caching some data about best possible location to allocate some
> different sizes allocation unit size multiplied by n^2 like you can
> see on Linux in /proc/slabinfo in case of *kmalloc* SLABs.
> This is why in case of ZFS number of volumes, snapshots has zero
> impact on avg speed of interactions over VFS layer.

I'm feeling the whole discussion only started because you think
performance perception solely comes from VFS latencies. Is that so?


> If you will be able present real impact of the fragmentation (again
> *if*) this may trigger other actions.

I start guessing that the numbers I'd present are not convincing for
you because you only want to see VFS latencies. Please think of
something imaginary: Perceived performance *whoosh*

Sure, I can throw lots of RAM at the problem. I can throw SSDs at the
problem. I can introduce HBAs with huge caching capabilites. I can
throw ZFS with L2ARC and ZIL at it. Plus huge amounts of RAM. It's all
no problem, we actually do that for high performance, high cost
enterprise server machines. But the ordinary desktop user can probably
not effort that.


> So AFAIK no one been able to deliver real numbers or scenarios about
> such impact.
> And *if* such impact really exist one of the solutions may be just
> mimic what ZFS is doing (maybe there are other solutions).

No. Probably not. You cannot just replace btrfs infrastructure with
something else and still call it btrfs. And also, there would be no
migration path. And then: ZFS on Linux is already there. If I want ZFS,
I use it, and do not invest efforts to make something else into ZFS.

Remember the rules: If it's not broken, don't fix it. And also use the
tools that best fit. When we are faced with what is here, and it
improves things as a one shot solution for an acceptable period of time
- why not use it? I mean, McGyver would also use that bubble gum to
glue the lighter to a stick, and not walk to the next super glue store
to get the one and only valid way to glue lighters to sticks. The
bubble gum will do long enough to temporarily solve the problem.


> So please show us test unit exposing problem with measurement
> methodology presenting pathology related to fragmentation.

Yeah, I get it: Fragmentation is a non-issue.


> > Bees is, btw, not about defragmentation: I have some OS containers
> > running and I want to deduplicate data after updates.  
> 
> Deduplication done in userspace has natural consequences in form of
> security issues.

Yes, of course. It needs proper isolation. The kernel is already very
"bloated", do you really want another worker process doing complicated
things running directly in kernel space? This naturally introduces
stability issues (which, btw, also introduce security issues). What
about providing better interfaces for exactly such operations?


> executable doing such things will need full access to everything and
> needs to have exposed some API/ABI allowing fiddle with content of the
> btrfs. Which adds second batch of security related risks.

It depends on how much other interfaces such a process exposes. You can
use proper process isolation. And maybe you shouldn't run it on
untrusted machines. But then again: Personally, I'd not store sensitive
information there. If security is your concern, then don't bloat the
kernel with such things, and then simply don't run it. Every extra
process running can be a security issue. Everyone knows that.

> Try to have look how deduplication is working in case of ZFS without
> offline deduplication.

I didn't investigate the inner workings but I know it needs lots of
RAM.


> >> In other words if someone is thinking that such defragmentation
> >> daemon is solving any problems he/she may be 100% right .. such
> >> person is only *thinking* that this is truth.  
> >
> > Bees is not about that.  
> 
> I've been only trying to say that I would be really surprised if bees
> will be taking care of such scenarios.

It at least tries to not be totally inefficient and as far as I read
the code and docs, it removes extent slack by recombining and
resplitting extents using data-safe kernel operations. But not for the
sake of defragmenting.


> >> So first show that fragmentation is hurting latency of the
> >> access to btrfs data and it will be possible to measurable such
> >> impact. Before you will start measuring this you need to learn how
> >> o sample for example VFS layer latency. Do you know how to do this
> >> to deliver such proof?  
> >
> > You didn't get the point. You only read "defragmentation" and your
> > alarm lights lid up. You even think bees would be a defragmenter. It
> > probably is more the opposite because it introduces more fragments
> > in exchange for more reflinks.  
> 
> So you are asking to start investing in the development time
> implementing something without proving or demonstrating that problem
> is real?

No, you did ask for it between the lines. You are taking about
latencies of single access. It is probably no problem. BTW: You don't
need to prove that to me.

But - personal experience - when it takes me to search the system
journal 30-40s, and when I defragmented the file, it takes just 3-4
seconds? What does this have to do with VFS layer latencies? Nothing!

I'm even in the same boat with you saying the the many file accesses
are still all low latency at the VFS layer. But boy, they are so much
more! That is perceived performance. Fragmentation makes a performance
difference. That takes no scientific approach to believe that. The fix
is already implemented: defrag the extents. The kernel has an IOCTL for
this.

Now, leverage the tools for it: To fasten a screw, you use a screw
driver. You don't built it yourself, you take it from you toolbox. The
screw is already there, the screw driver is there. Nothing to invent.
McGyver wouldn't build one himself when one was already lying around.


> No matter how long someone will be thinking about this it will change
> nothing.

Probably the right conclusion. So let's take the tools that are here,
or switch to a better fitting file system (which, btw, is also a tool
that is available).


> [..]
> > Can we please not start a flame war just because you hate defrag
> > tools?  
> 
> Really I have no idea where I wrote that I hate defragmentation.
> Using ZFS as working and real example I've only told you that
> necessity to reduce fragmentation is NULL if you are following exact
> path.

Yes, I'll provide data for systemd journal access. And please, not
another thread about that application.


> In your world you are trying to tell that you keys do not match to the
> locker in doors.

No, the key is just under the carpet. Use it, and turn it in the right
direction.


> I'm only trying to tell you that there are many doors without key hole
> which can be opened and closed.

That is insecure. *scnr


> I can only repeat that to trigger some actions about defragmentation
> first you need to *present* some case scenario exposing that the
> problem is real. I may even believe you that you may be right but
> engineering it is not something is possible to apply "believe" term.

Okay, no more hints about useful software because btrfs already has
everything you ever need.

Seriously, I didn't ask for fixing anything in btrfs. I hinted two
tools that the OP could benefit from when using snapshots and handling
fragmented files and asking for best practice. And I didn't recommend
to defragment the whole filesystem all day long because it will give
you a speed boost of 100+%.

You jumped the train and said that defragmentation is never needed,
because btrfs does all this perfectly already, while later telling how
much better zfs does everything, then telling that extent allocation is
the problem. Ah yes, we get to the point... But well, that's a
non-issue because VFS latencies are not the problem except I
scientifically prove it. No one wanted to go so far and deep. Really.

Fragmented files with lots of small extents? Defragment this file. Did
it help?

  Yes, okay that's your tool, the problem comes from the CoW
nature. Also, please use bees if you are planning to defrag files part
of the snapshot reflinks or undo operations. Maybe btrfs doesn't fit
your workload then.

  If no, okay let's look at the underlying problem. Now it's time to do
all this scientific stuff and so on.

But this has totally been hijacked with no chance for the OP to follow
this thread sanely.


> Intuition always may be tricking you here that as long as impact is
> non-zero someone should take care of this.

Yes, if access to the file is slow, I rewrite it with some tool, and
now it's fast. I must have been totally tricked. God, how dare I to
measure the time with a clock and not some block tracing debug tool
from the kernel...

And if I rearrange boot files on a spindle and the system comes up in
30s now like a fresh build instead of in 2 minutes... I must have been
tricked. Okay, it was Windows. But really, tell me: What does Windows
do what Linux wouldn't do during boot? Read files? Nah... I can deduce
that it has an effect even on Linux, I'm just still into finding and
making the right tool for it while meanwhile I circumvented it with
bcache.

And please, I don't use those shiny snake oil defraggers with even
counterproductive effects on the file system. I'm not a dumb non-tech
reader born this millenium, I'm not clicking those click-bait articles
"defragment your harddrive for speed". I'm looking into the technical
workings behind this (and other stuff), since almost 30 years. There are
only very very few tools available that do defrag right. And I know
exactly 2, one for NTFS, one for ext3.

But in the FOSS world, I can at least improve that. But maybe I
shouldn't even try, because there is no problem. And there's nothing to
fix.


> No. if this impact will be enough small this can be ignored as same as
> we are ignoring some consequences of the quantum physics in our life
> (probability that bucket of water standing on open fire may freeze
> instead boil according to quantum physics is always non-zero and
> despite this fact no one been able to observe something like this).
> In other words you need to show some *real numbers* which will show
> SCALE of the issue.

Quantum physics is - literally - when you try to plug your USB thumb
drive and it doesn't fit, turn it around, try again, and it doesn't
fit, then look at it and try again, and it fits. And that is a perfect
example for what the Schrödinger experiment really stands.

Try that with your water example, it won't work so easily. ;-)


-- 
Regards,
Kai

Replies to list-only preferred.


