From: Christian Brunner <chb@muc.de>
Subject: Re: [3.2-rc7] slowdown, warning + oops creating lots of files
Date: Sat, 7 Jan 2012 22:34:58 +0100
Message-ID: <CAO47_--5T1_ud+d+nhpY0o93PaH5UyHdXOE1ve=B7weLGQrvSA@mail.gmail.com>
References: <20120104214445.GE17026@dastard>
	<20120104221105.GF17026@dastard>
	<4F04D178.2070006@csamuel.org>
	<20120104230122.GA24466@dastard>
	<20120105184657.GC30372@shiny>
	<20120105194500.GD30372@shiny>
	<20120105201216.GG24466@dastard>
	<20120105210255.GE30372@shiny>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120105210255.GE30372@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2012/1/5 Chris Mason <chris.mason@oracle.com>:
> On Fri, Jan 06, 2012 at 07:12:16AM +1100, Dave Chinner wrote:
>> On Thu, Jan 05, 2012 at 02:45:00PM -0500, Chris Mason wrote:
>> > On Thu, Jan 05, 2012 at 01:46:57PM -0500, Chris Mason wrote:
>> > > On Thu, Jan 05, 2012 at 10:01:22AM +1100, Dave Chinner wrote:
>> > > > On Thu, Jan 05, 2012 at 09:23:52AM +1100, Chris Samuel wrote:
>> > > > > On 05/01/12 09:11, Dave Chinner wrote:
>> > > > >
>> > > > > > Looks to be reproducable.
>> > > > >
>> > > > > Does this happen with rc6 ?
>> > > >
>> > > > I haven't tried. All I'm doing is running some benchmarks to g=
et
>> > > > numbers for a talk I'm giving about improvements in XFS metada=
ta
>> > > > scalability, so I wanted to update my last set of numbers from
>> > > > 2.6.39.
>> > > >
>> > > > As it was, these benchmarks also failed on btrfs with oopsen a=
nd
>> > > > corruptions back in 2.6.39 time frame. =A0e.g. same VM, same
>> > > > test, different crashes, similar slowdowns as reported here:
>> > > > http://comments.gmane.org/gmane.comp.file-systems.btrfs/11062
>> > > >
>> > > > Given that there is now a history of this simple test uncoveri=
ng
>> > > > problems, perhaps this is a test that should be run more regul=
arly
>> > > > by btrfs developers?
>> > >
>> > > Unfortunately, this one works for me. =A0I'll try it again and s=
ee if I
>> > > can push harder. =A0If not, I'll see if I can trade beer for som=
e
>> > > diagnostic runs.
>> >
>> > Aha, if I try it just on the ssd instead of on my full array it tr=
iggers
>> > at 88M files. =A0Great.
>>
>> Good to know. =A0The error that is generating the BUG on my machine =
is
>> -28 (ENOSPC). =A0Given there's 17TB free on my filesystem....
>
> Yeah, same thing here. =A0I'm testing a fix now, it's pretty dumb. =A0=
We're
> not allocating more metadata chunks from the drive because of where t=
he
> allocation is happening, so it is just a check for "do we need a new
> chunk" in the right place.
>
> I'll make sure it can fill my ssd and then send to you.

Could you send the patch to the list (or to me), please? Telling from
what you mentioned on IRC this sounds quite interesting and I would
like to see if this solves my performance problems with ceph, too...

Thanks,
Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
