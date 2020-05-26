Return-Path: <SRS0=wzTy=7I=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F959C433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 May 2020 16:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 358F120723
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 May 2020 16:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388339AbgEZQoe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 May 2020 12:44:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:42976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388061AbgEZQoe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 May 2020 12:44:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E41B5AC12;
        Tue, 26 May 2020 16:44:35 +0000 (UTC)
Date:   Tue, 26 May 2020 11:44:28 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>
Subject: Re: [PATCH 4/7] btrfs: Switch to iomap_dio_rw() for dio
Message-ID: <20200526164428.sirhx6yjsghxpnqt@fiona>
References: <20200522123837.1196-1-rgoldwyn@suse.de>
 <20200522123837.1196-5-rgoldwyn@suse.de>
 <SN4PR0401MB35981C3BAEDA15CC85D13AE79BB00@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB35981C3BAEDA15CC85D13AE79BB00@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 15:03 26/05, Johannes Thumshirn wrote:
> Just as a heads up, this one gives me lot's of Page cache invalidation
> failure prints from dio_warn_stale_pagecache() on btrfs/004 with 
> current misc-next:
> 
<snip>

> [   23.696400] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
> [   23.698115] File: /mnt/scratch/bgnoise/p0/f0 PID: 6562 Comm: fsstress
> 
> I have no idea yet why but I'm investigating.

This is caused because we are trying to release a page when the extent
has locked the page and release page returns false. To minimize the
effect, I had proposed a patch [1] in v6. However, this created
more extent locking issues and so was dropped.

[1] https://patchwork.kernel.org/patch/11275063/

-- 
Goldwyn
