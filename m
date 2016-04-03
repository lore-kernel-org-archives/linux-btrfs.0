Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39825 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbcDCECS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Apr 2016 00:02:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amZEp-0002zn-5g
	for linux-btrfs@vger.kernel.org; Sun, 03 Apr 2016 06:02:11 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Apr 2016 06:02:11 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Apr 2016 06:02:11 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Sun, 3 Apr 2016 06:02:02 +0200
Message-ID: <20160403060202.03e67651@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 2 Apr 2016 18:14:17 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

> On Sat, Apr 2, 2016 at 2:16 PM, Kai Krakow <hurikhan77@gmail.com>
> wrote:
> 
> > I'll go checking the RAM for problems - tho that would be the first
> > time in twenty years that a RAM module hadn't errors from the
> > beginning. Well, you'll never know. But I expect no error since
> > usually this would mean all sorts of different and random problems
> > which I don't have. Problems are very specific, which is atypical
> > for RAM errors.  
> 
> Well so far it's just the VDI that's experiencing csum mismatch
> errors, right? So that's not bad RAM, which would affect other files
> too. And same for a failing SSD.

No, other files are affected, too. And it looks like those files are
easily affected even when removed and recreated from whatever backup
source.

> I think you've got a bug somewhere and it's just hard to say where it
> is based on the available information. I've already lost track if
> others have all of the exact same setup you do: bcache + nossd +
> autodefrag + lzo + VirtualBox writing to VDI on this Btrfs volume.
> There are others who have some of those options, but I don't know if
> there's anyone who has all of those going on.

I didn't run VirtualBox since the incident. So I'd rule out VirtualBox.
Currently, there seems to be no csum error for the VDI file, instead
now another file gets corruptions, even after recreated. I think it is
result of another corruption and thus a side effect.

Also I think, having options nossd+autodefrag+lzo shouldn't be an
exotic or unsupported option. Having this on top of bcache should just
work.

Let's not rule out bcache had a problem although I usually expect
bcache to freak out with internal btree corruption then.

> Maybe Qu has some suggestions, but if it were me I'd do this. Build
> mainline 4.5.0, it's a known quantity by Btrfs devs.

4.5.0-gentoo is currently only a few patches so I could easily build
vanilla.

> Build the kernel
> with BTRFS_FS_CHECK_INTEGRITY enabled in kernel config. And when you
> mount the file system, don't use mount option check_int, just use your
> regular mount options and try to reproduce the VDI corruption. If you
> can reproduce it, then start over, this time with check_int mount
> option included along with the others you're using and try to
> reproduce. It's possible there will be fairly verbose kernel messages,
> so use boot parameter log_buf_len=1M and then that way you can use
> dmesg rather than depending on journalctl -k which sometimes drops
> messages if there are too many.

Does it make sense while I still have the corruptions in the FS? I'd
like to wait for Qu whether I should recreate the FS or whether I
should take some image, or send info to improve btrfsck...

I'm pretty sure I do not have reproducible corruptions which are not
caused by another corruption - so check_int would probably be of less
use currently.

> If you reproduce the corruption while check_int is enabled, kernel
> messages should have clues and then you can put that in a file and
> attach to the list or open a bug. FWIW, I'm pretty sure your MUA is
> wrapping poorly, when I look at this URL for your post with smartctl
> output, it wraps in a way that's essentially impossible to sort out at
> a glance. Whether it's your MUA or my web browser pretty much doesn't
> matter, it's not legible so what I do is just attach as file to a bug
> report or if small enough onto the list itself.
> http://www.spinics.net/lists/linux-btrfs/msg53790.html

Claws mail is just too smart for me... It showed up correctly in the
editor before hitting the send button. I wish I could go back to knode
(that did it's job right). But it's currently an unsupported orphan
project of KDE. :-(

> Finally, I would retest yet again with check_int_data as a mount
> option and try to reproduce. This is reported to be dirt slow, but it
> might capture something that check_int doesn't. But I admit this is
> throwing spaghetti on the wall, and is something of a goose chase just
> because I don't know what else to recommend other than iterating all
> of your mount options from none, adding just one at a time, and trying
> to reproduce. That somehow sounds more tedious. But chances are you'd
> find out what mount option is causing it; OR maybe you'd find out the
> corruption always happens, even with defaults, even without bcache, in
> which case that'd seem to implicate either a gentoo patch, or a
> virtual box bug of some sort.

I think the latter two are easily the least probable sort of bugs. But
I'll give it a try. For the time being, I could switch bcache to
write-around mode - so it could at least not corrupt btrfs during
writes.

-- 
Regards,
Kai

Replies to list-only preferred.

