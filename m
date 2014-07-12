Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p02c11o141.mxlogic.net ([208.65.144.74]:52459 "EHLO
	p02c11o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaGLCE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jul 2014 22:04:59 -0400
From: David Player <dplayer@seagullscientific.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Modify UUID/CTRANSID for incremental backups
Date: Sat, 12 Jul 2014 01:56:01 +0000
Message-ID: <B2E8CD86330BEF41BB6ED95EFC9EBBEE5881CB@SRVEX2.corp.seagullscientific.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Given the situation explained below, it appears I can fix my btrfs send datastream by updating the UUID and CTRANSID of alternate_sv2. Specifically, Command 1 TLV 1 and 2, or Command 2 TLV 1 and 2. The CRC32 would also be updated.

This would make incremental btrfs "send" backups markedly more useful because it allows me to erase intermediate backups after a time.

It's trivial to write a program to do this, so I plan to start testing next week unless anyone has concerns.



btrfs subvolume snapshot -r real v1
#later...
btrfs subvolume snapshot -r real v2
#later...
btrfs subvolume snapshot -r real v3

btrfs send -f sv1 v1
btrfs send -f sv2 v2 -p v1
btrfs send -f sv3 v3 -p v2

btrfs subvolume delete v?

btrfs receive -vf sv1 .
btrfs receive -vf sv2 .
btrfs subvolume delete v1
btrfs send -f alternate_sv2 v2
btrfs subvolume delete v?


#Scenario 1 should work (and does)
btrfs receive -vf sv1 .
btrfs receive -vf sv2 .
btrfs receive -vf sv3 .


#Scenario 2 should work (but doesn't)
btrfs receive -vf alternate_sv2 .
btrfs receive -vf sv3 .		# "ERROR: could not find parent subvolume"



To solve the problem, I plan to update the data for TLV ops 1 and 2 in alternate_sv2.

Packet: op 2    SNAPSHOT        length 46       crc32 36A251CC
   TLV: op F    PATH            length 2        "v2"
   TLV: op 1    UUID            length 10       81A4010723F85C4E996371EE73A413AC
   TLV: op 2    CTRANSID        length 8        EB01000000000000
   TLV: op 14   CLONE_UUID      length 10       FA2E1AEC25CFD540B7CA404D6584F4AA
   TLV: op 15   CLONE_CTRANSID  length 8        EA01000000000000

It also appears possible to combine two data streams without "btrfs receive", but that's more complicated.
