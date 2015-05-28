Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15361 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750812AbbE1CtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 May 2015 22:49:09 -0400
Message-ID: <55668222.8060707@cn.fujitsu.com>
Date: Thu, 28 May 2015 10:49:06 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Tobias Holst <tobby@tobby.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Uncorrectable errors on RAID6
References: <CAGwxe4h5ubG1SptGLH9STNvDaghQJwbUXEDTa_UHREXye9nPsA@mail.gmail.com>
In-Reply-To: <CAGwxe4h5ubG1SptGLH9STNvDaghQJwbUXEDTa_UHREXye9nPsA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Uncorrectable errors on RAID6
From: Tobias Holst <tobby@tobby.eu>
To: linux-btrfs@vger.kernel.org <linux-btrfs@vger.kernel.org>
Date: 2015年05月28日 10:18

> Hi
>
> I am doing a scrub on my 6-drive btrfs RAID6. Last time it found zero
> errors, but now I am getting this in my log:
>
> [ 6610.888020] BTRFS: checksum error at logical 478232346624 on dev
> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
> [ 6610.888025] BTRFS: checksum error at logical 478232346624 on dev
> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
> [ 6610.888029] BTRFS: bdev /dev/dm-2 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
> [ 6611.271334] BTRFS: unable to fixup (regular) error at logical
> 478232346624 on dev /dev/dm-2
> [ 6611.831370] BTRFS: checksum error at logical 478232346624 on dev
> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
> [ 6611.831373] BTRFS: checksum error at logical 478232346624 on dev
> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
> [ 6611.831375] BTRFS: bdev /dev/dm-2 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
> [ 6612.396402] BTRFS: unable to fixup (regular) error at logical
> 478232346624 on dev /dev/dm-2
> [ 6904.027456] BTRFS: checksum error at logical 478232346624 on dev
> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
> [ 6904.027460] BTRFS: checksum error at logical 478232346624 on dev
> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
> [ 6904.027463] BTRFS: bdev /dev/dm-2 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
>
> Looks like it is always the same sector.
>
> "btrfs balance status" shows me:
> scrub status for a34ce68b-bb9f-49f0-91fe-21a924ef11ae
>          scrub started at Thu May 28 02:25:31 2015, running for 6759 seconds
>          total bytes scrubbed: 448.87GiB with 14 errors
>          error details: read=8 csum=6
>          corrected errors: 3, uncorrectable errors: 11, unverified errors: 0
>
> What does it mean and why are these erros uncorrectable even on a RAID6?
> Can I find out, which files are affected?
If it's OK for you to put the fs offline,
btrfsck is the best method to check what happens, although it may take a 
long time.

There is a known bug that replace can cause checksum error, found by 
Zhao Lei.
So did you run replace while there is still some other disk I/O happens?

Thanks,
Qu
>
> system: Ubuntu 14.04.2
> kernel version 4.0.4
> btrfs-tools version: 4.0
>
> Regards
> Tobias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
