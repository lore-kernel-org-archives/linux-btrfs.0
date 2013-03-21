Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:58050 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab3CUN1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 09:27:11 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: =?utf-8?q?Fr=C3=A9d=C3=A9ric_COIFFIER?= <frederic.coiffier@free.fr>
Subject: Re: How to recover uncorrectable errors ?
Date: Thu, 21 Mar 2013 14:27:08 +0100
Cc: linux-btrfs@vger.kernel.org
References: <6033676.gK0GbPgrpE@athlonxp> <201303201959.54969.Martin@lichtvoll.de> <1380005.JyAIHqx6kZ@athlonxp> (sfid-20130321_141413_820672_B26E5E96)
In-Reply-To: <1380005.JyAIHqx6kZ@athlonxp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303211427.09220.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 21. März 2013 schrieb Frédéric COIFFIER:
> Hi Martin,
> 
> Le mercredi 20 mars 2013 19:59:54 Martin Steigerwald a écrit :
> > Am Mittwoch, 20. März 2013 schrieb Frédéric COIFFIER:
> > > > But I really think BTRFS displays the filename affected meanwhile. So
> > > > maybe if it does not, its some metadata being affected? So output of btrfsck
> > > > hints at that and that you can´t remove the file does as well. What happens
> > > > if you try to remove the file? Do you get an input/output error or
> > > > something like that?
> > > 
> > > # rm -rf *
> > > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > > rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> > > ...
> > 
> > You are trying to remove the files from an NFS client. Stale NFS file
> > handle just means that the NFS handle is no longer valid.
> 
> Absolutely not. I'm not using NFS and I try to remove the files locally.
> It seems that btrfs returns a strange ESTALE errno...
> 
> grep -rsn ESTALE fs/btrfs/
> fs/btrfs/inode.c:2412:          if (ret && ret != -ESTALE)
> fs/btrfs/inode.c:2415:          if (ret == -ESTALE && root == root->fs_info->tree_root) {
> fs/btrfs/inode.c:2451:          if (ret == -ESTALE) {
> fs/btrfs/inode.c:4273:                  inode = ERR_PTR(-ESTALE);
> fs/btrfs/export.c:71:           return ERR_PTR(-ESTALE);
> fs/btrfs/export.c:104:          return ERR_PTR(-ESTALE);
> 
> This error seems to be common (even if I can't see any recent reports) :
> http://www.google.fr/search?q=btrfs+Stale+NFS+file+handle

Thanks for notice. Well I thought one can take the error message literally.
I only ever saw it with NFS and its also NFS in the error message. I think
the error message is at least misleading.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
