From: Nik Markovic <nmarkovi.navteq@gmail.com>
Subject: Re: Strange prformance degradation when COW writes happen at fixed offsets
Date: Fri, 24 Feb 2012 14:38:57 -0600
Message-ID: <CAB3q876D=jFQF8D+PypAkZM3Uuxgwmf+tjLB9m9Pb5JZsCHZTw@mail.gmail.com>
References: <CAB3q8748dryFek4UZnh+5__feqp_ffCX-VdZNkcs62B=X47Ghw@mail.gmail.com>
	<CAB3q874F+6HrjvxYduex3sKcskMYcVXOa_CqW6i1F=gDv8+u7g@mail.gmail.com>
	<pan.2012.02.24.06.38.07@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.02.24.06.38.07@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 24, 2012 at 12:38 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Nik Markovic posted on Thu, 23 Feb 2012 20:31:02 -0600 as excerpted:
>
>> I noticed a few errors in the script that I used. I corrected it and=
 it
>> seems that degradation is occurring even at fully random writes:
>
> I don't have an ssd, but is it possible that you're simply seeing era=
se-
> block related degradation due to multi-write-block sized erase-blocks=
?
>
> It seems to me that when originally written to the btrfs-on-ssd, the =
file
> will likely be written block-sequentially enough that the file as a w=
hole
> takes up relatively few erase-blocks. =A0As you COW-write individual
> blocks, they'll be written elsewhere, perhaps all the changed blocks =
to a
> new erase-block, perhaps each to a different erase block.

This is a very interesting insight. I wasn't even aware of the
erase-block issue, so I did some reading up on it...

>
> As you increase the successive COW generation count, the file's file-
> system/write blocks will be spread thru more and more erase-blocks,
> basically fragmentation but of the SSD-critical type, into more and m=
ore
> erase blocks, thus affecting modification and removal time but not re=
ad
> time.

OK, so time to write would increase due to fragmentation and writing,
it now makes sense (though I don't see why small writes would affect
this, but my concerns are not writes anyway), but why would cp
--reflink time increase so much. Yes, new extents would be created,
but btrfs doesn't write into data blocks, does it? I figured its
metadata would be kept in one place. I figure the only thing BTRFS
would do on cp --reflink=3Dalways:
1. Take a collection of extents owned by source.
2. Make the new copy use the same collection of extents.
3. Write the collection of extents to the "directory".

Now this process seems to be CPU intensive. When I remove or make a
reflink copy, one core pikes up to 100%, which tells me that there's a
performance issue there, not an ssd issue. Also, only one CPU thread
is being used for this. I figured that I can improve this by some
setting. Maybe thread_pool mount option? Are there any updates in
later kernels that I should possibly pick up?

>
> IIRC I saw a note about this on the wiki, in regard to the nodatacow
> mount-option. =A0Let's see if I can find it again. =A0Hmm... yes...
>
> http://btrfs.ipv5.de/index.php?title=3DGetting_started#Mount_Options
>
> In particular this (for nodatacow, read the rest as there's additiona=
l
> implications):
>
>>>>>>
> Performance gain is usually < 5% unless the workload is random writes=
 to
> large database files, where the difference can become very large.
> <<<<<
>

Unless I am wrong, this would disable COW completely and reflink copy.
Reflinks are a crucial component and the sole
reason I picked BTRFS for the system that I am writing for my company.
The autodefrag option addresses multiple writes. Writing is not the
problem, but cp --reflink should be near-instant. That was the reason
we chose BTRFS over ZFS, which seemed to be the only feasible
alternative. ZFS snapshot complicate the design and deduplication copy
time is the same as (or not much better than) raw copy.

> In addition to nodatacow, see the note on the autodefrag option.
>
> IOW, with the repeated generations of random-writes to cow-copies, yo=
u're
> apparently triggering a cow-worst-case fragmentation situation. =A0It
> shouldn't affect read-time much on SSD, but it certainly will affect =
copy
> and erase time, as the data and metadata (which as you'll recall is 2=
X by
> default on btrfs) gets written to more and more blocks that need upda=
ted
> at copy/erase time,
>
>
> That /might/ be the problem triggering the freezes you noted that set=
 off
> the original investigation as well, if the SSD firmware is running ou=
t of
> erase blocks and having to pause access while it rearranges data to a=
llow
> operations to continue. =A0Since your original issue on "rotating rus=
t"
> drives was fragmentation, rewriting would seem to be something you do
> quite a lot of, triggering different but similar-cause issues on SSDs=
 as
> well.
>
> FWIW, with that sort of database-style workload, large files constant=
ly
> random-change rewritten, something like xfs might be more appropriate
> than btrfs. =A0See the recent xfs presentations (were they at ScaleX =
or
> LinuxConf.au? both happened about the same time and were covered in t=
he
> same LWN weekly edition) as covered a couple weeks ago on LWN for mor=
e.
>

As I mentioned above, the COW is the crucial component of our system,
XFS won't do. Our system does not do random writes. In fact it is
mainly heavy on read operation. The system does occasional "rotation
of rust" on large files in a way that version control system would
(large files are modified and then used as a new baseline)

> --
> Duncan - List replies preferred. =A0 No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master." =A0Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

Thanks for all your help on this issue. I hope that someone can point
out some more tweaks or added features/fixes after 3.2 RC5 that I may
do.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
