From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Fri, 26 Aug 2011 08:24:45 +0200
Message-ID: <CANGUGtC1qk2Tkv42fvibUKiEJz_MnNiV-nQ7T-_woppVhjQK-Q@mail.gmail.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110825060632.GA9933@infradead.org>
	<20110825064039.GO3162@dastard>
	<0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
	<20110826013528.GW3162@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, viro@zeniv.linux.org.uk, dchinner@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110826013528.GW3162@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

2011/8/26 Dave Chinner <david@fromorbit.com>:
> On Thu, Aug 25, 2011 at 12:51:56AM -0600, Andreas Dilger wrote:
>> On 2011-08-25, at 12:40 AM, Dave Chinner wrote:
>> > On Thu, Aug 25, 2011 at 02:06:32AM -0400, Christoph Hellwig wrote:
>> >> On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
>> >>> This is a test to make sure seek_data/seek_hole is acting like i=
t does on
>> >>> Solaris. =A0It will check to see if the fs supports finding a ho=
le or not and will adjust as necessary.
>> >>
>> >> Can you resend this with any updates that happened in the meantim=
e?
>> >>
>> >> Dave also still had some comments about semantics, so it might be=
 worth
>> >> to incorporate that as well.
>> >
>> > The main questions I had when looking at this was how we should
>> > handle unwritten extents - the only answer I got was along the lin=
es
>> > of "we'll deal with that once filesystems have implemented
>> > something". That's a bit of a chicken-and-egg situation, and doesn=
't
>> > help me decide what is the best thing to do. I don't want to have =
to
>> > re-implement this code when it's decided i did the wrong thing
>> > initially.
>>
>> Let's first clarify what you mean by an unwritten extent? =A0Do you =
mean a
>> preallocated extent that returns 0 when read,
>
> Exactly that.
>
>> or do you mean a delayed
>> allocation extent that was written by the application that is still =
in
>> memory but not yet written to disk?
>
> That's not an unwritten extent - that's a delayed allocation extent ;=
)
>
>> Unfortunately, ZFS has no concept of preallocated extents, so we can=
't
>> look to it for precedent, but it definitely has delayed allocation.
>> Possibly if UFS on Solaris has SEEK_HOLE and also preallocated exten=
ts
>> (I have no idea) it could be tested?
>>
>> > The most basic question I really want answered is this:
>> >
>> > =A0 =A0 - is preallocated space a HOLE, or is it DATA?
>> >
>> > Whatever the answer, I think it should be consistently
>> > presented by all filesystems that support preallocation, and it
>> > should be encoded into the generic SEEK_HOLE/SEEK_DATA tests....
>>
>> My thought would be that a preallocated extent is still a HOLE, beca=
use
>> it doesn't contain data that an application actually cares about. =A0=
On
>> the other hand, a delalloc extent is DATA because it has something t=
hat
>> an application cares about.
>
> OK, that's the way I'd expect to treat both preallocated and
> delalloc space.
>
>> > Answering that question then helps answer the more complex questio=
ns
>> > I had, like:
>> >
>> > =A0 =A0 - what does SEEK_DATA return when you have a file layout
>> > =A0 =A0 =A0 like "hole-prealloc-data"?
>>
>> I would think only the "data" part, since that is what the definitio=
n
>> of "SEEK_DATA" is IMHO.
>
> Agreed, that's the way I'd interpret it, too. So perhaps we need to
> ensure that this interpretation is actually tested by this test?
>
> How about some definitions to work by:
>
> Data: a range of the file that contains valid data, regardless of
> whether it exists in memory or on disk. The valid data can be
> preceeded and/or followed by an arbitrary number of zero bytes
> dependent on the underlying implementation of hole detection.
>
> Hole: a range of the file that contains no data or is made up
> entirely of =A0NULL (zero) data. Holes include preallocated ranges of
> files that have not had actual data written to them.
>
> Does that make sense? It has sufficient flexibility in it for the

No for me. A hole is made up of zero data? It's a strange definition
for me. A hole is simply no data. With this definition a hole can be
start from a block with data but partially filled, and fs should check
instead of presence of a block, the data content. I don't like it very
much. For the fallocate case, we need only a simple rule: no check is
done beyond eof. At this point it's clear that we can check the file
block allocation till i_size, don't care if there are other blocks
allocated. I don't know if it's applicable even for unwritten extents
case.

Marco
