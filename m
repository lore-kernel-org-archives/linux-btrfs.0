Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32060 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaJGCFu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Oct 2014 22:05:50 -0400
Date: Tue, 7 Oct 2014 10:05:39 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Rich Rauenzahn <rrauenza@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Two uncorrectable errors across RAID1 at same logical block?
Message-ID: <20141007020538.GA3187@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAG+QAKVPcJPVL-mRsnG0m1NQCRrwaUbYDqKXBCjOnH_5A0ifHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG+QAKVPcJPVL-mRsnG0m1NQCRrwaUbYDqKXBCjOnH_5A0ifHg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 06, 2014 at 10:06:52AM -0700, Rich Rauenzahn wrote:
> This fs is across two ssd drives.  Am I interpreting this right that the
> same logical block is corrupt on both drives?  That seems odd.
> 

Yes, they both corrupt somehow.

> How do I map it to a filename?

You may try "btrfs inspect-internal logical-resolve 58464632832 /your_btrfs_mnt"

thanks,
-liubo

> 
> $ sudo dmesg --clear
> 
> $ dmesg
> 
> $ sudo btrfs scrub start -B /
> scrub done for
> 35f0ce3f-0902-47a3-8ad8-86179d1f3e3a
>         scrub started at Mon Oct  6 09:51:01 2014 and finished after 325 seconds
>         total bytes scrubbed: 114.89GiB with 2 errors
>         error details: csum=2
>         corrected errors: 0, uncorrectable errors: 2, unverified errors: 0
> 
> $ dmesg
>  btrfs: bdev /dev/sdg3 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
>  btrfs: unable to fixup (regular) error at logical 58464632832 on dev /dev/sdg3
>  btrfs: bdev /dev/sdf3 errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
>  btrfs: unable to fixup (regular) error at logical 58464632832 on dev /dev/sdf3
> 
> $ uname -a
> Linux hostname 3.10.0-123.8.1.el7.x86_64 #1 SMP Mon Sep 22 19:06:58
> UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> 
> $ btrfs --version
> Btrfs v3.12
> 
> $ btrfs fi show
> Btrfs v3.12
> 
> $ btrfs fi df /
> Data, RAID1: total=107.07GiB, used=55.47GiB
> System, RAID1: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=4.00GiB, used=2.04GiB
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
