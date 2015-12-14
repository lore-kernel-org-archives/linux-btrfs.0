Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56544 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbbLNKvV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 05:51:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a8Qis-0002Bm-Un
	for linux-btrfs@vger.kernel.org; Mon, 14 Dec 2015 11:51:19 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 11:51:18 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 11:51:18 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
Date: Mon, 14 Dec 2015 10:51:11 +0000 (UTC)
Message-ID: <pan$ebb43$1588cbbe$750076d0$4848c51f@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
	<20151126003342.GA24333@carfax.org.uk>
	<1450057495.2388.40.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Mon, 14 Dec 2015 02:44:55 +0100 as
excerpted:

> Two more on these:
> 
> On Thu, 2015-11-26 at 00:33 +0000, Hugo Mills wrote:
>> 3) When I would actually disable datacow for e.g. a subvolume that
>> > holds VMs or DBs... what are all the implications?

>> After snapshotting, modifications are CoWed precisely once, and
>> then it reverts to nodatacow again. This means that making a snapshot
>> of a nodatacow object will cause it to fragment as writes are made to
>> it.

> AFAIU, the one the get's fragmented then is the snapshot, right, and the
> "original" will stay in place where it was? (Which is of course good,
> because one probably marked it nodatacow, to avoid that fragmentation
> problem on internal writes).

No.  Or more precisely, keep in mind that from btrfs' perspective, in 
terms of reflinks, once made, there's no "original" in terms of special 
treatment, all references to the extent are treated the same.

What a snapshot actually does is create another reference (reflink) to an 
extent.  What btrfs normally does on change as a cow-based filesystem is 
of course copy-on-write the change.  What nocow does, in the absence of 
other references to that extent, is rewrite the change in-place.

But if there's another reference to that extent, the change can't be in-
place because that would change the file reached by that other reference 
as well, and the change was only to be made to one of them.  So in the 
case of nocow, a cow1 (one-time-cow) exception must be made, rewriting 
the changed data to a new location, as the old location continues to be 
referenced by at least one other reflink.

So (with the fact that writable snapshots are available and thus it can 
be the snapshot that changed if it's what was written to) the one that 
gets the changed fragment written elsewhere, thus getting fragmented, is 
the one that changed, whether that's the working copy or the snapshot of 
that working copy.

> I'd assume the same happens when I do a reflink cp.

Yes.  It's the same reflinking mechanism, after all.  If there's other 
reflinks to the extent, snapshot or otherwise, changes must be written 
elsewhere, even if they'd otherwise be nocow.

> Can one make a copy, where one still has atomicity (which I guess
> implies CoW) but where the destination file isn't heavily fragmented
> afterwards,... i.e. there's some pre-allocation, and then cp really does
> copy each block (just everything's at the state of time where I stared
> cp, not including any other internal changes made on the source in
> between).

The way that's handled is via ro snapshots which are then copied, which 
of course is what btrfs send does (at least in non-incremental mode, and 
incremental mode still uses the ro snapshot part to get atomicity), in 
effect.

> And one more:
> You both said, auto-defrag is generally recommended.
> Does that also apply for SSDs (where we want to avoid unnecessary
> writes)?
> It does seem to get enabled, when SSD mode is detected.
> What would it actually do on an SSD?

Did you mean it does _not_ seem to get (automatically) enabled, when SSD 
mode is detected, or that it _does_ seem to get enabled, when 
specifically included in the mount options, even on SSDs?

Or did you actually mean it the way you wrote it, that it seems to be 
enabled (implying automatically, along with ssd), when ssd mode is 
detected?

Because the latter would be a shock to me, as that behavior hasn't been 
documented anywhere, but I can't imagine it's actually doing it and that 
you actually meant what you actually wrote.


If you look waaayyy back to shortly before I did my first more or less 
permanent deployment (I had initially posted some questions and did an 
initial experimental deployment several months earlier, but it didn't 
last long, because $reasons), you'll see a post I made to the list with 
pretty much the same general question, autodefrag on ssd, or not.

I believe the most accurate short answer is that the benefit of 
autodefrag on SSD is fuzzy, and thus left to local choice/policy, without 
an official recommendation either way.

There are two points that we know for certain: (1) the zero-seek-time of 
SSD effectively nullifies the biggest and most direct cost associated 
with fragmentation on spinning rust, thereby lessening the advantage of 
autodefrag as seen on spinning rust by an equally large degree, and (2) 
autodefrag will without question lead to a relatively limited number of 
near-time additional writes, as the rewrite is queued and eventually 
processed.

To the extent that an admin considers these undisputed factors alone, or 
weighs them less heavily than the more controversial factors below, 
they're likely to consider autodefrag on ssd a net negative and leave it 
off.

But I was persuaded by the discussion when I asked the question, to 
enable autodefrag on my all-ssd btrfs deployment here.  Why?  Those 
other, less direct and arguably less directly measurable (except possibly 
by actual detail benchmarking or a/b deployment testing over long 
periods).

There are three factors I'm aware of here as well, all favoring 
autodefrag, just as the two above favored leaving it off.

1) IOPS, Input/Output Operations Per Second.  SSDs typically have both an 
IOPS and a throughput rating.  And unlike spinning rust, where raw non-
sequential-write IOPS are generally bottlenecked by seek times, on SSDs 
with their zero seek-times, IOPS can actually be the bottleneck.

