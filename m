Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbbKBPQX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Nov 2015 10:16:23 -0500
Date: Mon, 2 Nov 2015 16:14:53 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 4.3-rc1
Message-ID: <20151102151453.GI13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the kernel 4.3 was released yesterday, the btrfs-progs will follow at the end
of this week. I've tagged an rc1 from current devel branch. There are a lots of
small invisible changes and one change in the defaults:

* mkfs: mixed mode is not forced anymore for devices smaller than 1 GiB

I've updated manual pages for mkfs, balance, btrfstune, convert and inspect,
I'd be glad if somebody could proofread them.

Otherwise bugfixes and small-sized patches are still welcome.


Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
