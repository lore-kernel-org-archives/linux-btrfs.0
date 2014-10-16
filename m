Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaJPMhP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 08:37:15 -0400
Date: Thu, 16 Oct 2014 14:37:13 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Btrfs-progs pre-release 3.17, take 2
Message-ID: <20141016123713.GF22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20141014121717.GQ22943@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141014121717.GQ22943@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this another rc, tagged as v3.17-rc5 (a197726ad770760), fixing a few problems.
There's one known issue, xfstests/btrfs/006 prints an unexpected output (more
at https://patchwork.kernel.org/patch/5084631/). ETA for release is tomorrow.

Shortlog:

Anand Jain (3):
      btrfs-progs: mkfs should be consistent in calling register device
      btrfs-progs: introduce a proper structure on which cli will call register-device ioctl
      btrfs-progs: open RW to register device using btrfs-control

Filipe Manana (1):
      Btrfs-progs: check, fix return value check of is_child_root()

Zach Brown (2):
      btrfs-progs: check sscanf return code
      btrfs-progs: fix show super unknown flag output
