From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Honest timeline for btrfsck
Date: Wed, 28 Mar 2012 09:36:39 +0000 (UTC)
Message-ID: <pan.2012.03.28.09.36.38@cox.net>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
	<1312404713-sup-6548@shiny> <loom.20110818T030824-742@post.gmane.org>
	<1313700115-sup-2457@shiny> <jf42r4$fua$1@dough.gmane.org>
	<20120118011357.GO3658@shiny> <loom.20120328T080446-49@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Danny Piccirillo posted on Wed, 28 Mar 2012 06:15:41 +0000 as excerpted:

> Chris Mason <chris.mason <at> oracle.com> writes:
>> 
>> People have already started picking up #4, fujitsu had some patches in
>> this direction that we'll keep developing with.
>> 
>> I stepped back to add some directory metadata fixups as well to the
>> basic fsck tool.  I had thought I could easily do it all from the
>> kernel, but sometimes the userland side really is easier.
> 
> 
> Phoronix reported on your talk at the SCALE 10x conference here
> http://www.phoronix.com/scan.php?page=news_item&px=MTA0Njk
> 
> 
> What happened to the February 14th deadline? Is another rewrite
> underway? I think the biggest thing that can be done in lieu of the
> release is really good communication. There's no feed to get up-to-date
> info on what's being worked on, what's left, etc.

I too read the phoronix article, and in fact mentioned it here back about 
Feb 10 or so...

Actually, a somewhat-working repair-writing btrfsck does exist and is in 
fact "public"... for some value of "public", at least.  It's still sort 
of like the plans for the pan-galactic bypass in hitchhiker's guide to 
the galaxy, down several flights of stairs behind a door that says 
"beware of leopard", in that it's only available in Chris's 
"dangerdonteveruse" git branch, but it *IS* publicly available... as I 
said for /some/ value of "public" anyway.

Here's the issue, tho.  At present, it's pretty much a "well, it may fix 
some problems, but then again, it might wreak further havoc on an already 
damaged filesystem, destroying any reasonable chance of retrieving valid 
data off it, too!" type of situation.  That's why it's still stuck in 
"dangerdonteveruse".

But if you read the article well, that's all that was really promised 
anyway, at this point.  That was a deadline for Oracle getting it for 
testing and QA, etc.  It was *NOT* a "release quality" deadline, or even 
a "this matches the experimental state of the filesystem" deadline, in 
any shape or form.

So Oracle and others are doing some seriously focused QA and bug fixes on 
the thing at present.  The idea is that they can release it along with a 
kernel with their own patches, and support that.  It's worth noting, 
however, that if they're only supporting their own kernel, they can, if 
necessary, disable certain already available features of the filesystem 
in their kernel, AND in the btrfsck, so as to be able to support what's 
left.  After all, the filesystem itself is still officially experimental 
and in disk-format-flux, as well as lacking various targeted features 
ATM, and it's only a small stretch to go from there to disabling a 
feature or two already in mainline, if necessary to be able to be 
comfortable supporting the rest.


Bottom line:  Purely as a simple Linux user following this list for 
perhaps a couple months now, I'd expect btrfs to continue maturing and 
that it'll probably getting toward somewhat stable toward the end of the 
year... depending on how conservative you are, of course (there's many 
that are barely warming up to ext4 at this point).  Which would put it in 
line for the spring of next year (2013) distro releases.  Until then, I'd 
expect the current label, experimental, fit only for testing, not for 
storage of data you expect to be able to reliably retrieve, to continue 
to apply, tho to a lessor degree as it gradually matures.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

