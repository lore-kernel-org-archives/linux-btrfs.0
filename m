Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbbA0RM3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Jan 2015 12:12:29 -0500
Date: Tue, 27 Jan 2015 18:12:27 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 3.18.2
Message-ID: <20150127171227.GC3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is probably the last release before 3.19 unless something urgent pops up.
I'm going to start 3.19 with the autotools update and merge the bigger
patchsets (restore, find-root, check/repair).

Changes:

* qgroup show: print human readable sizes, options to say otherwise
* check: new option to explicitly say no to writes
* mkfs: message about trimming is not printed to stderr
* fi show: fixed return value
* tests: new infrastructure
* btrfstune: force flag can be used together with seeding option
* backtrace support is back
* getopt cleanups
* doc and help updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

david