Now I'm /far/ from a hardware storage device expert and thus may be badly 
misconstruing things here, but at least as I understand things, reading/
writing a single extent/fragment is typically issued as a single IO 
operation (to some maximum size), and particularly at the higher 
throughput speeds ssds commonly have and with their zero-seek-times, it's 
quite possible to bottleneck on the number of such operations, hitting 
the IOPS ceiling on either the device itself or its controller, if files 
are highly fragmented and/or there's multiple tasks doing IO to the same 
device at once.

Back when I first setup btrfs on my then new SSDs, I didn't know a whole 
lot about SSDs and this was my primary reason for choosing autodefrag; 
less fragmentation means larger IO operations so fewer of them are 
necessary to complete the data transfer, placing a lower stress on the 
device controllers and making it less likely to bottleneck on the IOPS 
limits.

2) SSD physical write and erase block sizes as multiples of the logical/
read block size.  To the extent that extent sizes are multiples of the 
write and/or erase-block size, writing larger extents will reduce write 
amplification due to writing and blocks smaller than the write or erase 
block size.

While the initial autodefrag rewrite is a second-cycle write after a 
fragmented write, spending a write cycle for the autodefrag, consistent 
use of autodefrag should help keep file fragmentation and thus ultimately 
space fragmentation to a minimum, so initial writes, where there's enough 
data to write an initially large extent, won't be forced to be broken 
into smaller extents because there's simply no large free-space extents 
left due to space fragmentation.

IOW, autodefrag used consistently should reduce space fragmentation as 
well as file fragmentation, and this reduced space fragmentation will 
lead to the possibility of writing larger extents initially, where the 
amount of data to be written allows it, thereby reducing initial file 
write fragmentation and the need for autodefrag as a result.

This one dawned on me somewhat later, after I understood a bit more about 
SSDs and write amplification due to physical write and erase block 
sizing. I was in the process of explaining (in the context of spinning 
rust) how autodefrag used consistently should help manage space 
fragmentation as well, when I suddenly realized the implications that had 
on SSDs as well, due to their larger physical write and erase block sizes.

3) Btrfs metadata management overhead.  While btrfs tracks things like 
checksums at fixed sizes, other metadata is per extent.  Obviously, the 
more extents a file has, the harder btrfs has to work to track them all.  
Maintenance tasks such as balance and check already have scaling issues; 
do we really want to make them worse by forcing them to track thousands 
or tens of thousands of extents per (large) file where they could be 
tracking a dozen or two?

Autodefrag helps keep the work btrfs itself has to do under control, and 
in some contexts, that alone can be worth any write-amplification costs.


On balance, I was persuaded to use autodefrag on my own btrfs' on SSDs, 
and believe the near-term write-cycle damage may in fact be largely 
counteracted by indirect free-space defrag effect and the effect that in 
turn has on the ability to even find large areas of cohesive free space 
to write into in the first place.  With that largely counteracted, the 
other benefits in my mind again outweigh the negatives, so autodefrag 
continues to be worth it in general, even on SSDs.

But I can definitely see how someone could logically take the opposing 
position, and without someone actually doing either some pretty complex 
benchmarks or some longer term a/b testing where autodefrag's longer term 
effect on free space fragmentation can come into play, against just 
letting things fragment as they will on the other side, in enough 
different usage scenarios to be convincing for the general purpose case 
as well, it's unlikely the debate will ever be properly resolved.

I suppose someone will eventually do that sort of testing, but of course 
even if they did it now, with btrfs code still to be optimized and 
various scaling work still to be done, it's anyone's guess if the test 
results would still apply a few years down the road, after that scaling 
and optimization work.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

