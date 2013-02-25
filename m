Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:47423 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756750Ab3BYVzQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/17] btrfs-progs: More misc fixes & cleanups
Date: Mon, 25 Feb 2013 16:54:33 -0600
Message-Id: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A bunch of Coverity static analysis checker fixes, including
a couple actual bugfixes.

This gets it down from around 80 defects to about 50; I have a couple
other patches I need to clean up which quiets it even more.

By getting it to a tolerable level, subsequent runs to check for
regressions & new problems should be more manageable...

thanks,
-Eric

[PATCH 01/17] btrfs-progs: Unify size-parsing
[PATCH 02/17] btrfs-progs: fix btrfs_get_subvol cut/paste  error
[PATCH 03/17] btrfs-progs: Remove write-only var fdres in cmd_dev_stats()
[PATCH 04/17] btrfs-progs: btrfs_list_get_path_rootid error handling
[PATCH 05/17] btrfs-progs: avoid double-free in __btrfs_map_block
[PATCH 06/17] btrfs-progs: fix open error test in cmd_start_replace
[PATCH 07/17] btrfs-progs: fix close of error fd in scrub cancel
[PATCH 08/17] btrfs-progs: more scrub cancel error handling
[PATCH 09/17] btrfs-progs: free memory before error exit in read_whole_eb
[PATCH 10/17] btrfs-progs: don't call close on error fd
[PATCH 11/17] btrfs-progs: provide positive errno to strerror in cmd_restore
[PATCH 12/17] btrfs-progs: free allocated di_args in cmd_start_replace
[PATCH 13/17] btrfs-progs: close fd on cmd_subvol_get_default return
[PATCH 14/17] btrfs-progs: fix mem leak in resolve_root
[PATCH 15/17] btrfs-progs: Tidy up resolve_root
[PATCH 16/17] btrfs-progs: fix fd leak in cmd_subvol_set_default
[PATCH 17/17] btrfs-progs: replace strtok_r with strsep
