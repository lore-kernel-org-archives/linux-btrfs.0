Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hermes15.it.auth.gr ([155.207.1.232]:46042 "EHLO
	hermes15.it.auth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbcB0L6M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Feb 2016 06:58:12 -0500
Received: from [155.207.212.89] (auth-vdhcp26.ccf.auth.gr [155.207.212.89])
	(authenticated bits=0)
	by hermes15.it.auth.gr (8.14.4/8.14.4/Debian-4.1ubuntu1) with ESMTP id u1RBj3HR034599
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Feb 2016 13:45:05 +0200
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?zpPOuc+Oz4HOs86/z4IgzqDOrM67zrvOsc+C?= <gpall@it.auth.gr>
Subject: btrfs equivalent for zfs send -R
Message-ID: <56D18C3F.9000105@it.auth.gr>
Date: Sat, 27 Feb 2016 13:45:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all.

If I have a btrfs subvolume 'subv' and then subvolumes subv/sub1, 
subv/sub2, subv/sub3, is there a way to snapshot all the subv tree and 
then recursively send it remotely?

I think this would be the analogous of zfs snapshot -r, and then zfs 
send -R.

thanks!
Giorgos

