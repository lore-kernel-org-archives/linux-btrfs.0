Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46544 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbcBFF5f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 6 Feb 2016 00:57:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aRvsC-0001Ju-Uy
	for linux-btrfs@vger.kernel.org; Sat, 06 Feb 2016 06:57:33 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Feb 2016 06:57:32 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Feb 2016 06:57:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-progs4.4 with linux-3.16.7 (with truncation of extends
 patch)
Date: Sat, 6 Feb 2016 05:57:21 +0000 (UTC)
Message-ID: <pan$84aa7$90a27a$80294ac8$88eb3ebd@cox.net>
References: <56B505CB.8080604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicholas D Steeves posted on Fri, 05 Feb 2016 15:27:55 -0500 as excerpted:

> Hello,
> 
> Is it safe to use btrfs-progs-4.4 with linux-3.16.7 patched with the
> following:
> 
> linux-3.16.7 Btrfs: fix truncation of compressed and inlined extents
> https://git.kernel.org/linus/0305cd5f7fca85dae392b9ba85b116896eb7c1c7
> 
> The specific case I'm looking into is when a Debian user sticks with the
> default kernel, but installs btrfs-progs-4.4 from backports.  I've also
> read that there will be some userspace<->kernel compatibility checks
> added to btrfs-progs at some point, but I wasn't able to find recent
> news on its progress.

There's two ways to answer that.  First...

In general, here on-list we consider btrfs still stabilizING, not yet 
fully stable or mature, and strongly recommend that people stick to the 
two latest kernels of either the LTS kernel series or current.  With 4.4 
both latest current and latest LTS, and 4.1 the latest previous LTS, that 
and the one-back 4.3 on the current kernel side are the currently 
recommended kernels, altho as stated, btrfs is gradually stabilizing, and 
it seems that with 4.4-LTS we may actually continue to support the second-
back LTS, 3.18, as well, so three LTS kernel series, now.

In that regard, kernel 3.16 is simply too far back to really be 
recommended on-list in any case.  We will of course try to support it as 
best we can, but the general on-list feeling seems to be that while there 
are valid reasons to run older and more stale^H^Hble kernels, those 
reasons tend to be incompatible with an interest in running a filesystem 
that itself isn't yet fully stable and mature.  The recommendation, then, 
is to pick one or the other.  If people really want sta(b)le, then btrfs 
isn't for them as it's honestly not there yet, and the btrfs 
recommendation to stay near current simply isn't compatible with that.  
Otherwise, if people really want to use btrfs, they really need to give 
up the idea of running years outdated kernels and (at least btrfs) 
userspace, as btrfs simply isn't to the level yet where it has been 
proven stable over enough years that people /can/ run old kernels and not 
have to worry about code that is known outdated and buggy.

That said, we recognize that various longer term and enterprise distros 
are billing their (nominally) older-kernel btrfs as supported, and 
indeed, often there's serious effort going into backporting fixes, thus 
the "(nominally)" parenthetical.  That's their decision to make, and 
their users' decisions to go with that support or not.  But here we track 
upstream, and don't really track what patches various distros have 
backported.  Basically, our position where distros are choosing to 
support btrfs on older kernels, is that if users choose to use them, they 
really should be looking to those distros for proper support, not this 
list, since only those distros know what is backported, etc, while our 
focus here is current mainline, not older distro kernels with who knows 
what fixes backported... or not.  If it says 3.16 on the label, as far as 
we're concerned it's an old kernel that's long "water under the bridge" 
as they say, and we've simply moved on.  Again, we'll still try to offer 
help where we can, but generally where there's issues with these old 
kernels one of the first requests is that people try a newer kernel, 
preferably latest current, and see if the problem's still there.  If they 
don't wish to, well, that's what the distro's claims of support are for, 
they really need to be using that, as if they won't try current, there's 
a rather serious limit to the level of help we can provide them here, and 
they really /do/ need to be taking their distro up on that offer of 
support running btrfs on what to us really are long outdated and known 
buggy kernels.

So really, our support for kernel 3.16 in any form is very limited, and 
our best recommendation is to choose between running really old and 
hopefully stable systems without btrfs, if that's what their use-case 
calls for, or running btrfs on newer kernels, if they're willing to live 
a bit more on the edge than that old sta(b)le stuff, because by choosing 
btrfs they're already choosing to live a bit on the edge as it really is 
_not_ yet fully stable, and if they really need stable, that's a 
potentially very serious incompatibility they need to resolve, one way or 
the other.

