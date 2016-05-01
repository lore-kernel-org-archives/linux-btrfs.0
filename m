Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50095 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbcEAMrP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 May 2016 08:47:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1awqmF-0001d2-PF
	for linux-btrfs@vger.kernel.org; Sun, 01 May 2016 14:47:11 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 May 2016 14:47:11 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 May 2016 14:47:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
Date: Sun, 1 May 2016 12:47:00 +0000 (UTC)
Message-ID: <pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sun, 01 May 2016 09:00:46 +0200 as excerpted:

> I'm not sure what triggeres this, neither if it is btrfs specific. The
> filesystems have been recreated from scratch. Mainly during my rsync
> backup (from btrfs to btrfs), but not necessarily limited to rsync
> usage, my system experiences uninterruptable freezes of commands like
> "df", "du", "btrfs fs sync", and probably more.
> 
> I created a backtrace in dmesg using sysrq+w. Here's the log:
> (https://gist.github.com/kakra/8e6a2b7ac4047fa9e345648664f5667b)

FWIW, that link give me the github "this is not the web page you are
looking for" 404 error...  Do you have it set private or something?

Anyway...

> [92481.503505] sysrq: SysRq : Show Blocked State
> [92481.503511]   task                        PC stack   pid father
> [92481.503603] ksysguardd      D 00000000000141c0     0 32516      1 0x00000004
> [92481.503609]  ffff880231748c00 ffff88032a468000 ffff88032a467bc0 ffff880231748c00
> [92481.503612]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000 ffffffff817167cc
> [92481.503615]  7fffffffffffffff ffffffff817190df ffff88032a467bc0 ffffffff810b4d99
> [92481.503617] Call Trace:
> [92481.503625]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
> [92481.503630]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
> [92481.503635]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
> [92481.503639]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
> [92481.503642]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
> [92481.503646]  [<ffffffff81717012>] ? wait_for_completion+0x92/0xf0
> [92481.503649]  [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60
> [92481.503652]  [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> [92481.503654]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> [92481.503657]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> [92481.503660]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> [92481.503662]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> [92481.503665]  [<ffffffff8117ddc8>] ? path_lookupat+0x58/0x100
> [92481.503667]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> [92481.503671]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> [92481.503674]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> [92481.503677]  [<ffffffff8119cc8a>] ? user_statfs+0x2a/0x80
> [92481.503679]  [<ffffffff8119ccf0>] ? SYSC_statfs+0x10/0x30
> [92481.503683]  [<ffffffff8103ea53>] ? __do_page_fault+0x1a3/0x400
> [92481.503686]  [<ffffffff81719cd7>] ? entry_SYSCALL_64_fastpath+0x12/0x6a
> [92481.503688] trash.so        D 00000000000141c0     0   449   1478 0x00000004
> [92481.503691]  ffff8802ee5b1800 ffff88022c720000 ffff88022c71fb70 ffff8802ee5b1800
> [92481.503694]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000 ffffffff817167cc
> [92481.503697]  7fffffffffffffff ffffffff817190df ffff88022c71fb70 ffffffff810b4d99
> [92481.503699] Call Trace:
> [92481.503702]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
> [92481.503706]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
> [92481.503709]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
> [92481.503712]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
> [92481.503714]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
> [92481.503717]  [<ffffffff81717012>] ? wait_for_completion+0x92/0xf0
> [92481.503720]  [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60
> [92481.503722]  [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> [92481.503724]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> [92481.503727]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> [92481.503729]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> [92481.503731]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> [92481.503734]  [<ffffffff8117d973>] ? link_path_walk+0x163/0x4f0
> [92481.503736]  [<ffffffff8117c4d1>] ? path_init+0x1f1/0x330
> [92481.503738]  [<ffffffff8117dde7>] ? path_lookupat+0x77/0x100
> [92481.503741]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> [92481.503743]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> [92481.503746]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> [92481.503749]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
> [92481.503752]  [<ffffffff81176ddd>] ? SYSC_newlstat+0x1d/0x40
> [92481.503754]  [<ffffffff8117271d>] ? vfs_write+0x13d/0x180
> [92481.503757]  [<ffffffff811734a1>] ? SyS_write+0x61/0x90
> [92481.503760]  [<ffffffff810f5175>] ? from_kuid_munged+0x5/0x10
> [92481.503763]  [<ffffffff81719cd7>] ? entry_SYSCALL_64_fastpath+0x12/0x6a
> [92481.503766] ksysguardd      D 00000000000141c0     0  9869      1 0x00000004
> [92481.503769]  ffff880092012400 ffff880203868000 ffff880203867bc0 ffff880092012400
> [92481.503771]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000 ffffffff817167cc
> [92481.503774]  7fffffffffffffff ffffffff817190df ffff880203867bc0 ffffffff810b4d99
> [92481.503776] Call Trace:
> [92481.503779]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
> [92481.503782]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
> [92481.503786]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
> [92481.503789]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
> [92481.503791]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
> [92481.503794]  [<ffffffff81717012>] ? wait_for_completion+0x92/0xf0
> [92481.503797]  [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60
> [92481.503799]  [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> [92481.503801]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> [92481.503803]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> [92481.503806]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> [92481.503808]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> [92481.503810]  [<ffffffff8117ddc8>] ? path_lookupat+0x58/0x100
> [92481.503813]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> [92481.503815]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> [92481.503818]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> [92481.503820]  [<ffffffff8119cc8a>] ? user_statfs+0x2a/0x80
> [92481.503822]  [<ffffffff8119ccf0>] ? SYSC_statfs+0x10/0x30
> [92481.503825]  [<ffffffff8103ea53>] ? __do_page_fault+0x1a3/0x400
> [92481.503827]  [<ffffffff81719cd7>] ? entry_SYSCALL_64_fastpath+0x12/0x6a
> [92481.503830] trash.so        D 0000000000000000     0 14351   1478 0x00000004
> [92481.503833]  ffff8803072ac800 ffff8800438fc000 ffff8800438fbb70 ffff8803072ac800
> [92481.503835]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000 ffffffff817167cc
> [92481.503838]  7fffffffffffffff ffffffff817190df 0000000000000010 0000000000000287
> [92481.503841] Call Trace:
> [92481.503844]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
> [92481.503847]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
> [92481.503850]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
> [92481.503852]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
> [92481.503855]  [<ffffffff81717012>] ? wait_for_completion+0x92/0xf0
> [92481.503858]  [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60
> [92481.503860]  [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> [92481.503862]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> [92481.503864]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> [92481.503866]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> [92481.503869]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> [92481.503871]  [<ffffffff8117d973>] ? link_path_walk+0x163/0x4f0
> [92481.503873]  [<ffffffff8117c4d1>] ? path_init+0x1f1/0x330
> [92481.503876]  [<ffffffff8117dde7>] ? path_lookupat+0x77/0x100
> [92481.503878]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> [92481.503880]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> [92481.503883]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> [92481.503886]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
> [92481.503889]  [<ffffffff81176ddd>] ? SYSC_newlstat+0x1d/0x40
> [92481.503891]  [<ffffffff8117271d>] ? vfs_write+0x13d/0x180
> [92481.503893]  [<ffffffff811734a1>] ? SyS_write+0x61/0x90
> [92481.503895]  [<ffffffff810f5175>] ? from_kuid_munged+0x5/0x10
> [92481.503898]  [<ffffffff81719cd7>] ? entry_SYSCALL_64_fastpath+0x12/0x6a
> [92481.503901] trash.so        D 0000000000000000     0 17062   1478 0x00000004
> [92481.503903]  ffff880350ee4800 ffff8801e4d5c000 ffff8801e4d5bb70 ffff880350ee4800
> [92481.503906]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000 ffffffff817167cc
> [92481.503908]  7fffffffffffffff ffffffff817190df ffff8801e4d5bb70 ffffffff810b4d99
> [92481.503911] Call Trace:
> [92481.503914]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
> [92481.503917]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
> [92481.503920]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
> [92481.503923]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
> [92481.503925]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
> [92481.503928]  [<ffffffff81717012>] ? wait_for_completion+0x92/0xf0
> [92481.503931]  [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60
> [92481.503934]  [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> [92481.503936]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> [92481.503938]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> [92481.503940]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> [92481.503942]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> [92481.503945]  [<ffffffff8117d973>] ? link_path_walk+0x163/0x4f0
> [92481.503947]  [<ffffffff8117c4d1>] ? path_init+0x1f1/0x330
> [92481.503949]  [<ffffffff8117dde7>] ? path_lookupat+0x77/0x100
> [92481.503951]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> [92481.503954]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> [92481.503956]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> [92481.503959]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
> [92481.503962]  [<ffffffff81176ddd>] ? SYSC_newlstat+0x1d/0x40
> [92481.503964]  [<ffffffff8117271d>] ? vfs_write+0x13d/0x180
> [92481.503966]  [<ffffffff811734a1>] ? SyS_write+0x61/0x90
> [92481.503969]  [<ffffffff810f5175>] ? from_kuid_munged+0x5/0x10
> [92481.503971]  [<ffffffff81719cd7>] ? entry_SYSCALL_64_fastpath+0x12/0x6a
> [92481.503973] df              D 00000000000141c0     0 20885  20797 0x00000004
> [92481.503976]  ffff8803c42e6000 ffff8801001b4000 ffff8801001b3bd0 ffff8803c42e6000
> [92481.503979]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000 ffffffff817167cc
> [92481.503981]  7fffffffffffffff ffffffff817190df ffff8801001b3bd0 ffffffff810b4d99
> [92481.503984] Call Trace:
> [92481.503987]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
> [92481.503990]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
> [92481.503993]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
> [92481.503996]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
> [92481.503999]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
> [92481.504002]  [<ffffffff81717012>] ? wait_for_completion+0x92/0xf0
> [92481.504005]  [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60
> [92481.504007]  [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> [92481.504009]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> [92481.504011]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> [92481.504013]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> [92481.504016]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> [92481.504018]  [<ffffffff8117ddc8>] ? path_lookupat+0x58/0x100
> [92481.504020]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> [92481.504023]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> [92481.504026]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> [92481.504028]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
> [92481.504031]  [<ffffffff81176d9a>] ? SYSC_newstat+0x1a/0x40
> [92481.504034]  [<ffffffff81719cd7>] ? entry_SYSCALL_64_fastpath+0x12/0x6a

IIRC you're on gentoo as I am.  It's interesting how close our systems are
to each other, and yet how far away.  Based on the ksysguardd above, I'm
guessing you run kde, as I do, and we both use claws for mail (tho messages
here will say pan, as I use it for news and do my mailing lists as news via
gmane.org's list2news service).

But I run a pretty stripped down kde; nothing like automount (the autofs4
in your traces) at all, the baloo parts of plasma-workspace and
plasma-desktop patched out at build time so I can use a virtual
"null-package" baloo from my overlay that installs no files and has no
dependencies to fill the dep (easier than patching it out of the ebuild,
unfortunately the hoops I gotta go thru now that they dumped the
semantic-desktop USE flag for kde/frameworks/plasma5); similarly the
runtime-only udisks dep is filled by a null-package as I don't need or
want those features and definitely don't want to pull in all its deps, etc.

But with kde so heavily stripped down, mostly only the basic desktop and
many of the games, it's reasonably easy to run the live-9999 ebuilds from
the gentoo/kde overlay and use smart-live-rebuild to only rebuild packages
with new commits, so I'm actually running live-git kde, for the parts of
kde I have installed at all, anyway. =:^)


To the issue at hand...

As you know I'm a btrfs user, not a dev.  However, if I'm not mistaken,
the D after each of the apps indicates the same "disk sleep" status
you'd see in top and the like, for apps waiting on IO.

Further, each of the listed apps appears to be waiting at the same
schedule function, basically yielding the cpu to other apps until the
filesystem returns what they're looking for, up the call stack to
obviously each of the apps doing a file operation, apparently write in
some cases, stat on some not-yet-cached file in other cases.

Looks to me pretty normal, just waiting for access to the disk when
something else is hogging all the (limited) disk bandwidth.  Nothing
like btrfs worker threads hung up, etc, that would make it
btrfs-specific.


Meanwhile, du isn't in the traces above (tho df is), but you mention
it in the title and first paragraph, so it's worth noting that du,
unlike df, generally crawls the directory trees you point it at to
get the space used by all the files in all the dirs, recursively,
so it'll do much more IO than something like df, which in general is
a far faster call to the filesystem, asking for a single set of stats
that the filesystem can normally return without crawling a big
directory tree.

But obviously the df call here was waiting for /something/ from disk.
Maybe it was actually still trying to load the df binary itself?  (df
doesn't load but three libs, the linux-vdso kernel-virtual being one
of them, the ld loader itself, and the libc, pretty basic and the two
actual file-based libs, the loader itself and libc, will obviously be
cached, so it shouldn't block on loading them.)


As for btrfs fi sync, that's going to force-write-out all dirty
write-cache for that filesystem, so if it's called on the btrfs
the rsync is writing to, that's likely to block for quite some time
waiting for all those writes to flush, as well.

If btrfs filesystem sync is called on a _different_ btrfs, AND that
independent btrfs is on an entirely separate physical device (AND
that separate physical device isn't on the same legacy IDE cable or
SATA port-multiplier), THEN btrfs filesystem sync should return
relatively fast, compared to a general sync at least, since it
will only flush that separate filesystem, not all filesystems as
would a general sync.


Meanwhile, general IO scheduling is a somewhat different subject.
I believe the kernel does try to prioritize reads over writes,
pushing them to the front of the queue, which should get them
addressed and any apps only waiting on reads unstuck faster,
but on spinning rust, it can still take some time.

But there are at least two possible large problems.  One is
BIOS related and on many systems, not configurable at all, tho
on higher end server or gaming systems it can be, the other
is kernel IO tuning.

The BIOS related one, and I'm not sure it even applies to PCIE,
as the old system I had with the option was a pre-PCIE server
board with high-speed PCIX (and AGP still, remember that? =:^)
but not PCIE, has to do with IO thruput vs. responsiveness.
Unfortunately IDR what it was called exactly, but the settings
were IIRC powers of two from something like 16 MB (IIRC) up thru
128 or 256 MB.  Lower settings were more responsive, but 
would slow total thruput in certain use-cases as there was
more command and bus overhead.

The reason I still mention this here at all is that with the
higher settings, I definitely had IO-related lagginess in a lot
of things, including mouse movement (freeze-and-jump syndrome)
and even audio playback (dropouts).  I tried a bunch of kernel
adjustments, etc, but the problem in this case was below the
kernel in the BIOS settings, and wasn't fixed until I decided
to try lowering that setting to IIRC 32 MB (or whatever), after
which the problem simply disappeared!

The point being, sometimes it's nothing the kernel can really
control!  Of course that general primary point applies regardless
of whether there's anything like that specific setting in more
modern PCIE style hardware, which is why I still mentioned it.


Meanwhile, what kernel IO scheduler do you use (deadline, noop,
cfq,... cfq is the normal default)?  Do you use either normal
process nice/priority or ionice to control the rsync?  What
about cgroups?

And finally, what are your sysctl aka /proc/sys/vm settings for
dirty_* and vfs_cache_pressure?  Have you modified these from
defaults at all, either by changing your /etc/sysctl.(d|conf)
vm.* settings, or by writing directly to the files in
/proc/sys/vm, say at bootup (which is what changing the sysctl
config actually does)?

Because the default cache settings as a percent of memory were
setup back when memory was much smaller, and many people argue
that on today's multi-GiB memory machines, they allow far too
much dirty content to accumulate in cache before triggering
writeback, particularly for slow spinning rust.  When the time
expiry is set to 30 seconds but the amount of dirty data allowed
to accumulate before triggering high priority writeback is near
a minute's worth of writeback activity, something's wrong,
and that's very often a large part of the reason people see
IO related freezes in other processes trying to read stuff
off disk, as well as other lagginess on occasion (tho as
touched on above, that's rarer these days, due to point-to-
point buses such as PCIE and SATA, as opposed to the old
shared buses of PCI and EIDE).


FWIW, while I have ssds for the main system now, I already
had my system tuned in this regard:

1) I set things like emerge, kernel building, rsync, etc,
to idle/batch priority (19 niceness), which is more
efficient for cpu scheduling batch processes as they get
longer time slices but at idle/lowest priority so they
don't disturb other tasks much.

Additionally, for the cfq IO scheduler, it sees the idle
cpu priority and automatically lowers IO priority as well,
so manual use of ionice isn't necessary.  (I don't believe
the other schedulers account for this, however, which is
one reason I asked about them, above.)

For something like rsync that's normally IO-bound anyway,
the primary effect would be the automatic IO-nicing due
to the process nicing.

That was pretty effective at that level.  But combined
with #2, it's even more so.

2) I tuned my vm.dirty settings to trigger at much
lower sizes for both low priority background writeback
and higher priority foreground writeback.  You can
check the kernel's procfs documentation for the
specific settings if you like, but here's what I have
for my 16 GiB system (ssd now as I said, but I saw
no reason to change it from the spinning rust settings
I had, particularly since I still use spinning rust
for my media partition).

Direct from that section of my /etc/sysctl.conf:

################################################################################
# Virtual-machine: swap, write-cache

# vm.vfs_cache_pressure = 100
# vm.laptop_mode = 0
# vm.swappiness = 60
vm.swappiness = 100

# write-cache, foreground/background flushing
# vm.dirty_ratio = 10 (% of RAM)
# make it 3% of 16G ~ half a gig
vm.dirty_ratio = 3
# vm.dirty_bytes = 0

# vm.dirty_background_ratio = 5 (% of RAM)
# make it 1% of 16G ~ 160 M
vm.dirty_background_ratio = 1
# vm.dirty_background_bytes = 0

# vm.dirty_expire_centisecs = 2999 (30 sec)
# vm.dirty_writeback_centisecs = 499 (5 sec)
# make it 10 sec
vm.dirty_writeback_centisecs = 1000
################################################################################

The commented values are normal defaults.  Either ratio, percentage of RAM, or
direct bytes can be set.  Setting one clears (zeros) the other.  While the
ratio isn't of total RAM but of available RAM, total RAM's a reasonable
approximation on most modern systems.

Taking the foreground, vm.dirty_ratio setting first:

Spinning rust may be as low as 30 MiB/sec thruput, and 10% of 16 gig of RAM
is 1.6 gig, ~1600+ meg.  Doing the math that's ~53 seconds worth of writeback
accumulated by default, before it kicks into high priority writeback mode.
With a 30 second default timeout, that makes no sense at all as it's almost
double the timeout!

Besides, who wants to wait nearly a minute for it to dump all that?

So I set that to 3%, which with 16 gigs of RAM is ~half a gig, or about 16
seconds worth of writeback at 30 MB/sec.  That's only about half the 30
second time expiry and isn't /too/ bad to wait, tho you'll probably notice
if it takes that full 16 seconds.  But it's reasonable, and given
the integer setting and that we want background set lower, 3% is getting
about as low as practical.  (Obviously if I upped to 32 GiB RAM, I'd
want to switch to the bytes setting for this very reason.)

The background vm.dirty_background_ratio setting is where the lower
priority background writeback kicks in, so with luck the higher priority
foreground limit is never reached, tho it obviously will be for something
doing a lot of writing, like rsync often will.  So this should be lower
than foreground.

With foreground set to 3%, that doesn't leave much room for background, but 1%
is still reasonable.  That's about 160 MB or 5 seconds worth of writeback at
30 MB/sec, so it's reasonable.

As you can see, with the size triggers lowered to something reasonable, I
decided I could actually up the background time expiry from the default 5
seconds to 10.  That's still well and safely under the 30 second foreground
time expiry, and with the stronger size triggers I thought it was reasonable.

I haven't actually touched vfs_cache_pressure, but that's another related
knob you can twist.

I don't actually have any swap configured on my current machine (and
indeed, have it disabled in the kernel config) so the swappiness setting
doesn't matter, but I did have swap setup on my old 8 GiB machine.  I was
actually using the priority= option to set four swap partitions, one
each on four different devices, to the same priority, effectively
raid0-striping them.  My system was mdraid1 on the same four devices.
So I upped swappiness to 100 (it's more or less percentage, 0-100 range)
from its default 60, to force swapping out over dumping cache.  Even still,
I seldom went more than a few hundred MiB into swap, so the 8 GiB was
just about perfect for that 4-cores system.  (My new system has 6
cores and I figured the same 2 GiB per core.  I think now a more realistic
figure for my usage at least is say 4 GiB, plus a GiB per core, which 
seems to work out for both my old 4-core system with 8 gig RAM, and
my newer 6-core system where 12 gig of RAM would hit about the same
usage.  I have 16 gig, but seldom actually use the last 4 gig at all,
so 12 gig would be perfect, and then I might configure swap, just in
case.  But swap would be a waste with 16 gig since I literally seldom
use that last 4 gig even for cache anyway, so it's effectively my
overflow area.)

I used laptop mode, with laptop-mode-tools, on my netbook, the reason
it's comment-listed there as of-interest, but I've no reason to use
it on my main machine, which is wall-plug powered.  IIRC when active
it would try to flush everything possible once the disk was already
active, so it could spin down for longer between activations.
Laptop-mode-tools allows configuring a bunch of other stuff to toggle
between wall power and battery power as well, and of course one of
the other settings it changed was the above vm.dirty_* settings, to
much larger triggers and longer timeouts (upto 5 minutes or so,
tho I've read of people going to extremes and setting it to 15
minutes or even longer, tho that of course risks losing all that work
in a crash (!!)), again, to let the drive stay spun down for longer.


Between the two, setting much lower writeback cache size triggers,
and using a nice of 19 to set idle/batch mode for stuff like emerge
and rsync, after setting that bios setting on the old system as well,
responsiveness under heavy load, either IO or CPU, was MUCH better.

Hopefully you'll find it's similarly effective for you, assuming
you don't already have similar settings and are STILL seeing
the problem.

Of course for things like rsync, you could probably use ionice (with
the cfq io scheduler) instead and not bother doing normal nice on 
rsync, but because the cfq scheduler already effectively does ionice
on strongly niced processes, I didn't need to worry about it here.

As I said, with ssds I don't really need it that strict any more,
but I saw no need to change it, and indeed, with spinning rust still
for my media drive, it's still useful there.

So there it is.  Hope it's useful. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

