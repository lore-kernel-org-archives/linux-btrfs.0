Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34357 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3K2FvX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 00:51:23 -0500
Message-ID: <52982B4C.2070507@cn.fujitsu.com>
Date: Fri, 29 Nov 2013 13:51:08 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: 2 errors when scrubbing - but I don't know what they mean
References: <5297A950.3020100@informatik.uni-bonn.de>
In-Reply-To: <5297A950.3020100@informatik.uni-bonn.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 11/29/2013 04:36 AM, Sebastian Ochmann wrote:
> Hello everyone,
>
> when I scrubbed one of my btrfs volumes today, the result of the scrub 
> was:
>
> total bytes scrubbed: 1.27TB with 2 errors
> error details: super=2
> corrected errors: 0, uncorrectable errors: 0, unverified errors: 0
Here super error means superblock checksum mismatch,scrub just report
superblock errors but dosen't try to fix it....

Maybe this is just a read error, anyway, superblocks will be rewritten 
after commiting
a transaction..

Thanks,
Wang
>
> and dmesg said:
>
> btrfs: bdev /dev/mapper/tray errs: wr 0, rd 0, flush 0, corrupt 0, gen 1
> btrfs: bdev /dev/mapper/tray errs: wr 0, rd 0, flush 0, corrupt 0, gen 2
>
> Can someone please enlighten me what these errors mean (especially the 
> "super" and "gen" values)? As an additional info: The drive is 
> sometimes used in a machine with kernel 3.11.6 and sometimes with 
> 3.12.0, could this swapping explain the problem somehow?
>
> Best regards
> Sebastian
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

