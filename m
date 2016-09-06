Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33612 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753617AbcIFMcQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 08:32:16 -0400
Received: by mail-oi0-f67.google.com with SMTP id w78so8627246oie.0
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Sep 2016 05:32:16 -0700 (PDT)
Subject: Re: [OT] Re: Balancing subvolume on a specific device
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <df03a71c-8558-520c-af1b-ffb152f65a7d@davideddu.org>
 <20160819171734.GJ20440@carfax.org.uk>
 <pan$dbf6f$52e9f6f3$42f8cce4$2ebbbbc6@cox.net>
 <20160901214519.79d27445@jupiter.sol.kaishome.de>
 <pan$97e1b$477b3a63$5742ac9b$a63fe8a6@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ba97bb60-7b59-9fe0-b255-a39c6ab4e420@gmail.com>
Date: Tue, 6 Sep 2016 08:32:02 -0400
MIME-Version: 1.0
In-Reply-To: <pan$97e1b$477b3a63$5742ac9b$a63fe8a6@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-02 06:55, Duncan wrote:
> Kai Krakow posted on Thu, 01 Sep 2016 21:45:19 +0200 as excerpted:
>
>> Am Sat, 20 Aug 2016 06:30:11 +0000 (UTC)
>> schrieb Duncan <1i5t5.duncan@cox.net>:
>>
>>> There's at least three other options to try to get what you mention,
>>> however.  FWIW, I'm a gentooer and thus build everything from sources
>>> here, and use ccache myself.  What I do is put all my build stuff, the
>>> gentoo git and assorted overlay git trees, ccache, kernel sources, the
>>> binpkg cache, etc, all on a separate "build" btrfs on normal
>>> partitions, / not/ a subvolume.  That way it can go wherever I want,
>>> and it, along with the main system (/) and /home, but /not/ my media
>>> partition (all of which are fully independent filesystems on their own
>>> partitions, most of them btrfs raid1 on a parallel set of partitions on
>>> a pair of ssds), on ssd. Works great. =:^)
>>
>> Off topic: Is ccache really that helpful? I dumped it a few years ago
>> after getting some build errors and/or packaging bugs with it (software
>> that would just segfault when built with ccache), and in the end it
>> didn't give a serious speed boost anyways after comparing the genlop
>> results.
>
> Two comments on ccache...
>
> 1) ccache hasn't caused me any serious issues in over a decade of gentoo
> usage, including some periods with various hardware issues.  The few
> problems I /did/ have at one point were related to crashes while building
> and thus corruption of the ccache, but those errors were pretty easily
> identified as ccache errors (IDR what the specifics were, but something
> about corrupted input files that really made no sense /except/ in the
> context of ccache or serious hardware error and I wasn't seeing anything
> else related to the latter, so it was pretty clear) and easily enough
> fixed by setting CCACHE_RECACHE=1 (write-only mode, basically) for the
> specific packages in question, to flush out the corruption by writing
> uncorrupted new copies of the files in question.
>
> 2a) ccache won't help a lot with ordinary new-version upgrade-cycle
> builds, at least with portage, because the build-path is part of the
> hash, and portage's default build path includes the package and version
> number, so for upgrades, the path and therefore the hash will be
> different, resulting in a ccache miss on a new version build, even if
> it's the exact same command building the exact same sources.
>
> Similarly, rebuilds of the same sources using the same commands but after
> tool (gcc, etc) upgrades won't hash-match (nor would you want them to as
> rebuilding with the new version is usually the point), because the hashes
> on the tools themselves don't match.
>
> This is why ccache is no longer recommended for ordinary gentooers -- the
> hit rate simply doesn't justify it.
>
> 2b) cache *does*, however, help in two types of circumstances:
>
> 2bi) In ordinary usage, particularly during test compiles in the
> configure step, some limited code (here test code) is repeatedly built
> with identical commands and paths.  This is where the hits that /are/
> generated during normal upgrade usage normally come from, and they can
> speed things up somewhat.  However, it's a pretty limited effect and this
> by itself doesn't really justify usage.
>
> More measurably practical would be rebuilds of existing versions with
> existing tools, perhaps because a library dep upgrade forces it
> (intermediate objects involving that library will hash-fail and be
> rebuilt, but objects internal to the package itself or only involving
> other libs should hash-check and cache-hit), or due to some ebuild change
> (like a USE flag change with --newuse) not involving a version bump.
> There is often a rather marked ccache related speedup in this sort of
> rebuild, but again, while it does happen for most users, it normally
> doesn't happen /enough/ to be worth the trouble.
>
> But some users do still run ccache for this case, particularly if like me
> they really REALLY hate to see a big build like firefox taking the same
> long time it did before, just to change a single USE flag or something.
>
> 2bii) Where ccache makes the MOST sense is where people are running large
> numbers of live-vcs builds with unchanging (9999) version numbers,
> probably via smart-live-rebuild checking to see what packages actually
> have new commits since the last build.
>
> I'm running live-git kde, tho a relatively lite version without packages
> I don't use and with (my own) patches to kill the core plasma semantic-
> desktop (baloo and friends) dependencies, since in my experience semantic-
> desktop and its deps simply *are* *not* *worth* *it* !!  That's 170+ kde-
> related packages, plus a few misc others, all live-git 9999 version,
> which means they build with the same version path and the upstream commit
> changes may be as small/simple as some minversion dep bump or l10n
> changes to some *.desktop file, neither of which change the code at all,
> so in those cases rebuilds should be 100% ccache hits, provided the
> ccache is big enough, of course.
>
> Again, live-git (or other live-vcs) rebuilds are where ccache REALLY
> shines, and because I run live-kde and other live-git builds, ccache
> still makes serious sense for me here.  Tho personally, I'd still be
> using it for the 2bi case of same-version and limited same-call within
> the same package build, as well, simply because I'm both already familiar
> with it, and would rather take a small overhead hit on other builds to
> speed up the relatively rare same-package-same-tools-rebuild case.
>
>
>> What would help a whole lot more would be to cache this really
>> really inefficient configure tool of hell which often runs much longer
>> than the build phase of the whole source itself.
>
> IDK if you were around back then, but some time ago there was a confcache
> project that tried to do just that.  But unfortunately, it was enough of
> a niche use-case (most folks just run binary distros and don't care, and
> others have switched to cmake or the like and don't care) and came with
> enough problem corner-cases that required upstream cooperation that
> wasn't coming as they didn't care, to fix, that the project was
> eventually given up.  =:^(
>
> The more modern workaround (not really a fix) for that problem seems to
> be parallel package builds.  Run enough at once and the configure stage
> latency doesn't seem so bad.
Alternatively, there's a mechanism (I think it's called something like 
config.local) that lets you pre-load certain things in the configure 
script.  Some things aren't safe to load here, but many package 
invariant things (like if you have working headers, or how malloc(0) 
returns, or similar things that are never going to change unless you 
change your CHOST) can be put here.  I don't know how much it may help 
speed things up (I don't use it right now myself), but it may be worth 
trying.
>
> Of course on standard gentoo, that's severely limited by the fact that
> the @system set and its deps are forced serial, the frustration of which
> built here until I got tired of it and very carefully negated the entire
> @system set, adding @world entries where necessary so critical packages
> weren't depcleaned.  Now even the core would-be @system set builds in
> parallel.
>
> Of course there are some risks to that in theory, but in practice, once
> the system is built and running in mostly just ongoing maintenance mode,
> I've not had a problem.  Maybe it's just because I know where to be
> careful, but it has worked fine for me, and it SURE reduced the
> frustration of watching all those forced-serial core update builds go by
> one-at-a-time.
>
>> I now moved to building inside tmpfs (/var/tmp/portage mounted as 32GB
>> tmpfs with x-systemd.automount), added around 30GB of swap space just in
>> case. I'm running on 16GB of RAM and found around half of my RAM almost
>> always sits there doing nothing. Even building chromium and libreoffice
>> at the same time shows no problems with this setup. Plus, it's a whole
>> lot faster than building on the native fs (even if I'm using bcache).
>> And I'm building more relaxed since my SSD is wearing slower - Gentoo
>> emerge can put a lot of burden on the storage.
>
> I've run with PORTAGE_TMPDIR and PKG_TMPDIR pointed at tmpfs for I guess
> half a decade at least, now.  No swap and 16 GiB RAM now, tho I was
> running it with 6 GiB RAM and generally not going much into swap (even
> with swappiness=100) for quite awhile.  Tmpfs size now the default half
> of memory, so 8 gig.
For most things, 8G is more than enough.  On my systems, the biggest 
package I have is LLVM, with an average build directory size of about 
4G, and I've only rarely seen space usage in PORTAGE_TMPDIR go over 8G 
during a parallel build.
>
> But I don't have chromium or libreoffice installed, and recently I
> switched to upstream binpkg firefox due to gentoo package upgrade
> availability delays even of hard-masked in the mozilla overlay, so I
> don't even have to worry about firefox these days.  I guess my longest
> taking builds are now qtwebkit, both 4.x and 5.x, these days, and I've
> never had a problem with them and other builds in parallel.
>
> But part of the lack of parallel build problems may be because while I do
> have it active, I'm only running a 6-core, and I've found increasing load
> average significantly above the number of cores to be counterproductive,
> so I have MAKEOPTS="-j10 -l8" and portage configured with --jobs=12
> --load-average=6, so emphasis is clearly on giving existing builds more
> threads if they'll use them, to cores+2 load, and only going parallel
> package build if the load average drops under the number of cores.  That
> doesn't tend to test the tmpfs capacity limits at all.
>
> But for sure, PORTAGE_TMPDIR on tmpfs makes a **BIG** difference! =:^)
>
Pretty much the same here, I just don't use parallel builds ATM (I've 
had lots of ebuild bugs hit me recently, and it's a bit easier to debug 
such things if everything is serialized), and have an insane amount of 
swap space (64GB, but it's primarily because I sometimes do local 
processing of very large data sets and have my systems set to never 
overcommit virtual memory).  Even on my laptop which has an SSD which is 
almost as fast as the RAM, it still cuts build times by almost 20%.
