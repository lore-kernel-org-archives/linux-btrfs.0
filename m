Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbcANMry (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 07:47:54 -0500
Date: Thu, 14 Jan 2016 13:47:48 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.4-rc1
Message-ID: <20160114124748.GV4227@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the btrfs-progs 4.4-rc1 has been tagged. This is a heads-up before the release
(ETA tmorrow). Please give it some testing.

I'll write a more detailed changelog for 4.4, but here are some notable changes:

* manual pages enhanced (btrfs, mkfs, mount, filesystem, balance)
* mkfs.btrfs --data dup
* new/enhanced balance filters (kernel 4.4+):
  * limit=min..max
  * stripes=min..max
  * usage=min..max
* free space tree (aka space_cache=v2, kernel 4.5+)
* fix: fi usage and mixed block groups
* debug-tree: -t understands chunk tree (3) and tree root (1)

Minor bugfixes are still accepted, the rest will go to the next development
cycle.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
