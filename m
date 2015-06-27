Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:34977 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbF0XRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jun 2015 19:17:16 -0400
Received: by lagh6 with SMTP id h6so18356274lag.2
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Jun 2015 16:17:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
Date: Sun, 28 Jun 2015 02:17:15 +0300
Message-ID: <CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
Subject: Fwd: btrfs replace seems to corrupt the file system
From: Mordechay Kaganer <mkaganer@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

Hello. I'm running our backup archive on btrfs. We have MD-based RAID5
array with 4 6TB disks then LVM on top of it, and btrfs volume on the
LV (we don't use btrfs's own RAID features because we want RAID5 and
as far as i understand the support is only partial).

I wanted to move the archive to another MD array of 4 8TB drives (this
time without LVM). So i did:

btrfs replace start 1 /dev/md1 <mount_point>

Where 1 is the only devid that was present and /dev/md1 is the new array.

The replace run successfully until finished after more than 5 days.
The system downloaded some fresh backups and created new snapshots
during the ongoing replace. I've go 2 kernel warnings about replace
task waiting for more than 120 seconds in the middle, but process
seamed to go on anyway.

After the replace have finished i did btrfs fi resize 1:max
<mount_point> then unmounted and mounted again using the new drive.

Then i've run a scrub on the FS - and got a lot of checksum errors.
Messages like this:

BTRFS: checksum error at logical 5398405586944 on dev /dev/md1, sector
10576283152, root 12788, inode 4512290, offset 23
592960, length 4096, links 1 (path: XXXXXXXXX)
BTRFS: bdev /dev/md1 errs: wr 0, rd 0, flush 0, corrupt 67165, gen 0
BTRFS: unable to fixup (regular) error at logical 5398405586944 on dev /dev/md1

Is there any way to fix this? I still have the old array available but
replace have wiped out it's superblock so it's not mountable.

# uname -a
Linux <hostname> 3.16.0-41-generic #57~14.04.1-Ubuntu SMP Thu Jun 18
18:01:13 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
Btrfs v3.12

-- 
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
