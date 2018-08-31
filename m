Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47524 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbeHaGhH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 02:37:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fvZBw-0007CD-LA
        for linux-btrfs@vger.kernel.org; Fri, 31 Aug 2018 04:29:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to erase a RAID1 (+++)?
Date: Fri, 31 Aug 2018 02:29:36 +0000 (UTC)
Message-ID: <pan$4e7f0$2612a395$18eaf6d3$f09fc7a4@cox.net>
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
        <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
        <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
        <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
        <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
        <CAJCQCtTcCWavzu5k6ZnhCDU+jaHxWfzfuR5Whic1-ic0s+x+8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 30 Aug 2018 11:08:28 -0600 as excerpted:

>> My purpose is a simple RAID1 main fs, with bootable flag on the 2 disks
>> in prder to start in degraded mode....
> 
> Good luck with this. The Btrfs archives are full of various limitations
> of Btrfs raid1. There is no automatic degraded mount for Btrfs. And if
> you persistently ask for degraded mount, you run the risk of other
> problems if there's merely a delayed discovery of one of the devices.
> Once a Btrfs volume is degraded, it does not automatically resume normal
> operation just because the formerly missing device becomes available.
> 
> So... this is flat out not suitable for use cases where you need
> unattended raid1 degraded boot.

Agreeing in general and adding some detail...

1) Are you intending to use an initr*?  I'm not sure the current status 
(I actually need to test again for myself), but at least in the past, 
booting a btrfs raid1 rootfs required an initr*, and I have and use one 
here, for that purpose alone (until switching to btrfs raid1 root, I went 
initr*-less, and would prefer that again, due to the complications of 
maintaining an initr*).

The base problem is that with raid1 (or other forms of multi-device 
btrfs, but it happens to be raid1 that's in question for both you and I) 
the filesystem needs multiple devices to complete the filesystem and the 
kernel's root= parameter takes only one.  When mounting after userspace 
is up, a btrfs device scan is normally run (often automatically by udev) 
before the mount, that lets btrfs in the kernel track what devices belong 
to what filesystems, so pointing to just one of the devices is enough 
because the kernel knows from that what filesystem is intended and can 
match up the others that go with it from the earlier scan.

Now there's a btrfs mount option, device=/dev/*, that can be provided 
more than once for additional devices, that can /normally/ be used to 
tell the kernel what specific devices to use, bypassing the need for 
btrfs device scan, and in /theory/, passing that like other mount options 
in the kernel commandline via rootflags= /should/ "just work".

But for reasons I as a btrfs user (not dev, and definitely not kernel or 
btrfs dev) don't fully understand, passing device= via rootflags= is, or 
at least was, broken, so properly mounting a multi-device btrfs required 
(and may still require) userspace, thus for a multi-device btrfs rootfs, 
an initr*.

So direct-booting to a multi-device btrfs rootfs didn't normally work.  
It would if you passed rootflags=degraded (at least with a two-device 
raid1 so the one device passed in root= contained one copy of 
everything), but then it was unclear if the additional device was 
successfully added to the raid1 later, or not.  And with no automatic 
sync and bringing back to undegraded status, it was a risk I didn't want 
to take.  So unfortunately, initr* it was!

But I originally tested that when I setup my own btrfs raid1 rootfs very 
long ago in kernel and btrfs terms, kernel 3.6 or so IIRC, and while I've 
not /seen/ anything definitive on-list to suggest rootflags=device= is 
unbroken now (I asked recently and got an affirmative reply, but I asked 
for clarification and I've not seen it, tho perhaps it's there and I've 
not read it yet), perhaps I missed it.  And I've not retested lately, tho 
I really should as while I asked I guess the only real way to know is to 
try it for myself, and it'd definitely be nice to be direct-booting 
without having to bother with an initr*, again.

2) As both Chris and I alluded to, unlike say mdraid, btrfs doesn't (yet) 
have an automatic mechanism to re-sync and "undegrade" after having been 
mounted degraded,rw.  A btrfs scrub can be run to re-sync raid1 chunks, 
but single chunks may have been added while in the degraded state as 
well, and those need a balance convert to raid1 mode, before the 
filesystem and data on it can be be considered reliably able to withstand 
device loss once again.

In fact, while the problem has been fixed now, for quite awhile if the 
filesystem was mounted degraded,rw, you often had exactly that one mount 
to fix the problem, as new chunks would be written in single mode and 
after that the filesystem would refuse to mount writable,degraded, and 
would only let you mount degraded,ro, which would let you get data off it 
but not let you fix the problem.  Word to the wise if you're planning on 
running stable-debian (which tend to be older) kernels, or even just 
trying to use them for recovery if you need to!  (The fix was to have a 
mount check if at least one copy of all chunks were available and allow rw 
mounting if so, instead of simply assuming that any single-mode chunks at 
all meant some wouldn't be available on a multi-device filesystem with a 
device missing, thus forcing read-only mode only mounting, as it used to 
do.)

