Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nk11p03mm-asmtp010.mac.com ([17.158.232.169]:64563 "EHLO
	nk11p03mm-asmtp010.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099Ab2IDRKb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Sep 2012 13:10:31 -0400
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from [10.2.2.31] ([62.245.66.210]) by nk11p03mm-asmtp010.mac.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Jan
  3 2012)) with ESMTPSA id <0M9U00ADT29GVR20@nk11p03mm-asmtp010.mac.com> for
 linux-btrfs@vger.kernel.org; Tue, 04 Sep 2012 16:10:31 +0000 (GMT)
From: =?iso-8859-2?Q?Petr_Tich=FD?= <spaceboy@mac.com>
Subject: Is my btrfs full?
Date: Tue, 04 Sep 2012 18:07:50 +0200
Message-id: <2878656B-C9CF-4055-8378-5F000BE84489@mac.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody,

I have a 130 GB btrfs with rsnapshot-like backups mounted with compressoin=zlib and now I'm getting ENOSPC, while df shows only some 60 % used. I'm running Linux version 3.2.0-3-amd64 (Debian 3.2.23-1). Is my btrfs really full? Will a more recent kernel solve this?

root@roura:~# btrfs filesystem show --all-devices
Label: none  uuid: 12880174-8337-47bc-be05-f485a0b7503f
	Total devices 1 FS bytes used 72.67GB
	devid    1 size 130.00GB used 130.00GB path /dev/sdd

root@roura:~# btrfsck /dev/sdd
checking extents
checking fs roots
checking root refs
found 78034288640 bytes used err is 0
total csum bytes: 72765720
total tree bytes: 3521994752
total fs tree bytes: 3242008576
btree space waste bytes: 476621556
file data blocks allocated: 74512293888
 referenced 107630747648
Btrfs Btrfs v0.19

Thanks

Petr
