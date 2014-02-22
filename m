Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42151 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaBVTWd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Feb 2014 14:22:33 -0500
Date: Sat, 22 Feb 2014 11:22:29 -0800
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>, Josef Bacik <jbacik@fb.com>
Message-ID: <20140222192229.GD24751@merlins.org>
References: <1392558191-14475-1-git-send-email-fdmanana@gmail.com>
 <20140214015426.GH27097@merlins.org>
 <20140216142352.GN27097@merlins.org>
 <CAL3q7H5JY=1WdG0vtNqPcHmwvPXdgznOqU9J9M3ctKgzVZQqAA@mail.gmail.com>
 <20140216172315.GC2117@merlins.org>
 <CAL3q7H7uuaTjH7RWW-Q73E7zpc5=bpHP4nCrK3JkOsXaAj08Jw@mail.gmail.com>
 <20140217053232.GQ27097@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140217053232.GQ27097@merlins.org>
Subject: btrfs send ioctl failed with -25: Inappropriate ioctl for device
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 16, 2014 at 09:32:32PM -0800, Marc MERLIN wrote:
> On Sun, Feb 16, 2014 at 09:08:57PM +0000, Filipe David Manana wrote:
> > I'll see if I come up with other ways of getting into that issue.
> 
> If you're collecting them, I found another bug, although it might not
> matter to most: if I put my laptop in S3 sleep during a send/receive, it
> reliably breaks the copy (this is disk to disk, not disk to network).
> 
> Not a problem for a server, but on a laptop, if you happen to have a
> background backup from disk1 to disk2 and you put the laptop to sleep,
> it will break the backup in a way that's not recoverable and you need to
> start back up from scratch.
> 
> btrfs send | btrfs receive gives:
> Create a readonly snapshot of 'home' in './home_ro.20140216_21:03:53'
> At subvol home_ro.20140216_21:03:53
> At subvol home_ro.20140216_21:03:53
> 
> ERROR: crc32 mismatch in command.
> Error line 137 with status 234
> 
> If that helps, I can reproduce at will.

Mmmh, I may have found another problem.

I tried to init a new backup like so:

    btrfs send "$src_newsnap" | btrfs receive "$dest_pool/"

And get:
+ btrfs send media_ro.20140222_11:12:53
+ btrfs receive /mnt/btrfs_bigbackup/
At subvol media_ro.20140222_11:12:53
ERROR: send ioctl failed with -25: Inappropriate ioctl for device

Or more simply:
gargamel:/mnt/btrfs_pool1# btrfs send media_ro.20140222_11:12:53 | less
At subvol media_ro.20140222_11:12:53
ERROR: send ioctl failed with -25: Inappropriate ioctl for device
gargamel:/mnt/btrfs_pool1# btrfs subvolume show media_ro.20140222_11:12:53
/mnt/btrfs_pool1/media_ro.20140222_11:12:53
        Name:                   media_ro.20140222_11:12:53
        uuid:                   7e36a8a4-3aa2-7b4d-acbb-1ac79c52ae19
        Parent uuid:            0e4dff73-1b21-0344-a7f1-79002d0eaa94
        Creation time:          2014-02-22 11:12:56
        Object ID:              8095
        Generation (Gen):       6512
        Gen at creation:        6512
        Parent:                 5
        Top Level:              5
        Flags:                  readonly
        Snapshot(s):
gargamel:/mnt/btrfs_bigbackup# uname -r
3.13.3-amd64-i915-preempt-20140216
gargamel:/mnt/btrfs_bigbackup# btrfs --version
Btrfs v3.12
gargamel:/mnt/btrfs_bigbackup# btrfs fi show
Label: btrfs_boot  uuid: e4c1daa8-9c39-4a59-b0a9-86297d397f3b
        Total devices 1 FS bytes used 54.44GiB
        devid    1 size 79.93GiB used 60.04GiB path /dev/mapper/cryptroot

Label: varlocalspace  uuid: 9f46dbe2-1344-44c3-b0fb-af2888c34f18
        Total devices 1 FS bytes used 464.76GiB
        devid    1 size 1.63TiB used 471.04GiB path /dev/mapper/cryptraid0

Label: btrfs_pool1  uuid: 6358304a-2234-4243-b02d-4944c9af47d7
        Total devices 1 FS bytes used 7.45TiB
        devid    1 size 14.55TiB used 7.50TiB path /dev/mapper/dshelf1

Label: btrfs_pool2  uuid: cb9df6d3-a528-4afc-9a45-4fed5ec358d6
        Total devices 1 FS bytes used 2.74TiB
        devid    1 size 7.28TiB used 2.81TiB path /dev/mapper/dshelf2

Label: bigbackup  uuid: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
        Total devices 5 FS bytes used 1.62MiB
        devid    1 size 1.82TiB used 1.02GiB path /dev/dm-9
        devid    2 size 1.82TiB used 2.00GiB path /dev/dm-6
        devid    3 size 1.82TiB used 2.00GiB path /dev/dm-5
        devid    4 size 1.82TiB used 1.01GiB path /dev/dm-7
        devid    5 size 1.82TiB used 1.01GiB path /dev/mapper/crypt_sdq1

Btrfs v3.12

Any ideas why btrfs send fails?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
