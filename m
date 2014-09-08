Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:45552 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaIHJpQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 05:45:16 -0400
Message-ID: <1410169197.2383.3.camel@daevel.fr>
Subject: Re: Linux 3.14.18 : kernel BUG at fs/btrfs/file.c:890!
From: Olivier Bonvalet <btrfs.list@daevel.fr>
To: Holger =?ISO-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 08 Sep 2014 11:39:57 +0200
In-Reply-To: <pan.2014.09.07.17.48.53@googlemail.com>
References: <1410107980.2832.41.camel@localhost>
	 <pan.2014.09.07.17.48.53@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Le dimanche 07 septembre 2014 à 17:48 +0000, Holger Hoffstätte a écrit :
> On Sun, 07 Sep 2014 18:39:40 +0200, Olivier Bonvalet wrote:
>
> I cannot really offer much assistance, but that particular area of code
> looks suspiciously like something fixed later and *not* yet backported
> to 3.14.8:
> 
> "Btrfs: fix leaf corruption caused by ENOSPC while hole punching"
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/btrfs?id=fc19c5e73645f95d3eca12b4e91e7b56faf1e4a4
> 
> The symptoms described in the patch sound like they might be your OOPS.
> Unfortunately (I think) that would mean that just installing different
> kernels will not fix the problem, since the problem is on disk. :/
> 
> So to me it seems your best course of action is to backup/mkfs/restore
> the affected partition and stick with 3.17-rc3, since that has tons
> more fixes.
> 
> If you really need/want 3.14.x and are not afraid of building your
> own kernel, you can try applying my btrfs-* patches from:
> https://github.com/hhoffstaette/kernel-patches/tree/master/3.14
> which apply cleanly to the latest 3.14.18-stable.
> 
> However even that will not fix a bungled tree on disk.
> 
> -h
> 
> --

Ok, so the cause is probably solved, this is a very good news, thanks.
And yes, I can easily use 3.17-rc3 kernel.

So the problem is with current data : I don't know an easy way to
export/restore subvolumes & snapshots thought network, and I don't have
physical access to this rent servers.

Any hope that btrfsck be updated to fix that ?

Olivier

