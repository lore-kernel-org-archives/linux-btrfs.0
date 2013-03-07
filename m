Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57944 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab3CGPkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 10:40:05 -0500
Message-ID: <5138B4D1.8070208@petaramesh.org>
Date: Thu, 07 Mar 2013 16:40:01 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, Eric Sandeen <sandeen@redhat.com>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>,
        "Anand.Jain@oracle.com" <Anand.Jain@oracle.com>
Subject: Re: mkfs.btrfs broken
References: <513883DD.8080203@petaramesh.org> <5138980C.8080000@redhat.com> <5138ADA6.5070101@petaramesh.org> <5138AE96.3020304@redhat.com> <5138B08F.70607@petaramesh.org> <20130307153507.GA5784@shiny.masoncoding.com>
In-Reply-To: <20130307153507.GA5784@shiny.masoncoding.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 07/03/2013 16:35, Chris Mason a écrit :
> Could you please send the contents of /proc/mounts
Here it goes !

(Last line is the USB key I dropped in just for taking a copy of
/proc/mounts ; it didn't exist at the time the errors occured...)

rootfs / rootfs rw 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
devtmpfs /dev devtmpfs
rw,relatime,size=990948k,nr_inodes=170721,mode=755 0 0
tmpfs /run tmpfs rw,relatime 0 0
devpts /dev/pts devpts rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
/dev/loop2 /br_sqfs squashfs ro,relatime 0 0
aufs / aufs rw,relatime,si=6434ca9 0 0
tmpfs /tmp tmpfs rw,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
/dev/sdc1 /media/sdc1 vfat
rw,relatime,fmask=0022,dmask=0022,codepage=cp437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro
0 0

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

