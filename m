Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48452 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752002AbcKICGA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 21:06:00 -0500
Date: Tue, 8 Nov 2016 18:05:19 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.com>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs support for filesystems >8TB on 32bit architectures
Message-ID: <20161109020519.GN13371@merlins.org>
References: <20161107053647.uj7df3ppve4pbfms@merlins.org> <10ed4e8a-c9a6-961a-fb51-16186da079e4@cn.fujitsu.com> <20161107145502.7lahpm6smqsv6s2q@merlins.org> <cf75cc57-62f9-2d88-a544-72a45aadd674@cn.fujitsu.com> <20161108003950.GD13371@merlins.org> <63a1964d-f8df-413d-c088-20163f824e3d@cn.fujitsu.com> <20161108010600.GE13371@merlins.org> <977bbf2a-5d9f-f5aa-084c-4ca1d891eb72@cn.fujitsu.com> <20161108152429.GC24297@merlins.org> <f17792e9-498a-4ff0-2cc5-674ae10a01ad@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f17792e9-498a-4ff0-2cc5-674ae10a01ad@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 09, 2016 at 09:50:08AM +0800, Qu Wenruo wrote:
> Yeah, quite possible!
> 
> The truth is, current btrfs check only checks:
> 1) Metadata
>    while --check-data-csum option will check data, but still
>    follow the restriction 3).
> 2) Crossing reference of metadata (contents of metadata)
> 3) The first good mirror/backup
> 
> So quite a lot of problems can't be detected by btrfs check:
> 1) Data corruption (csum mismatch)
> 2) 2nd mirror corruption(DUP/RAID0/10) or parity error(RAID5/6)
> 
> For btrfsck to check all mirror and data, you could try out-of-tree 
> offline scrub patchset:
> https://github.com/adam900710/btrfs-progs/tree/fsck_scrub
> 
> Which implements the kernel scrub equivalent in btrfs-progs.

I see, thanks for the answer.
Note that this is very confusing to the end user.
If check --repair returns success, the filesystem should be clean.
Hopefully that patchset can be included in btrfs-progs

But sure enough, I'm seeing a lot of these:
BTRFS warning (device dm-6): checksum error at logical 269783986176 on dev /dev/mapper/crypt_bcache2, sector 529035384, root 16755, inode 1225897, offset 77824, length 4096, links 5 (path: magic/20150624/home/merlin/public_html/rig3/img/thumb800_302_1-Wire.jpg)

This is bad because I would expect check --repair to find them all and offer
to remove all the corrupted files after giving me a list of what I've lost,
or just recompute the checksum to be correct, know the file is now corrupted
but "clean" and I have the option of keeping them as is (ok-ish for a video
file) or restore them from backup.

The worst part with scrub is that I have to find all these files, and then
find all the snapshots they're in (maybe 10 or 20) and delete them all, and
then some of those snapshots are read only because they are btrfs send
source, so I need to destroy those snapshots and lose my btrfs send
relationship and am forced to recreate it (maybe 2 to 6 days of syncing over
a slow-ish link)

When data is corrupted, no solution is perfect, but hopefully check --repair
will indeed be able to restore the entire filesystem to a clean state, even
if some data must be lost in the process.

Thanks for considering.

Marc

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
