Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA12C65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 15:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66C2D2086D
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 15:54:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66C2D2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbeLLPyQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 10:54:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:43132 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726358AbeLLPyQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 10:54:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9AB34AEC0;
        Wed, 12 Dec 2018 15:54:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0BBD8DA7E5; Wed, 12 Dec 2018 16:53:52 +0100 (CET)
Date:   Wed, 12 Dec 2018 16:53:52 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dmitriy Gorokh <Dmitriy.Gorokh@wdc.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: raid56: data corruption on a device removal
Message-ID: <20181212155352.GZ23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dmitriy Gorokh <Dmitriy.Gorokh@wdc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <66F8D435-4E51-4761-B6CF-BA96F4BC5986@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66F8D435-4E51-4761-B6CF-BA96F4BC5986@wdc.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 12:25:55AM +0000, Dmitriy Gorokh wrote:
> I found that RAID5 or RAID6 filesystem might be got corrupted in the following scenario:
> 
> 1. Create 4 disks RAID6 filesystem
> 2. Preallocate 16 10Gb files
> 3. Run fio: 'fio --name=testload --directory=./ --size=10G --numjobs=16 --bs=64k --iodepth=64 --rw=randrw --verify=sha256 --time_based --runtime=3600’
> 4. After few minutes pull out two drives: 'echo 1 > /sys/block/sdc/device/delete ;  echo 1 > /sys/block/sdd/device/delete’
> 
> About 5 of 10 times the test is run, it led to silent data corruption
> of a random extent, resulting in ‘IO Error’ and ‘csum failed’ messages
> while trying to read the affected file. It usually affects only small
> portion of the files and only one underlying extent of a file. When I
> converted logical address of the damaged extent to physical address
> and dumped a stripe directly from drives, I saw specific pattern,
> always the same when the issue occurs.
> 
> I found that few bios which were being processed right during the
> drives removal, contained non zero bio->bi_iter.bi_done field despite
> of  EIO bi_status. bi_sector field was also increased from original
> one by that 'bi_done' value. Looks like this is a quite rare
> condition. Subsequently, in the raid_rmw_end_io handler that failed
> bio can be translated to a wrong stripe number and fail wrong rbio.

Thanks for the analysis, sounds correct to me and the fix too. Would be
good if you can attach the logs or portions of the dumps you've used to
understand the problem, like the pattern you mention above.
