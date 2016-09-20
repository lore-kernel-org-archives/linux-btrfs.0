Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52550 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753014AbcITAuC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 20:50:02 -0400
Subject: Re: super-recover crashing because it found a bad superblock
To: hawken <hawken@thehawken.org>, <linux-btrfs@vger.kernel.org>
References: <dfe1eed9-2aac-a6b6-c681-93d74d4fd83d@thehawken.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d463e64d-6c7e-66a5-abb2-adfde57136b5@cn.fujitsu.com>
Date: Tue, 20 Sep 2016 08:49:54 +0800
MIME-Version: 1.0
In-Reply-To: <dfe1eed9-2aac-a6b6-c681-93d74d4fd83d@thehawken.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/20/2016 08:38 AM, hawken wrote:
> Hi!
>
> In super-recover.c, around line 96, check_super calls
> btrfs_super_csum_size, which then dies because the size was too big.
> I have solved this by reimplementing that stub inside super-recover.c
> with error handling rather than crashing:
>
> diff --git a/super-recover.c b/super-recover.c
> index adb2c44..2508e06 100644
> --- a/super-recover.c
> +++ b/super-recover.c
> @@ -93,7 +93,11 @@ void free_recover_superblock(struct
> btrfs_recover_superblock *recover)
>
>  static int check_super(u64 bytenr, struct btrfs_super_block *sb)
>  {
> -       int csum_size = btrfs_super_csum_size(sb);
> +       int t = btrfs_super_csum_type(sb);
> +       if(t >= ARRAY_SIZE(btrfs_csum_sizes))
> +               return 0;
> +       int csum_size = btrfs_csum_sizes[t];
> +
>         char result[csum_size];
>         u32 crc = ~(u32)0;

Oh, we have only fixed check_super() in disk_io.c, forgot this one.

We need to merge it with the one in disk_io.c, which checks super more 
comprehensively.

Nice one.

Thanks,
Qu
>
>
> (Sorry for bad formatting)
> This allowed me to recover my superblocks
>
> I found this bug kind of ironic because a routine made to discover bad
> data, crashed because it encountered bad data :D
>
> - hawken
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


