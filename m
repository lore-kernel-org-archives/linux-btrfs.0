Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55870 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaFPLS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 07:18:28 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS, SSD and single metadata
Date: Mon, 16 Jun 2014 13:18:24 +0200
Message-ID: <4823159.jCObc9Zrv0@vajra>
In-Reply-To: <539ED083.5050705@gmail.com>
References: <1723493.aXdklhDgAK@vajra> <539ED083.5050705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Austin, and thanks for your reply.

Le lundi 16 juin 2014, 07:09:55 Austin S Hemmelgarn a écrit :
> 
> What mkfs.btrfs looks at is
> /sys/block/<whatever-device>/queue/rotational, if that is 1 it knows
> that the device isn't a SSD.  I believe that LVM passes through whatever
> the next lower layer's value is, but dmcrypt (and by extension LUKS)
> always force it to a 1 (possibly to prevent programs from using
> heuristics for enabling discard)

In the current "running condition", the system clearly sees this is *not* 
rotational, even thru the LVM/dmcrypt stack :

# mount | grep btrfs
/dev/mapper/VG-LINUX on / type btrfs 
(rw,noatime,seclabel,compress=lzo,ssd,discard,space_cache,autodefrag)

# ll /dev/mapper/VGV-LINUX
lrwxrwxrwx. 1 root root 7 16 juin  09:21 /dev/mapper/VG-LINUX -> ../dm-1

# cat /sys/block/dm-1/queue/rotational 
0

...However, at mkfs.btrfs time, it migth well not have seen it, as I made it 
from a live USB key in which both the lvm.conf and crypttab had not been 
taylored to allow "trim" commands...

However, now that the FS is created, I still wonder whether I should use a 
rebalance to change the metadata from DUP to SINGLE, or if Id' better stay 
with DUP...

Kind regards.


-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

