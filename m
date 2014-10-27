Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:52035 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaJ0M4L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 08:56:11 -0400
Received: from fb07-iapwap2.physik.uni-giessen.de ([134.176.19.122]) by
 mail.gmx.com (mrgmx103) with ESMTPSA (Nemesis) id 0LmrZY-1YJCej2bCm-00h33c
 for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 13:56:09 +0100
From: Marc Dietrich <marvin24@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: nocow and compression
Date: Mon, 27 Oct 2014 13:56:07 +0100
Message-ID: <2033879.2EPALEPetI@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I created a filesystem and mounted it with compress-force=lzo. Then I did:

# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0      100M  4.1M   96M   5% /mnt

# yes "Hello World" | dd of=/mnt/test iflag=fullblock bs=1M count=20 
status=none
yes: standard output: Broken pipe
yes: write error

# sync; ls -l ; df -h .
total 20480
-rw-r--r-- 1 root root 20971520 Oct 27 13:48 test
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0      100M  4.7M   96M   5% /mnt

so far so good ...

# touch test2; chattr +C test2
# dd if=test of=test2 conv=notrunc bs=1M iflag=fullblock oflag=append 
status=none
# sync; ls -l ; df -h .
total 40960
-rw-r--r-- 1 root root 20971520 Oct 27 13:51 test
-rw-r--r-- 1 root root 20971520 Oct 27 13:51 test2
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0      100M   25M   76M  25% /mnt

oops, no compression.

Is this intended?

Marc

