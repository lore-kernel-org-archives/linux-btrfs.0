Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:43112 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205AbaL1AGQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 19:06:16 -0500
Message-ID: <549F4975.7060009@pobox.com>
Date: Sat, 27 Dec 2014 16:06:13 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
References: <3738341.y7uRQFcLJH@merkaba> <4232026.31LFOYpm2s@merkaba> <20141227093043.GJ25267@carfax.org.uk> <2235526.D1sZ4Blnlh@merkaba> <549EC829.8080808@pobox.com> <20141227162642.GK25267@carfax.org.uk>
In-Reply-To: <20141227162642.GK25267@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Semi off-topic questions...

On 12/27/2014 08:26 AM, Hugo Mills wrote:
>     This is... badly mistaken, at best. The problem of where to write a
> file into a set of free extents is definitely *not* an NP-hard
> problem. It's a P problem, with an O(n log n) solution, where n is the
> number of free extents in the free space cache. The simple approach:
> fill the first hole with as many bytes as you can, then move on to the
> next hole. More complex: order the free extents by size first. Both of
> these are O(n log n) algorithms, given an efficient general-purpose
> index of free space.

Which algorithm is actually in use?

Is any attempt made to keep subsequent allocations in the same data extent?

All of "best fit", "first fit", and "first encountered" allocation have 
terrible distribution graphs over time.

Without a knod to locality, discontiguous allocation will have 
staggeringly bad after-effects in terms of read-ahead.

>
>     The problem of placing file data isn't a bin-packing problem; it's
> not like allocating RAM (where each allocation must be contiguous).
> The items being placed may be split as much as you like, although
> minimising the amount of splitting is a goal.

How is compression and re-compression handled? If a linear extent is 
compressed to find its on-disk size in bytes, and then there isn't an 
extent large enough to fit it, it has to be cut, then recompressed, then 
searched again right?

How does the system look for the right cut? How iterative can this get? 
Does it always try cutting in half? Does it shave single bytes off the 
end? Does it add one byte at a time till it reaches the size of the 
extent its looking at?

Can you get down to a point where you are placing data in five or ten 
byte chunks somehow? (e.g. what's the smallest chunk you can place? 
clearly if I open a multi-megabyte file and update a single word or byte 
it's not going to land in metadata from my reading of the code.) One 
could easily end up with a couple million free extents of just a few 
bytes each, particularly if largest-first allocation is used.

The degenerate cases here do come straight from the various packing 
problems. You may not be executing any of those packing algorithms but 
once you ignore enough of those issues in the easy cases your free space 
will be a fine pink mist suspended in space. (both an explosion analogy 
and a reference to pink noise 8-) ).

>     I suspect that the performance problems that Martin is seeing may
> indeed be related to free space fragmentation, in that finding and
> creating all of those tiny extents for a huge file is causing
> problems. I believe that btrfs isn't alone in this, but it may well be
> showing the problem to a far greater degree than other FSes. I don't
> have figures to compare, I'm afraid.

>
>> I also don't know what kind of tool you are using, but it might be
>> repeatedly trying and failing to fallocate the file as a single
>> extent or something equally dumb.
>
>     Userspace doesn't as far as I know, get to make that decision. I've
> just read the fallocate(2) man page, and it says nothing at all about
> the contiguity of the extent(s) storage allocated by the call.

Yep, my bad. But as soon as I saw that "fio" was starting two threads, 
one doing random read/write and another doing sequential read/write, 
both on the same file, it set off my "not just creating a file" mindset. 
Given the delayed write into/through the cache normally done by casual 
file io, It seemed likely that fio would be doing something more 
aggressive (like using O_DIRECT or repeated fdatasync() which could get 
very tit-for-tat).

Compare that to a VM in which the guest operating system "knows" it has, 
and has used, its "disk space" internally, and the subsequent async 
activity of the monitor to push that activity out to real storage which 
is usually quite pathological... well you can get into some super 
pernicious behavior over write ordering and infinite retries.

So I was wrong about fallocate per-se, applications can be incredibly 
dumb. For instance a VM might think its _inconceivable_ to get an ENOSPC 
while rewriting data it's just read from a file it "knows" has no holes etc.

Given how lots of code doesn't even check the results of many function 
calls... how many times have you seen code that doesn't look at the 
return value of fwrite() or printf()? Or one that, if it does something 
like if (bytes_written < size) retry_remainder(); So sure I was 
imagining an fallocate() in a loop or something equally dumb. 8-)

>
>     Hugo.
>
> [snip]
>

