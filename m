Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41509 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab3FZPuG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 11:50:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Urryt-0001xy-MY
	for linux-btrfs@vger.kernel.org; Wed, 26 Jun 2013 17:50:04 +0200
Received: from bb0216e5.virtua.com.br ([bb0216e5.virtua.com.br])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 17:50:03 +0200
Received: from rodrigodc by bb0216e5.virtua.com.br with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 17:50:03 +0200
To: linux-btrfs@vger.kernel.org
From: Rodrigo Dias Cruz <rodrigodc@gmail.com>
Subject: Re: Filesystem 
Date: Wed, 26 Jun 2013 15:44:52 +0000 (UTC)
Message-ID: <loom.20130626T173801-308@post.gmane.org>
References: <loom.20130617T230152-537@post.gmane.org> <20130617212132.GA19183@localhost.localdomain> <CADn-QaOWq7BR0DXn_Xd5YRnDc2NZOBGCn_YfV2y1FjpBg4f_LQ@mail.gmail.com> <CADn-QaNS01CGtPJtr9yHkEU-TET7MrhCUbr1j4g3gYROvQ=K+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander Skwar <alexanders.mailinglists+nospam <at> gmail.com> writes:

> 
> Hi
> 
> On Mon, Jun 17, 2013 at 11:43 PM, Alexander Skwar
> <alexanders.mailinglists+nospam <at> gmail.com> wrote:
> > Hello Josef
> >
> > On Mon, Jun 17, 2013 at 11:21 PM, Josef Bacik <jbacik <at> fusionio.com> 
wrote:
> >
> >> Pull down my tree
> >>
> >> git://github.com/josefbacik/btrfs-progs.git
> >>
> >> and build and run the fsck in there and see if it's a bit more 
friendly.
> >
> > I just gave it a try, but wasn't successful, it seems… Kernel still
> > crashes.
> > Maybe checkout the screenphotos at http://goo.gl/DWkRH or
> > http://imgur.com/a/00pTx
> 
> Any other ideas, about what I might be able to do, to
> revive my btrfs filesystem?
> 


I had the very same problem some days ago.

I have not yet found out how to fix the broken btrfs filesystem. However, I 
have been able to recover all my files from the filesystem and copy them to 
a brand new ext4 filesystem, that I am using now.

To recover files from the broken btrfs filesystem, use the program "btrfs-
restore". For example, if the filesystem is on "/dev/sda1" and you want your 
files to be copied to the directory "/backup", then:

    $ btrfs-restore /dev/sda1 /backup

At the end, all your files should be found at the directory "/backup". If 
you wish, you can recreate the filesystem on "/dev/sda1" (using mkfs.btrfs 
or mkfs.ext4) and copy the files back to there.

Rodrigo.


