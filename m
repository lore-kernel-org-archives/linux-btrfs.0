Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38024 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab3KLNmD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 08:42:03 -0500
Received: by mail-wg0-f43.google.com with SMTP id n12so3041782wgh.34
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 05:42:01 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 0/5] Add support for object properties
Date: Tue, 12 Nov 2013 13:41:41 +0000
Message-Id: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a revised version of the original proposal/work from Alexander Block
to introduce a generic framework to set properties on btrfs filesystem objects
(inodes, subvolumes, filesystems, devices).

I preserved most of Alexander's work, rebasing only his main patch against
latest integration branch, adding some missing static qualifiers, malloc failure
checks and fixing some checkpatch.pl warnings. On top of his work, I added a few
fixes and enhancements and added support for 1 inode property, named compression,
which requires the corresponding kernel patch.

Once there's agreement on this feature and patchset, I'll send my xfstests patch
that tests this feature.

Alexander's original cover letter:

"
        This patchset introduces the btrfs property subgroup. It is the
        result of a discussion we had on IRC. I tried to make the properties
        interface as generic and extensible as possible. Comments are welcome.

        Currently the command group looks like this:
        btrfs prop set [-t <type>] /path/to/object <name> <value>
        btrfs prop get [-t <type>] /path/to/object [<name>] (omitting name dumps all)
        btrfs prop list [-t <type>] /path/to/object (lists properties with description)

        The type is used to explicitly specify what type of object you mean. This is 
        necessary in case the object+property combination is ambiguous.  For example
        '/path/to/fs/root' could mean the root subvolume, the directory inode or the 
        filesystem itself. Normally, btrfs-progs will try to detect the type 
        automatically.

        David suggested that it should also be possible to specify objects by
        their id/uuid/fsid. I like that idea, but would be happy if someone else
        could take over that part :)

        For now, I've implemented two properties:

        1. read-only. Usable on subvolumes to toggle the read-only flags.
        2. label. I looked through btrfs to find good examples of things that
           could be moved to the new properties interface and the filesystem
           label looked like a good one. There are for sure more, but that is
           something for later (and maybe for someone else). I would suggest 
           to move everthing that makes sense over to the props interface and 
           mark the old interfaces as deprecated. Comments on this are welcome.

        Patch version history:
        v1
          Initial version.
        v2
          - Removed the filesystem prefix and implemented it as new command group
          - Switched from the <name>[=<value>] form to the set/get <name> [<value>] 
            form.
          - Removed patches "Btrfs-progs: make filesystem_cmd_group non const"
            and "Btrfs-progs: move skip_prefix and prefixcmp to utils.c". They
            are not needed anymore due to the 'btrfs prop list' command.
          - Udjusted the subvol flags patch to be compatible to the "Btrfs: use 
            _IOR for BTRFS_IOC_SUBVOL_GETFLAGS" patch.
          - Using -t <type> instead of <type>: prefix now.
          - Changes are based on feedback from Ilya and David.

        Alex.
"

Thanks.


Alexander Block (1):
  Btrfs-progs: introduce btrfs property subgroup

Filipe David Borba Manana (4):
  Btrfs-progs: let get_label return the label instead of printing it
  Btrfs-progs: fix detection of root objects in cmds-property.c
  Btrfs-progs: add type root to label property
  Btrfs-progs: add support for the compression property

 Makefile          |    4 +-
 btrfs.c           |    1 +
 cmds-filesystem.c |   14 +-
 cmds-property.c   |  467 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h        |    2 +
 ioctl.h           |   12 ++
 props.c           |  184 +++++++++++++++++++++
 props.h           |   43 +++++
 utils.c           |   15 +-
 utils.h           |    2 +-
 10 files changed, 729 insertions(+), 15 deletions(-)
 create mode 100644 cmds-property.c
 create mode 100644 props.c
 create mode 100644 props.h

-- 
1.7.9.5

