Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:42054 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205Ab2JKTd6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 15:33:58 -0400
Message-ID: <50771F22.3070501@profihost.ag>
Date: Thu, 11 Oct 2012 21:33:54 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: problems with btrfs send / restore
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

i wanted to try to out btrfs send and restore but i'm failing on a 
simple step:

[server: /btrfs/target]# btrfs send /btrfs/src/\@snapshot/1 | btrfs 
receive /btrfs/target/\@snapshot/
At subvol /btrfs/src/@snapshot/1
At subvol 1
[server: /btrfs/target]# ls -la /btrfs/target/\@snapshot/
total 4
drwxr-xr-x 1 root root  2 Oct 11 20:25 .
dr-xr-xr-x 1 root root 18 Oct 11 20:25 ..
dr-xr-xr-x 1 root root 52 Oct 10 23:52 1

<= works fine

[server: /btrfs/target]# btrfs send -i /btrfs/src/\@snapshot/1 
/btrfs/src/\@snapshot/2 | btrfs receive /btrfs/target/\@snapshot/
At subvol /btrfs/src/@snapshot/2
At subvol 2
ERROR: failed to open /btrfs/target/@snapshot/@snapshot/1/test.tar. No 
such file or directory

Stefan
