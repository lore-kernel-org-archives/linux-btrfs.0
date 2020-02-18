Return-Path: <SRS0=4mvY=4G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023C8C34048
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Feb 2020 16:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D77752467A
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Feb 2020 16:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgBRQup (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 11:50:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:59782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgBRQup (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Feb 2020 11:50:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CFBF1AD14;
        Tue, 18 Feb 2020 16:50:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E7985DA7BA; Tue, 18 Feb 2020 17:50:26 +0100 (CET)
Date:   Tue, 18 Feb 2020 17:50:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.cz>,
        "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Fix memory leak on failed cache-writes
Message-ID: <20200218165026.GS2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>
References: <20200213155803.14799-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213155803.14799-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 14, 2020 at 12:57:58AM +0900, Johannes Thumshirn wrote:
> Fstests' test case generic/475 reliably leaks the btrfs_io_ctl::pages
> allocated in __btrfs_write_out_cache().
> 
> The first patch in this series is freeing the pages when we throw away a dirty
> block group. The other patches are small things I noticed while hunting down the
> problem and are independant of fix.
> 
> Changes to v1:
> - Move fix to the first position (David)
> 
> Johannes Thumshirn (5):
>   btrfs: free allocated pages on failed cache write-out
>   btrfs: use inode from io_ctl in io_ctl_prepare_pages
>   btrfs: make the uptodate argument of io_ctl_add_pages() boolean.
>   btrfs: use standard debug config option to enable free-space-cache
>     debug prints
>   btrfs: simplify error handling in __btrfs_write_out_cache()

I've seen some weird test failures and this patchset was in the tested
branch (either for-next or standalone). I need to retest misc-next again
to have a clean baseline so I can see the diff.
