Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41559 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2FXVU3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jun 2012 17:20:29 -0400
Received: by bkcji2 with SMTP id ji2so2680230bkc.19
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jun 2012 14:20:28 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 0/5] introduce btrfs filesystem property command
Date: Sun, 24 Jun 2012 23:20:03 +0200
Message-Id: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset introduces the btrfs filesystem property command. It is the
result of a discussion we had on IRC. I tried to make the properties
interface as generic and extensible as possible. Comments are welcome.

Currently the command looks like this:
btrfs fi prop /path/to/object [name[=value]]

Some people may prefer other forms. For example I got suggestions for
these forms:
btrfs set/get /path/to/object [name [value]]
btrfs prop /pach/to/object [name[=value]] (and also without the =)

I'm open to more suggestions and a discussion on this. I'm definitely
for removing the fi[lesystem] prefix but I'm neutral to the other 
suggestions made so far.

For now, I've implemented three properties:
1. read-only. Usable on subvolumes to toggle the read-only flags.
2. label. I looked through btrfs to find good examples of things that
   could be moved to the new properties interface and the filesystem
   label looked like a good one. There are for sure more, but that is
   something for later (and maybe for someone else). I would suggest 
   to move everthing that makes sense over to the props interface and 
   mark the old interfaces as deprecated. Comments on this are welcome.

Alex.

Alexander Block (5):
  Btrfs-progs: add BTRFS_IOC_SUBVOL_GET/SETFLAGS to ioctl.h
  Btrfs-progs: move skip_prefix and prefixcmp to utils.c
  Btrfs-progs: let get_label return the label instead of of printing it
  Btrfs-progs: make filesystem_cmd_group non const
  Btrfs-progs: introduce btrfs filesystem property command

 Makefile          |    3 +-
 btrfs.c           |   19 +--
 btrfslabel.c      |   13 +-
 btrfslabel.h      |    4 +-
 cmds-filesystem.c |  115 +++++++++++++-
 commands.h        |    9 +-
 help.c            |    2 +
 ioctl.h           |    2 +
 props.c           |  460 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 props.h           |   45 ++++++
 utils.c           |   15 ++
 utils.h           |    3 +
 12 files changed, 659 insertions(+), 31 deletions(-)
 create mode 100644 props.c
 create mode 100644 props.h

-- 
1.7.10

