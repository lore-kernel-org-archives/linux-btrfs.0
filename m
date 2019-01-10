Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8FCC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 16:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23DF1206B7
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 16:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbfAJQIf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 11:08:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:42158 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728213AbfAJQIf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 11:08:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 85277AFFD
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2019 16:08:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F3653DA7E8; Thu, 10 Jan 2019 17:08:01 +0100 (CET)
Date:   Thu, 10 Jan 2019 17:08:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [For 5.0-rc PATCH] btrfs: Use real device structure to verify
 dev extent
Message-ID: <20190110160801.GO23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <20190108060818.9517-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108060818.9517-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 08, 2019 at 02:08:18PM +0800, Qu Wenruo wrote:
> [BUG]
> Linux v5.0-rc1 will fail fstests/btrfs/163 with the following kernel
> message:
> 
>   BTRFS error (device dm-6): dev extent devid 1 physical offset 13631488 len 8388608 is beyond device boundary 0
>   BTRFS error (device dm-6): failed to verify dev extents against chunks: -117
>   BTRFS error (device dm-6): open_ctree failed
> 
> [CAUSE]
> Commit cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev extent
> mapping check") introduced strict check on dev extents.
> 
> We use btrfs_find_device() with dev uuid and fs uuid set to NULL, and
> only dependent on @devid to find the real device.
> 
> For seed devices, we call clone_fs_devices() in open_seed_devices() to
> allow us search seed devices directly.
> 
> However clone_fs_devices() just populates devices with devid and dev
> uuid, without populating other essential members, like disk_total_bytes.

That's quite fragile but works as a quick fix, queued for 5.0-rc,
thanks.
