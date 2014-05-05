Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41831 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbaEEC3e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 22:29:34 -0400
Date: Sun, 4 May 2014 18:27:19 -0700
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>, Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is metadata redundant over more than one drive with raid0 too?
Message-ID: <20140505012719.GD10159@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$a3b93$98e8eca3$3f96ad92$ba13c4f@cox.net>
 <5365EFE9.8000300@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 04, 2014 at 09:44:41AM +0200, Brendan Hide wrote:
> >Ah, I see the man page now "This is because SSDs can remap blocks
> >internally so duplicate blocks could end up in the same erase block
> >which negates the benefits of doing metadata duplication."
> 
> You can force dup but, per the man page, whether or not that is
> beneficial is questionable.

So the reason I was confused originally was this:
legolas:~# btrfs fi df /mnt/btrfs_pool1
Data, single: total=734.01GiB, used=435.39GiB
System, DUP: total=8.00MiB, used=96.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=8.50GiB, used=6.74GiB
Metadata, single: total=8.00MiB, used=0.00

This is on my laptop with an SSD. Clearly btrfs is using duplicate
metadata on an SSD, and I did not ask it to do so.
Note that I'm still generally happy with the idea of duplicate metadata
on an SSD even if it's not bulletproof.

> >What's the difference between -m dup and -m raid1
> >Don't they both say 2 copies of the metadata?
> >Is -m dup only valid for a single drive, while -m raid1 for 2+ drives?
> 
> The issue is that -m dup will always put both copies on a single
> device. If you lose that device, you've lost both (all) copies of
> that metadata. With -m raid1 the second copy is on a *different*
> device.

Aaah, that explains it now, thanks. So -m dup is indeed kind of stupid
if you have more than one drive.
 
> I believe dup *can* be used with multiple devices but mkfs.btrfs
> might not let you do it from the get-go. The way most have gotten
> there is by having dup on a single device and then, after adding
> another device, they didn't convert the metadata to raid1.

Right, that also makes sense.

> >-d raid0: if you one 1 drive out of 2, you may end up with small files
> >and the rest will be lost
> >
> >-d single: you're more likely to have files be on one drive or the
> >other, although there is no guarantee there either.
> >
> >Correct?
> 
> Correct

Thanmks :)

On Sun, May 04, 2014 at 09:49:24PM +0000, Duncan wrote:
> Brendan has answered well, but sometimes a second way of putting things 
> helps, especially when there was originally some misconception to clear 
> up, as seems to be the case here.  So let me try to be that rewording. 
> =:^)

Sure, that can always help.
 
> No.  Btrfs raid1 (the multi-device metadata default) is (still only) two 
> copies, as is btrfs dup (which is the single-device metadata default 
> except for SSDs).  The distinction is that dup is designed for the single 
> device case and puts both copies on that single device, while raid1 is 
> designed for the multi-device case, and ensures that the two copies 
> always go to different devices, so loss of the single device won't kill 
> the metadata.

Yep, I got that now.

> Dup mode being designed for single device usage only, it's normally not 
> available on multi-device filesystems.  As Brendan mentions, the way 
> people sometimes get it is starting with a single-device filesystem in dup 
> mode and adding devices.  If they then fail to balance-convert, old 
> metadata chunks will be dup mode on the original device, while new ones 
> should be created as raid1 by default.  Of course a partial balance-
> convert will be just that, partial, with whatever failed to convert still 
> dup mode on the original single device.

Yes, that makes sense too.
 
> Finally, for the single-device-filesystem case, dup mode is normally only 
> allowed for metadata (where it is again the default, except on ssd), 
> *NOT* for data.  However, someone noticed and posted that one of the side-
> effects of mixed-block-group mode, used by default on filesystems under 1 
> GiB but normally discouraged on filesystems above 32-64 gig for 
> performance reasons, because in mixed-bg mode data and metadata share the 
> same chunks, mixed-bg mode actually allows (and defaults to, except on 
> SSD) dup for data as well as metadata.  There was some discussion in that 

Yes, I read that. That's an interesting side effect which could be used
in some cases.

> thread as to whether that was a deliberate feature or simply an 
> accidental result of the sharing.  Chris Mason confirmed it was the 
> latter.  The intention has been that dup mode is a special case for 
> rather critical metadata on a single device in ordered to provide better 
> protection for it, and the fact that mixed-bg mode allows (indeed, even 
> defaults to) dup mode for data was entirely an accident of mixed-bg mode 
> implementation -- albeit one that's pretty much impossible to remove.  
> But given that accident and the fact that some users do appreciate the 
> ability to do dup mode data via mixed-bg mode on larger single-device 
> filesystems even if it reduces performance and effectively halves storage 
> space, I expect/predict that at some point, dup mode for data will be 
> added as an option as well, thereby eliminating the performance impact of 
> mixed-bg mode while offering single-device duplicate data redundancy on 
> large filesystems, for those that value the protection such duplication 
> provides, particularly given btrfs' data checksumming and integrity 
> features.

This would indeed be nice for some uses, great to know.
 
(...)
> No.  That's the distinction between raid0 mode and single mode.  Raid0 
> mode effectively sacrifices everything else for (single thread sequential 
> access) speed.  If a device drops out, consider anything that was raid0 
> toast.

Thanks for confirming.

> But those are the lucky cases.  As I said above, the general rule is that 
> anything on raid0 is destroyed if a device drops, so you never NEVER 
> stick anything on raid0 that you value at all, and then you won't have to 
> worry about it! =:^)
 
That's correct.
The original reason why I was asking myself this question and trying to
figure out how much better 
-m raid1 -d raid0
was over
-m raid0 -d raid0

I think the summary is that in the first case, you're going to to be
abel to recover all/most small files (think maildir) if you lose one
device, whereas in the 2nd case, with half the metadata missing, your FS
is pretty much fully gone.
Fair to say that?

Now, if I don't care about speed, but wouldn't mind recovering a few
bits should something happen (actually in my case mostly knowing the
state of the filesystem when a drive was lost so that I can see how
many new files showed up since my last backup), it sounds like it
wouldn't be bad to use:
-m raid1 -d linear

This will not give me the speed boost from raid0 which I don't care
about, it will give me metadata redundancy, and due to linear, there is
a decent chance that half my files are intact on the remaining drive
(depending on their size apparently).


(snip)
> sequential-access.  And the price it pays for that optimization is, IMO, 
> very rarely worth it, tho if you have that use-case and are prepared to 
> pay the cost in terms of data-loss risk, it can /indeed/ be worth it.  
> Just be sure that's your use case, preferably testing a raid0 deployment 
> in actual use to be sure it's giving you that extra speed, because in 
> many cases, it won't, and then it's simply NOT worth the data risk cost, 

So one place I use it is not for speed but for one FS that gives me more
space without redundancy (rotating buffer streaming video from security
cams).
At the time I used -m raid1 -d raid0, but it sounds for slightly extra
recoverability, I should have ued -m raid1 -d linear (and yes, I
undertand that one should not consider a -d linear recoverable when a
drive went missing).

Thanks for going through those scenario with me :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
