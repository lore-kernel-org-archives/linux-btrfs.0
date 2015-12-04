Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from emkei.cz ([46.167.245.116]:44590 "EHLO emkei.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbbLDMOH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Dec 2015 07:14:07 -0500
To: linux-btrfs@vger.kernel.org
Subject: Subvolume UUID, data =?UTF-8?B?Y29ycnVwdGlvbj8=?=
From: "S.J" <sorry@anonym.com>
Reply-To: sorry@anonym.com
Content-Type: text/plain; charset=utf-8
Message-Id: <20151204120529.37E47D5A28@emkei.cz>
Date: Fri,  4 Dec 2015 13:05:28 +0100 (CET)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

As we know, two file systems with the same UUID (like reported by eg. "blkid") are problematic, especially if both are mounted at the same time it leads to data corruption. So, copying a BTRFS partition with eg. dd to another and use it immediately is bad. To prevent this, "btrfstune -u /dev/sdaX" changes the UUID of the given partition.

However, BTRFS subvolumes have their own UUID, which can be viewed eg. with "btrfs sub list -u /mountpoint". This UUIDs are not changed by the command above, and apparently there is no other way to do this.

My question is: Is this a problem similar to the main UUID? Can mounting two BTRFS partitions with equal subvolume UUIDs (but different main UUID) can cause data corruption?

(...well, and maybe someone could explain me what these subvol UUIDs are for in the first place. Subvolumes already have an unique number, and from user p.o.v, there isn't anything where the subvol UUIDs can be used at all (?))

Thank you

PS: Apologies for sending a second mail, somehow my first try didn't contain any text
