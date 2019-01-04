Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59A4C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 16:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2A4218CD
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 16:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfADQuR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 11:50:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:40444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbfADQuR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 11:50:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18B71AF1F;
        Fri,  4 Jan 2019 16:50:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B68DDDA7CE; Fri,  4 Jan 2019 17:49:45 +0100 (CET)
Date:   Fri, 4 Jan 2019 17:49:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dmitriy Gorokh <dmitriy.gorokh@gmail.com>
Cc:     linux-btrfs@vger.kernel.org, jthumshirn@suse.de
Subject: Re: [PATCH v2] btrfs: raid56: data corruption on a device removal
Message-ID: <20190104164943.GU23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Dmitriy Gorokh <dmitriy.gorokh@gmail.com>,
        linux-btrfs@vger.kernel.org, jthumshirn@suse.de
References: <66F8D435-4E51-4761-B6CF-BA96F4BC5986@wdc.com>
 <CANYdAbLNAxoAXcxuC+ugpdhsCpTbh0zVjY3T5rtOcpVufnmWRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANYdAbLNAxoAXcxuC+ugpdhsCpTbh0zVjY3T5rtOcpVufnmWRA@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 14, 2018 at 08:48:50PM +0300, Dmitriy Gorokh wrote:
> RAID5 or RAID6 filesystem might get corrupted in the following scenario:
> 
> 1. Create 4 disks RAID6 filesystem
> 2. Preallocate 16 10Gb files
> 3. Run fio: 'fio --name=testload --directory=./ --size=10G
> --numjobs=16 --bs=64k --iodepth=64 --rw=randrw --verify=sha256
> --time_based --runtime=3600’
> 4. After few minutes pull out two drives: 'echo 1 >
> /sys/block/sdc/device/delete ;  echo 1 > /sys/block/sdd/device/delete’
> 
> About 5 of 10 times the test is run, it led to a silent data
> corruption of a random stripe, resulting in ‘IO Error’ and ‘csum
> failed’ messages while trying to read the affected file. It usually
> affects only small portion of the files.
> 
> It is possible that few bios which were being processed during the
> drives removal, contained non zero bio->bi_iter.bi_done field despite
> of EIO bi_status. bi_sector field was also increased from original one
> by that 'bi_done' value. Looks like this is a quite rare condition.
> Subsequently, in the raid_rmw_end_io handler that failed bio can be
> translated to a wrong stripe number and fail wrong rbio.
> 
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Dmitriy Gorokh <dmitriy.gorokh@wdc.com>
> ---
>  fs/btrfs/raid56.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 3c8093757497..cd2038315feb 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1451,6 +1451,12 @@ static int find_bio_stripe(struct btrfs_raid_bio *rbio,
>   struct btrfs_bio_stripe *stripe;
> 
>   physical <<= 9;
> + /*
> +  * Since the failed bio can return partial data, bi_sector might be
> +  * incremented by that value. We need to revert it back to the
> +  * state before the bio was submitted.
> +  */
> + physical -= bio->bi_iter.bi_done;

The bi_done member has been removed in recent block layer changes
commit 7759eb23fd9808a2e4498cf36a798ed65cde78ae ("block: remove
bio_rewind_iter()"). I wonder what kind of block-magic do we need to do
as the iterators seem to be local and there's nothing available in the
call chain leading to find_bio_stripe. Johannes, any ideas?
