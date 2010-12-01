From: Matt <jackdachef@gmail.com>
Subject: Re: dm-crypt barrier support is effective
Date: Wed, 1 Dec 2010 17:05:56 +0100
Message-ID: <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
	<4CD6B7FA.3050005@redhat.com>
	<AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
	<AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
	<20101107194547.GA12521@basil.fritz.box>
	<4CD71C8B.1050604@redhat.com>
	<20101107230508.GB17592@basil.fritz.box>
	<20101108145809.GD29714@redhat.com>
	<1289238930-sup-9765@think>
	<20101114205925.GA20451@redhat.com>
	<AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
	<4CE05A9E.9090204@redhat.com>
	<AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mike Snitzer <snitzer@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>,
	Chris Mason <chris.mason@oracle.com>, htejun@gmail.com
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 15, 2010 at 12:24 AM, Matt <jackdachef@gmail.com> wrote:
> On Sun, Nov 14, 2010 at 10:54 PM, Milan Broz <mbroz@redhat.com> wrote:
>> On 11/14/2010 10:49 PM, Matt wrote:
>>> only with the dm-crypt scaling patch I could observe the data-corruption
>>
>> even with v5 I sent on Friday?
>>
>> Are you sure that it is not related to some fs problem in 2.6.37-rc1?
>>
>> If it works on 2.6.36 without problems, it is probably problems somewhere
>> else (flush/fua conversion was trivial here - DM is still doing full flush
>> and there are no other changes in code IMHO.)
>>
>> Milan
>>
>
> Hi Milan,
>
> I'm aware of your new v5 patch (which should include several
> improvements (or potential fixes in my case) over the v3 patch)
>
> as I already wrote my schedule unfortunately currently doesn't allow
> me to test it
>
> * in the case of no corruption it would be nice to have 2.6.37-rc* running :)
>
> * in the case of data corruption that would mean restoring my system -
> since it's my production box and right now I don't have a fallback at
> reach
> at earliest I could give it a shot at the beginning of December. Then
> I could also test reiserfs and ext4 as a system partition to rule out
> that it's
> a ext4-specific thing (currently I'm running reiserfs on my system-partition).
>
> Thanks !
>
> Matt
>


OK guys,

I've updated my system to latest glibc 2.12.1-r3 (on gentoo) and gcc
hardened 4.5.1-r1 with 1.4 patchset which also uses pie (that one
should fix problems with graphite)

not much system changes besides that,

with those it worked fine with 2.6.36 and I couldn't observe any
filesystem corruption



the bad news is: I'm again seeing corruption (!) [on ext4, on the /
(root) partition]:

I was re-emerging/re-installing stuff - pretty trivial stuff actually
(which worked fine in the past): emerging gnome-base programs (gconf,
librsvg, nautilus, gnome-mount, gnome-vfs, gvfs, imagemagick,
xine-lib) and some others: terminal (from xfce), vtwm, rman, vala
(library), xclock, xload, atk, gtk+, vte

during that I noticed some corruption and programs kept failing to
configure/compile, saying that g++ was missing; I re-extracted gcc
(which I previously had made an backup-tarball), that seemed to help
for some time until programs again failed with some corrupted files
from gcc

so I re-emerged gcc (compiling it) and after it had finished the same
error occured I already had written about in an previous email:
the content of /etc/env.d/03opengl got corrupted - but NOT the whole file:

normally it's
# Configuration file for eselect
# This file has been automatically generated.
LDPATH=
OPENGL_PROFILE=
<-- where the path to the graphics-drivers and the opengl profile is written;

in this case of the corruption it only where @@@@@@@@@@@@
symbols


I have no clue how this file could be connected with gcc


===> so the No.1 trigger of this kind of corruption where files are
empty, missing or the content gets corrupted (at least for me) is
compiling software which is part of the system (e.g. emerge -e
system);

the system is Gentoo ~amd64; with binutils 2.20.51.0.12 (afaik this
one has changed from 2.20.51.0.10 to 2.20.51.0.12 from my last
report); gcc 4.5.1 (Gentoo Hardened 4.5.1-r1 p1.4, pie-0.4.5) <--
works fine with 2.6.36 and 2.6.36.1

I'm not sure whether benchmarks would have the same "impact"



the kernel currently running is 2.6.37-rc4 with the [PATCH v5] dm
crypt: scale to multiple CPUs

besides that additional patchsets are applied (I apologize that it's
not only plain vanilla with the dm-crypt patch):
* Prevent kswapd dumping excessive amounts of memory in response to
high-order allocation
* ext4: coordinate data-only flush requests sent by fsync
* vmscan: protect executable page from inactive list scan
* writeback livelock fixes v2

I originally had hoped that the mentioned patch in "ext4: coordinate
data-only flush requests sent by fsync", namely: "md: Call
blk_queue_flush() to establish flush/fua" and additional changes &
fixes to 2.6.37-rc4 would once and for all fix problems but it didn't

I'm also using the the writeback livelock fixes and the dm-crypt scale
to multiple CPUs with 2.6.36 so those generally work fine

so it has be something that changed from 2.6.36->2.6.37 within
dm-crypt or other parts that gets stressed and breaks during usage of
the "[PATCH v5] dm crypt: scale to multiple CPUs" patch

the other included patches surely won't be the cause for that (100%).

Filesystem corruption only seems to occur on the / (root) where the
system resides -

Fortunately I haven't encountered any corruption on my /home partition
which also uses ext4 and during rsync'ing from /home to other data
partitions with ext4 and xfs (I don't want to try to seriously corrupt
any of my data so I played it safe from the beginning and didn't use
anything heavy such as virtualmachines, etc.) - browsing the web,
using firefox & chromium, amarok, etc. worked fine so far

the system is in a pretty "new" state - which means I extracted it
from a tarball out of an liveCD environment with 2.6.35 kernel to the
harddrive - 1st boot was to and 2.6.36 kernel where the 2.6.37-rc4*
kernel was compiled
2nd boot -> current uptime 4 hours

harddrive: Samsung HD203WI (no bad blocks reported by smartmontools,
also no corruptions reported by a run of badblocks (the tool) itself)

harddrive -> cryptsetup -> LVM (volume group: system and swap) -> on
system: ext4

lvm-version is 2.02.74; cryptsetup 1.1.3;
mount options:
noatime,commit=60,barrier=1

currently the system is still running

@Tejun, Milan, Mike:
is there something like the following from reiser4 but for ext4 that
you could use to identify the problem:
--> debugfs.reiser4 -P <device> | bzip2 -c > <device>.bz2

I read about debugfs and catastrophic mode but I have no clue how that
should help

If you need any more info please tell, otherwise I'll wipe that system
and revert back to 2.6.36

I really hope that someone with the big boxes can reproduce this

unfortunately bisecting under these consequences would be impossible
for me (I need to study; waiting hours until the first corruption
occurs ...)

to make things easier:

the first kernel of the 2.6.37-line I compiled was before 2.6.37-rc1
got tagged and was shortly after btrfs got merged:

which should be around:
http://git.eu.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=67577927e8d7a1f4b09b4992df640eadc6aacb36

that should help cut time to narrow possible causes ...

Thanks ! && Regards

Matt
