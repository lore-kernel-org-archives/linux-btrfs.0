Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55713 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2F0NRB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 09:17:01 -0400
Received: by bkcji2 with SMTP id ji2so935379bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 06:16:59 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCHv2 0/3] Btrfs-progs: introduce btrfs property subgroup
Date: Wed, 27 Jun 2012 15:16:48 +0200
Message-Id: <1340803011-21882-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

Alexander Block (3):
  Btrfs-progs: add BTRFS_IOC_SUBVOL_GET/SETFLAGS to ioctl.h
  Btrfs-progs: let get_label return the label instead of of printing it
  Btrfs-progs: introduce btrfs property subgroup

 Makefile          |    5 +-
 btrfs.c           |    1 +
 btrfslabel.c      |   13 +-
 btrfslabel.h      |    4 +-
 cmds-filesystem.c |   14 +-
 cmds-property.c   |  459 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h        |    2 +
 ioctl.h           |    2 +
 props.c           |  114 +++++++++++++
 props.h           |   43 +++++
 10 files changed, 645 insertions(+), 12 deletions(-)
 create mode 100644 cmds-property.c
 create mode 100644 props.c
 create mode 100644 props.h

-- 
1.7.10

