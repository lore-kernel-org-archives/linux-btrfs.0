Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36300 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaJJCEo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Oct 2014 22:04:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XcPZS-0004no-6r
	for linux-btrfs@vger.kernel.org; Fri, 10 Oct 2014 04:04:42 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 04:04:42 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 04:04:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fwd: Confusion with newly converted filesystem
Date: Fri, 10 Oct 2014 02:04:24 +0000 (UTC)
Message-ID: <pan$b0425$ee6a20ac$73d43927$36624189@cox.net>
References: <CAAKzf7nLzh1ck7YK8z_E3fx1hK5zWLbKRh1NiG5oVpxuaGtO7Q@mail.gmail.com>
	<CAAKzf7=XxK0FXtSrMtFou-gZ9DDYJtuHFy4R5cdjQFjBm0urvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tim Cuthbertson posted on Thu, 09 Oct 2014 13:58:58 -0500 as excerpted:

> I ran "btrfs subv delete /ext2_saved". Then I ran "btrfs balance start
> /".
> That relocated 15 of 15 chunks. Now fi show shows 2.03 GB used on each
> device and fi df shows 1 GB of metadata total.
> 
> Apparently, that saved ext4 subvolume was a real mess.

Yes and no.

The problem is that ext4 and btrfs work rather differently from each 
other, and btrfs can't manage the saved ext4 subvolume as it would normal 
btrfs subvolumes because doing so would break the ext4 side, killing the 
ability to roll-back to ext4 that's the whole point of keeping that 
dedicated subvolume.

So once you are sure you aren't going to roll-back, deleting the ext4 
saved subvolume, thus allowing btrfs to manage the entire filesystem 
without the previously ext4 stuff getting in the way, is high priority.

IOW the conversion, like many conversions, is a compromise.  It serves a 
certain purpose, but until the legacy stuff is gone, the new stuff is 
hobbled and can't be used to full effect.

So yes, any btrfs converted from ext4 is going to be a real mess, in 
btrfs terms, until that ext4 saved subvolume is deleted, because it 
simply can't manage it like it can native btrfs since doing so would 
break the ability to roll back to the ext4.  But it's an expected mess, 
and it's only a mess because the native formats differ.  The ext4 image 
can be just fine in ext4, and when it is removed, btrfs is normally just 
fine as well.  It's just the btrfs with the ext4 image still there that's 
a problem, and that only because the ext4 image isn't really playing by 
btrfs native rules, so btrfs can't properly manage it.


BTW, if it was letting you balance without an error than you probably 
didn't run into this particular problem that often happens with ext* 
conversions, likely because the filesystem was new and basically all 
relatively small (under 1 GiB) distro files, but it's worth knowing about 
and doing the one additional step, just to be sure, plus for possible 
future conversions.

With ext4, extent size is effectively unlimited.  A full 4.7 GiB DVD ISO 
image file, for instance, properly defragged, can appear as a single 4.7 
GiB extent.  No problem on ext4 and in fact that'd be the ideal.

On btrfs, by contrast, data chunk size, and thus largest possible extent 
size, is 1 GiB.  That 4.7 GiB DVD ISO image would have to be broken up 
into at least five extents, four of a full GiB each plus the sub-GiB 
remainder of the file.  In practice it'd likely be six extents, the 
beginning of the file using what was left of the current data chunk, four 
complete 1 GiB data chunks, and whatever was left beginning a sixth data 
chunk, that would eventually be filled with other file data as well.

Of course the same thing applies to other large files, whatever their 
content and size.  Big VM images are one example, big database files 
another, big multi-gig archive files yet another, big non-ISO media files 
again another.

As a result, people with these sorts of large files on their originating 
ext4 filesystem tend to run into problems with btrfs balance, etc, after 
the conversion, because btrfs balance expects to see extents no larger 
than the btrfs-native 1 GiB data chunk, and doesn't know what to do with 
these > 1 GiB "super-extents".

On converted btrfs with this sort of file, balance will simply error out 
while the ext4 saved subvolume remains, and normally even after it is 
gone, until a btrfs filesystem defrag is run on the former ext4 content 
to break up these super-extents into 1 GiB maximum native btrfs data 
chunks that btrfs in general and btrfs balance in particular can actually 
handle.

Since you didn't run into this problem, you evidently either didn't have 
any of these > 1 GiB files, not surprising on a fresh install, or if you 
did, they were already fragmented enough for btrfs balance to handle.

However, I'd still recommend doing a proper btrfs filesystem defrag and 
then another balance, the combination of which should ensure that every 
last bit of what remains of the ext4 formatting is properly converted to 
btrfs native.  Given that you already completed a balance the defrag and 
rebalance may not matter, but better to do it unnecessarily now and be 
sure, than to run into problems and /wish/ you had done so later.

Additionally, doing it now, before you add too many additional files to 
the filesystem, will be easier and take less time than doing it later.


One more tip while we're talking about defrag:  If you don't have any big 
(> half a GiB) files to deal with, or if you do but they're all 
essentially static files (like already written media files that aren't 
going to be edited in-place), I'd strongly recommend using btrfs' 
autodefrag mount option, which I use on all my btrfs here.

OTOH, for large "internal rewrite pattern" files such as active VM image 
files, big database files, even big torrented files until they're fully 
downloaded and not being rewritten any longer, the autodefrag mount 
option doesn't scale so well.  Very briefly, consider using the nocow 
file attribute on these types of files.  But there's more to it than that 
especially if you're planning on making regular use of btrfs 
snapshotting, so this is primarily intended as a pointer for where to 
start your own research on the subject, and perhaps a new thread if you 
have further questions after that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

