Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:37478 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3EFAjA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 20:39:00 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9883D7C067C
	for <linux-btrfs@vger.kernel.org>; Sun,  5 May 2013 18:39:00 -0600 (MDT)
Date: Sun, 5 May 2013 20:38:57 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug at extent-tree.c:5446
Message-ID: <20130506003857.GG12414@localhost.localdomain>
References: <CAAr69zaPjT=yez5FbHYd8JdieuQS9e9-EE4N-u0HkfLKU2yQpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAAr69zaPjT=yez5FbHYd8JdieuQS9e9-EE4N-u0HkfLKU2yQpg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 05, 2013 at 01:16:27PM -0600, Szőts Ákos wrote:
> Dear list members,
> 
> When I tried to recover my partition from the space cache bug (see
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24360.html
> ), I issued the command `mount -o clear_cache -t btrfs /dev/sda7
> /aaa/aaa`. After 10 minutes the mount command segfaulted. I cloned the
> latest btrfs-progs from Josef's Github account and ran the `btrfsck
> --repair` twice on the partition.
> 
> Then I tried to mount under my normal openSUSE system (with kernel
> 3.9) and the following BUG appeared during the boot-up process: Kernel
> bug at extent-tree.c:5446
> The picture I've taken: www.morrohun.hu/temp/btrfs/IMG_1770.JPG
> 
> I tried to boot in an openSUSE Rescue CD, an Ubuntu Live CD, but just
> a SystemRescueCD was actually working, but I can't reach my partition.
> Even though I was able to make an image by `btrfs-image -c9 -t8` and
> I'll send you the link if it's requested.
> 

I'd like to see the image and can you file a bug at bugzilla.kernel.org so I
don't lose track of this issue?  Make sure the component is set to Btrfs.
Thanks,

Josef
