Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38667 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbcF1WwP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 18:52:15 -0400
Received: by mail-wm0-f48.google.com with SMTP id r201so47999809wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 15:52:14 -0700 (PDT)
Received: from system (dslb-088-067-121-064.088.067.pools.vodafone-ip.de. [88.67.121.64])
        by smtp.gmail.com with ESMTPSA id a198sm1587709wme.16.2016.06.28.15.52.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jun 2016 15:52:11 -0700 (PDT)
Date: Wed, 29 Jun 2016 00:52:08 +0200
From: Saint Germain <saintger@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug during RAID1 replace
Message-ID: <20160629005208.5e9addcf@system>
In-Reply-To: <CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
References: <20160627233612.662d2a9a@system>
	<CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
	<20160628002602.022258bf@system>
	<CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
	<CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
	<20160628010618.58e235fa@system>
	<CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
	<20160628024940.3b323b26@system>
	<CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Jun 2016 20:14:58 -0600, Chris Murphy
<lists@colorremedies.com> wrote :

> On Mon, Jun 27, 2016 at 6:49 PM, Saint Germain <saintger@gmail.com>
> wrote:
> 
> >
> > I've tried both option and launched a replace, but I got the same
> > error (replace is cancelled, jernel bug).
> > I will let these options on and attempt a ddrescue on /dev/sda
> > to /dev/sdd.
> > Then I will disconnect /dev/sda and reboot and see if it works
> > better.
> 
> Sounds reasonable. Just make sure the file system is already unmounted
> when you use ddrescue because otherwise you're block copying it while
> it could be modified while rw mounted (generation number tends to get
> incremented while rw mounted).
> 
> 

Well I made a ddrescue image of both drives (only one error on sdb
during ddrescue copy) and started the computer again (after
disconnecting the old drives).

However the errors remains there, and I still cannot scrub (scrub is
aborted), nor delete the file which have errors (drive is remounted
read-only if I try to delete the files).

I don't know if I should continue trying to repair this RAID1 or if I
should just cp/rsync to a new BTRFS volume and get done with it.
On the other hand it seems interesting to repair instead of just giving
up. It gives a good look at BTRFS resiliency/reliability.

Here is the log from the mount to the scrub aborting and the result
from smartctl.

Thanks for your precious help so far.


