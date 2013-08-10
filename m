Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.200]:65006 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968527Ab3HJJ7Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 05:59:24 -0400
Received: from mailout-us.gmx.com ([172.19.198.45]) by mrigmx.server.lan
 (mrigmxus001) with ESMTP (Nemesis) id 0MUZKZ-1VYJtx3d7j-00RE14 for
 <linux-btrfs@vger.kernel.org>; Sat, 10 Aug 2013 11:59:22 +0200
Content-Type: text/plain; charset="utf-8"
Date: Sat, 10 Aug 2013 05:59:22 -0400
From: "Mike Audia" <mikey_a@gmx.com>
Message-ID: <20130810095922.206170@gmx.com>
MIME-Version: 1.0
Subject: Error relating to /dev/sr0 when calling btrfs fi show /dev/sdxy
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is the error relating to /dev/sr0 relevant to a call to /usr/bin/brtfs?  Why does it show the superfluous output?

% sudo btrfs fi show /dev/sda3
failed to open /dev/sr0: No medium found
Label: 'arch64'  uuid: ab6f9133-a2ce-4c92-97ab-35cdc3c2d2a9
 Total devices 1 FS bytes used 2.46GB
 devid    1 size 119.00GB used 5.02GB path /dev/sda3

Btrfs v0.20-rc1-253-g7854c8b
