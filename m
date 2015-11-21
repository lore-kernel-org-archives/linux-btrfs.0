Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:48302 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759652AbbKUBIV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 20:08:21 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
From: Lukas Pirl <btrfs@lukas-pirl.de>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <564FC3FE.9020905@lukas-pirl.de>
Date: Sat, 21 Nov 2015 14:08:14 +1300
MIME-Version: 1.0
In-Reply-To: <564FBF0F.4050705@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2015 01:47 PM, Qu Wenruo wrote as excerpted:
> Hard to say, but we'd better keep an eye on this issue.
> At least, if it happens again, we should know if it's related to
> something like newer kernel or snapshots.

I can confirm the initially describe behavior of "btrfs check" and
reading the data works fine also.

Versions etc.:

$ uname -a
Linux 4.2.0-0.bpo.1-amd64 #1 SMP Debian 4.2.6-1~bpo8+1 …
$ btrfs filesystem show /mnt/data
Label: none  uuid: 5be372f5-5492-4f4b-b641-c14f4ad8ae23
        Total devices 6 FS bytes used 2.87TiB
        devid    1 size 931.51GiB used 636.00GiB path /dev/mapper/…SZ
        devid    2 size 931.51GiB used 634.03GiB path /dev/mapper/…03
        devid    3 size 1.82TiB used 1.53TiB path /dev/mapper/…76
        devid    4 size 1.82TiB used 1.53TiB path /dev/mapper/…78
        devid    6 size 1.82TiB used 1.05TiB path /dev/mapper/…UK
        *** Some devices missing

btrfs-progs v4.3

$ btrfs subvolume list /mnt/data | wc -l
62

Best,

Lukas