BTRFS error (device sdb1): cleaner transaction attach returned -30
BTRFS info (device sdb1): disk space caching is enabled
BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714507, gen 1335
BTRFS info (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21622, gen 24
scrub_handle_errored_block: 164 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 93445255168 on dev /dev/sdb1, sector 54528696, root 5, inode 3434831, offset 479232, length 4096, links 1 (path: user/.local/share/zeitgeist/activity.sqlite-wal)
btrfs_dev_stat_print_on_error: 164 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714508, gen 1335
scrub_handle_errored_block: 164 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 93445255168 on dev /dev/sdb1
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714509, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 93445259264 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 93445255168 on dev /dev/sda1, sector 77669048, root 5, inode 3434831, offset 479232, length 4096, links 1 (path: user/.local/share/zeitgeist/activity.sqlite-wal)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21623, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 93445255168 on dev /dev/sda1
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21624, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 93445259264 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349810688 on dev /dev/sda1, sector 140429952, root 5, inode 4265283, offset 0, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21625, gen 24
BTRFS warning (device sdb1): checksum error at logical 136349929472 on dev /dev/sda1, sector 140430184, root 5, inode 4265283, offset 118784, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS warning (device sdb1): checksum error at logical 136350060544 on dev /dev/sda1, sector 140430440, root 5, inode 4265283, offset 249856, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21626, gen 24
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21627, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349810688 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136350060544 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349929472 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349814784 on dev /dev/sda1, sector 140429960, root 5, inode 4265283, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21628, gen 24
BTRFS warning (device sdb1): checksum error at logical 136350064640 on dev /dev/sda1, sector 140430448, root 5, inode 4265283, offset 253952, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21629, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349814784 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349933568 on dev /dev/sda1, sector 140430192, root 5, inode 4265283, offset 122880, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21630, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136350064640 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349933568 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349818880 on dev /dev/sda1, sector 140429968, root 5, inode 4265283, offset 8192, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21631, gen 24
BTRFS warning (device sdb1): checksum error at logical 136350068736 on dev /dev/sda1, sector 140430456, root 5, inode 4265283, offset 258048, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21632, gen 24
BTRFS warning (device sdb1): checksum error at logical 136349937664 on dev /dev/sda1, sector 140430200, root 5, inode 4265283, offset 126976, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21633, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349818880 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136350068736 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349937664 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 136349822976 on dev /dev/sda1, sector 140429976, root 5, inode 4265283, offset 12288, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21634, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349822976 on dev /dev/sda1
scrub_handle_errored_block: 164 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 136349810688 on dev /dev/sdb1, sector 138326656, root 5, inode 4265283, offset 0, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
btrfs_dev_stat_print_on_error: 164 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714510, gen 1335
BTRFS warning (device sdb1): checksum error at logical 136349929472 on dev /dev/sdb1, sector 138326888, root 5, inode 4265283, offset 118784, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714511, gen 1335
BTRFS warning (device sdb1): checksum error at logical 136350060544 on dev /dev/sdb1, sector 138327144, root 5, inode 4265283, offset 249856, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714512, gen 1335
scrub_handle_errored_block: 164 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349810688 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 136349814784 on dev /dev/sdb1, sector 138326664, root 5, inode 4265283, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714513, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349814784 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 136349818880 on dev /dev/sdb1, sector 138326672, root 5, inode 4265283, offset 8192, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714514, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349818880 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 136349822976 on dev /dev/sdb1, sector 138326680, root 5, inode 4265283, offset 12288, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714515, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349822976 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 136349827072 on dev /dev/sdb1, sector 138326688, root 5, inode 4265283, offset 16384, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714516, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349827072 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 136349831168 on dev /dev/sdb1, sector 138326696, root 5, inode 4265283, offset 20480, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714517, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349831168 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 136349835264 on dev /dev/sdb1, sector 138326704, root 5, inode 4265283, offset 24576, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714518, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349835264 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 136349839360 on dev /dev/sdb1, sector 138326712, root 5, inode 4265283, offset 28672, length 4096, links 1 (path: user/Pictures/Picture-42-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1714519, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349839360 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349843456 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 136349847552 on dev /dev/sdb1
scrub_handle_errored_block: 164 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 139677478912 on dev /dev/sda1, sector 146929304, root 5, inode 4265287, offset 208896, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
btrfs_dev_stat_print_on_error: 164 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21799, gen 24
BTRFS warning (device sdb1): checksum error at logical 139677347840 on dev /dev/sda1, sector 146929048, root 5, inode 4265287, offset 77824, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21800, gen 24
BTRFS warning (device sdb1): checksum error at logical 139677609984 on dev /dev/sda1, sector 146929560, root 5, inode 4265287, offset 339968, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21801, gen 24
BTRFS warning (device sdb1): checksum error at logical 139677270016 on dev /dev/sda1, sector 146928896, root 5, inode 4265287, offset 0, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21802, gen 24
scrub_handle_errored_block: 164 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677478912 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677483008 on dev /dev/sda1, sector 146929312, root 5, inode 4265287, offset 212992, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21803, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677347840 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677609984 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677483008 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677270016 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677351936 on dev /dev/sda1, sector 146929056, root 5, inode 4265287, offset 81920, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21804, gen 24
BTRFS warning (device sdb1): checksum error at logical 139677614080 on dev /dev/sda1, sector 146929568, root 5, inode 4265287, offset 344064, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21805, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677351936 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677487104 on dev /dev/sda1, sector 146929320, root 5, inode 4265287, offset 217088, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21806, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677614080 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677274112 on dev /dev/sda1, sector 146928904, root 5, inode 4265287, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21807, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677487104 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 139677356032 on dev /dev/sda1, sector 146929064, root 5, inode 4265287, offset 86016, length 4096, links 1 (path: user/Pictures/Picture-51-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 21808, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677356032 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 139677274112 on dev /dev/sda1
scrub_handle_errored_block: 434 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 140475179008 on dev /dev/sda1, sector 148487312, root 5, inode 4265291, offset 114688, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
btrfs_dev_stat_print_on_error: 434 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22243, gen 24
BTRFS warning (device sdb1): checksum error at logical 140475064320 on dev /dev/sda1, sector 148487088, root 5, inode 4265291, offset 0, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22244, gen 24
BTRFS warning (device sdb1): checksum error at logical 140475310080 on dev /dev/sda1, sector 148487568, root 5, inode 4265291, offset 245760, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22245, gen 24
BTRFS warning (device sdb1): checksum error at logical 140475441152 on dev /dev/sda1, sector 148487824, root 5, inode 4265291, offset 376832, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22246, gen 24
scrub_handle_errored_block: 434 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475179008 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475064320 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475310080 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475441152 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475183104 on dev /dev/sda1, sector 148487320, root 5, inode 4265291, offset 118784, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22247, gen 24
BTRFS warning (device sdb1): checksum error at logical 140475068416 on dev /dev/sda1, sector 148487096, root 5, inode 4265291, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22248, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475183104 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475314176 on dev /dev/sda1, sector 148487576, root 5, inode 4265291, offset 249856, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22249, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475068416 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475445248 on dev /dev/sda1, sector 148487832, root 5, inode 4265291, offset 380928, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22250, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475314176 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475187200 on dev /dev/sda1, sector 148487328, root 5, inode 4265291, offset 122880, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22251, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475445248 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 140475072512 on dev /dev/sda1, sector 148487104, root 5, inode 4265291, offset 8192, length 4096, links 1 (path: user/Pictures/Picture-56-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22252, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475187200 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140475072512 on dev /dev/sda1
scrub_handle_errored_block: 649 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 140157034496 on dev /dev/sdb1, sector 145762640, root 5, inode 4265289, offset 0, length 4096, links 1 (path: user/Pictures/Picture-54-2.jpg)
btrfs_dev_stat_print_on_error: 649 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715023, gen 1335
BTRFS warning (device sdb1): checksum error at logical 140157091840 on dev /dev/sdb1, sector 145762752, root 5, inode 4265289, offset 57344, length 4096, links 1 (path: user/Pictures/Picture-54-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715024, gen 1335
BTRFS warning (device sdb1): checksum error at logical 140157222912 on dev /dev/sdb1, sector 145763008, root 5, inode 4265289, offset 188416, length 4096, links 1 (path: user/Pictures/Picture-54-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715025, gen 1335
BTRFS warning (device sdb1): checksum error at logical 140157353984 on dev /dev/sdb1, sector 145763264, root 5, inode 4265289, offset 319488, length 4096, links 1 (path: user/Pictures/Picture-54-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715026, gen 1335
scrub_handle_errored_block: 649 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140157034496 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140157091840 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 140157038592 on dev /dev/sdb1, sector 145762648, root 5, inode 4265289, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-54-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715027, gen 1335
BTRFS warning (device sdb1): checksum error at logical 140157095936 on dev /dev/sdb1, sector 145762760, root 5, inode 4265289, offset 61440, length 4096, links 1 (path: user/Pictures/Picture-54-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715028, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140157038592 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140157095936 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 140157042688 on dev /dev/sdb1, sector 145762656, root 5, inode 4265289, offset 8192, length 4096, links 1 (path: user/Pictures/Picture-54-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715029, gen 1335
BTRFS warning (device sdb1): checksum error at logical 140157100032 on dev /dev/sdb1, sector 145762768, root 5, inode 4265289, offset 65536, length 4096, links 1 (path: user/Pictures/Picture-54-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715030, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140157042688 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140157100032 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 140157046784 on dev /dev/sdb1, sector 145762664, root 5, inode 4265289, offset 12288, length 4096, links 1 (path: user/Pictures/Picture-54-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715031, gen 1335
BTRFS warning (device sdb1): checksum error at logical 140157104128 on dev /dev/sdb1, sector 145762776, root 5, inode 4265289, offset 69632, length 4096, links 1 (path: user/Pictures/Picture-54-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715032, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140157046784 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140157104128 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140157050880 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 140157108224 on dev /dev/sdb1
scrub_handle_errored_block: 415 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 162995294208 on dev /dev/sda1, sector 192471912, root 5, inode 4265299, offset 24576, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS warning (device sdb1): checksum error at logical 162995556352 on dev /dev/sda1, sector 192472424, root 5, inode 4265299, offset 286720, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
btrfs_dev_stat_print_on_error: 415 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22564, gen 24
BTRFS warning (device sdb1): checksum error at logical 162995269632 on dev /dev/sda1, sector 192471864, root 5, inode 4265299, offset 0, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS warning (device sdb1): checksum error at logical 162995425280 on dev /dev/sda1, sector 192472168, root 5, inode 4265299, offset 155648, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22565, gen 24
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22566, gen 24
BTRFS warning (device sdb1): checksum error at logical 162995818496 on dev /dev/sda1, sector 192472936, root 5, inode 4265299, offset 548864, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS warning (device sdb1): checksum error at logical 162995687424 on dev /dev/sda1, sector 192472680, root 5, inode 4265299, offset 417792, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22567, gen 24
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22568, gen 24
scrub_handle_errored_block: 415 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995294208 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995556352 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 162995298304 on dev /dev/sda1, sector 192471920, root 5, inode 4265299, offset 28672, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22569, gen 24
BTRFS warning (device sdb1): checksum error at logical 162995429376 on dev /dev/sda1, sector 192472176, root 5, inode 4265299, offset 159744, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22570, gen 24
BTRFS warning (device sdb1): checksum error at logical 162995560448 on dev /dev/sda1, sector 192472432, root 5, inode 4265299, offset 290816, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22571, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995818496 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995687424 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995298304 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995429376 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995560448 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995269632 on dev /dev/sda1
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22572, gen 24
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 22573, gen 24
BTRFS warning (device sdb1): checksum error at logical 162995822592 on dev /dev/sda1, sector 192472944, root 5, inode 4265299, offset 552960, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995691520 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995822592 on dev /dev/sda1
scrub_handle_errored_block: 434 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 162995294208 on dev /dev/sdb1, sector 190368616, root 5, inode 4265299, offset 24576, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS warning (device sdb1): checksum error at logical 162995425280 on dev /dev/sdb1, sector 190368872, root 5, inode 4265299, offset 155648, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
btrfs_dev_stat_print_on_error: 433 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715449, gen 1335
BTRFS warning (device sdb1): checksum error at logical 162995556352 on dev /dev/sdb1, sector 190369128, root 5, inode 4265299, offset 286720, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715450, gen 1335
BTRFS warning (device sdb1): checksum error at logical 162995687424 on dev /dev/sdb1, sector 190369384, root 5, inode 4265299, offset 417792, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715451, gen 1335
BTRFS warning (device sdb1): checksum error at logical 162995269632 on dev /dev/sdb1, sector 190368568, root 5, inode 4265299, offset 0, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715452, gen 1335
BTRFS warning (device sdb1): checksum error at logical 162995818496 on dev /dev/sdb1, sector 190369640, root 5, inode 4265299, offset 548864, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715453, gen 1335
scrub_handle_errored_block: 433 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995294208 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 162995298304 on dev /dev/sdb1, sector 190368624, root 5, inode 4265299, offset 28672, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715454, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995425280 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995556352 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995687424 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995269632 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 162995429376 on dev /dev/sdb1, sector 190368880, root 5, inode 4265299, offset 159744, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715455, gen 1335
BTRFS warning (device sdb1): checksum error at logical 162995560448 on dev /dev/sdb1, sector 190369136, root 5, inode 4265299, offset 290816, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715456, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995429376 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 162995691520 on dev /dev/sdb1, sector 190369392, root 5, inode 4265299, offset 421888, length 4096, links 1 (path: user/Pictures/Picture-22.jpg)
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995818496 on dev /dev/sdb1
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715457, gen 1335
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1715458, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995298304 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995560448 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 162995691520 on dev /dev/sdb1
scrub_handle_errored_block: 434 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 170606833664 on dev /dev/sda1, sector 207338200, root 5, inode 4265298, offset 57344, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
btrfs_dev_stat_print_on_error: 433 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23007, gen 24
BTRFS warning (device sdb1): checksum error at logical 170606776320 on dev /dev/sda1, sector 207338088, root 5, inode 4265298, offset 0, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23008, gen 24
BTRFS warning (device sdb1): checksum error at logical 170606964736 on dev /dev/sda1, sector 207338456, root 5, inode 4265298, offset 188416, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23009, gen 24
BTRFS warning (device sdb1): checksum error at logical 170607095808 on dev /dev/sda1, sector 207338712, root 5, inode 4265298, offset 319488, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23010, gen 24
BTRFS warning (device sdb1): checksum error at logical 170607226880 on dev /dev/sda1, sector 207338968, root 5, inode 4265298, offset 450560, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23011, gen 24
BTRFS warning (device sdb1): checksum error at logical 170607357952 on dev /dev/sda1, sector 207339224, root 5, inode 4265298, offset 581632, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23012, gen 24
scrub_handle_errored_block: 434 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170606833664 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170606776320 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170606964736 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607095808 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607226880 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607357952 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 170606837760 on dev /dev/sda1, sector 207338208, root 5, inode 4265298, offset 61440, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23013, gen 24
BTRFS warning (device sdb1): checksum error at logical 170606780416 on dev /dev/sda1, sector 207338096, root 5, inode 4265298, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23014, gen 24
BTRFS warning (device sdb1): checksum error at logical 170606968832 on dev /dev/sda1, sector 207338464, root 5, inode 4265298, offset 192512, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23015, gen 24
BTRFS warning (device sdb1): checksum error at logical 170607099904 on dev /dev/sda1, sector 207338720, root 5, inode 4265298, offset 323584, length 4096, links 1 (path: user/Pictures/Picture-22-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23016, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170606837760 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170606780416 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170606968832 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 170607099904 on dev /dev/sda1
scrub_handle_errored_block: 281 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 171215843328 on dev /dev/sda1, sector 208527672, root 5, inode 4265266, offset 0, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS warning (device sdb1): checksum error at logical 171216105472 on dev /dev/sda1, sector 208528184, root 5, inode 4265266, offset 262144, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
btrfs_dev_stat_print_on_error: 281 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23299, gen 24
BTRFS warning (device sdb1): checksum error at logical 171215974400 on dev /dev/sda1, sector 208527928, root 5, inode 4265266, offset 131072, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23300, gen 24
BTRFS warning (device sdb1): checksum error at logical 171216236544 on dev /dev/sda1, sector 208528440, root 5, inode 4265266, offset 393216, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23301, gen 24
BTRFS warning (device sdb1): checksum error at logical 171216498688 on dev /dev/sda1, sector 208528952, root 5, inode 4265266, offset 655360, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS warning (device sdb1): checksum error at logical 171216367616 on dev /dev/sda1, sector 208528696, root 5, inode 4265266, offset 524288, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23302, gen 24
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23303, gen 24
scrub_handle_errored_block: 281 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215843328 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216105472 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215974400 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216236544 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 171215847424 on dev /dev/sda1, sector 208527680, root 5, inode 4265266, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23304, gen 24
BTRFS warning (device sdb1): checksum error at logical 171216109568 on dev /dev/sda1, sector 208528192, root 5, inode 4265266, offset 266240, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23305, gen 24
BTRFS warning (device sdb1): checksum error at logical 171215978496 on dev /dev/sda1, sector 208527936, root 5, inode 4265266, offset 135168, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23306, gen 24
BTRFS warning (device sdb1): checksum error at logical 171216240640 on dev /dev/sda1, sector 208528448, root 5, inode 4265266, offset 397312, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23307, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216367616 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216498688 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216109568 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215847424 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215978496 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171216240640 on dev /dev/sda1
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23308, gen 24
scrub_handle_errored_block: 602 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 171215843328 on dev /dev/sdb1, sector 206424376, root 5, inode 4265266, offset 0, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
btrfs_dev_stat_print_on_error: 601 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716183, gen 1335
BTRFS warning (device sdb1): checksum error at logical 171215974400 on dev /dev/sdb1, sector 206424632, root 5, inode 4265266, offset 131072, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716184, gen 1335
BTRFS warning (device sdb1): checksum error at logical 171216105472 on dev /dev/sdb1, sector 206424888, root 5, inode 4265266, offset 262144, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716185, gen 1335
BTRFS warning (device sdb1): checksum error at logical 171216236544 on dev /dev/sdb1, sector 206425144, root 5, inode 4265266, offset 393216, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716186, gen 1335
BTRFS warning (device sdb1): checksum error at logical 171216498688 on dev /dev/sdb1, sector 206425656, root 5, inode 4265266, offset 655360, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716187, gen 1335
BTRFS warning (device sdb1): checksum error at logical 171216367616 on dev /dev/sdb1, sector 206425400, root 5, inode 4265266, offset 524288, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716188, gen 1335
scrub_handle_errored_block: 602 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215843328 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 171215847424 on dev /dev/sdb1, sector 206424384, root 5, inode 4265266, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716189, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215847424 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 171215851520 on dev /dev/sdb1, sector 206424392, root 5, inode 4265266, offset 8192, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716190, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215851520 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 171215855616 on dev /dev/sdb1, sector 206424400, root 5, inode 4265266, offset 12288, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716191, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215855616 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 171215859712 on dev /dev/sdb1, sector 206424408, root 5, inode 4265266, offset 16384, length 4096, links 1 (path: user/Pictures/Picture-33.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716192, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215859712 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215863808 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215867904 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215872000 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215876096 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 171215880192 on dev /dev/sdb1
scrub_handle_errored_block: 311 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 182510542848 on dev /dev/sda1, sector 230587632, root 5, inode 4265300, offset 0, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
btrfs_dev_stat_print_on_error: 311 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23619, gen 24
BTRFS warning (device sdb1): checksum error at logical 182510669824 on dev /dev/sda1, sector 230587880, root 5, inode 4265300, offset 126976, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23620, gen 24
BTRFS warning (device sdb1): checksum error at logical 182510800896 on dev /dev/sda1, sector 230588136, root 5, inode 4265300, offset 258048, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23621, gen 24
BTRFS warning (device sdb1): checksum error at logical 182510931968 on dev /dev/sda1, sector 230588392, root 5, inode 4265300, offset 389120, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23622, gen 24
BTRFS warning (device sdb1): checksum error at logical 182511063040 on dev /dev/sda1, sector 230588648, root 5, inode 4265300, offset 520192, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23623, gen 24
BTRFS warning (device sdb1): checksum error at logical 182511194112 on dev /dev/sda1, sector 230588904, root 5, inode 4265300, offset 651264, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23624, gen 24
scrub_handle_errored_block: 311 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510542848 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 182510546944 on dev /dev/sda1, sector 230587640, root 5, inode 4265300, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23625, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510669824 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510800896 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510931968 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182511063040 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 182510673920 on dev /dev/sda1, sector 230587888, root 5, inode 4265300, offset 131072, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23626, gen 24
BTRFS warning (device sdb1): checksum error at logical 182510804992 on dev /dev/sda1, sector 230588144, root 5, inode 4265300, offset 262144, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23627, gen 24
BTRFS warning (device sdb1): checksum error at logical 182510936064 on dev /dev/sda1, sector 230588400, root 5, inode 4265300, offset 393216, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23628, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182511194112 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510546944 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510673920 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510804992 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510936064 on dev /dev/sda1
scrub_handle_errored_block: 345 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 182510542848 on dev /dev/sdb1, sector 228484336, root 5, inode 4265300, offset 0, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
btrfs_dev_stat_print_on_error: 345 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716504, gen 1335
BTRFS warning (device sdb1): checksum error at logical 182510669824 on dev /dev/sdb1, sector 228484584, root 5, inode 4265300, offset 126976, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716505, gen 1335
BTRFS warning (device sdb1): checksum error at logical 182510800896 on dev /dev/sdb1, sector 228484840, root 5, inode 4265300, offset 258048, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716506, gen 1335
BTRFS warning (device sdb1): checksum error at logical 182510931968 on dev /dev/sdb1, sector 228485096, root 5, inode 4265300, offset 389120, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716507, gen 1335
BTRFS warning (device sdb1): checksum error at logical 182511063040 on dev /dev/sdb1, sector 228485352, root 5, inode 4265300, offset 520192, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716508, gen 1335
BTRFS warning (device sdb1): checksum error at logical 182511194112 on dev /dev/sdb1, sector 228485608, root 5, inode 4265300, offset 651264, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716509, gen 1335
scrub_handle_errored_block: 345 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510542848 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510546944 on dev /dev/sdb1, sector 228484344, root 5, inode 4265300, offset 4096, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716510, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510800896 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510804992 on dev /dev/sdb1, sector 228484848, root 5, inode 4265300, offset 262144, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716511, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510931968 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182510936064 on dev /dev/sdb1, sector 228485104, root 5, inode 4265300, offset 393216, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716512, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182511063040 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 182511067136 on dev /dev/sdb1, sector 228485360, root 5, inode 4265300, offset 524288, length 4096, links 1 (path: user/Pictures/Picture-24-2.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716513, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182511194112 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510669824 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182511198208 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510546944 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510804992 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 182510936064 on dev /dev/sdb1
scrub_handle_errored_block: 345 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 198160961536 on dev /dev/sda1, sector 261154856, root 5, inode 4265307, offset 2609152, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
btrfs_dev_stat_print_on_error: 345 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 198161223680 on dev /dev/sda1, sector 261155368, root 5, inode 4265307, offset 2871296, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS warning (device sdb1): checksum error at logical 198160945152 on dev /dev/sda1, sector 261154824, root 5, inode 4265307, offset 2592768, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23976, gen 24
BTRFS warning (device sdb1): checksum error at logical 198161092608 on dev /dev/sda1, sector 261155112, root 5, inode 4265307, offset 2740224, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS warning (device sdb1): checksum error at logical 198161485824 on dev /dev/sda1, sector 261155880, root 5, inode 4265307, offset 3133440, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS warning (device sdb1): checksum error at logical 198161354752 on dev /dev/sda1, sector 261155624, root 5, inode 4265307, offset 3002368, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23977, gen 24
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23978, gen 24
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23979, gen 24
scrub_handle_errored_block: 345 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161223680 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198161227776 on dev /dev/sda1, sector 261155376, root 5, inode 4265307, offset 2875392, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23980, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160945152 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160961536 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161485824 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161354752 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161092608 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161227776 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198160949248 on dev /dev/sda1, sector 261154832, root 5, inode 4265307, offset 2596864, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23981, gen 24
BTRFS warning (device sdb1): checksum error at logical 198160965632 on dev /dev/sda1, sector 261154864, root 5, inode 4265307, offset 2613248, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23982, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160949248 on dev /dev/sda1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160965632 on dev /dev/sda1
BTRFS warning (device sdb1): checksum error at logical 198161489920 on dev /dev/sda1, sector 261155888, root 5, inode 4265307, offset 3137536, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23983, gen 24
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23984, gen 24
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161489920 on dev /dev/sda1
BTRFS error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0, corrupt 23985, gen 24
BTRFS error (device sdb1): parent transid verify failed on 1894596354048 wanted 246893 found 240551
BTRFS error (device sdb1): parent transid verify failed on 1894596354048 wanted 246893 found 240551
scrub_handle_errored_block: 166 callbacks suppressed
BTRFS warning (device sdb1): checksum error at logical 198160945152 on dev /dev/sdb1, sector 259051528, root 5, inode 4265307, offset 2592768, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
btrfs_dev_stat_print_on_error: 164 callbacks suppressed
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716859, gen 1335
BTRFS warning (device sdb1): checksum error at logical 198160961536 on dev /dev/sdb1, sector 259051560, root 5, inode 4265307, offset 2609152, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716860, gen 1335
BTRFS warning (device sdb1): checksum error at logical 198161092608 on dev /dev/sdb1, sector 259051816, root 5, inode 4265307, offset 2740224, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716861, gen 1335
BTRFS warning (device sdb1): checksum error at logical 198161223680 on dev /dev/sdb1, sector 259052072, root 5, inode 4265307, offset 2871296, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716862, gen 1335
BTRFS warning (device sdb1): checksum error at logical 198161354752 on dev /dev/sdb1, sector 259052328, root 5, inode 4265307, offset 3002368, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716863, gen 1335
BTRFS warning (device sdb1): checksum error at logical 198161485824 on dev /dev/sdb1, sector 259052584, root 5, inode 4265307, offset 3133440, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716864, gen 1335
scrub_handle_errored_block: 166 callbacks suppressed
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160945152 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160961536 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161092608 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161223680 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161354752 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 198160949248 on dev /dev/sdb1, sector 259051536, root 5, inode 4265307, offset 2596864, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716865, gen 1335
BTRFS warning (device sdb1): checksum error at logical 198160965632 on dev /dev/sdb1, sector 259051568, root 5, inode 4265307, offset 2613248, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716866, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161485824 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 198161096704 on dev /dev/sdb1, sector 259051824, root 5, inode 4265307, offset 2744320, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716867, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198160949248 on dev /dev/sdb1
BTRFS warning (device sdb1): checksum error at logical 198161358848 on dev /dev/sdb1, sector 259052336, root 5, inode 4265307, offset 3006464, length 4096, links 1 (path: user/Pictures/Picture-38.jpg)
BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14, flush 7928, corrupt 1716868, gen 1335
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161096704 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161227776 on dev /dev/sdb1
BTRFS error (device sdb1): unable to fixup (regular) error at logical 198161358848 on dev /dev/sdb1
BTRFS error (device sdb1): parent transid verify failed on 1894596354048 wanted 246893 found 240551
BTRFS error (device sdb1): parent transid verify failed on 1894596354048 wanted 246893 found 240551

root@system:/# smartctl -x /dev/sda
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.6.0-0.bpo.1-amd64] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     ST2000LM003 HN-M201RAD
Serial Number:    S377J9CH203273
LU WWN Device Id: 5 0004cf 211e05d6a
Firmware Version: 2BE10001
User Capacity:    2 000 398 934 016 bytes [2,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      2.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Jun 29 00:46:44 2016 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM level is:     254 (maximum performance), recommended: 254
APM level is:     254 (maximum performance)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status:      (  38)	The self-test routine was interrupted
					by the host with a hard or soft reset.
Total time to complete Offline 
data collection: 		(21420) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 357) minutes.
SCT capabilities: 	       (0x003f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    0
  2 Throughput_Performance  -OS--K   252   252   000    -    0
  3 Spin_Up_Time            PO---K   090   089   025    -    3170
  4 Start_Stop_Count        -O--CK   100   100   000    -    7
  5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
  7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
  8 Seek_Time_Performance   --S--K   252   252   015    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    20
 10 Spin_Retry_Count        -O--CK   252   252   051    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    19
191 G-Sense_Error_Rate      -O---K   252   252   000    -    0
192 Power-Off_Retract_Count -O---K   252   252   000    -    0
194 Temperature_Celsius     -O----   064   058   000    -    35 (Min/Max 24/45)
195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
196 Reallocated_Event_Count -O--CK   252   252   000    -    0
197 Current_Pending_Sector  -O--CK   252   252   000    -    0
198 Offline_Uncorrectable   ----CK   252   252   000    -    0
199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    0
223 Load_Retry_Count        -O--CK   252   252   000    -    0
225 Load_Cycle_Count        -O--CK   100   100   000    -    250
241 Total_LBAs_Written      -O--CK   096   094   000    -    6054713
242 Total_LBAs_Read         -O--CK   094   094   000    -    8176813
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      2  Comprehensive SMART error log
0x03       GPL     R/O      2  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      2  Extended self-test log
0x08       GPL     R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xc0-0xdf  GPL,SL  VS      16  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Offline             Interrupted (host reset)      60%        20         -
# 2  Short captive       Self-test routine in progress 60%        20         -

SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever been run
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Interrupted [60% left] (0-65535)
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  2
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    35 Celsius
Power Cycle Min/Max Temperature:     30/40 Celsius
Lifetime    Min/Max Temperature:     24/45 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         5 minutes
Temperature Logging Interval:        5 minutes
Min/Max recommended Temperature:     -5/80 Celsius
Min/Max Temperature Limit:           -10/85 Celsius
Temperature History Size (Index):    128 (50)

Index    Estimated Time   Temperature Celsius
  51    2016-06-28 14:10    35  ****************
  52    2016-06-28 14:15    44  *************************
  53    2016-06-28 14:20    44  *************************
  54    2016-06-28 14:25    44  *************************
  55    2016-06-28 14:30    42  ***********************
  56    2016-06-28 14:35    43  ************************
  57    2016-06-28 14:40    44  *************************
 ...    ..(  2 skipped).    ..  *************************
  60    2016-06-28 14:55    44  *************************
  61    2016-06-28 15:00    45  **************************
 ...    ..( 16 skipped).    ..  **************************
  78    2016-06-28 16:25    45  **************************
  79    2016-06-28 16:30    44  *************************
 ...    ..( 29 skipped).    ..  *************************
 109    2016-06-28 19:00    44  *************************
 110    2016-06-28 19:05    43  ************************
 111    2016-06-28 19:10    44  *************************
 112    2016-06-28 19:15    44  *************************
 113    2016-06-28 19:20    43  ************************
 ...    ..( 19 skipped).    ..  ************************
   5    2016-06-28 21:00    43  ************************
   6    2016-06-28 21:05    42  ***********************
 ...    ..(  4 skipped).    ..  ***********************
  11    2016-06-28 21:30    42  ***********************
  12    2016-06-28 21:35    43  ************************
  13    2016-06-28 21:40    41  **********************
  14    2016-06-28 21:45    33  **************
  15    2016-06-28 21:50    36  *****************
  16    2016-06-28 21:55    37  ******************
  17    2016-06-28 22:00    37  ******************
  18    2016-06-28 22:05    34  ***************
  19    2016-06-28 22:10    33  **************
  20    2016-06-28 22:15    33  **************
  21    2016-06-28 22:20    32  *************
  22    2016-06-28 22:25    32  *************
  23    2016-06-28 22:30    33  **************
 ...    ..(  2 skipped).    ..  **************
  26    2016-06-28 22:45    33  **************
  27    2016-06-28 22:50    34  ***************
  28    2016-06-28 22:55    34  ***************
  29    2016-06-28 23:00    34  ***************
  30    2016-06-28 23:05    35  ****************
 ...    ..(  7 skipped).    ..  ****************
  38    2016-06-28 23:45    35  ****************
  39    2016-06-28 23:50    34  ***************
  40    2016-06-28 23:55    37  ******************
  41    2016-06-29 00:00    39  ********************
  42    2016-06-29 00:05    38  *******************
  43    2016-06-29 00:10    38  *******************
  44    2016-06-29 00:15    39  ********************
  45    2016-06-29 00:20    40  *********************
  46    2016-06-29 00:25    40  *********************
  47    2016-06-29 00:30    38  *******************
  48    2016-06-29 00:35    37  ******************
  49    2016-06-29 00:40    37  ******************
  50    2016-06-29 00:45    36  *****************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  4            0  Command failed due to ICRC error
0x0002  4            0  R_ERR response for data FIS
0x0003  4            0  R_ERR response for device-to-host data FIS
0x0004  4            0  R_ERR response for host-to-device data FIS
0x0005  4            0  R_ERR response for non-data FIS
0x0006  4            0  R_ERR response for device-to-host non-data FIS
0x0007  4            0  R_ERR response for host-to-device non-data FIS
0x0008  4            0  Device-to-host non-data FIS retries
0x0009  4            7  Transition from drive PhyRdy to drive PhyNRdy
0x000a  4            6  Device-to-host register FISes sent due to a COMRESET
0x000b  4            0  CRC errors within host-to-device FIS
0x000d  4            0  Non-CRC errors within host-to-device FIS
0x000f  4            0  R_ERR response for host-to-device data FIS, CRC
0x0010  4            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  4            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  4            0  R_ERR response for host-to-device non-data FIS, non-CRC
0x8e00  4            0  Vendor specific
0x8e01  4            0  Vendor specific
0x8e02  4            0  Vendor specific
0x8e03  4            0  Vendor specific
0x8e04  4            0  Vendor specific
0x8e05  4            0  Vendor specific
0x8e06  4            0  Vendor specific
0x8e07  4            0  Vendor specific
0x8e08  4            0  Vendor specific
0x8e09  4            0  Vendor specific
0x8e0a  4            0  Vendor specific
0x8e0b  4            0  Vendor specific
0x8e0c  4            0  Vendor specific
0x8e0d  4            0  Vendor specific
0x8e0e  4            0  Vendor specific
0x8e0f  4            0  Vendor specific
0x8e10  4            0  Vendor specific
0x8e11  4            0  Vendor specific

root@system:/# smartctl -x /dev/sdb
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.6.0-0.bpo.1-amd64] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     ST2000LM003 HN-M201RAD
Serial Number:    S377J9CH203271
LU WWN Device Id: 5 0004cf 211e05d48
Firmware Version: 2BE10001
User Capacity:    2 000 398 934 016 bytes [2,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      2.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Jun 29 00:46:46 2016 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM level is:     254 (maximum performance), recommended: 254
APM level is:     254 (maximum performance)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status:      (  38)	The self-test routine was interrupted
					by the host with a hard or soft reset.
Total time to complete Offline 
data collection: 		(23220) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 387) minutes.
SCT capabilities: 	       (0x003f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    0
  2 Throughput_Performance  -OS--K   252   252   000    -    0
  3 Spin_Up_Time            PO---K   090   090   025    -    3121
  4 Start_Stop_Count        -O--CK   100   100   000    -    5
  5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
  7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
  8 Seek_Time_Performance   --S--K   252   252   015    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    12
 10 Spin_Retry_Count        -O--CK   252   252   051    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    10
191 G-Sense_Error_Rate      -O---K   252   252   000    -    0
192 Power-Off_Retract_Count -O---K   252   252   000    -    0
194 Temperature_Celsius     -O----   064   061   000    -    34 (Min/Max 26/45)
195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
196 Reallocated_Event_Count -O--CK   252   252   000    -    0
197 Current_Pending_Sector  -O--CK   252   252   000    -    0
198 Offline_Uncorrectable   ----CK   252   252   000    -    0
199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    1
223 Load_Retry_Count        -O--CK   252   252   000    -    0
225 Load_Cycle_Count        -O--CK   100   100   000    -    114
241 Total_LBAs_Written      -O--CK   095   095   000    -    7238560
242 Total_LBAs_Read         -O--CK   097   094   000    -    4420088
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      2  Comprehensive SMART error log
0x03       GPL     R/O      2  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      2  Extended self-test log
0x08       GPL     R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xc0-0xdf  GPL,SL  VS      16  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Offline             Interrupted (host reset)      60%        12         -
# 2  Short captive       Self-test routine in progress 60%        12         -

SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever been run
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Interrupted [60% left] (0-65535)
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  2
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    33 Celsius
Power Cycle Min/Max Temperature:     29/39 Celsius
Lifetime    Min/Max Temperature:     24/45 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         5 minutes
Temperature Logging Interval:        5 minutes
Min/Max recommended Temperature:     -5/80 Celsius
Min/Max Temperature Limit:           -10/85 Celsius
Temperature History Size (Index):    128 (116)

Index    Estimated Time   Temperature Celsius
 117    2016-06-28 14:10    33  **************
 118    2016-06-28 14:15     ?  -
 ...    ..(  8 skipped).    ..  -
 127    2016-06-28 15:00     ?  -
   0    2016-06-28 15:05    33  **************
   1    2016-06-28 15:10    36  *****************
   2    2016-06-28 15:15    39  ********************
   3    2016-06-28 15:20    40  *********************
   4    2016-06-28 15:25    40  *********************
   5    2016-06-28 15:30    41  **********************
   6    2016-06-28 15:35    42  ***********************
   7    2016-06-28 15:40    43  ************************
   8    2016-06-28 15:45    43  ************************
   9    2016-06-28 15:50    44  *************************
  10    2016-06-28 15:55    44  *************************
  11    2016-06-28 16:00    44  *************************
  12    2016-06-28 16:05    45  **************************
 ...    ..( 29 skipped).    ..  **************************
  42    2016-06-28 18:35    45  **************************
  43    2016-06-28 18:40    44  *************************
 ...    ..( 28 skipped).    ..  *************************
  72    2016-06-28 21:05    44  *************************
  73    2016-06-28 21:10    43  ************************
 ...    ..(  8 skipped).    ..  ************************
  82    2016-06-28 21:55    43  ************************
  83    2016-06-28 22:00    32  *************
  84    2016-06-28 22:05    35  ****************
  85    2016-06-28 22:10    36  *****************
  86    2016-06-28 22:15    33  **************
  87    2016-06-28 22:20    32  *************
  88    2016-06-28 22:25    31  ************
 ...    ..(  2 skipped).    ..  ************
  91    2016-06-28 22:40    31  ************
  92    2016-06-28 22:45    32  *************
  93    2016-06-28 22:50    32  *************
  94    2016-06-28 22:55    32  *************
  95    2016-06-28 23:00    33  **************
 ...    ..(  2 skipped).    ..  **************
  98    2016-06-28 23:15    33  **************
  99    2016-06-28 23:20    34  ***************
 ...    ..(  4 skipped).    ..  ***************
 104    2016-06-28 23:45    34  ***************
 105    2016-06-28 23:50    33  **************
 106    2016-06-28 23:55    33  **************
 107    2016-06-29 00:00    36  *****************
 108    2016-06-29 00:05    38  *******************
 109    2016-06-29 00:10    36  *****************
 110    2016-06-29 00:15    36  *****************
 111    2016-06-29 00:20    38  *******************
 112    2016-06-29 00:25    39  ********************
 113    2016-06-29 00:30    37  ******************
 114    2016-06-29 00:35    35  ****************
 115    2016-06-29 00:40    36  *****************
 116    2016-06-29 00:45    34  ***************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  4            0  Command failed due to ICRC error
0x0002  4            0  R_ERR response for data FIS
0x0003  4            0  R_ERR response for device-to-host data FIS
0x0004  4            0  R_ERR response for host-to-device data FIS
0x0005  4            0  R_ERR response for non-data FIS
0x0006  4            0  R_ERR response for device-to-host non-data FIS
0x0007  4            0  R_ERR response for host-to-device non-data FIS
0x0008  4            0  Device-to-host non-data FIS retries
0x0009  4            6  Transition from drive PhyRdy to drive PhyNRdy
0x000a  4            6  Device-to-host register FISes sent due to a COMRESET
0x000b  4            0  CRC errors within host-to-device FIS
0x000d  4            0  Non-CRC errors within host-to-device FIS
0x000f  4            0  R_ERR response for host-to-device data FIS, CRC
0x0010  4            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  4            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  4            0  R_ERR response for host-to-device non-data FIS, non-CRC
0x8e00  4            0  Vendor specific
0x8e01  4            0  Vendor specific
0x8e02  4            0  Vendor specific
0x8e03  4            0  Vendor specific
0x8e04  4            0  Vendor specific
0x8e05  4            0  Vendor specific
0x8e06  4            0  Vendor specific
0x8e07  4            0  Vendor specific
0x8e08  4            0  Vendor specific
0x8e09  4            0  Vendor specific
0x8e0a  4            0  Vendor specific
0x8e0b  4            0  Vendor specific
0x8e0c  4            0  Vendor specific
0x8e0d  4            0  Vendor specific
0x8e0e  4            0  Vendor specific
0x8e0f  4            0  Vendor specific
0x8e10  4            0  Vendor specific
0x8e11  4            0  Vendor specific
