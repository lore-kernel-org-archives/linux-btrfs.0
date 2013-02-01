Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab3BARlO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 12:41:14 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 87F94A38EA
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2013 18:41:12 +0100 (CET)
Date: Fri, 1 Feb 2013 18:41:11 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Integration branch of btrfs-progs 2013-02-01
Message-ID: <20130201174110.GC23239@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

documentation updates, mkfs support of extended refs (aka more hardlinks
possible), new command 'subvolume show' and extensions/updates to
the 'subvolume list' command and fsck fixes.

Please consider this more like a preview, there were some merge
conflicts and I may have missed some combination of subvol list options
that do not do what they're expected to do.

I'm going to do some more testing of the previous integration branch and
send a pull request as of 20130126.


david

repo url: git://repo.or.cz/btrfs-progs-unstable/devel.git
---

Anand Jain (14):
      Btrfs-progs: man btrfs: subcommands must be grouped together
      Btrfs-progs: move printing subvol list outside of btrfs_list_subvols
      Btrfs-progs: add parent uuid for snapshots
      Btrfs-progs: move struct root_info to btrfs-list.h
      Btrfs-progs: add function btrfs_get_subvol to get root_info of a subvol
      Btrfs-progs: add method to filter snapshots by parent uuid
      Btrfs-progs: put find_mount_root() in commands.h
      Btrfs-progs: make printing subvol extensible to newer layouts
      Btrfs-progs: make get_subvol_name non cmds-send specific
      Btrfs-progs: add show subcommand to subvol cli
      Btrfs-progs: update btrfs_get_subvol to be inline with resolve_root ret changes
      Btrfs-progs: Fix a small memory leak in managing the btrfs list filter
      Btrfs-progs: add subvol flags to print
      Btrfs-progs: dont print uuid unless -u option is given

Chen Yang (2):
      Btrfs-prog/send: fix wrong dump_fd check in cmd_send_start()
      Btrfs-progs: Complete the help information of btrfs send/receive

David Sterba (5):
      btrfs-progs: fix parallel build
      btrfs-progs: upcase filter options
      btrfs-progs: add option g to show generation
      btrfs-progs: add option c to show ogeneration
      btrfs-progs: update man pages of subvol list

Dieter Ries (1):
      btrfs-progs: btrfsck: Print which filesystem to be checked to stdout

Eric Sandeen (1):
      btrfs-progs: fix mkfs.btrfs -r option

Goffredo Baroncelli (1):
      Update the man page with the new prefixes.

Josef Bacik (1):
      Btrfs-progs: use btrfs_lookup_first_block_group when fixing accounting

Lukas Czerner (3):
      Btrfs-progs: move path modification to filters
      Btrfs-progs: add '-o' option into subvolume list command
      Btrfs-progs: List all subvolumes by default

Mark Fasheh (3):
      btrfs-progs: Basic support for extended inode refs
      btrfs-progs: add extended inode ref support to btrfsck
      btrfs-progs: mkfs support for extended inode refs

Wang Shilong (1):
      Btrfs-progs: filter the deleted subvolumes when listing snapshots
