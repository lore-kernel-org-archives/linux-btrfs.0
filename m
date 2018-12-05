Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1705C04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 00:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F66B2082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 00:18:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F66B2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbeLEASP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 19:18:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:34882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbeLEASP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 19:18:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2A8C1AFE1
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 00:18:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 017D2DAC39; Wed,  5 Dec 2018 01:17:54 +0100 (CET)
Date:   Wed, 5 Dec 2018 01:17:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        fdmanana@suse.com
Subject: Re: [PATCH 2/2] btrfs: scrub: move scrub_setup_ctx allocation out of
 device_list_mutex
Message-ID: <20181205001754.GW17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        fdmanana@suse.com
References: <cover.1543935982.git.dsterba@suse.com>
 <cfd97a36f22e60f29878598673be01f69208fea9.1543935982.git.dsterba@suse.com>
 <e0917cec-7d06-6217-16f4-9f83d3ae5ff6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0917cec-7d06-6217-16f4-9f83d3ae5ff6@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 04, 2018 at 05:22:19PM +0200, Nikolay Borisov wrote:
> > @@ -3874,16 +3882,9 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
> >  	if (ret) {
> >  		mutex_unlock(&fs_info->scrub_lock);
> >  		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> > -		return ret;
> > +		goto out_free_ctx;
> 
> Don't we suffer the same issue when calling scrub_workers_get since in
> it we do btrfs_alloc_workqueue which also calls kzalloc with GFP_KERNEL?

Yes, that's right. I instrumented only the allocations in scrub.c to see
if the nofs and lock_not_held assertions work at all so this one did not
get caught directly.

As scrub_workers_get still needs the scrub_lock, fixing it by moving
does not work and would need more restructuring.
