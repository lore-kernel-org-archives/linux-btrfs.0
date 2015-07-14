Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbbGNMGF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 08:06:05 -0400
Date: Tue, 14 Jul 2015 14:06:03 +0200
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.1.2 (urgent fix, do not use 4.1.1)
Message-ID: <20150714120603.GH15535@twin.jikos.cz>
Reply-To: dsterba@suse.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

due to a buggy bugfix to mkfs, filesystems created with version 4.1.1 are not
entirely correct.

To check if the filesystem is affected run 'btrfs check' and look for

Chunk[256, 228, 0]: length(4194304), offset(0), type(2) mismatch with block group[0, 192, 4194304]: offset(4194304), objectid(0), flags(34)
Chunk[256, 228, 4194304]: length(8388608), offset(4194304), type(4) mismatch with block group[4194304, 192, 8388608]: offset(8388608), objectid(4194304), flags(36)

at the beginning of the output. Such filesystems must not be used and
must be recreated. Read-only mount should be safe to retrieve the data,
but at the moment this hasn't been verified.

Thanks to Qu Wenruo for identifying the problem, I'm sorry for the trouble.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
