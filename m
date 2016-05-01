Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57763 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbcEAQyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 May 2016 12:54:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1awudc-0001aw-JB
	for linux-btrfs@vger.kernel.org; Sun, 01 May 2016 18:54:32 +0200
Received: from ip5f5ae06c.dynamic.kabel-deutschland.de ([95.90.224.108])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 May 2016 18:54:32 +0200
Received: from hurikhan77 by ip5f5ae06c.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 May 2016 18:54:32 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
Date: Sun, 1 May 2016 18:54:18 +0200
Message-ID: <20160501185418.5a148cdd@jupiter.sol.kaishome.de>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
	<pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 1 May 2016 12:47:00 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Kai Krakow posted on Sun, 01 May 2016 09:00:46 +0200 as excerpted:
> 
> > I'm not sure what triggeres this, neither if it is btrfs specific.
> > The filesystems have been recreated from scratch. Mainly during my
> > rsync backup (from btrfs to btrfs), but not necessarily limited to
> > rsync usage, my system experiences uninterruptable freezes of
> > commands like "df", "du", "btrfs fs sync", and probably more.
> > 
> > I created a backtrace in dmesg using sysrq+w. Here's the log:
> > (https://gist.github.com/kakra/8e6a2b7ac4047fa9e345648664f5667b)  
> 
> FWIW, that link give me the github "this is not the web page you are
> looking for" 404 error...  Do you have it set private or something?

Yes it's private but it's working for me in an incognito window of
Chromium. So maybe you copied the closing bracket or something into the
URL? Or some temporary error?

> Anyway...

It's actually just what follows...

> > [92481.503505] sysrq: SysRq : Show Blocked State
> > [92481.503511]   task                        PC stack   pid father
> > [92481.503603] ksysguardd      D 00000000000141c0     0 32516
> > 1 0x00000004 [92481.503609]  ffff880231748c00 ffff88032a468000
> > ffff88032a467bc0 ffff880231748c00 [92481.503612]  ffff880403cd8f20
> > ffff880403cd8f00 0000000000000000 ffffffff817167cc [92481.503615]
> > 7fffffffffffffff ffffffff817190df ffff88032a467bc0 ffffffff810b4d99
> > [92481.503617] Call Trace: [92481.503625]  [<ffffffff817167cc>] ?
> > schedule+0x2c/0x80 [92481.503630]  [<ffffffff817190df>] ?
> > schedule_timeout+0x13f/0x1a0 [92481.503635]  [<ffffffff810b4d99>] ?
> > finish_wait+0x29/0x60 [92481.503639]  [<ffffffff81718229>] ?
> > mutex_lock+0x9/0x30 [92481.503642]  [<ffffffff811e0e23>] ?
> > autofs4_wait+0x433/0x710 [92481.503646]  [<ffffffff81717012>] ?
> > wait_for_completion+0x92/0xf0 [92481.503649]
> > [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60 [92481.503652]
> > [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> > [92481.503654]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> > [92481.503657]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> > [92481.503660]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> > [92481.503662]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> > [92481.503665]  [<ffffffff8117ddc8>] ? path_lookupat+0x58/0x100
> > [92481.503667]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> > [92481.503671]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> > [92481.503674]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> > [92481.503677]  [<ffffffff8119cc8a>] ? user_statfs+0x2a/0x80
> > [92481.503679]  [<ffffffff8119ccf0>] ? SYSC_statfs+0x10/0x30
> > [92481.503683]  [<ffffffff8103ea53>] ? __do_page_fault+0x1a3/0x400
> > [92481.503686]  [<ffffffff81719cd7>] ?
> > entry_SYSCALL_64_fastpath+0x12/0x6a [92481.503688] trash.so
> > D 00000000000141c0     0   449   1478 0x00000004 [92481.503691]
> > ffff8802ee5b1800 ffff88022c720000 ffff88022c71fb70 ffff8802ee5b1800
> > [92481.503694]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000
> > ffffffff817167cc [92481.503697]  7fffffffffffffff ffffffff817190df
> > ffff88022c71fb70 ffffffff810b4d99 [92481.503699] Call Trace:
> > [92481.503702]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
> > [92481.503706]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
> > [92481.503709]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
> > [92481.503712]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
> > [92481.503714]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
> > [92481.503717]  [<ffffffff81717012>] ?
> > wait_for_completion+0x92/0xf0 [92481.503720]
> > [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60 [92481.503722]
> > [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> > [92481.503724]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> > [92481.503727]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> > [92481.503729]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> > [92481.503731]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> > [92481.503734]  [<ffffffff8117d973>] ? link_path_walk+0x163/0x4f0
> > [92481.503736]  [<ffffffff8117c4d1>] ? path_init+0x1f1/0x330
> > [92481.503738]  [<ffffffff8117dde7>] ? path_lookupat+0x77/0x100
> > [92481.503741]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> > [92481.503743]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> > [92481.503746]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> > [92481.503749]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
> > [92481.503752]  [<ffffffff81176ddd>] ? SYSC_newlstat+0x1d/0x40
> > [92481.503754]  [<ffffffff8117271d>] ? vfs_write+0x13d/0x180
> > [92481.503757]  [<ffffffff811734a1>] ? SyS_write+0x61/0x90
> > [92481.503760]  [<ffffffff810f5175>] ? from_kuid_munged+0x5/0x10
> > [92481.503763]  [<ffffffff81719cd7>] ?
> > entry_SYSCALL_64_fastpath+0x12/0x6a [92481.503766] ksysguardd
> > D 00000000000141c0     0  9869      1 0x00000004 [92481.503769]
> > ffff880092012400 ffff880203868000 ffff880203867bc0 ffff880092012400
> > [92481.503771]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000
> > ffffffff817167cc [92481.503774]  7fffffffffffffff ffffffff817190df
> > ffff880203867bc0 ffffffff810b4d99 [92481.503776] Call Trace:
> > [92481.503779]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
> > [92481.503782]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
> > [92481.503786]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
> > [92481.503789]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
> > [92481.503791]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
> > [92481.503794]  [<ffffffff81717012>] ?
> > wait_for_completion+0x92/0xf0 [92481.503797]
> > [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60 [92481.503799]
> > [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> > [92481.503801]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> > [92481.503803]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> > [92481.503806]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> > [92481.503808]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> > [92481.503810]  [<ffffffff8117ddc8>] ? path_lookupat+0x58/0x100
> > [92481.503813]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> > [92481.503815]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> > [92481.503818]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> > [92481.503820]  [<ffffffff8119cc8a>] ? user_statfs+0x2a/0x80
> > [92481.503822]  [<ffffffff8119ccf0>] ? SYSC_statfs+0x10/0x30
> > [92481.503825]  [<ffffffff8103ea53>] ? __do_page_fault+0x1a3/0x400
> > [92481.503827]  [<ffffffff81719cd7>] ?
> > entry_SYSCALL_64_fastpath+0x12/0x6a [92481.503830] trash.so
> > D 0000000000000000     0 14351   1478 0x00000004 [92481.503833]
> > ffff8803072ac800 ffff8800438fc000 ffff8800438fbb70 ffff8803072ac800
> > [92481.503835]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000
> > ffffffff817167cc [92481.503838]  7fffffffffffffff ffffffff817190df
> > 0000000000000010 0000000000000287 [92481.503841] Call Trace:
> > [92481.503844]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
> > [92481.503847]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
> > [92481.503850]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
> > [92481.503852]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
> > [92481.503855]  [<ffffffff81717012>] ?
> > wait_for_completion+0x92/0xf0 [92481.503858]
> > [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60 [92481.503860]
> > [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> > [92481.503862]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> > [92481.503864]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> > [92481.503866]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> > [92481.503869]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> > [92481.503871]  [<ffffffff8117d973>] ? link_path_walk+0x163/0x4f0
> > [92481.503873]  [<ffffffff8117c4d1>] ? path_init+0x1f1/0x330
> > [92481.503876]  [<ffffffff8117dde7>] ? path_lookupat+0x77/0x100
> > [92481.503878]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> > [92481.503880]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> > [92481.503883]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> > [92481.503886]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
> > [92481.503889]  [<ffffffff81176ddd>] ? SYSC_newlstat+0x1d/0x40
> > [92481.503891]  [<ffffffff8117271d>] ? vfs_write+0x13d/0x180
> > [92481.503893]  [<ffffffff811734a1>] ? SyS_write+0x61/0x90
> > [92481.503895]  [<ffffffff810f5175>] ? from_kuid_munged+0x5/0x10
> > [92481.503898]  [<ffffffff81719cd7>] ?
> > entry_SYSCALL_64_fastpath+0x12/0x6a [92481.503901] trash.so
> > D 0000000000000000     0 17062   1478 0x00000004 [92481.503903]
> > ffff880350ee4800 ffff8801e4d5c000 ffff8801e4d5bb70 ffff880350ee4800
> > [92481.503906]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000
> > ffffffff817167cc [92481.503908]  7fffffffffffffff ffffffff817190df
> > ffff8801e4d5bb70 ffffffff810b4d99 [92481.503911] Call Trace:
> > [92481.503914]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
> > [92481.503917]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
> > [92481.503920]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
> > [92481.503923]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
> > [92481.503925]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
> > [92481.503928]  [<ffffffff81717012>] ?
> > wait_for_completion+0x92/0xf0 [92481.503931]
> > [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60 [92481.503934]
> > [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> > [92481.503936]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> > [92481.503938]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> > [92481.503940]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> > [92481.503942]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> > [92481.503945]  [<ffffffff8117d973>] ? link_path_walk+0x163/0x4f0
> > [92481.503947]  [<ffffffff8117c4d1>] ? path_init+0x1f1/0x330
> > [92481.503949]  [<ffffffff8117dde7>] ? path_lookupat+0x77/0x100
> > [92481.503951]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> > [92481.503954]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> > [92481.503956]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> > [92481.503959]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
> > [92481.503962]  [<ffffffff81176ddd>] ? SYSC_newlstat+0x1d/0x40
> > [92481.503964]  [<ffffffff8117271d>] ? vfs_write+0x13d/0x180
> > [92481.503966]  [<ffffffff811734a1>] ? SyS_write+0x61/0x90
> > [92481.503969]  [<ffffffff810f5175>] ? from_kuid_munged+0x5/0x10
> > [92481.503971]  [<ffffffff81719cd7>] ?
> > entry_SYSCALL_64_fastpath+0x12/0x6a [92481.503973] df
> > D 00000000000141c0     0 20885  20797 0x00000004 [92481.503976]
> > ffff8803c42e6000 ffff8801001b4000 ffff8801001b3bd0 ffff8803c42e6000
> > [92481.503979]  ffff880403cd8f20 ffff880403cd8f00 0000000000000000
> > ffffffff817167cc [92481.503981]  7fffffffffffffff ffffffff817190df
> > ffff8801001b3bd0 ffffffff810b4d99 [92481.503984] Call Trace:
> > [92481.503987]  [<ffffffff817167cc>] ? schedule+0x2c/0x80
> > [92481.503990]  [<ffffffff817190df>] ? schedule_timeout+0x13f/0x1a0
> > [92481.503993]  [<ffffffff810b4d99>] ? finish_wait+0x29/0x60
> > [92481.503996]  [<ffffffff81718229>] ? mutex_lock+0x9/0x30
> > [92481.503999]  [<ffffffff811e0e23>] ? autofs4_wait+0x433/0x710
> > [92481.504002]  [<ffffffff81717012>] ?
> > wait_for_completion+0x92/0xf0 [92481.504005]
> > [<ffffffff810a2b80>] ? wake_up_q+0x60/0x60 [92481.504007]
> > [<ffffffff811e1a4f>] ? autofs4_expire_wait+0x5f/0x80
> > [92481.504009]  [<ffffffff811dfa36>] ? autofs4_d_manage+0x56/0x150
> > [92481.504011]  [<ffffffff8117b811>] ? follow_managed+0x91/0x2c0
> > [92481.504013]  [<ffffffff8117bcd2>] ? lookup_fast+0x102/0x300
> > [92481.504016]  [<ffffffff8117d3f1>] ? walk_component+0x31/0x450
> > [92481.504018]  [<ffffffff8117ddc8>] ? path_lookupat+0x58/0x100
> > [92481.504020]  [<ffffffff811800d5>] ? filename_lookup+0x95/0x110
> > [92481.504023]  [<ffffffff8115b55e>] ? kmem_cache_alloc+0x10e/0x160
> > [92481.504026]  [<ffffffff8117fdeb>] ? getname_flags+0x4b/0x170
> > [92481.504028]  [<ffffffff81176934>] ? vfs_fstatat+0x44/0x90
> > [92481.504031]  [<ffffffff81176d9a>] ? SYSC_newstat+0x1a/0x40
> > [92481.504034]  [<ffffffff81719cd7>] ?
> > entry_SYSCALL_64_fastpath+0x12/0x6a  
> 
> IIRC you're on gentoo as I am.  It's interesting how close our
> systems are to each other, and yet how far away.  Based on the
> ksysguardd above, I'm guessing you run kde, as I do, and we both use
> claws for mail (tho messages here will say pan, as I use it for news
> and do my mailing lists as news via gmane.org's list2news service).

I use Claws only for gmane.org's list2news service, running NNTP thru
leafnode. Apparently, knode no longer works with plasma, except I'm
pulling in a lot of legacy KDE stuff which conflicts with what I want
to have installed.

> But I run a pretty stripped down kde; nothing like automount (the
> autofs4 in your traces) at all, the baloo parts of plasma-workspace
> and plasma-desktop patched out at build time so I can use a virtual
> "null-package" baloo from my overlay that installs no files and has no
> dependencies to fill the dep (easier than patching it out of the
> ebuild, unfortunately the hoops I gotta go thru now that they dumped
> the semantic-desktop USE flag for kde/frameworks/plasma5); similarly
> the runtime-only udisks dep is filled by a null-package as I don't
> need or want those features and definitely don't want to pull in all
> its deps, etc.

I'm using full-blown KDE plasma here, nothing stripped down. I love
balloo - it's fast, the system is responsive, I never notice indexing,
the searching features are really great for starting programs. The
system boots up in under 15s, the desktop is loaded in maybe 5 seconds
with a lot of autostart stuff like Steam. This also includes three
container VMs I'm using for development stuff (systemd-nspawn) and a
local MariaDB server.

> But with kde so heavily stripped down, mostly only the basic desktop
> and many of the games, it's reasonably easy to run the live-9999
> ebuilds from the gentoo/kde overlay and use smart-live-rebuild to
> only rebuild packages with new commits, so I'm actually running
> live-git kde, for the parts of kde I have installed at all, anyway.
> =:^)

I didn't now about smart-live-rebuild. Interesting. ;-)

> To the issue at hand...

Yep.

> As you know I'm a btrfs user, not a dev.  However, if I'm not
> mistaken, the D after each of the apps indicates the same "disk
> sleep" status you'd see in top and the like, for apps waiting on IO.

Yes, D indicates disk sleep - but I don't have any outstanding IO I'd
know of, neither I see HDD LED activity, nor I to excessive reading
that could explain that.

I'm managing a lot of Gentoo-based servers at my company, and a lot of
tuning has gone into optimizing IO - so I know the knobs and where to
look for problems.

This one however leaves me a little clueless.

I can see "du", "df", etc in "ps axuw" in disk sleep state - not sure
why they don't show up in that generated trace. Ctrl+c'ing those
commands simply does nothing except display "^C" on the shell. Neither
"kill -9" works on those hanging commands.

> Further, each of the listed apps appears to be waiting at the same
> schedule function, basically yielding the cpu to other apps until the
> filesystem returns what they're looking for, up the call stack to
> obviously each of the apps doing a file operation, apparently write in
> some cases, stat on some not-yet-cached file in other cases.

When the systems comes to the point those commands hang, everything
else is still working: No excessive IO, no unexpected IO, performance
is still very good. But processes looking for free disk space on _any_
of my filesystems then hang - even Wine, PlayOnLinux, ksysguardd, the
KDE trash handling routines... Shutting the system down in this state
takes at least 2 minutes vs. usually 10-20s. I expect systemd is just
trying to hard kill processes and then eventually ignores them. In
turn, probably the filesystems won't be unmounted properly which may
explain the corruption I had previously. But now, I returned all
filesystems to sane state by recreating them from scratch, using a
brand-new SSD for bcache, etc. I also error checked components like
HDD, RAM, etc. All is well.

> Looks to me pretty normal, just waiting for access to the disk when
> something else is hogging all the (limited) disk bandwidth.  Nothing
> like btrfs worker threads hung up, etc, that would make it
> btrfs-specific.

Not so normal however is that state holds on forever. Some point in
time such processes should eventually finish their jobs.

> Meanwhile, du isn't in the traces above (tho df is), but you mention
> it in the title and first paragraph, so it's worth noting that du,
> unlike df, generally crawls the directory trees you point it at to
> get the space used by all the files in all the dirs, recursively,
> so it'll do much more IO than something like df, which in general is
> a far faster call to the filesystem, asking for a single set of stats
> that the filesystem can normally return without crawling a big
> directory tree.

Running "du" just hangs - there's no IO going on which I would expect
when running "du". Further, df hangs, sync hangs, ksysguard only
partially works (it still shows ongoing IO, but some other graphs no
longer show values) and eventually later refuses to work completely.

Until a reboot fixes all of that.

> But obviously the df call here was waiting for /something/ from disk.
> Maybe it was actually still trying to load the df binary itself?  (df
> doesn't load but three libs, the linux-vdso kernel-virtual being one
> of them, the ld loader itself, and the libc, pretty basic and the two
> actual file-based libs, the loader itself and libc, will obviously be
> cached, so it shouldn't block on loading them.)

I'm pretty sure that all those libs and binaries are even in cache when
I run them: Of my 16 GB RAM there's still plenty of RAM free with a lot
of it being cache.

I experienced Linux servers in the past that were running from cache
completely fine with the RAID controller frozen. Writing froze but
everything else still worked - until the cache filled up, then the
system broke completely down.

> As for btrfs fi sync, that's going to force-write-out all dirty
> write-cache for that filesystem, so if it's called on the btrfs
> the rsync is writing to, that's likely to block for quite some time
> waiting for all those writes to flush, as well.

It affects all file systems. The "btrfs fi sync" is used to finish my
rsync backup and ensure everything is written before I'm trying to
unmount it or the system goes back to sleep.

"df" and friends also freeze on tmp (ramdisk) fs and vfat fs (my EFI
boot partition).

> If btrfs filesystem sync is called on a _different_ btrfs, AND that
> independent btrfs is on an entirely separate physical device (AND
> that separate physical device isn't on the same legacy IDE cable or
> SATA port-multiplier), THEN btrfs filesystem sync should return
> relatively fast, compared to a general sync at least, since it
> will only flush that separate filesystem, not all filesystems as
> would a general sync.

Yes, I expect that to be the difference (full flush vs. fs-specific
flush).

> Meanwhile, general IO scheduling is a somewhat different subject.
> I believe the kernel does try to prioritize reads over writes,
> pushing them to the front of the queue, which should get them
> addressed and any apps only waiting on reads unstuck faster,
> but on spinning rust, it can still take some time.

The kernel, with cfq and deadline schedules, prioritizes reads over
writes but ensures there's no write starvation. The background is that
a process is expected to block on write more often then it is expected
to block on reads (e.g. if you save a file in your editor, you are
comfortable with waiting a little time, but if it'd happen if you
click a menu or open a dialog - ah, well, not so nice experience).

Bcache uses a similar approach for calculating IO congestion on the SSD
to fall back to passing IO directly to the backing devices. Tho, the
congestion counter in bcache never ever counted anything for me - which
tells me: excessive IO is not my problem.

> But there are at least two possible large problems.  One is
> BIOS related and on many systems, not configurable at all, tho
> on higher end server or gaming systems it can be, the other
> is kernel IO tuning.

No traditional BIOS here, I use EFI ultra-fast boot (aka Windows 8 fast
boot) with NVIDIA GOP to get an EFI framebuffer. According to
systemd-analyze, my system only uses 1s in EFI firmware during boot.
The EFI setup itself doesn't expose much stuff regarding to PCI-E
latency settings - and even when, I think it defaults to 32 ticks which
I never had problems with. I remember the days with buggy VIA baords
where you had to tune that setting so that your Windows 95 wouldn't
freeze so often during audio output, or even to fix audio stuttering.
But that's history a long-time.

> The BIOS related one, and I'm not sure it even applies to PCIE,
> as the old system I had with the option was a pre-PCIE server
> board with high-speed PCIX (and AGP still, remember that? =:^)
> but not PCIE, has to do with IO thruput vs. responsiveness.
> Unfortunately IDR what it was called exactly, but the settings
> were IIRC powers of two from something like 16 MB (IIRC) up thru
> 128 or 256 MB.  Lower settings were more responsive, but 
> would slow total thruput in certain use-cases as there was
> more command and bus overhead.

I think this is something you find with server boards only, because
those are optimized for throughput instead of interactivity. A classic
desktop board shouldn't have those knobs tho I'd expect some
manufactures to tune those knobs to show better benchmark results.
Still, those are usually not exposed in the BIOS UI, or they are
hidden behing obscure settings.

However, my settings are pretty standard - I just lowered CPU voltage a
little bit for a cooler CPU and ran some burn-in benchmarks to verify
it's still running stable. That gained my up to 10°C less CPU
temperature when idle. The system stays cooler and more quiet. And it's
using less watts.
 
> The reason I still mention this here at all is that with the
> higher settings, I definitely had IO-related lagginess in a lot
> of things, including mouse movement (freeze-and-jump syndrome)
> and even audio playback (dropouts).  I tried a bunch of kernel
> adjustments, etc, but the problem in this case was below the
> kernel in the BIOS settings, and wasn't fixed until I decided
> to try lowering that setting to IIRC 32 MB (or whatever), after
> which the problem simply disappeared!

No mouse lags here. Even no lags at all, after boot all programs
(including Chromium) almost start instantly when clicking them. Neither
after the system has been up for a long time: Everything is almost
instant. As I expect it after migrating to bcache.

> The point being, sometimes it's nothing the kernel can really
> control!  Of course that general primary point applies regardless
> of whether there's anything like that specific setting in more
> modern PCIE style hardware, which is why I still mentioned it.

Your observation about responsiveness on server hardware is at least
interesting. I will keep that in mind and look for this setting when I
see such problems with a server board.

> Meanwhile, what kernel IO scheduler do you use (deadline, noop,
> cfq,... cfq is the normal default)?  Do you use either normal
> process nice/priority or ionice to control the rsync?  What
> about cgroups?

Due to systemd booting my system, everything is in a cgroup. The backup
job itself is not tied to its own cgroup. But it actually uses ionicing
and nicing:

$ systemctl cat usb-backup.service
# /etc/systemd/system/usb-backup.service
[Unit]
Description=Daily USB Backup Service

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/usb-backup.sh
IOSchedulingClass=idle
IOSchedulingPriority=7
CPUSchedulingPolicy=batch
Nice=3
PrivateTmp=true
ProtectHome=read-only
ProtectSystem=true

But whatever those settings are, it should never expose a behavior as I
see. I don't think this is related. I only know the rsync job is the
most probable to trigger the problem.

> And finally, what are your sysctl aka /proc/sys/vm settings for
> dirty_* and vfs_cache_pressure?  Have you modified these from
> defaults at all, either by changing your /etc/sysctl.(d|conf)
> vm.* settings, or by writing directly to the files in
> /proc/sys/vm, say at bootup (which is what changing the sysctl
> config actually does)?

This is standard here. I experimented with it in the past, but it only
showed very observable bad performance in edge cases while only showing
almost non-existing improvements in normal performance.

$ sudo sysctl -a 2>&1 | egrep 'vm.dirty|vfs'
vm.dirty_background_bytes = 0
vm.dirty_background_ratio = 10
vm.dirty_bytes = 0
vm.dirty_expire_centisecs = 3000
vm.dirty_ratio = 20
vm.dirty_writeback_centisecs = 500
vm.dirtytime_expire_seconds = 43200
vm.vfs_cache_pressure = 100

> Because the default cache settings as a percent of memory were
> setup back when memory was much smaller, and many people argue
> that on today's multi-GiB memory machines, they allow far too
> much dirty content to accumulate in cache before triggering
> writeback, particularly for slow spinning rust.  When the time
> expiry is set to 30 seconds but the amount of dirty data allowed
> to accumulate before triggering high priority writeback is near
> a minute's worth of writeback activity, something's wrong,
> and that's very often a large part of the reason people see
> IO related freezes in other processes trying to read stuff
> off disk, as well as other lagginess on occasion (tho as
> touched on above, that's rarer these days, due to point-to-
> point buses such as PCIE and SATA, as opposed to the old
> shared buses of PCI and EIDE).

Experimented with that a found it's not worth to do for my system.
Writeback rate is very high due to bcache, 500 MB/s, and if SSD is
congested, I could get some extra MB/s from the backing devices. This
is similar behavior to the servers I configure with BBU and writeback,
where I can see up to 2 GB/s writes for a few minutes before the
writeback cache becomes congested.

Even if I copy a lot of data around, or a lot of data from USB3 to my
FS, write rates are not an issue. The data is written a lot faster than
it comes in - or completely fits into bcache. I rarely experience IO
stalls - usually only when a multi GB process segfaults and dumps it
core.

> FWIW, while I have ssds for the main system now, I already
> had my system tuned in this regard:
> 
> 1) I set things like emerge, kernel building, rsync, etc,
> to idle/batch priority (19 niceness), which is more
> efficient for cpu scheduling batch processes as they get
> longer time slices but at idle/lowest priority so they
> don't disturb other tasks much.

The difference is maybe a few seconds on a multi-minute build with the
difference that interactivity is a lot better. Tho, on my system I
don't see any difference now, whether I build the kernel "make -j9" or
"nice make -j9". With bcache, even "ionice rsync" does no longer have
such a high impact as before.

> Additionally, for the cfq IO scheduler, it sees the idle
> cpu priority and automatically lowers IO priority as well,
> so manual use of ionice isn't necessary.  (I don't believe
> the other schedulers account for this, however, which is
> one reason I asked about them, above.)

I used BFQ for a while and was very happy with it. But it's currently
not in the gentoo-patches for the kernel.

> For something like rsync that's normally IO-bound anyway,
> the primary effect would be the automatic IO-nicing due
> to the process nicing.

Almost no effect visible here due to bcache.

> That was pretty effective at that level.  But combined
> with #2, it's even more so.
> 
> 2) I tuned my vm.dirty settings to trigger at much
> lower sizes for both low priority background writeback
> and higher priority foreground writeback.  You can
> check the kernel's procfs documentation for the
> specific settings if you like, but here's what I have
> for my 16 GiB system (ssd now as I said, but I saw
> no reason to change it from the spinning rust settings
> I had, particularly since I still use spinning rust
> for my media partition).

That only led to bad behavior in edge cases for me. I prefer having a
percent-sized writeback cache now, otherwise the system would stutter
too often for me. It's not worth trying to micro-optimize that if you
use bcache.

> 
> Direct from that section of my /etc/sysctl.conf:
> 
> ################################################################################
> # Virtual-machine: swap, write-cache

Err, it's VM = virtual memory. ;-)

[...]

> The commented values are normal defaults.  Either ratio, percentage
> of RAM, or direct bytes can be set.  Setting one clears (zeros) the
> other.  While the ratio isn't of total RAM but of available RAM,
> total RAM's a reasonable approximation on most modern systems.
> 
> Taking the foreground, vm.dirty_ratio setting first:
> 
> Spinning rust may be as low as 30 MiB/sec thruput, and 10% of 16 gig
> of RAM is 1.6 gig, ~1600+ meg.  Doing the math that's ~53 seconds
> worth of writeback accumulated by default, before it kicks into high
> priority writeback mode. With a 30 second default timeout, that makes
> no sense at all as it's almost double the timeout!

Accoring to boot chart, I get IO rates up to 800MB/s during boot-up. Of
course, that is reading. I trimmed down writing a lot during the last
months (e.g. by switching to noatime). That was, after I saw how fast
bcache wears the SSD. Now, I switched to 4x bigger SSD. Bcache doesn't
fill the cache currently, so it's not rewriting caches over and over
again. That should take a lot of writes out of the equation.

> Besides, who wants to wait nearly a minute for it to dump all that?

Dumping 16GB to my FS just takes 10-20 seconds for me. Dumping the 10%
of that (worth of writeback) is thus usually done in 1-2 seconds. Even
if it is slower due to seeking, it should still be below 10s. I have no
problems with that, I only very very rarely experience stalls due to
writeback. And even then, applications block for a second maybe.

> So I set that to 3%, which with 16 gigs of RAM is ~half a gig, or
> about 16 seconds worth of writeback at 30 MB/sec.  That's only about
> half the 30 second time expiry and isn't /too/ bad to wait, tho
> you'll probably notice if it takes that full 16 seconds.  But it's
> reasonable, and given the integer setting and that we want background
> set lower, 3% is getting about as low as practical.  (Obviously if I
> upped to 32 GiB RAM, I'd want to switch to the bytes setting for this
> very reason.)
> 
> The background vm.dirty_background_ratio setting is where the lower
> priority background writeback kicks in, so with luck the higher
> priority foreground limit is never reached, tho it obviously will be
> for something doing a lot of writing, like rsync often will.  So this
> should be lower than foreground.

rsync writes to a device that is write-only. No desktop process ever
reads from that device. And I also don't see this invalidating my
cache. The system feels normal during backup (except games may stutter,
as I already experienced).

I only increased nr_requests which improves IO performance a lot better
than fiddling around with vm dirty ratios.

#!/bin/sh
for nr_requests in /sys/bus/scsi/devices/[012345]:0:0:0/block/*/queue/nr_requests; do
        echo 512 >$nr_requests
#       echo 128 >$nr_requests
done

With that setting, I see write rates up to 120MB/s to my USB3 HDD,
mostly churning around 50MB/s.

> With foreground set to 3%, that doesn't leave much room for
> background, but 1% is still reasonable.  That's about 160 MB or 5
> seconds worth of writeback at 30 MB/sec, so it's reasonable.
> 
> As you can see, with the size triggers lowered to something
> reasonable, I decided I could actually up the background time expiry
> from the default 5 seconds to 10.  That's still well and safely under
> the 30 second foreground time expiry, and with the stronger size
> triggers I thought it was reasonable.
> 
> I haven't actually touched vfs_cache_pressure, but that's another
> related knob you can twist.

As there's no IO going on, I doubt it'd make a difference for my
problem. And I experimented with that in the past and it was just not
worth tuning it. I've put in bcache, tuned nr_requests. That's it.
Tuning these other knobs just doesn't work well - edge-case behavior
suffers a lot from that.

> I don't actually have any swap configured on my current machine (and
> indeed, have it disabled in the kernel config) so the swappiness
> setting doesn't matter, but I did have swap setup on my old 8 GiB
> machine.

I'm using 60GB of swap, as I use a lot of tmpfs filesystem (30GB
for /var/tmp/portage). The swap is 3x 20GB on each HDD, same priority
so it is evenly spread by the kernel. Bcache caches the normal
filesystems (not the swaps!), so I suffer almost no performance loss for
normal FS operation when the kernel starts using the swaps.

>  I was actually using the priority= option to set four swap
> partitions, one each on four different devices, to the same priority,
> effectively raid0-striping them.  My system was mdraid1 on the same
> four devices. So I upped swappiness to 100 (it's more or less
> percentage, 0-100 range) from its default 60, to force swapping out
> over dumping cache.  Even still, I seldom went more than a few
> hundred MiB into swap, so the 8 GiB was just about perfect for that
> 4-cores system.  (My new system has 6 cores and I figured the same 2
> GiB per core.  I think now a more realistic figure for my usage at
> least is say 4 GiB, plus a GiB per core, which seems to work out for
> both my old 4-core system with 8 gig RAM, and my newer 6-core system
> where 12 gig of RAM would hit about the same usage.  I have 16 gig,
> but seldom actually use the last 4 gig at all, so 12 gig would be
> perfect, and then I might configure swap, just in case.  But swap
> would be a waste with 16 gig since I literally seldom use that last 4
> gig even for cache anyway, so it's effectively my overflow area.)

Here's it's almost impossible to use more than 9 GB RAM during normal
operation. After boot (full-blown KDE), ksysguard shows 2-3 GB usage of
RAM (this excludes caches).

So I concluded: Desktop systems with 12 GB RAM a well equipped (and
that is what I ordered at work for my workplace).

> I used laptop mode, with laptop-mode-tools, on my netbook, the reason
> it's comment-listed there as of-interest, but I've no reason to use
> it on my main machine, which is wall-plug powered.  IIRC when active
> it would try to flush everything possible once the disk was already
> active, so it could spin down for longer between activations.
> Laptop-mode-tools allows configuring a bunch of other stuff to toggle
> between wall power and battery power as well, and of course one of
> the other settings it changed was the above vm.dirty_* settings, to
> much larger triggers and longer timeouts (upto 5 minutes or so,
> tho I've read of people going to extremes and setting it to 15
> minutes or even longer, tho that of course risks losing all that work
> in a crash (!!)), again, to let the drive stay spun down for longer.

Never worked for me. Something always triggered even tiny writes once
in a while a woke up the HDDs. So I stopped experimenting with that. If
it's for a laptop, you gain much much more battery by just swapping the
HDD with an SSD - and that's it. Simple, easy. SSDs have become cheap
enough that it's no longer worth a hassle (standard laptop come with
512GB HDD, pay €120 extra and you have a 512GB SSD + an external HDD
what used to be the internal SSD).

There's just one caveat (seen in tests, and seen in the wild during my
job): Samsung SSD die a sudden death. They go from working to
inaccessible without any previous notice if they wear out - which is
after about 3-5 years worth of a bit more than normal desktop usage.

Apparently, I'm also using a 512GB Samsung SSD now, and it seems it has
no SMART indicate of write-usage as my Crucial SSD had. So I'm left for
surprise I think. I suppose I have to figure out how to convert
"241 Total_LBAs_Written" to life-time against the 85TB
write-performance of those SSDs.

> Between the two, setting much lower writeback cache size triggers,
> and using a nice of 19 to set idle/batch mode for stuff like emerge
> and rsync, after setting that bios setting on the old system as well,
> responsiveness under heavy load, either IO or CPU, was MUCH better.

I'm using these vm dirty knobs only for servers to even-out web stalls.

> Hopefully you'll find it's similarly effective for you, assuming
> you don't already have similar settings and are STILL seeing
> the problem.

Nope. Tried. Didn't make anything better, just worse.

> Of course for things like rsync, you could probably use ionice (with
> the cfq io scheduler) instead and not bother doing normal nice on 
> rsync, but because the cfq scheduler already effectively does ionice
> on strongly niced processes, I didn't need to worry about it here.
> 
> As I said, with ssds I don't really need it that strict any more,
> but I saw no need to change it, and indeed, with spinning rust still
> for my media drive, it's still useful there.

A dirty cache is not the problem here as far as I see. It simply
deadlocks due to some unknown reason (probably).

> So there it is.  Hope it's useful. =:^)

At least it was long... ;-)


-- 
Regards,
Kai

Replies to list-only preferred.


