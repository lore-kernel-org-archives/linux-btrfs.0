Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33849 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933892Ab3BLTDG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 14:03:06 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A57397C041F
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 12:03:05 -0700 (MST)
Date: Tue, 12 Feb 2013 14:02:58 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: "Richard W.M. Jones" <rjones@redhat.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What can I do to make btrfs work?
Message-ID: <20130212190258.GH16687@shiny.masoncoding.com>
References: <20130212185449.GA16773@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130212185449.GA16773@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 12, 2013 at 11:54:49AM -0700, Richard W.M. Jones wrote:
> Btrfs has been broken for me for ages.  I first reported it on this
> list 5 months ago[1].  Below is a very simple reproducer that anyone
> can run.
> 
> *NB* before you run this, adjust /dev/sda & /dev/sda1 to point to an
> unused block device!
> 
> ----------------------------------------------------------------------
> #!/bin/sh -
> set -e
> while true; do
>   parted -s -- /dev/sda mklabel msdos
>   parted -s -- /dev/sda mkpart primary 64s -64s
>   wipefs -a /dev/sda1
>   mkfs.btrfs --label TEST /dev/sda1
>   mount /dev/sda1 /sysroot
>   touch /sysroot/foo
>   mkdir /sysroot/bar
>   umount /sysroot
> done
> ----------------------------------------------------------------------
> 
> On the latest 3.8.0 kernel, this fails immediately (at the mount), and
> on 3.7.x it usually fails after a very few iterations.  I see a
> variety of errors, but the latest kernel error is:
> 
> [    8.474934] device label ROOT devid 1 transid 2 /dev/sda2
> [    8.570619] device label ROOT devid 1 transid 2 /dev/sda2
> [    8.581891] btrfs: disk space caching is enabled
> [    8.594146] btrfs bad tree block start 0 4194304
> [    8.595144] btrfs: failed to read tree root on sda2
> [    8.605308] btrfs: open_ctree failed
> 
> I would really like btrfs to work.  What can I do?

Hi Rich,

Can you try the btrfs-progs raid56-experimental branch.  It has this
patch which was fixing things for me:

https://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=commit;h=8fe354744cd7b5c4f7a3314dcdbb5095192a032f

I'm not 100% sure I've reproduced your exact problem, but I hope this is
it.

-chris
