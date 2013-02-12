Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab3BLXP3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 18:15:29 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 25FE3A52D4
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 00:15:28 +0100 (CET)
Date: Wed, 13 Feb 2013 00:15:27 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Integration branch of btrfs-progs 2013-02
Message-ID: <20130212231526.GE12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a few more fixes and enhancements: check and restore subcommands,
support for send mode NO_FILE_DATA and partial "libifying".

The libify patchset porting was not straightforward (based on old sources) and
I fixed it here up to my satisfaction.  The changes were mostly small but there
was quite a lot of them.  I'll send patches as a followup to this mail for
review in case I did non-trivial modifications.

There's the patch converting build to autotools, but the conflict
surface was too big so it's left out for now.

(The patch backlog is not yet finished.)

Thanks for testing,
david

---
Arvin Schnell (1):
      btrfs-progs: make libbtrfs usable from C++

David Sterba (2):
      btrfs-progs: build btrsfck to keep compatibility
      btrfs-progs: don't link binaries to a dynamic library

Eric Sandeen (2):
      Btrfs-progs print more informative error when we fail to open a device
      btrfs-progs: remove unused bit-radix.[ch] files

Ian Kumlien (6):
      Btrfs-progs: add static compile target
      Btrfs-progs: -U_FORTIFY_SOURCE before -D
      Btrfs-progs: Rename btrfsck.c -> cmds-check.c
      Btrfs-progs: add btrfsck functionality to btrfs
      Btrfs-progs: restore.c -> cmds-restore.c
      Btrfs-progs: add restore command to btrfs

Ilya Dryomov (3):
      Btrfs-progs: move crc32c optimization init
      Btrfs-progs: add btrfsck name detection to btrfs
      Btrfs-progs: make 0 a valid usage filter argument

Josef Bacik (3):
      Btrfs-progs: handle errors reading fs roots
      Btrfs-progs: fix double free of extent buffer
      Btrfs-progs: return an error if we can't find an fs root

Mark Fasheh (3):
      btrfs-progs: Add support for BTRFS_SEND_FLAG_NO_FILE_DATA
      btrfs-progs: libify some parts of btrfs-progs
      btrfs-progs: add send-test

Wang Sheng-Hui (1):
      btrfs-progs: code cleanup for root-tree.c/btrfs_del_root
