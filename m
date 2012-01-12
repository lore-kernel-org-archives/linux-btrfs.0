From: Christian Brunner <chb@muc.de>
Subject: Re: [3.2-rc7] slowdown, warning + oops creating lots of files
Date: Thu, 12 Jan 2012 17:18:37 +0100
Message-ID: <CAO47_-_Jx9BV5FBs3vFtzzsh+Jo8FiQiXEdueR9DDgx2i4raXw@mail.gmail.com>
References: <20120104214445.GE17026@dastard>
	<20120104221105.GF17026@dastard>
	<4F04D178.2070006@csamuel.org>
	<20120104230122.GA24466@dastard>
	<20120105184657.GC30372@shiny>
	<20120105194500.GD30372@shiny>
	<20120105201216.GG24466@dastard>
	<20120105210255.GE30372@shiny>
	<CAO47_--5T1_ud+d+nhpY0o93PaH5UyHdXOE1ve=B7weLGQrvSA@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO47_--5T1_ud+d+nhpY0o93PaH5UyHdXOE1ve=B7weLGQrvSA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2012/1/7 Christian Brunner <chb@muc.de>:
> 2012/1/5 Chris Mason <chris.mason@oracle.com>:
>> On Fri, Jan 06, 2012 at 07:12:16AM +1100, Dave Chinner wrote:
>>> On Thu, Jan 05, 2012 at 02:45:00PM -0500, Chris Mason wrote:
>>> > On Thu, Jan 05, 2012 at 01:46:57PM -0500, Chris Mason wrote:
>>> > >
>>> > > Unfortunately, this one works for me. =A0I'll try it again and =
see if I
>>> > > can push harder. =A0If not, I'll see if I can trade beer for so=
me
>>> > > diagnostic runs.
>>> >
>>> > Aha, if I try it just on the ssd instead of on my full array it t=
riggers
>>> > at 88M files. =A0Great.
>>>
>>> Good to know. =A0The error that is generating the BUG on my machine=
 is
>>> -28 (ENOSPC). =A0Given there's 17TB free on my filesystem....
>>
>> Yeah, same thing here. =A0I'm testing a fix now, it's pretty dumb. =A0=
We're
>> not allocating more metadata chunks from the drive because of where =
the
>> allocation is happening, so it is just a check for "do we need a new
>> chunk" in the right place.
>>
>> I'll make sure it can fill my ssd and then send to you.
>
> Could you send the patch to the list (or to me), please? Telling from
> what you mentioned on IRC this sounds quite interesting and I would
> like to see if this solves my performance problems with ceph, too...

I apologize for bothering you again, but I would really like to give it=
 a spin.

Thanks,
Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
