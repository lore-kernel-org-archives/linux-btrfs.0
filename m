Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41302 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdGaEx1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 00:53:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dc2hj-0004ZQ-1C
        for linux-btrfs@vger.kernel.org; Mon, 31 Jul 2017 06:53:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more
 recent gen (33682) compared to the found root node (0)
Date: Mon, 31 Jul 2017 04:53:07 +0000 (UTC)
Message-ID: <pan$3b64a$a9b921fc$3e4651f5$627d0636@cox.net>
References: <20170501170641.GG3516@merlins.org>
        <20170707163834.GA6083@merlins.org> <20170709043417.GE6704@merlins.org>
        <21425367.VGcO8ck7Vu@merkaba>
        <MEXPR01MB216863F67F4553F8564CC3CD9EA80@MEXPR01MB2168.ausprd01.prod.outlook.com>
        <pan$2b9aa$a4dca8a2$fc1e4ebe$a8fffbe3@cox.net>
        <CAK5rZE7sj+T8-x0q=wPXeHKN4zBZGc2Jhj9NYA7ZQcV+yk2XSA@mail.gmail.com>
        <pan$12269$5fb80e78$f5b26ca4$74a3427f@cox.net>
        <CAK5rZE6vMujb5KEqwUZD2-ZmZ4vi2T4+J2BzTLi9qqx8GeFKgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Imran Geriskovan posted on Sun, 30 Jul 2017 16:54:25 +0200 as excerpted:

> On 7/30/17, Duncan <1i5t5.duncan@cox.net> wrote:
>>>> Also, all my btrfs are raid1 or dup for checksummed redundancy
> 
>>> Do you have any experience/advice/comment regarding dup data on ssds?
> 
>> Very good question. =:^)
> 
>> Limited.  Most of my btrfs are raid1, with dup only used on the device-
>> respective /boot btrfs (of which there are four, one on each of the two
>> ssds that otherwise form the btrfs raid1 pairs, for each of the working
>> and backup copy pairs -- I can use BIOS to select any of the four to
>> boot), and those are all sub-GiB mixed-bg mode.
> 
> Is this a military or deep space device? ;)

Just happens to have four physical ssds, two pairs, with everything but 
/boot being paired btrfs raid1.  Because I wanted similar partition 
layout for ease of management, that's a /boot on each one, and because 
bios can only point to one at a time, that's four separate grub installs
[1], each of which is configured to load its own /boot.

While four is a bit much, three can certainly be very useful, because it 
allows a bad grub upgrade to be core-installed to one BIOS-boot 
partition, while allowing me to fat-finger point it to the wrong /boot on 
a second device destroying my ability to boot to it as well, and still 
have a third untouched to boot from.  The forth is simply bonus insurance 
on that, more by accident due to having two pair than because I really 
needed it.

A minimum of three /boots is also quite convenient for my kernel update 
routine, given I routinely test and sometimes bisect pre-release 
kernels.  The default/working /boot gets the prereleases with a release 
and stable fallback, the first backup the releases and a stable fallback, 
and the secondary backups get updated less frequently, generally when I'm 
doing a / backup cycle as well and there has been either a kernel config 
or system change substantial enough that I'm no longer confident the 
older kernels will work correctly with the updated system.

Of course the same general testing/release/stable /boot system works well 
for other related updates, say to the grub menu (I use grub2's bash-like 
scripting language directly, not the high level stuff which I find too 
difficult to tweak to my liking) or the initrd, which I attach to the 
individual kernels at build-time, so a tested kernel selection is a 
tested initramfs selection as well.

> For /boot, I've also tried dup data.
> 
> But because of combinations of constraints you've mentioned,
> I totally give-up trying to have a bullet proof /boot as my poor laptop
> is not mission critical as your device and as I do always have bootable
> backups and always carry some bootable sdcards.

When I complained about the 64-MiB default mixed-bg mode chunk size on a 
256 MiB filesystem being too big to allow balance in dup mode, a dev 
answered that in theory chunk sizes are supposed to be limited to 1/8 
filesystem size (down to something like a 16 MiB minimum chunk size I 
think, but might be 8 or 32), but something about my setup, likely the 
mixed-bg mode as it's less tested, was short-circuiting that, thus the 
quarter-fs-size 64 MiB chunk sizes, which he agreed didn't make much 
sense on a 256 MiB filesystem in dup mode.

He was able to duplicate the problem, and there seemed no disagreement is 
was a bug, but I'm not sure if mkfs.btrfs was ever patched to fix it, and 
of course now with the bigger half-gig filesystem the same 64-MiB initial 
chunk size is fine.

And my other quarter-gig btrfs, log, is raid1, quarter-gig per device, so 
I'd not see the problem there, mixed-mode or not.  (As mentioned in the 
footnote below, at least in this go-round it's not... more by accident 
than intent.)

