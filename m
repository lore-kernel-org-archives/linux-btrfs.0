Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:41860 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab3A1Lz6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 06:55:58 -0500
Message-ID: <5106674B.6020304@jan-o-sch.net>
Date: Mon, 28 Jan 2013 12:55:55 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Lev Vainblat <lev@zadarastorage.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Warnings on file removal after Quota exceeded error (EDQUOT)
References: <C53E5EC1712746DBA90EFED6D9BAEF52@LevPC>
In-Reply-To: <C53E5EC1712746DBA90EFED6D9BAEF52@LevPC>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Lev,

On 24.01.2013 10:39, Lev Vainblat wrote:
> I executed the following simple sequence of commands:
> 
> # mount /dev/sda /mnt/btrfs
> # btrfs quota enable /mnt/btrfs/
> # btrfs subvolume create /mnt/btrfs/SV
> Create subvolume '/mnt/btrfs/SV'
> # btrfs qgroup limit 1m /mnt/btrfs/SV
> # dd if=/dev/zero of=/mnt/btrfs/SV/file bs=64x1024
> dd: writing `/mnt/btrfs/SV/file': Disk quota exceeded
> 16+0 records in
> 15+0 records out
> 983040 bytes (983 kB) copied, 0.00192474 s, 511 MB/s
> # rm /mnt/btrfs/SV/file

Thanks for the simple reproducer.

Although you probably have noticed through the cc, I should mention in
case someone digs this thread out of an archive: I sent a patch that
should fix your problem some hours ago, subject "Btrfs: fix EDQUOT
handling in btrfs_delalloc_reserve_metadata". Feel free to test and
report back :-)

-Jan
