Return-Path: <SRS0=ure3=Z2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC21C43603
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Dec 2019 16:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E840C2081B
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Dec 2019 16:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfLDQHo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 11:07:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:54532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728149AbfLDQHo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Dec 2019 11:07:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D56C8AE2A;
        Wed,  4 Dec 2019 16:07:41 +0000 (UTC)
Date:   Wed, 4 Dec 2019 17:07:34 +0100
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 03/28] btrfs: Check and enable HMZONED mode
Message-ID: <20191204160734.GA3950@Johanness-MacBook-Pro.local>
References: <20191204081735.852438-1-naohiro.aota@wdc.com>
 <20191204081735.852438-4-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204081735.852438-4-naohiro.aota@wdc.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 04, 2019 at 05:17:10PM +0900, Naohiro Aota wrote:
> HMZONED mode cannot be used together with the RAID5/6 profile for now.
> Introduce the function btrfs_check_hmzoned_mode() to check this. This
> function will also check if HMZONED flag is enabled on the file system and
> if the file system consists of zoned devices with equal zone size.

I have a question, you wrote you check for a file system consisting of zoned
devices with equal zone size. What happens if you create a multi device file
system combining zoned and regular devices? Is this even supported and if no
where are the checks for it?

[...]

> +int btrfs_check_hmzoned_mode(struct btrfs_fs_info *fs_info)
> +{
> +	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> +	struct btrfs_device *device;
> +	u64 hmzoned_devices = 0;
> +	u64 nr_devices = 0;
> +	u64 zone_size = 0;
> +	int incompat_hmzoned = btrfs_fs_incompat(fs_info, HMZONED);
> +	int ret = 0;
> +
> +	/* Count zoned devices */
> +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
> +		if (!device->bdev)
> +			continue;

Nit:
		enum blk_zoned_model zone_model = blk_zoned_model(device->bdev);

		if (zone_model == BLK_ZONED_HM ||
		    zone_model == BLK_ZONED_HA &&
		    incompat_hmzoned) {

> +		if (bdev_zoned_model(device->bdev) == BLK_ZONED_HM ||
> +		    (bdev_zoned_model(device->bdev) == BLK_ZONED_HA &&
> +		     incompat_hmzoned)) {
> +			hmzoned_devices++;
> +			if (!zone_size) {
> +				zone_size = device->zone_info->zone_size;
> +			} else if (device->zone_info->zone_size != zone_size) {
> +				btrfs_err(fs_info,
> +					  "Zoned block devices must have equal zone sizes");
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +		}
> +		nr_devices++;
> +	}
