Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23024 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753715AbaDJXfy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 19:35:54 -0400
Message-ID: <53472AEB.7030004@fb.com>
Date: Thu, 10 Apr 2014 19:36:11 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: <fengguang.wu@intel.com>, <kbuild-all@01.org>
Subject: Re: [PATCH v4 2/2] Btrfs: scrub raid56 stripes in the right way
References: <1396955932-4547-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1396955932-4547-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/08/2014 07:18 AM, Wang Shilong wrote:
> Steps to reproduce:
>   # mkfs.btrfs -f /dev/sda[8-11] -m raid5 -d raid5
>   # mount /dev/sda8 /mnt
>   # btrfs scrub start -BR /mnt
>   # echo $? <--unverified errors make return value be 3
>
> This is because we don't setup right mapping between physical
> and logical address for raid56, which makes checksum mismatch.
> But we will find everthing is fine later when rechecking using
> btrfs_map_block().
>
> This patch fixed the problem by settuping right mappings and
> we only verify data stripes' checksums.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
> v3->v4: fix compile warnings on avr32 platform.(reported by 0-day LKP)

Can you please send this as an incremental?  I'd rather not rebase the 
integration branch right now.

Thanks!

-chris
