Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55892 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2JOL6s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 07:58:48 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][V1][BTRFS-PROGS] Replace the units from KB to KiB..
Date: Mon, 15 Oct 2012 13:58:46 +0200
Cc: Goffredo Baroncelli <kreijack@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        Chris Mason <chris.mason@fusionio.com>, David Sterba <dave@jikos.cz>
References: <1350156436-14439-1-git-send-email-kreijack@gmail.com> (sfid-20121014_015034_115476_F3498551)
In-Reply-To: <1350156436-14439-1-git-send-email-kreijack@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210151358.46677.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 13. Oktober 2012 schrieb Goffredo Baroncelli:
> Hi All,
> 
> several people asked to update the units showed by the "btrfs" tool
> form the SI ones (KB, MB, GB...) to the IEC ones (KiB, MiB...).
> 
> The aim of this patch is to allow the user to choice which units
> are showed. Depending by the BTRFS_UNIT environmental variable,
> the following units are showed:
> 
>     BTRFS_UNIT=SI the suffix is KB for 1000bytes, MB for 10^6 bytes...
>     BTRFS_UNIT=IEC the suffix is KiB for 1024bytes, MiB for 1024 KiB ...
>     BTRFS_UNIT=COMPACT the suffix is KB for 1024 bytes, MB for 1024 KiB;
>                        no space between the number and the suffix.
> 
> BR
> G.Baroncelli

What base does this build upon?

I tried to apply upon your disk_free branch, but got:

martin@merkaba:~/Linux/Dateisysteme/BTRFS/btrfs-progs-unstable> patch -p1 < ../\[PATCH\]\[V1\]\[BTRFS-PROGS\]\ Replace\ the\ units\ from\ KB\ to\ KiB...mbox
patching file utils.c
Hunk #1 FAILED at 1085.
1 out of 1 hunk FAILED -- saving rejects to file utils.c.rej
patching file cmds-filesystem.c
Hunk #1 succeeded at 366 (offset 164 lines).
patching file cmds-scrub.c
patching file man/btrfs.8.in
Hunk #1 succeeded at 424 (offset 69 lines).

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
