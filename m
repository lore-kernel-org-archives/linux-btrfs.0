Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45983 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751393AbdJBTfW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 15:35:22 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dz6Ui-0005zS-KN
        for linux-btrfs@vger.kernel.org; Mon, 02 Oct 2017 21:35:12 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Why do full balance and deduplication reduce available free
 space?
Date: Mon, 2 Oct 2017 21:35:09 +0200
Message-ID: <20171002213509.50a68609@jupiter.sol.kaishome.de>
References: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 02 Oct 2017 12:02:16 +0200
schrieb Niccolò Belli <darkbasic@linuxsystems.it>:

> This is how I performe balance: btrfs balance start --full-balance
> rootfs This is how I perform deduplication (duperemove is from git
> master): duperemove -drh --dedupe-options=noblock
> --hashfile=../rootfs.hash <all_subvols_except_snapshots_ones>

Besides defragging removing the reflinks, duperemove will unshare your
snapshots when used in this way: If it sees duplicate blocks within the
subvolumes you give it, it will potentially unshare blocks from the
snapshots while rewriting extents.

BTW, you should be able to use duperemove with read-only snapshots if
used in read-only-open mode. But I'd rather suggest to use bees
instead: It works at whole-volume level, walking extents instead of
files. That way it is much faster, doesn't reprocess already
deduplicated extents, and it works with read-only snapshots.

Until my patch it didn't like mixed nodatasum/datasum workloads.
Currently this is fixed by just leaving nocow data alone as users
probably set nocow for exactly the reason to not fragment extents and
relocate blocks.


-- 
Regards,
Kai

Replies to list-only preferred.


