Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay01.libero.it ([212.52.84.101]:56619 "EHLO
	outrelay01.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab2FTMCg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 08:02:36 -0400
Message-ID: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost>
Date: Wed, 20 Jun 2012 14:02:22 +0200 (CEST)
From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
To: <hpa@zytor.com>, cwillu <cwillu@cwillu.com>
Subject: R: Re: Subvolumes and /proc/self/mountinfo
Cc: <helmut@hullen.de>, <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI all,

>----Messaggio originale----
>Da: hpa@zytor.com
>Data: 20/06/2012 5.22
>A: "cwillu"<cwillu@cwillu.com>
>Cc: <helmut@hullen.de>, <linux-btrfs@vger.kernel.org>
>Ogg: Re: Subvolumes and /proc/self/mountinfo
>

>
>The concept of what is the "root" and what is the "path" is
>straightforward for lesser filesystems: the root of the filesystem is
>defined by the root inode, and the path is a unique sequence of
>directories from that root.  Note that this is completely independent of
>how the filesystem was mounted when the boot loader was installed.

For the aim of the discussion, I would like to highlight a small difference 
between the path of the subvolume and the subvolume-id.
The latter is the specific subvolume, the former is a "functional" reference
to this subvolume.

For example, in my root btrfs I have two two subvolumes: __active (the root 
filesystem of my system) and (__rollback the last "good" copy)

If I swap (via a rename) __active and __rollback, in the next boot my system
uses a "good" copy of the root filesystem. This is a simple way to swap 
two subvolumes, without involving the boot logic

Instead if I had tracked the subvolume-id, to swap the root filesystem I 
would have update the boot logic.

I suspect that could exists other cases where it is preferable to track the 
subvolume-id instead the path. However what I would highlight it is the two
ways aren't equal.

BR
G.Baroncelli

