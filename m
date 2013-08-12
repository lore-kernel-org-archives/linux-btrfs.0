Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54501 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3HLSMW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 14:12:22 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C21A57C067C
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 12:12:21 -0600 (MDT)
Date: Mon, 12 Aug 2013 14:12:19 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Josef Bacik <jbacik@fusionio.com>, Emil Karlson <jekarlson@gmail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible bug in send/receive with simple reproducer
Message-ID: <20130812181219.GD2150@localhost.localdomain>
References: <CAELSAVaZNofc+g8jgvbkiL7dmzv9jiFtYtNxDR1+UkLZyaCMmg@mail.gmail.com>
 <20130812145952.GC2150@localhost.localdomain>
 <5208FC34.4080705@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5208FC34.4080705@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 12, 2013 at 05:16:04PM +0200, Stefan Behrens wrote:
> On Mon, 12 Aug 2013 10:59:52 -0400, Josef Bacik wrote:
> > On Sun, Aug 11, 2013 at 09:53:01PM +0300, Emil Karlson wrote:
> >> Greetings
> >>
> >> Send fails for me unexpectedly:
> >>
> >> I get:
> >> ERROR: rename o262-5-0 -> snapshots failed. No such file or directory
> >>
> >> reproducer ( http://users.tkk.fi/~jkarlson/files/test4.txt  ):
> >>
> >> for i in 1 2; do
> >>   mkdir /mnt/$i
> >>   truncate -s 4G /mnt/$i.img
> >>   mkfs.btrfs /mnt/$i.img
> >>   mount -o loop /mnt/$i.img /mnt/$i
> >> done
> >>
> >> mkdir /mnt/1/testdir
> >> mkdir /mnt/1/testdir/1/
> >> mkdir /mnt/1/testdir/2/
> >> dd if=/dev/urandom  of=/mnt/1/testdir/aa count=16
> >> dd if=/dev/urandom  of=/mnt/1/testdir/bb count=16
> >>
> >> mkdir /mnt/1/snapshots
> >> btrfs sub snap -r /mnt/1/ /mnt/1/snapshots/backup2
> >> btrfs sub snap -r /mnt/1/ /mnt/1/snapshots/backup3
> >> btrfs send /mnt/1/snapshots/backup3/ | btrfs receive /mnt/2/
> >>
> >> umount /mnt/{1,2}; rm /mnt/{1,2}.img; rmdir /mnt/{1,2}
> > 
> > This was perfect, thank you for that.  I've posted a fix and I'll turn this into
> > an xfstest to make sure we don't ever regress.  Thanks again,
> >
> 
> If you create a subvolume below /mnt/[12] and run the test there, you
> have the problem reproduced again :)
> 

Yeah I noticed this problem when I converted it over to an xfstest, forgot that
I'm an idiot.  Trying to figure out a less braindead way to fix this.  Thanks,

Josef
