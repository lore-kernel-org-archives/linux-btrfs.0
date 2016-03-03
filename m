Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43609 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbcCCXdZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Mar 2016 18:33:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1abckE-0000n7-BF
	for linux-btrfs@vger.kernel.org; Fri, 04 Mar 2016 00:33:22 +0100
Received: from 87-127-115-15.static.enta.net ([87.127.115.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 00:33:22 +0100
Received: from 6401e46d by 87-127-115-15.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 00:33:22 +0100
To: linux-btrfs@vger.kernel.org
From: boris <6401e46d@opayq.com>
Subject: [btrfs-progs suspected BUG] Scrub info with Ubuntu-style subvol-as-root setup
Date: Thu, 3 Mar 2016 23:33:15 +0000 (UTC)
Message-ID: <loom.20160304T001047-911@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Setup: btrfs root but Ubuntu style: <btrfs root>/@/<root,etc,var,usr,..>
with root=@ as a kernel boot option. Been using it happily for years; not
even sure if Ubuntu still uses this system for btrfs installs.
btrfs fs is a partition on my GPT HDD.
My fstab contains subvol=@ as option on the btrfs line, and
adding/subtracting compress,autodefrag make no difference to this.

>From Linux 4.4, I think, "btrfs scrub status" reports:

"scrub status for fdd6a335-6edf-****-****-****102cc8f5
	no stats available
	total bytes scrubbed: 0.00B with 0 errors" at all times including after
finishing.

I think it must be to do with the subvol mounted as root; pretty sure that 
The scrub appears to be doing something, but no info is available.

I haven't investigated much, it's not a show-stopper. I have waited until
4.4.1 btrfs-progs release before reporting, JIC.

Just to be clear: I've been using this setup for installs on everything from
Debian, Arch, Exherbo, CentOS, CoreOS (!), Gentoo, Funtoo .. without
problems. I've never actually used Ubuntu - knowingly!

Is there a heads-up about using this subvol-as-root setup I've missed? Does
anyone else use it? It's handy for rollbacks.

Thank you all.

