Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbbFKQGj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 12:06:39 -0400
From: David Sterba <dsterba@suse.cz>
To: stable@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Btrfs stable updates for 4.0
Date: Thu, 11 Jun 2015 18:06:32 +0200
Message-Id: <cover.1434037853.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please queue the following patches to 4.0 stable. There are fixes for user
visible bugs and one usability regression with RAID1 -> single conversion
during balance.

One of the patches does not apply cleanly to 4.0.5, there's a minor conflict in
patch context (153c35b6cccc0c72de9fae06c8e2c8b2c47d79d4, the last one). A reply
to this mail is the adapted version or you can pull/cherry-pick from

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-stable-4.0

Subjects:
	Btrfs: send, add missing check for dead clone root
	Btrfs: send, don't leave without decrementing clone root's send_progress
	btrfs: incorrect handling for fiemap_fill_next_extent return
	btrfs: cleanup orphans while looking up default subvolume
	Btrfs: fix range cloning when same inode used as source and destination
	Btrfs: fix uninit variable in clone ioctl
	Btrfs: fix regression in raid level conversion
Commits:
	5cc2b17e80cf5770f2e585c2d90fd8af1b901258 # 3.14+
	2f1f465ae6da244099af55c066e5355abd8ff620 # 3.14+
	26e726afe01c1c82072cf23a5ed89ce25f39d9f2 # 3.10+
	727b9784b6085c99c2f836bf4fcc2848dc9cf904 # 3.14+
	df858e76723ace61342b118aa4302bd09de4e386 # 4.0+
	de249e66a73d696666281cd812087979c6fae552 # 4.0+
	153c35b6cccc0c72de9fae06c8e2c8b2c47d79d4 # 4.0+

Thanks.