3) If a btrfs raid1 is mounted degraded,rw with one device missing, then 
mounted again degraded,rw, with a different device missing, without a 
full resync between them, the two separately missing devices have 
diverged and it's no longer safe to mount them together (there's a 
transaction generation check and the newest will be used, so the old copy 
on a single missing device shouldn't be used, but if the filesystem was 
mounted writable separately with different devices missing and the 
generation numbers for some needed data or metadata happen to be the same 
on both...).  Doing so may result in data loss, depending on the extent 
of the writes to each device while in degraded mode.

And it's worthwhile to note as well that due to COWed (copy-on-write-ed) 
metadata blocks, it's not just newly written data that may go missing.  
Old data is at risk too, if its metadata is in a block that was modified 
and thus COWed to a new location so it's different on the two devices.

So if for some reason do /do/ mount degrade,rw, with one device only 
temporarily missing, make sure you mount all devices undegraded and resync 
(scrub and balance-convert any resulting single chunks to raid1) as soon 
as possible, and be **SURE** not to mount with the originally missing 
device there and another device missing, until that is done!  Or at least 
if you do, **NEVER** then mount with both separately missing devices 
there again, unless you like gambling with the chance of lost data.

4) Systemd has a very irritating btrfs default udev rule...

/lib/udev/rules.d/64-btrfs.rules (path on my gentoo system but I believe 
it's systemd/udev-canonical)

... that will often try to second-guess the kernel and *immediately* 
unmount a degraded-mount filesystem if devices are missing, despite the 
degraded mount option and the kernel actually successfully mounting the 
degraded filesystem.  ("Immediately" means so fast it can appear that the 
filesystem wasn't mounted at all -- the only way you can really tell it 
was mounted is by checking dmesg for the normal kernel-btrfs mount 
messages, and the fact that mount returned a successful exit status.)

The systemd devs say the btrfs devs instituted btrfs device ready (which 
the rule uses) wrong, and the btrfs devs say the systemd devs are 
misusing it, but regardless, it's the sysadmins with a broken filesystem 
they're trying to fix or even just get to stay mounted long enough to get 
the data off it, left trying to pick up the pieces.

The solution here is to disable the udev rule in question, tho you may 
want to do that only if you actually need to mount degraded, since in the 
normal case it is helpful as it ensures all devices for a filesystem are 
actually there before it tries mounting.  (The btrfs devs say it should 
try mounting multiple times, before giving up after a timeout, so that 
mounting degraded will work when necessary, instead of using btrfs device 
ready, which is only intended to check whether all devices are there, not 
whether enough are there to mount degraded, but that's not what the 
systemd/udev people did, so the rule still helps in the normal case, but 
severely complicates things in the degraded case.)

So if you ever find yourself (presumably in the initr* for a btrfs 
rootfs) unable to keep a degraded btrfs mounted on a systemd-based 
system, because systemd keeps unmounting it (again, unless you're looking 
at dmesg or the mount status, it'll unmount so fast you'll likely think 
it was never mounted, been there, done that, was very confused until I 
remembered reading about the problem on the list and checked mount's exit 
status and dmesg, sure enough it was mounting and getting unmounted!), 
try mving/rming /lib/udev/rules.d/64-btrfs.rules, or simply commenting 
the guts of it, and see if the btrfs actually stays mounted after that.

And if you're not on an initr* or other temporary media where your 
changes are only ephemeral when it happens and you do the mv/rm, don't 
forget to put it back if appropriate later, because systemd isn't written 
to keep trying and will just fail the mount if a btrfs component device 
is a bit slow to appear, otherwise.

5) As a result of #2 and 3, mounting degraded except to recover and 
repair from a device malfunction is not recommended, nor is simply adding 
"degraded" to your mount options "just in case" or other unattended 
degraded mounting.  Don't put degraded in your normal mount options so 
you know when something breaks due to the mount failure and can fix it 
right then with your first and ideally only degraded,rw mount, and do the 
appropriate sync-maintenance immediately afterward.

OK, so if you've absorbed all that and you're only trying to make booting 
the btrfs raid1 rootfs degraded /possible/ for recovery purposes, go 
right ahead!  That's what btrfs raid1 is for, after all.  But if you were 
planning on mounting degraded (semi-)routinely, please do reconsider, 
because it's just not ready for that at this point, and you're going to 
run into all sorts of problems trying to do it on an ongoing basis due to 
the above issues.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
