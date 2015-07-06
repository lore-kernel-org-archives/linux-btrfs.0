Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:35493 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbbGFVyE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 17:54:04 -0400
Received: by labgy5 with SMTP id gy5so19784017lab.2
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2015 14:54:01 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 Jul 2015 00:54:01 +0300
Message-ID: <CA+xOVSO2Cd1aYxAnA_Aq32oBTiMTbuo1YQo2cqEY_5WONQV=qA@mail.gmail.com>
Subject: running duperemove but no free space gain
From: Mordechay Kaganer <mkaganer@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

Hello.

I have a btrfs volume which is used as a backup using rsync from the
main servers. It contains many duplicate files across different
subvolumes and i have some read only snapshots of each subvolume,
which are created every time after the backup completes.

I'm was trying to gain some free space using duperemove (compiled from
git master of this repo: https://github.com/markfasheh/duperemove).

Executed like this:

duperemove -rdAh <first_dir> <second_dir>

Both directories point to the most recent read only snapshots of the
corresponding subvolumes, but not to the subvolumes themselves, so i
had to add -r option. AFAIK, they should point to exactly the same
data because nothing was changed since the snapshots were taken.

It runs successfully for several hours and prints out many files which
are indeed duplicate like this:

Showing 4 identical extents with id 5164bb47
Start           Length          Filename
0.0     4.8M    "...."
0.0     4.8M    "...."
0.0     4.8M    "...."
0.0     4.8M    "...."
....skip...
[0x78dee80] Try to dedupe extents with id 5164bb47
[0x78dee80] Dedupe 3 extents (id: 5164bb47) with target: (0.0, 4.8M), "...."

But the actual free space reported by "df" or by "btrfs fi df" doesn't
seem to change. Used space and metadata space even increases slightly.

I thought that doing deduplication on a file in one snapshot would
affect all snapshots/subvolumes that contain this (exact version of
the) file because they all actually should point to the same data
extents, am i wrong?

Versions:

duperemove v0.11-dev

# uname -a
Linux yemot-bu 4.1.0-040100-generic #201507030940 SMP Fri Jul 3
09:41:47 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

# btrfs version
btrfs-progs v4.1

Thanks!

-- 
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
