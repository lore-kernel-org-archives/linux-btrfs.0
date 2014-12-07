Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:63334 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaLGF00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 00:26:26 -0500
Received: by mail-yk0-f170.google.com with SMTP id q200so1434651ykb.29
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Dec 2014 21:26:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1225b43cd030194ef1ee3db419aa7a5e@admin.virtall.com>
References: <3146bf116f41e590e8ce4fdb610def31@admin.virtall.com>
	<CAJCQCtRh7HU9yd-pxgXzXebVcjukQh6Lyhzfcd6bBJppyCxChQ@mail.gmail.com>
	<88e897a70d1ac64a5b6b2c4b2e9e49d5@admin.virtall.com>
	<CAJCQCtSGy5MBVC4hQUgHBtSy+6kNOap_0Mfb7f9G4HJH9AmtUQ@mail.gmail.com>
	<1225b43cd030194ef1ee3db419aa7a5e@admin.virtall.com>
Date: Sat, 6 Dec 2014 22:26:26 -0700
Message-ID: <CAJCQCtTmc4ZeT=Av=VFeaYXXxfbUhdoUuoEp=xkqZ=xqxLm4kA@mail.gmail.com>
Subject: Re: btrfs device delete missing - Input/output error
From: Chris Murphy <lists@colorremedies.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 6, 2014 at 2:17 AM, Tomasz Chmielewski <tch@virtall.com> wrote:

> After we run again btrfs device delete missing /home, the newly created
> directory eventually (/home/backup/ma-int/weekly.tmp) is being detected as
> "csum failed ino ...".

Unmount the volume and run btrfs check, without repair:

1.
If that comes up clean then chances are this is file corruption and
you can mount and do:

btrfs scrub start -r <MP>

This will show you filenames for corrupt files you'll need to locate
backups to restore from eventually. Then unmount it again and do:

btrfs check --init-csum-tree <dev>

This will remove the current checksum tree and calculate new checksums
(only very recent btrfs-progs does this, I tested with 3.17.3), so any
files that are corrupt will no longer be flagged as corrupt, and you
should be able to remove the missing device and resume the balance
needed to restore normal operation for the mirrored volume. If you
don't have recent btrfs-progs, the initialization of the csum tree
will strip the csums entirely, and you'll need to recreate the file
system (or live without checksums).

2.
I'm going to bet btrfs check doesn't come up clean, based on the
additional problems you reported. In this case it's not file
corruption, but filesystem corruption. Even though the mirror isn't
intact, there's a possibility this small hole in the file system can
be repaired with very recent fsck patches from Josef. You'd have to
check whether the patches he's submitted in the last month or so to
the list have been incorporated into btrfs-progs integration branch;
and build a btrfs-progs that has them. Then use --repair and cross
fingers.


Certainly before 2. and probably even before 1, you ought to go ahead
and get anything off the volume you care about, seeing as right now
it's at least mounting. It'd be good to know either way if it works.
And if it doesn't work, take a btrfs-image of the fs, Josef might be
interested in testing against it seeing as only a 4KB hole was punched
into the file system.



-- 
Chris Murphy
