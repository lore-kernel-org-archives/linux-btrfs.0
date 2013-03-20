Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:32815 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3CTTAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 15:00:00 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: =?utf-8?q?Fr=C3=A9d=C3=A9ric_COIFFIER?= <frederic.coiffier@free.fr>
Subject: Re: How to recover uncorrectable errors ?
Date: Wed, 20 Mar 2013 19:59:54 +0100
Cc: linux-btrfs@vger.kernel.org
References: <6033676.gK0GbPgrpE@athlonxp> <201303161916.55185.Martin@lichtvoll.de> <3160822.Hx5D6eTo7L@athlonxp> (sfid-20130320_195548_471593_E98D7A02)
In-Reply-To: <3160822.Hx5D6eTo7L@athlonxp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303201959.54969.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 20. März 2013 schrieb Frédéric COIFFIER:
> > But I really think BTRFS displays the filename affected meanwhile. So
> > maybe if it does not, its some metadata being affected? So output of btrfsck
> > hints at that and that you can´t remove the file does as well. What happens
> > if you try to remove the file? Do you get an input/output error or
> > something like that?
> 
> # rm -rf *
> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
> ...

You are trying to remove the files from an NFS client. Stale NFS file
handle just means that the NFS handle is no longer valid. NFS <v4
clients refer to file by a file handle composed of filesystem id and
inode number. Maybe a change in there?

Anyway, to find the real error message its necessary to try to delete
the files on the server. Cause even if there is a real BTRFS issue, the 
NFS client likely won´t report helpful error messages.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
