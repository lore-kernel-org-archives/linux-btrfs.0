Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57352 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaDKFyz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 01:54:55 -0400
Date: Thu, 10 Apr 2014 22:54:54 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 24/27] btrfs-progs: Convert man page for btrfs-zero-log
Message-ID: <20140411055454.GC7322@merlins.org>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com> <1396427378-10487-25-git-send-email-quwenruo@cn.fujitsu.com> <20140404184620.GA12124@merlins.org> <534353EB.9020601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534353EB.9020601@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 08, 2014 at 09:42:03AM +0800, Qu Wenruo wrote:
> >I had debian add this to the initramfs initrd by default so that someone
> >can recover their root filesystem with this command if it won't mount.
> >
> >What got fixed is the kernel used to oops and crash, and now it gives a
> >nice "can't mount" error message.
> >
> >Marc
> Thanks for the note.
> 
> After reading following up mails on the thread, I agree that the note is 
> needed.
> 
> But I would like to add more method to judge whether to call 
> btrfs-zero-log or other tools like btrfsck.
 
Sounds like a good idea. It may also make sense in places to have the man
page point to the btrfs wiki for more detailled info since it's easier to
update the wiki than to update the man page on thousands or millions of
systems :)

I wrote 
http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair
which is linked off
https://btrfs.wiki.kernel.org/index.php/Btrfsck
which I just updated with more details.

It would be great to put a pointer to the official wiki in the man page, and
also in the btrfsck man page which currently doesn't warn people enough that
they have many other options to try before btrfsck.

Now that I updated the official wiki page, would you agree that it would be
good to link to it in the man page?

> It would be quite nice if any one can provide a log-tree-broken small 
> btrfs image for me to test?
> (Personally, I would prefer using dmesg warning/backtrace and btrfsck 
> result to make sure to call btrfs-zero-log)

Unfortunately, my broken SSD that was generating that corruption has been
returned to the vendor, and my new SSD doesn't crash anymore, so I don't
have such broken filesystem anymore.
 
> P.S: If btrfs can be automatically mounted as RO when log tree is 
> broken, it would be better.
> But it also seems log tree related things will be improved sooner or 
> later, it may not be so urgent.

I agree this is a great idea, especially if it's the root filesystem without
which you can't fix the machine that's broken.

Thank you,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
