Return-Path: <SRS0=2FmH=P5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EF6C7113B
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 12:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DA182084A
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 12:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbfAUMZu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 07:25:50 -0500
Received: from bang.steev.me.uk ([81.2.120.65]:56807 "EHLO smtp.steev.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727926AbfAUMZu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 07:25:50 -0500
X-Greylist: delayed 1777 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2019 07:25:50 EST
Received: from localhost ([::1] helo=webmail.steev.me.uk)
        by smtp.steev.me.uk with esmtp (Exim 4.91)
        id 1glYBY-0001mE-6N
        for linux-btrfs@vger.kernel.org; Mon, 21 Jan 2019 11:56:12 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Jan 2019 11:56:12 +0000
From:   Steven Davies <btrfs-list@steev.me.uk>
To:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs: add read_mirror_policy parameter devid
In-Reply-To: <20180516100359.7752-3-anand.jain@oracle.com>
References: <20180516100359.7752-1-anand.jain@oracle.com>
 <20180516100359.7752-3-anand.jain@oracle.com>
Message-ID: <443d1af2948306c1f776baaa227272ae@steev.me.uk>
X-Sender: btrfs-list@steev.me.uk
User-Agent: Roundcube Webmail/1.3.8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-05-16 11:03, Anand Jain wrote:

Going back to an old patchset I was testing this weekend:

> Adds the mount option:
>   mount -o read_mirror_policy=<devid>
> 
> To set the devid of the device which should be used for read. That
> means all the normal reads will go to that particular device only.
> 
> This also helps testing and gives a better control for the test
> scripts including mount context reads.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-By: Steven Davies <btrfs-list@steev.me.uk>

> ---
>  fs/btrfs/super.c   | 21 +++++++++++++++++++++
>  fs/btrfs/volumes.c | 10 ++++++++++
>  fs/btrfs/volumes.h |  2 ++
>  3 files changed, 33 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 21eff0ac1e4f..7ddecf4178a6 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -852,6 +852,27 @@ int btrfs_parse_options(struct btrfs_fs_info
> *info, char *options,
>  					BTRFS_READ_MIRROR_BY_PID;
>  				break;
>  			}
> +
> +			intarg = 0;
> +			if (match_int(&args[0], &intarg) == 0) {
> +				struct btrfs_device *device;
> +
> +				device = btrfs_find_device(info, intarg,
> +							   NULL, NULL);
> +				if (!device) {
> +					btrfs_err(info,
> +					  "read_mirror_policy: invalid devid %d",
> +					  intarg);
> +					ret = -EINVAL;
> +					goto out;
> +				}
> +				info->read_mirror_policy =
> +						BTRFS_READ_MIRROR_BY_DEV;
> +				set_bit(BTRFS_DEV_STATE_READ_MIRROR,
> +					&device->dev_state);

Not an expert, but might this be overwritten with another state? e.g. 
BTRFS_DEV_STATE_REPLACE_TGT. The device would then lose its READ_MIRROR 
flag and the fs would always use the first device for reading.

> +				break;
> +			}

I noticed that it's possible to pass this option multiple times at 
mount, which sets multiple devices as read mirrors. While that doesn't 
do anything harmful, the code below will only use the first device. It 
may be worth at least mentioning this in documentation.

> +
>  			ret = -EINVAL;
>  			goto out;
>  		case Opt_err:
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 64dba5c4cf33..3a9c3804ff17 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5220,6 +5220,16 @@ static int find_live_mirror(struct
> btrfs_fs_info *fs_info,
>  		num_stripes = map->num_stripes;
> 
>  	switch(fs_info->read_mirror_policy) {
> +	case BTRFS_READ_MIRROR_BY_DEV:
> +		preferred_mirror = first;
> +		if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
> +			     &map->stripes[preferred_mirror].dev->dev_state))
> +			break;
> +		if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
> +			     &map->stripes[++preferred_mirror].dev->dev_state))
> +			break;
> +		preferred_mirror = first;

Why set preferred_mirror again? The only effect of re-setting it will be 
to use the lowest devid (1) rather than the highest (2). Is there any 
difference? Either way it should never happen, because the above code 
traps it (except when the BTRFS_DEV_STATE_READ_MIRROR flag has been 
changed as mentioned above).

 From Goffredo's comment[1] on Timofey's similar effect patch, if it 
becomes possible to have more mirrors in a RAID1/RAID10 fs then this 
code will need to be updated to test dev_state for more than two 
devices. Would it be sensible to implement this as a for loop straight 
away?

> +		break;
>  	case BTRFS_READ_MIRROR_DEFAULT:
>  	case BTRFS_READ_MIRROR_BY_PID:
>  	default:
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 953df9925832..55b2eebbf183 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -37,6 +37,7 @@ struct btrfs_pending_bios {
>  enum btrfs_read_mirror_type {
>  	BTRFS_READ_MIRROR_DEFAULT,
>  	BTRFS_READ_MIRROR_BY_PID,
> +	BTRFS_READ_MIRROR_BY_DEV,
>  };
> 
>  #define BTRFS_DEV_STATE_WRITEABLE	(0)
> @@ -44,6 +45,7 @@ enum btrfs_read_mirror_type {
>  #define BTRFS_DEV_STATE_MISSING		(2)
>  #define BTRFS_DEV_STATE_REPLACE_TGT	(3)
>  #define BTRFS_DEV_STATE_FLUSH_SENT	(4)
> +#define BTRFS_DEV_STATE_READ_MIRROR	(5)
> 
>  struct btrfs_device {
>  	struct list_head dev_list;

Happy to add Tested-By on patch 1/3 too, but I haven't looked at 3/3 
yet.

[1]: https://patchwork.kernel.org/patch/10678531/#22315779

-- 
Steven Davies
