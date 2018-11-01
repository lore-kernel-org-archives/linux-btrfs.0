Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F55C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 18:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AFC02064C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 18:02:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AFC02064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbeKBDGV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 23:06:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:47480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727870AbeKBDGV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 23:06:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 934AEADC9;
        Thu,  1 Nov 2018 18:02:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A6512DA6F4; Thu,  1 Nov 2018 19:02:07 +0100 (CET)
Date:   Thu, 1 Nov 2018 19:02:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Ethan Lien <ethanlien@synology.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use tagged writepage to mitigate livelock of
 snapshot
Message-ID: <20181101180206.GU9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Ethan Lien <ethanlien@synology.com>,
        linux-btrfs@vger.kernel.org
References: <20181101064903.11638-1-ethanlien@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101064903.11638-1-ethanlien@synology.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 02:49:03PM +0800, Ethan Lien wrote:
> Snapshot is expected to be fast. But if there are writers steadily
> create dirty pages in our subvolume, the snapshot may take a very long
> time to complete. To fix the problem, we use tagged writepage for snapshot
> flusher as we do in the generic write_cache_pages(), so we can ommit pages
> dirtied after the snapshot command.
> 
> We do a simple snapshot speed test on a Intel D-1531 box:
> 
> fio --ioengine=libaio --iodepth=32 --bs=4k --rw=write --size=64G
> --direct=0 --thread=1 --numjobs=1 --time_based --runtime=120
> --filename=/mnt/sub/testfile --name=job1 --group_reporting & sleep 5;
> time btrfs sub snap -r /mnt/sub /mnt/snap; killall fio
> 
> original: 1m58sec
> patched:  6.54sec
> 
> This is the best case for this patch since for a sequential write case,
> we omit nearly all pages dirtied after the snapshot command.
> 
> For a multi writers, random write test:
> 
> fio --ioengine=libaio --iodepth=32 --bs=4k --rw=randwrite --size=64G
> --direct=0 --thread=1 --numjobs=4 --time_based --runtime=120
> --filename=/mnt/sub/testfile --name=job1 --group_reporting & sleep 5;
> time btrfs sub snap -r /mnt/sub /mnt/snap; killall fio
> 
> original: 15.83sec
> patched:  10.35sec
> 
> The improvement is less compared with the sequential write case, since
> we omit only half of the pages dirtied after snapshot command.
> 
> Signed-off-by: Ethan Lien <ethanlien@synology.com>

This looks nice, thanks. I agree with the The suggestions from Nikolay,
please update and resend.

I was bit curious about the 'livelock', what you describe does not seem
to be one. System under heavy IO can make the snapshot dead slow but can
recover from that once the IO stops.

Regarding the sync semantics, there's AFAIK no change to the current
state where the sync is done before snapshot but without further other
guarantees. From that point I think it's safe to select only subset of
pages and make things faster.

As the requested changes are not functional I'll add the patch to
for-next for testing.
