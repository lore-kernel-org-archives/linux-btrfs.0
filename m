Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:35315 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932115AbeEICHn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 22:07:43 -0400
Received: by mail-it0-f44.google.com with SMTP id q72-v6so8557195itc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 19:07:43 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>,
        Howard McLauchlan <linux@hmclauchlan.com>
Subject: [RFC PATCH 0/6] btrfs send stream version 2
Date: Tue,  8 May 2018 22:06:45 -0400
Message-Id: <20180509020651.7946-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In trying to implement support for inode flags in send/receive, the need for
proper versioning/compatibility came up. I found some of Filipe's old patches
[1] for send stream v2 and rebased them on 4.17-rc4. My chattr changes are
landed on top and also gated behind send stream v2. Similar was done for
btrfs-progs (v4.16.1) [2] and a relevant xfstest (master) [3].

Unfortunately, since Filipe's changes are about 4 years old, rebasing required
quite a few "I guess this is how it works" guesses. A critical eye would be
greatly appreciated.

As of 4.17-rc4, commit a6aa10c70bf7 ("Btrfs: send, fix missing truncate for
inode with prealloc extent past eof") is causing some strange behaviour with the
rebased changes (this can be best seen in the xfstest output for btrfs/160).
Specifically, the hole/data structure is consistent between sender/receiver, but
the receiver is missing some information in fiemap for prealloc extents past
eof. Filipe mentioned that his fix was considering the lack of fallocate command
in send, so that's something we can look at if this patch set gets anywhere.

A few things I was unsure about:

- I couldn't use open_inode_for_write() in process_chattr() in btrfs-progs.
  Ended up having to open() with O_RDONLY. This is probably because I was
  setting immutable on the inode for my test cases.
- Filipe's original patches had BTRFS_SEND_{A/C}_INODE_FLAGS as placeholders,
  but I'd already implemented everything as BTRFS_SEND_{A/C}_CHATTR, since
  send_chown(), send_chmod(), etc. seemed to set a precedent in naming. If this
  needs to be changed let me know:

As of v4.17-rc4, these changes pass all "send" group xfstests.

Cheers, Howard

1: https://www.spinics.net/lists/linux-btrfs/msg35169.html
2: https://patchwork.kernel.org/patch/4021491/
3: https://patchwork.kernel.org/patch/4004861/

Filipe David Borba Manana (5):
  btrfs: send, bump stream version
  btrfs: send, implement total data size command to allow for progress
    estimation
  btrfs: send, use fallocate command to punch holes
  btrfs: send, use fallocate command to allocate extents
  btrfs: add send_stream_version attribute to sysfs

Howard McLauchlan (1):
  btrfs: add chattr support for send/receive

 fs/btrfs/ctree.h           |   2 +
 fs/btrfs/ioctl.c           |   2 +-
 fs/btrfs/send.c            | 496 +++++++++++++++++++++++++++++++------
 fs/btrfs/send.h            |  26 +-
 fs/btrfs/sysfs.c           |  29 +++
 include/uapi/linux/btrfs.h |  21 +-
 6 files changed, 495 insertions(+), 81 deletions(-)

-- 
2.17.0

