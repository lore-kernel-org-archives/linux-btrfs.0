Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:43784 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751266AbdDIAVW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 20:21:22 -0400
Subject: Re: About free space fragmentation, metadata write amplification and
 (no)ssd
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
 <22761.23640.216570.125948@tree.ty.sabi.co.uk>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <e3e2c13c-8f5d-2848-a3f6-759259d84d9d@mendix.com>
Date: Sun, 9 Apr 2017 02:21:19 +0200
MIME-Version: 1.0
In-Reply-To: <22761.23640.216570.125948@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/08/2017 11:55 PM, Peter Grandi wrote:
>> [ ... ] This post is way too long [ ... ]
> 
> Many thanks for your report, it is really useful, especially the
> details.

Thanks!

>> [ ... ] using rsync with --link-dest to btrfs while still
>> using rsync, but with btrfs subvolumes and snapshots [1]. [
>> ... ]  Currently there's ~35TiB of data present on the example
>> filesystem, with a total of just a bit more than 90000
>> subvolumes, in groups of 32 snapshots per remote host (daily
>> for 14 days, weekly for 3 months, montly for a year), so
>> that's about 2800 'groups' of them. Inside are millions and
>> millions and millions of files. And the best part is... it
>> just works. [ ... ]
> 
> That kind of arrangement, with a single large pool and very many
> many files and many subdirectories is a worst case scanario for
> any filesystem type, so it is amazing-ish that it works well so
> far, especially with 90,000 subvolumes.

Yes, this is one of the reasons for this post. Instead of only hearing
about problems all day on the mailing list and IRC, we need some more
reports of success.

The fundamental functionality of doing the cow snapshots, moo, and the
related subvolume removal on filesystem trees is so awesome. I have no
idea how we would have been able to continue this type of backup system
when btrfs was not available. Hardlinks and rm -rf was a total dead end
road.

The growth has been slow but steady (oops, fast and steady, I
immediately got corrected by our sales department), but anyway, steady.
This makes it possible to just let it do its thing every day and spot
small changes in behaviour over time, detect patterns that could be a
ticking time bomb and then deal with them in a way that allows conscious
decisions, well-tested changes and continous measurements of the result.

But, ok, it's surely not for the faint of heart, and the devil is in the
details. If it breaks, you keep the pieces. Using the NetApp hardware is
one of the relevant decisions made here. The shameful state of the most
basic case of recovering (or not be able to recover) a failure in a two
disk btrfs RAID1 is enough of a sign that the whole multi-disk handling
is a nice idea, but didn't get the amount of attention yet that it would
deserve to be something to be able to rely on (for me). Having the data
safe in my NetApp filer gives me the opportunity to do regular (like,
monthly) snapshots of the complete thing, so that I have something to go
back to if disaster would strike in linux land. Yes, it's a bit
inconvenient because I want to umount for a few minutes in a silent
moment of the week, but it's worth the effort, since I can keep the eggs
in a shadow basket.

OTOH, what we do with btrfs (taking a bulldozer and drive across all the
boundaries of sanity according to all recommendations and warnings) on
this scale of individual remotes is something that the NetApp people
should totally be jealous of. Backups management (manual create, restore
etc on top of the nightlies) is self service functionality for our
customers, and being able to implement the magic behind the APIs with
just a few commands like a btrfs sub snap and some rsync gives the right
amount of freedom and flexibility we need.

And, monitoring of trends is so. super. important. It's not a secret
that when I work with technology, I want to see what's going on in
there, crack the black box open and try to understand why the lights are
blinking in a specific pattern. What does this balance -dusage=75 mean?
Why does it know what's 75% full and I don't? Where does it get that
information from? The open source kernel code and the IOCTL API is a
source for many hours of happy hacking, because it allows all of this to
be done.

> As I mentioned elsewhere
> I would rather do a rotation of smaller volumes, to reduce risk,
> like "Duncan" also on this mailing list likes to do (perhaps to
> the opposite extreme).

Well, like seen in my 'keeps allocating new chunks for no apparent
reason' thread... even small filesystems can have really weird problems. :)

> As to the 'ssd'/'nossd' issue that is as described in 'man 5
> btrfs' (and I wonder whether 'ssd_spread' was tried too) but it
> is not at all obvious it should impact so much metadata
> handling. I'll add a new item in the "gotcha" list.

I suspect that the -o ssd behaviour is a decent source of the "help! my
filesystem is full but df says it's not" problems we see about every
week. But, I can't just argue that. Apart from that it was the very same
problem being the first thing that btrfs greeted me with when trying it
out for the first time a few years ago, (and it still is one of the
first problems people who start using btrfs encounter) I haven't spent
time to debug the behaviour when running fully allocated.

OTOH the two-step allocation process is also a nice thing, because I
*know* when I still have unallocated space available, which makes for
example the free space fragmentation debugging process much more bearable.

> It is sad that 'ssd' is used by default in your case, and it is
> quite perplexing that tghe "wandering trees" problem (that is
> "write amplification") is so large with 64KiB write clusters for
> metadata (and 'dup' profile for metadata).

A worst case 32x a 64KiB fits into 1x 2MiB. That is a bit of a bogus
argument, but take the extent tree changes (amount of leafs/nodes) it
causes to change, including all the wandering and shifting around of
items if they don't fit, and then the recursive updating, and it
apparently already makes a difference that causes an entire day of
writing metadata at Gigabit/s speed.

Notice that everyone who has rotational 0 in /sys is experiencing this
behaviour right now, when removing snapshots... and then they end up on
IRC complaining to us their computer is totally unusable for hours when
they remove some snapshots...

> * Probably the metadata and data cluster sizes should be create
>   or mount parameters instead of being implicit in the 'ssd'
>   option.
> * A cluster size of 2MiB for metadata and/or data presumably
>   has some downsides, otrherwise it would be the default. I
>   wonder whether the downsides related to barriers...

I don't know... yet. What I know is that adding options to tune things
will lead to users not setting them, or setting them to the wrong value.
It's a bit like having btrfs-zero-log, or --init-extent-tree. It just
doesn't work out in harsh reality.

-- 
Hans van Kranenburg
