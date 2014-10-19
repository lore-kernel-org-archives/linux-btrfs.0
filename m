Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:37671 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaJSPAc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Oct 2014 11:00:32 -0400
Received: by mail-la0-f42.google.com with SMTP id gf13so3057057lab.15
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Oct 2014 08:00:31 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 19 Oct 2014 17:00:30 +0200
Message-ID: <CANg_oxzXChzd7MJspDu-rxOew6BywBFTVk_ZqwXb6y8mhqsK0A@mail.gmail.com>
Subject: btrfs send on top level subvolumes that contain other subvolumes
From: john terragon <jterragon@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

Let's say I have a top-level subvolume /sub and that inside /sub I
have another subvolume say /sub/X/Y/subsub.

If I make a snapshot (both ro and rw give the same results) of /sub,
say /sub-snap, right now what I get is this

1) the /sub-snap/X/Y/subsub is present (and empty, and that's OK as
snapshot are not recursive) but it doesn't seem to be neither
   a) an empty subvolume (because btrfs sub list doesn't list it)
   b) a directory because, for example lsattr -d subsub gives me this
result "lsattr: Inappropriate ioctl for device While reading flags on
subsub"

2) if /sub-snap is ro and I send it somewhere, then in the destination
sub-snap subsub is not present at all (which wouldn't be illogical,
given the non-recursive nature of snapshots).

So I'm wondering it all of this is the intended outcome when
snapshotting and sending a subvolume that has internally defined
subvolumes or if perhaps it's a bug.

I'm using kernel 3.17.1 patched for the recent ro snapshot corruption
bug and btrfs-progs from the 3.17.x branch in git.

Thanks
John
