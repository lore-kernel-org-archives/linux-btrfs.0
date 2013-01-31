Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 24-246-31-2.cable.teksavvy.com ([24.246.31.2]:51971 "EHLO
	pyre.virge.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3AaPmI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 10:42:08 -0500
Date: Thu, 31 Jan 2013 10:33:37 -0500
From: Norbert Veber <nveber@pyre.virge.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs: extended inode refs
Message-ID: <20130131153337.GB14605@pyre.virge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


I am trying to switch my BackupPC filesystem to btrfs, so I upgraded to
kernel 3.7.5 as I understand it has support for more hard links.
However I still get the 'too many hard links error'.

I looked at Mark Fasheh's patch, and from my rudimentary udnerstanding
it seems like I need to set BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF in the
superblock.

Is there any way to edit the superblock of an existing filesystem to
enable extended inode refs so that more hard links can be used?

I even went as far as backing up the filesystem, re-formatting using the
mkfs in the latest git version of btrfs-progs, and restoring but it
still doesnt work - too many hard links.  Aparently the mkfs patch wasnt
even applied in git yet?

$ grep -ir BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF .
$ 

Does this mean I shouldnt be using the feature just yet? :P

Thanks,

Norbert