To get specific about that debian user with the old kernel, then, and 
we've specifically dealt with _exactly_ this problem with debian users 
before, our recommendation is to either update to at least mainline 
kernel 3.18 LTS and preferably LTS-4.1 or even better LTS-4.4 if there's 
no specific bug in the still new 4.4 preventing it, if they want the best 
support possible from this list, OR switch to a filesystem that's fully 
stabilized and thus more appropriate to the level of stability they need, 
OR since they're running debian, which seems to be claiming support for 
btrfs on old kernels, they really need to be taking up debian on that 
offer of support, as what we can provide here really is rather limited if 
they don't choose to upgrade to something closer to what this list 
considers at least reasonably current.

With the above understood, however, there's a second, arguably more 
direct way to answer the question, that's also probably more to your 
liking. =:^)

The btrfs goal is that both kernel and userspace should be both forward 
and backward compatible with the other, and (with the caveat of 
appropriate compatibility settings) to the extent that a filesystem 
created and used with the one breaks the other, it's considered a bug 
(well, back to the oldest LTS with btrfs, at least, that being the 2.6.32 
stable series that's just now going unsupported, which until now we were 
at least still trying to support in the userspace as well).  Newer 
userspace therefore should be just fine with older kernels, at least to 
the level of 3.16 "older", and newer kernels equally fine with older 
userspace, again, with the caveat that, for instance, a newer userspace 
mkfs.btrfs is run with the appropriate options to keep compatibility with 
older kernels that didn't understand a few of the newer device layout 
defaults.

The userspace/kernel compatibility checks that you mention are in the 
context of better automation of that compatibility caveat.  Right now, a 
new btrfs-progs userspace mkfs.btrfs defaults to creating a filesystem 
that an older kernel is likely to have problems with, because the 
defaults turn on a number of on-device-format options that older kernels 
would refuse to mount due to incompatibility flags that they know nothing 
about.

btrfs-convert has similar issues.

But other than those two and people deliberately turning on incompatible 
options with btrfs-tune, the rest of btrfs userspace should just work 
with whatever it finds, both in the kernel and on-device.  Btrfs check, 
for instance, shouldn't "repair" the filesystem by turning on these 
incompatibilities; it should "just work" with what it finds.  Btrfs 
restore similarly, altho it's read-only in terms of the btrfs it's 
restoring from in any case.  Most of the rest of the userspace tools, in 
particular, btrfs scrub, subvolume, balance, device, filesystem, send, 
receive, etc, work by making kernel calls to do the actual work in any 
case, and they will use the old calls if they need to.

The compatibility discussion, meanwhile, is on making mkfs.btrfs (and 
btrfs-convert) check the running kernel and taking its defaults from what 
that kernel supports, instead of choosing arbitrary defaults that may be 
better when supported, but that older kernels don't actually support.  Of 
course there will still be options to set these as desired regardless of 
defaults, just as there are now, so people using for instance booted to 
an old recovery kernel for system maintenance can still choose whatever 
options that version of mkfs.btrfs supports if they know they'll actually 
be mounting with a newer kernel, but the idea is simply to have 
mkfs.btrfs act more sanely /by/ /default/ when run on old kernels, so 
those same old kernels can actually mount a filesystem created with 
defaults.

Along that line, as a distro maintainer of the btrfs-progs package, you 
may wish to patch the mkfs.btrfs defaults to what your kernel supports.  
Btrfs-progs will probably ship with kernel-sensitive defaults some time 
in the future (userspace 4.5 release, probably), but it doesn't do so 
yet... that of course underlining the point I made earlier, that btrfs is 
_not_ fully stable yet. =:^)

But still... btrfs on a 3.16 kernel just isn't something we recommend, 
here, new userspace or not.  Because btrfs just wasn't stable enough for 
that, back then.  The 3.18 LTS, borderline, but 3.16, no.  And unless you 
want to be providing that support as a distro, for not even LTS kernels 
the age of 3.16 (the LTS previous to 3.18 was 3.14, which is definitely 
too far back to be considered reasonable to still be running btrfs on, 
list-perspective anyway), I believe the best recommendation for your 
users as well, would be to either run a newer kernel if they're 
comfortable with that, or choose something other than btrfs, as its 
stability level on kernels that old simply isn't compatible with the 
reasons you'd be running that old a kernel in the first place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

