Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60684 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab2GYN0k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 09:26:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Su1bm-000241-RX
	for linux-btrfs@vger.kernel.org; Wed, 25 Jul 2012 15:26:34 +0200
Received: from gut75-8-83-156-244-239.fbx.proxad.net ([83.156.244.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 15:26:34 +0200
Received: from cbay by gut75-8-83-156-244-239.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 15:26:34 +0200
To: linux-btrfs@vger.kernel.org
From: "Cyril B. " <cbay@excellency.fr>
Subject: mkfs devices ordering relevant with devices of different sizes?
Date: Wed, 25 Jul 2012 15:26:20 +0200
Message-ID: <juos5r$2tp$1@dough.gmane.org>
Reply-To: cbay@alwaysdata.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

When creating a filesystem with devices of different sizes, the resulting 
filesystem total size depends on the device order specified to mkfs. When 
the smaller device is specified first, the second (larger) device is seen as 
the same size as the first. This doesn't occur when the order is reversed.

It's confusing. Is this expected? I'm using the latest btrfs-progs and Linux 
3.5.


# ./mkfs.btrfs /dev/sda4 /dev/sdc

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

adding device /dev/sdc id 2
fs created label (null) on /dev/sda4
        nodesize 4096 leafsize 4096 sectorsize 4096 size 3.97TB
Btrfs Btrfs v0.19
backup6:~/btrfs-progs# ./btrfs fi show /dev/sdc
Label: none  uuid: 806b237e-53ed-409e-a7c1-02f101798384
        Total devices 2 FS bytes used 28.00KB
        devid    2 size 1.98TB used 2.01GB path /dev/sdc
        devid    1 size 1.98TB used 2.03GB path /dev/sda4

Btrfs Btrfs v0.19


# ./mkfs.btrfs /dev/sdc /dev/sda4

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

adding device /dev/sda4 id 2
fs created label (null) on /dev/sdc
        nodesize 4096 leafsize 4096 sectorsize 4096 size 4.71TB
Btrfs Btrfs v0.19
backup6:~/btrfs-progs# ./btrfs fi show /dev/sdc
Label: none  uuid: 8f99c072-521b-4827-a2be-41de6ab11b4f
        Total devices 2 FS bytes used 28.00KB
        devid    1 size 2.73TB used 2.03GB path /dev/sdc
        devid    2 size 1.98TB used 2.01GB path /dev/sda4

Btrfs Btrfs v0.19


Thanks.

-- 
Cyril B.

