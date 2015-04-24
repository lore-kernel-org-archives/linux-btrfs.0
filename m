Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30592 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751298AbbDXAhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 20:37:39 -0400
Message-ID: <5539904F.4060605@cn.fujitsu.com>
Date: Fri, 24 Apr 2015 08:37:35 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <lukas.lueg@gmail.com>
Subject: Re: [PATCH] btrfs: Check superblock csum type to avoid 0 division
 or array overflow.
References: <1429752681-566-1-git-send-email-quwenruo@cn.fujitsu.com> <20150423161659.GL4996@twin.jikos.cz>
In-Reply-To: <20150423161659.GL4996@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH] btrfs: Check superblock csum type to avoid 0 
division or array overflow.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年04月24日 00:16

> On Thu, Apr 23, 2015 at 09:31:21AM +0800, Qu Wenruo wrote:
>> Current btrfs only support CRC32 checksum, and if csum_type is 1, we
>> will get 0 csum size, causing 0 division later destroy the whole kernel.
>> Or csum_type is later than 1, we will get data from other random memory
>> causing more problem.
>
> The check for csum type is already there in btrfs_check_super_csum, but
> it's wrong and should be fixed.
>
> btrfs_csum_sizes = { 4, 0 };
>
>   429         if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
>   430                 printk(KERN_ERR "BTRFS: unsupported checksum algorithm %u\n",
>   431                                 csum_type);
>   432                 ret = 1;
>   433         }
>   434
>
> and the check fails to catch csum_type == 1.
>
Thanks for pointing the existing codes, I'll update the patch.

Thanks,
Qu
