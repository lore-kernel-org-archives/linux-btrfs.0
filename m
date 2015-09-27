Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fau.xxx ([94.23.43.98]:34477 "EHLO blind.goeswhere.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbbI0SAq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Sep 2015 14:00:46 -0400
Date: Sun, 27 Sep 2015 18:52:52 +0100
From: Chris West <solo-btrfs@goeswhere.com>
To: linux-btrfs@vger.kernel.org
Subject: fstrim silently does nothing on dev add/dev rem'd filesystem
Message-ID: <20150927175252.GA24990@blind.goeswhere.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a filesystem for which fstrim won't do anything.
The filesystem has a history of abuse; dev add, dev remove, dding, ...

There's nothing wrong with the kernel or the disc; other btrfs volumes
on the same disc trim fine, and the volume used to trim fine.

By "won't trim", I mean that it always, instantly returns 0 bytes
trimmed:

% time sudo fstrim -v .
.: 0 B (0 bytes) trimmed
sudo fstrim -v .  0.00s user 0.00s system 0% cpu 0.004 total

It used to, as expected, take a while, then report a trimmed size.
Currently, it's a single-device setup, but with weird devids because of
its history:

% sudo btrfs f show
Label: none  uuid: 672510b8-afb9-425f-a58d-bd325f7c987a
    Total devices 1 FS bytes used 226.86GiB
        devid    2 size 475.94GiB used 237.03GiB path /dev/sda2
[..]

% mount | fgrep sda2
/dev/sda2 on / type btrfs
(rw,relatime,compress=lzo,ssd,space_cache,user_subvol_rm_allowed,subvolid=257,subvol=/@)
/dev/sda2 on /home type btrfs
(rw,relatime,compress=lzo,ssd,space_cache,user_subvol_rm_allowed,subvolid=258,subvol=/@home)

% uname -a
Linux a 4.2.0-10-generic #12-Ubuntu SMP Tue Sep 15 19:43:01 UTC
2015 x86_64 x86_64 x86_64 GNU/Linux
(Ubuntu Wily pre-release.)

While fstrimming probably has minimal value for such an idle/empty
volume, I'd still be interested in working out what's wrong (if anything
is wrong).

Any suggestions?

Chris (Faux on IRC).

