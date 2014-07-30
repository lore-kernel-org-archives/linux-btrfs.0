Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:39235 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750949AbaG3XME (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 19:12:04 -0400
Message-ID: <53D97932.8010505@nuclearwinter.com>
Date: Wed, 30 Jul 2014 18:01:06 -0500
From: Larkin Lowrey <llowrey@nuclearwinter.com>
MIME-Version: 1.0
To: dptrash@arcor.de, linux-bcache@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs on bcache
References: <1368165877.1162129.1406757898943.JavaMail.ngmail@webmail06.arcor-online.net>
In-Reply-To: <1368165877.1162129.1406757898943.JavaMail.ngmail@webmail06.arcor-online.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been running two backup servers, with 25T and 20T of data, using
btrfs on bcache (writeback) for about 7 months. I periodically run btrfs
scrubs and backup verifies (SHA1 hashes) and have never had a corruption
issue.

My use of btrfs is simple, though, with no subvolumes and no btrfs level
raid. My bcache backing devices are LVM volumes that span multiple md
raid6 arrays. So, either the bug has been fixed or my configuration is
not susceptible.

I'm running kernel 3.15.5-200.fc20.x86_64.

--Larkin

On 7/30/2014 5:04 PM, dptrash@arcor.de wrote:
> Concerning http://thread.gmane.org/gmane.comp.file-systems.btrfs/31018, does this "bug" still exists?
>
> Kernel 3.14
> B: 2x HDD 1 TB
> C: 1x SSD 256 GB
>
> # make-bcache -B /dev/sda /dev/sdb -C /dev/sdc --cache_replacement_policy=lru
> # mkfs.btrfs -d raid1 -m raid1 -L "BTRFS_RAID" /dev/bcache0 /dev/bcache1
>
> I still have no "incomplete page write" messages in "dmesg | grep btrfs" and the checksums of some manually reviewed files are okay.
>
> Who has more experiences about this?
>
> Thanks,
>
> - dp
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

