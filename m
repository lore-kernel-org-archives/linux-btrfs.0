Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45768 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461Ab3CUIgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 04:36:10 -0400
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= COIFFIER <frederic.coiffier@free.fr>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to recover uncorrectable errors ?
Date: Thu, 21 Mar 2013 09:36 +0100
Message-ID: <1380005.JyAIHqx6kZ@athlonxp>
In-Reply-To: <201303201959.54969.Martin@lichtvoll.de>
References: <6033676.gK0GbPgrpE@athlonxp> <3160822.Hx5D6eTo7L@athlonxp> <201303201959.54969.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

Le mercredi 20 mars 2013 19:59:54 Martin Steigerwald a écrit :
> Am Mittwoch, 20. März 2013 schrieb Frédéric COIFFIER:
> > > But I really think BTRFS displays the filename affected meanwhile. So
> > > maybe if it does not, its some metadata being affected? So output of btrfsck
> > > hints at that and that you can´t remove the file does as well. What happens
> > > if you try to remove the file? Do you get an input/output error or
> > > something like that?
> > 
> > # rm -rf *
> > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > ...
> 
> You are trying to remove the files from an NFS client. Stale NFS file
> handle just means that the NFS handle is no longer valid.

Absolutely not. I'm not using NFS and I try to remove the files locally.
It seems that btrfs returns a strange ESTALE errno...

grep -rsn ESTALE fs/btrfs/
fs/btrfs/inode.c:2412:          if (ret && ret != -ESTALE)
fs/btrfs/inode.c:2415:          if (ret == -ESTALE && root == root->fs_info->tree_root) {
fs/btrfs/inode.c:2451:          if (ret == -ESTALE) {
fs/btrfs/inode.c:4273:                  inode = ERR_PTR(-ESTALE);
fs/btrfs/export.c:71:           return ERR_PTR(-ESTALE);
fs/btrfs/export.c:104:          return ERR_PTR(-ESTALE);

This error seems to be common (even if I can't see any recent reports) :
http://www.google.fr/search?q=btrfs+Stale+NFS+file+handle

Regards,
Frederic
