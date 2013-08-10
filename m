Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.201]:56006 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934434Ab3HJPmZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 11:42:25 -0400
Received: from mailout-us.gmx.com ([172.19.198.47]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0Mfpmy-1VSzQ40aW4-00NDpA for
 <linux-btrfs@vger.kernel.org>; Sat, 10 Aug 2013 17:42:24 +0200
Content-Type: text/plain; charset="utf-8"
Date: Sat, 10 Aug 2013 11:42:21 -0400
From: "Mike Audia" <mikey_a@gmx.com>
Message-ID: <20130810154221.206170@gmx.com>
MIME-Version: 1.0
Subject: Question about blocksize, I want to use 16k
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wanting to use 16k block for my btrfs, I did so via:

# mkfs.btrfs -l 16k -s 16k -L arch64 -f /dev/sda3

WARNING! - Btrfs v0.20-rc1-253-g7854c8b IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Detected a SSD, turning off metadata duplication.  Mkfs with -m dup if you want to force metadata duplication.
fs created label arch64 on /dev/sda3
 nodesize 16384 leafsize 16384 sectorsize 16384 size 119.00GB
Btrfs v0.20-rc1-253-g7854c8b

But when I tried to mount it, dmesg showed these errors aobut sector sizes:

# mount /dev/sda3 /newarch
mount: wrong fs type, bad option, bad superblock on /dev/sda3,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

[ 1463.366701] device label arch64 devid 1 transid 4 /dev/sda3
[ 1463.367186] btrfs: disk space caching is enabled
[ 1463.367189] btrfs flagging fs with big metadata feature
[ 1463.367539] btrfs: Incompatible sector size(16384) found on sda3
[ 1463.419215] btrfs: open_ctree failed

So I made the filesystem like this and all is well... what am I missing?

# mkfs.btrfs -l 16k -L arch64 -f /dev/sda3       

WARNING! - Btrfs v0.20-rc1-253-g7854c8b IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Detected a SSD, turning off metadata duplication.  Mkfs with -m dup if you want to force metadata duplication.
fs created label arch64 on /dev/sda3
 nodesize 16384 leafsize 16384 sectorsize 4096 size 119.00GB
Btrfs v0.20-rc1-253-g7854c8b