Meanwhile, such bugs come with the territory when you're running what 
might be roughly compared at the commercial software level to late beta 
or rc level software, or even initial release, pre-service-release-1, 
level, which I'd argue is a more accurate btrfs comparison at this 
point.  As long as you stay within the known stable areas the danger of 
it eating your data is relatively small now, but the full feature set 
isn't there yet, and some of the features that are there are 
significantly less mature and stable than others.

> Perhaps that has something to do with me kicking out all systemd, inits,
> initramfs, mkinitcpio, dracut, etc, etc.
> 
> Now the init on /boot is a "19 lines" shell script, including lines for
> keymap, hdparm, crytpsetup. And let's not forget this is possible by a
> custom kernel, its reliable buddy syslinux.

FWIW...

I really like grub2, especially it's quite flexible bash-like scripting 
language (the higher level stuff intended for normal users just isn't 
flexible enough for me, so I need the scripting language anyway, and once 
I knew that, the higher level stuff only got in the way) and command line 
that allow all sorts of stuff like browsing for kernel commandline 
documentation at the boot prompt that I never imagined possible in a boot 
manager.

And after holding off for awhile, I'm now a cautious adopter and 
supporter of systemd in general, tho I don't use its solutions for 
/everything/ and don't like its extremely aggressive feature expansion.

And after resisting an initr* for years as unnecessary, I've been a 
reluctant adopter since a btrfs raid1 root effectively requires it 
(rootflags=device= doesn't seem to work, for whatever reason, or at least 
didn't when I initially converted to btrfs, so at least a limited initr* 
seems the only viable solution for a btrfs raid1 root).

And I'm using dracut for that, tho quite cut down from its default, with 
a monolithic kernel and only installing necessary dracut modules.

But particularly after the last dracut update pulled in kmod as a 
mandatory dep as it now links against its libs, despite my monolithic 
kernel built without module support, I've been considering similar initr* 
alternatives, including hand-rolling my own initr* build scripts.

Because I'm still not happy having to run an initr* at all, especially 
since there's more "magic" there than I'm particularly comfortable with 
since I like to grok the boot and thus potential recovery process better 
than I do this, and dracut was just the most convenient option at the 
time.

But kmod isn't a /huge/ dep, particularly with the executables and docs 
install-masked so it's only the library, headers and *.pc config file 
installed, and the current dracut solution works /reasonably/ well, so 
finding/creating an alternative isn't particularly high on my priority 
list, and I'll probably never do it unless dracut suddenly decides some 
of its other modules are going to need mandatory deps, or something else 
radically changes the current fragile balance and I really do need that 
currently lacking initr* grok.

> Interestingly my seach for reliability started with "dup data" and ended
> up here. :)

=:^)

---
[1] Grub and partition layout:  I install grub-core (i386-pc) to a raw 
GPT legacy BIOS boot partition.  While this only requires a partition 
size of about a third of a MiB, I use gdisk's default 1 MiB alignment and 
the first MiB is the GTP and the alignment gap, so this first BIOS boot 
partition starts at 1 MiB and must be a whole MiB unit in size.  Because 
I wanted plenty of room, however, and wanted additional partitions a 
minimum of 4 MiB aligned, I configured a 3 MiB BIOS boot partition for 
grub to use, thus accomplishing that 4 MiB alignment for further 
partitions.

The second partition is a currently unused GPT EFI partition for forward 
compatibility, 252 MiB in size so further partitions are quarter-GiB 
aligned.

The third partition is the /boot partition we've been discussing, a half 
GiB in size, thus ending at 3/4 GiB.  It's my only btrfs mixed-mode dup 
in the layout, so a half gig in size but a quarter gig usable.  As 
mentioned, with four physical ssds that's a total of four /boots, each 
pointed at by the grub-core installation in the first partition on the 
corresponding ssd.

Partition 4 is the log partition, a quarter GiB in size as log rotation 
keeps typical usage under 50 MiB, but the quarter gig size means it ends 
on the 1 GiB boundary and further partitions are GiB aligned.  In the 
last layout generation this was a half gig and /boot a quarter gig, but I 
decided /boot could use the extra quarter gig more than log so I traded 
sizes.  This, like all further partitions, is btrfs raid1.  I intended to 
make it mixed-bg mode, as it was in the previous generation layout, but 
forgot the mkfs.btrfs switch for that and it no longer defaults to mixed 
at under a gig, so I got standard mode.  Never-the-less, with raid1 
instead of dup, and low normal usage, the chunk size is small enough that 
balance shouldn't be an issue, and if it is I can always blow it away and 
recreate in mixed mode.

All further partitions are gig-aligned btrfs raid1 pair-device, three 
copies, working/0 and backups 1 and 2, on two separate pairs of ssds.  
The older pair is 256GB/238GiB with the backup/1 copy, the newer pair is 
1TB/931GiB with working/0 and backup/2.  The partition size and layout is 
identical on all four thru the sub-GiB and first copy, with the second 
copy on the larger pair being a same-sequence same-size repeat of the 
first, beyond the non-duplicated sub-GiB, of course.  So as long as the 
GPT on one of the four remains intact and bootable, I can easily recreate 
the other three.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

