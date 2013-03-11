Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3CKOrN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 10:47:13 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A5054A50F4
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 15:47:12 +0100 (CET)
Date: Mon, 11 Mar 2013 15:47:11 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Integration branch of btrfs-progs 2013-03-11
Message-ID: <20130311144711.GC7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this set contains help text updates, the series from Eric and my fix to mkfs
superblock checksum (now needed to mount a new filesystem when the kernel-side
check is in place -- applies to current btrfs-next).

git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130311

david

--
Anand Jain (3):
      btrfs-progs: from troubleshooting point of view messages must be unique
      btrfs-progs: usage should match what is coded
      btrfs-progs: update the .gitignore file

David Sterba (1):
      btrfs-progs: separate super_copy out of fs_info

Eric Sandeen (14):
      btrfs-progs: close fd on cmd_subvol_list return
      btrfs-progs: close fd on do_convert error returns
      btrfs-progs: free resources on do_rollback error returns
      btrfs-progs: free allocated metadump structure on restore failure
      btrfs-progs: check for null string in parse_size
      btrfs-progs: tidy up cmd_snapshot() whitespace & returns
      btrfs-progs: Free resources when returning error from cmd_snapshot()
      btrfs-progs: tidy up cmd_subvol_create() whitespace & returns
      btrfs-progs: Free resources when returning error from cmd_subvol_create()
      btrfs-progs: check return of posix_fadvise
      btrfs-progs: Issue warnings if ioctls fail in sigint handlers
      btrfs-progs: better option/error handling for btrfs-vol
      btrfs-progs: Error handling in scrub_progress_cycle() thread
      btrfs-progs: fix scrub error return from pthread_mutex_lock

Zhi Yong Wu (1):
      btrfs-progs: update mkfs.btrfs help info for raid5/6
