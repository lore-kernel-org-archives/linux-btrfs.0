Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:42580 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab2FIFfk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Jun 2012 01:35:40 -0400
Message-ID: <4FD2E0AA.5040900@libero.it>
Date: Sat, 09 Jun 2012 07:35:38 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: linux-btrfs@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
        Josef Bacik <josef@redhat.com>
Subject: Re: problem re-adding original mount block device on multi-device
 fs
References: <20120608044210.GY725@wantstofly.org>
In-Reply-To: <20120608044210.GY725@wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/08/2012 06:42 AM, Lennert Buytenhek wrote:
> (please CC on replies, I'm not subscribed to the list)
> 
> Hi!
> 
> This fails:
> 
> 	# mkfs.btrfs /dev/sd[bcde]
> 	# mount /dev/sdb /mnt/x
> 	# btrfs device delete /dev/sdb /mnt/x
> 	# btrfs device add /dev/sdb /mnt/x
> 	/dev/sdb is mounted
> 	#
> 
> It seems that I have to unmount and remount the fs using another
> constituent block device before I can re-add the original block
> device that the filesystem was mounted with:
> 
> 	# umount /mnt/x
> 	# mount /dev/sdb /mnt/x
> 	mount: wrong fs type, bad option, bad superblock on /dev/sdb,
> 	       missing codepage or helper program, or other error
> 	       In some cases useful info is found in syslog - try
> 	       dmesg | tail or so
> 	# mount /dev/sdc /mnt/x
> 	# btrfs device add /dev/sdb /mnt/x
> 	#
> 
> This is on up-to-date F17, kernel 3.4.0(-1.fc17) with btrfs-progs
> 0.19(-18.fc17).

Give a look to this patche:

[PATCH 2/2] Btrfs: fix wrong the mount information in /proc

This should address (even without solving) this kind of problem.


> 
> 
> thanks,
> Lennert
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

