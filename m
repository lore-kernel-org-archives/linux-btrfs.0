Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64195 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbaJBPNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Oct 2014 11:13:35 -0400
Received: from fb07-iapwap2.physik.uni-giessen.de ([134.176.19.122]) by
 mail.gmx.com (mrgmx002) with ESMTPSA (Nemesis) id 0MWBpJ-1XkL4O0oZt-00XJYQ
 for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 17:13:33 +0200
From: Marc Dietrich <marvin24@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: FIBMAP unsupported
Date: Thu, 02 Oct 2014 17:13:22 +0200
Message-ID: <6602102.lhBckFYBLs@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a large (25G) virtual disk on a btrfs fs. Yes, I know this is not 
optimial. So I try to defrag it from time to time. However, using "btrfs fi 
defrag -c vm.vdi" results in even more fragments than before (reported by 
filefrag). So I wrote my own pseudo defragger,

-----
#!/bin/sh

test -f $1 || exit 2

echo "defrag $1"
/usr/sbin/filefrag $1 || exit

fallocate -n -l `filesize $1` $1.new || exit
chattr +C $1.new
dd if=$1 of=$1.new conv=notrunc oflag=append status=none
chmod --reference $1 $1.new
chown --reference $1 $1.new
mv $1.new $1
/usr/sbin/filefrag $1

-----

which produces much better results (ok, the file must not be in use). 
Somewhere in the 3.17 cycle the resulting image got corrupted using the script 
above. 

Running filefrag on it returns "FIBMAP unsupported".

Virtualbox returns  "AHCI#0P0: Read at offset 606236672 (49152 bytes left) 
returned rc=VERR_DEV_IO_ERROR". No errors in the kernel log.

Trying "cp vm.vdi /dev/null" returns: cp: Error reading „vm.vdi“: IO-Error

kernel 3.17-rc7
btrfs 3.17.x
mount options: rw,nodiratime,relatime,compress=lzo,space_cache,autodefrag

Marc

