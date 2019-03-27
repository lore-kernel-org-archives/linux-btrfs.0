Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB37AC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 08:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0CF72075C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 08:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfC0IhK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 04:37:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:45338 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725786AbfC0IhK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 04:37:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DE067AC3D
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 08:37:06 +0000 (UTC)
Subject: Re: [PATCH URGENT 2/2] btrfs-progs: disk-io: Flush to ensure super
 block write is FUA
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190327072500.11156-1-wqu@suse.com>
 <20190327072500.11156-3-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <dbab7606-3327-2ccb-5383-885818218fee@suse.com>
Date:   Wed, 27 Mar 2019 10:37:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190327072500.11156-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 27.03.19 г. 9:25 ч., Qu Wenruo wrote:
> [BUG]
> There are tons of reports of btrfs-progs screwing up the fs, the most
> recent one is "btrfs check --clear-space-cache v1" triggered BUG_ON()
> and then leaving the fs with transid mismatch problem.
> 
> [CAUSE]
> In kernel, we have block layer handing the flush work, even on devices
> without FUA support (like most SATA device using default libata
> settings), kernel handles FUA write by flushing the device, then normal
> write, and finish it with another flush.
> 
> The pre-flush, write, post-flush works pretty well to implement FUA
> write.
> 
> However in btrfs-progs we just use pwrite(), there is nothing keeping
> the write order.

This could be expanded to include the following information:

1. The device fs is opened with only O_RD or O_RDWR i.e we don't pass
any special arguments when opening the fd.

2. We do not use fsync anywhere

> 
> So even for basic v1 free space cache clearing, we have different vision
> on the write sequence from kernel bio layer (by dm-log-writes) and user
> space pwrite() calls.
> 
> In btrfs-progs, with extra debug output in write_tree_block() and
> write_dev_supers(), we can see btrfs-progs follows the right write
> sequence:
> 
>   Opening filesystem to check...
>   Checking filesystem on /dev/mapper/log
>   UUID: 3feb3c8b-4eb3-42f3-8e9c-0af22dd58ecf
>   write tree block start=1708130304 gen=39
>   write tree block start=1708146688 gen=39
>   write tree block start=1708163072 gen=39
>   write super devid=1 gen=39
>   write tree block start=1708179456 gen=40
>   write tree block start=1708195840 gen=40
>   write super devid=1 gen=40
>   write tree block start=1708130304 gen=41
>   write tree block start=1708146688 gen=41
>   write tree block start=1708228608 gen=41
>   write super devid=1 gen=41
>   write tree block start=1708163072 gen=42
>   write tree block start=1708179456 gen=42
>   write super devid=1 gen=42
>   write tree block start=1708130304 gen=43
>   write tree block start=1708146688 gen=43
>   write super devid=1 gen=43
>   Free space cache cleared
> 
> But from dm-log-writes, the bio sequence is a different story:
> 
>   replaying 1742: sector 131072, size 4096, flags 0(NONE)
>   replaying 1743: sector 128, size 4096, flags 0(NONE) <<< Only one sb write
>   replaying 1744: sector 2828480, size 4096, flags 0(NONE)
>   replaying 1745: sector 2828488, size 4096, flags 0(NONE)
>   replaying 1746: sector 2828496, size 4096, flags 0(NONE)
>   replaying 1787: sector 2304120, size 4096, flags 0(NONE)
>   ......
>   replaying 1790: sector 2304144, size 4096, flags 0(NONE)
>   replaying 1791: sector 2304152, size 4096, flags 0(NONE)
>   replaying 1792: sector 0, size 0, flags 8(MARK)
> 
> During the free space cache clearing, we committed 3 transaction but
> dm-log-write only caught one super block write.
> 
> This means all the 3 writes were merged into the last super block write.
> And the super block write was the 2nd write, before all tree block
> writes, completely screwing up the metadata CoW protection.
> 
> No wonder crashed btrfs-progs can make things worse.
> 
> [FIX]
> Fix this super serious problem by implementing pre and post flush for
> the primary super block in btrfs-progs.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  disk-io.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 238b1821be14..275ccff965e2 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1585,6 +1585,16 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
>  	u32 crc;
>  	int i, ret;
>  
> +	/*
> +	 * We need to write super block after all metadata written.
> +	 * This is the equivalent of kernel pre-flush for FUA.
> +	 */
> +	ret = fsync(device->fd);
> +	if (ret < 0) {
> +		error("failed to flush: %m");
> +		ret = -errno;
> +		goto write_err;
> +	}
>  	if (fs_info->super_bytenr != BTRFS_SUPER_INFO_OFFSET) {
>  		btrfs_set_super_bytenr(sb, fs_info->super_bytenr);
>  		crc = ~(u32)0;
> @@ -1605,6 +1615,12 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
>  			error("failed to write super block: %m");
>  			goto write_err;
>  		}
> +		ret = fsync(device->fd);
> +		if (ret < 0) {
> +			error("failed to flush: %m");
> +			ret = -errno;
> +			goto write_err;
> +		}
>  		return 0;
>  	}
>  
> @@ -1632,6 +1648,18 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
>  			error("failed to write super block %i: %m", i);
>  			goto write_err;
>  		}
> +		/*
> +		 * Flush after the primary sb write, this is the equivalent of
> +		 * kernel post-flush for FUA write.
> +		 */
> +		if (i == 0) {
> +			ret = fsync(device->fd);
> +			if (ret < 0) {
> +				error("failed to flush: %m");
> +				ret = -errno;
> +				goto write_err;
> +			}
> +		}
>  	}
>  
>  	return 0;
> 
