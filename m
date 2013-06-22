Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:18827 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3FVDPu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 23:15:50 -0400
Received: from [192.168.177.104]
	(p57B92FB7.dip0.t-ipconnect.de [87.185.47.183])
	by smtp.strato.de (joses mo43) (RZmta 31.28 DYNA|AUTH)
	with ESMTPA id Q00a42p5M19j2z for <linux-btrfs@vger.kernel.org>;
	Sat, 22 Jun 2013 05:15:47 +0200 (CEST)
Message-ID: <51C516E3.2080308@ifyouwantblood.de>
Date: Sat, 22 Jun 2013 05:15:47 +0200
From: Sebastian <sebastian@ifyouwantblood.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [Bug] btrfs-image from power failure, Transaction aborted (error
 -22), btrfsck fails
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

i'm using Btrfs as a root partition. an hour ago i had a power failure 
and the root btrfs would only mount ro. find below links to the relevant 
btrfs-image, dmesg and kernel config.

used kernel when power failed: 3.9.0-1-desktop (from openSuse)
however following output from kernel: 3.10-rc4 (vanilla from kernel.org, 
config see below)
btrfs mkfs was: mkfs.brtfs -d raid1 -m raid1 /dev/sda7 /dev/sdb1

mounting with recovery didn't help. btrfsck failed, too (standard from 
opensuse and dangerdonteveruse). it outputted (forgot to write down the 
numbers, sorry):
 > warning, start mismatch %uul %uul
 > Aborted.
i had a quick look into the source code (branch dangerdonteveruse) and 
found the Abort came from:

 > static int add_data_backref
 > (...)
 > if (rec->start != bytenr)
 > abort();

since my backup was just 3h old, for the heck of it i also tried 
btrfs-zero-log and btrfs-select-super without success. both even 
reported "failed to open_ctree"

links (config, btrfs-image, dmesg)
http://www.ifyouwantblood.de/temp/btrfs-2013-06-22-config
http://www.ifyouwantblood.de/temp/btrfs-2013-06-22-sdb1
http://www.ifyouwantblood.de/temp/btrfs-2013-06-22-dmesg

3.9.0-1-desktop
http://kernel.opensuse.org/cgit/kernel-source/commit/?id=97c14baeec524b749710c3a0dd18f9223ea55933

the relevant messages, i believe, are:
-------------------------------------------------------------
BTRFS error (device sda7): unable to find ref byte nr 2249924608 parent 
0 root 261  owner 13065 offset 5525504
BTRFS error (device sda7): trying to drop 3 refs but we only have 1 for 
bytenr 2249924608
BTRFS error (device sda7) in __btrfs_free_extent:5566: errno=-22 unknown
BTRFS info (device sda7): forced readonly
  BTRFS debug (device sda7): run_one_delayed_ref returned -22
BTRFS error (device sda7) in btrfs_run_delayed_refs:2630: errno=-22 unknown
BTRFS error (device sda7): Error removing orphan entry, stopping orphan 
cleanup
BTRFS critical (device sda7): could not do orphan cleanup -22
------------[ cut here ]------------
-------------------------------------------------------------
(see links above for full dmesg)

-- 
MFG Sebastian


