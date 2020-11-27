Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85295C3E8C5
	for <linux-btrfs@archiver.kernel.org>; Fri, 27 Nov 2020 20:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 555EA20B80
	for <linux-btrfs@archiver.kernel.org>; Fri, 27 Nov 2020 20:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbgK0UEH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 27 Nov 2020 15:04:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:36408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731305AbgK0UDg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Nov 2020 15:03:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CE4C7AC55;
        Fri, 27 Nov 2020 19:29:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 89B00DA7D9; Fri, 27 Nov 2020 20:28:08 +0100 (CET)
Date:   Fri, 27 Nov 2020 20:28:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v10 00/41] btrfs: zoned block device support
Message-ID: <20201127192808.GD6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
References: <cover.1605007036.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605007036.git.naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 10, 2020 at 08:26:03PM +0900, Naohiro Aota wrote:
> Johannes Thumshirn (1):
>   block: add bio_add_zone_append_page
> 
> Naohiro Aota (40):
>   iomap: support REQ_OP_ZONE_APPEND

From that one

>   btrfs: introduce ZONED feature flag
>   btrfs: get zone information of zoned block devices
>   btrfs: check and enable ZONED mode
>   btrfs: introduce max_zone_append_size
>   btrfs: disallow space_cache in ZONED mode
>   btrfs: disallow NODATACOW in ZONED mode
>   btrfs: disable fallocate in ZONED mode
>   btrfs: disallow mixed-bg in ZONED mode
>   btrfs: implement log-structured superblock for ZONED mode

up to this patch added to misc-next. There's still open question
regarding the superblock copies, we had a chat about that with Johanness
so he'll tell you more.
