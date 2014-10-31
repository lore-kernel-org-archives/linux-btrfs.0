Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56782 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbaJaOmr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 10:42:47 -0400
Message-ID: <54539FE3.6010006@gmx.de>
Date: Fri, 31 Oct 2014 15:42:43 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: v3.18-rc2 at a 32 bit KVM gives :"INFO: trying to register non-static
 key.the code is fine but needs lockdep annotation."
References: <54511C41.5090603@gmx.de> <20141030101552.GD26064@localhost.localdomain> <5452CAD7.30602@gmx.de> <20141031013626.GA30764@localhost.localdomain> <54536615.6030900@gmx.de> <20141031141252.GA7522@localhost.localdomain>
In-Reply-To: <20141031141252.GA7522@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2014 03:12 PM, Liu Bo wrote:
> Can you please tell me the trinity option?
> 
> (I'm using "trinity --dangerous -C 2 -N 200 -c writev -q -l off", But I only got softlockup for one time, others are OOM messages.)
> 
> thanks,
> -liubo

I'm running within the 32 bit KVM guest :

$> mkdir /mnt/ramdisk/btrfs; truncate -s 97M /mnt/ramdisk/btrfs.fs; /sbin/mkfs.btrfs /mnt/ramdisk/btrfs.fs; sudo su -c "mount -o loop,compress=lzo /mnt/ramdisk/btrfs.fs /mnt/ramdisk/btrfs; chmod 777 /mnt/ramdisk/btrfs"

followed by :

$> D=': D=/mnt/ramdisk/btrfs; while [[ : ]]; do cd ~; sudo rm -rf $D/t3 && mkdir $D/t3 || break; cd $D/t3; mkdir -p v1/v2; for i in $(seq 0 99); do touch v1/v2/f$i; mkdir v1/v2/d$i; done; trinity -C 2 -N 100000 -V $D/t3/v1/v2 -q; echo; echo " done"; echo; sleep 4; done

(latest git tree of trinity and Btrfs v3.14.2

-- 
Toralf
pgp key: 0076 E94E

