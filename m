Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A686ECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 15:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B6D12150F
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 15:46:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B6D12150F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbeJQXnJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 19:43:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:41788 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727013AbeJQXnI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 19:43:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 04893AF6C;
        Wed, 17 Oct 2018 15:46:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 37454DAD55; Wed, 17 Oct 2018 17:46:43 +0200 (CEST)
Date:   Wed, 17 Oct 2018 17:46:42 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix assertion on fsync of regular file when using
 no-holes feature
Message-ID: <20181017154642.GH29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181015085100.5720-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015085100.5720-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 09:51:00AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When using the NO_HOLES feature and logging a regular file, we were
> expecting that if we find an inline extent, that either its size in ram
> (uncompressed and unenconded) matches the size of the file or if it does
> not, that it matches the sector size and it represents compressed data.
> This assertion does not cover a case where the length of the inline extent
> is smaller then the sector size and also smaller the file's size, such
> case is possible through fallocate. Example:
> 
>   $ mkfs.btrfs -f -O no-holes /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ xfs_io -f -c "pwrite -S 0xb60 0 21" /mnt/foobar
>   $ xfs_io -c "falloc 40 40" /mnt/foobar
>   $ xfs_io -c "fsync" /mnt/foobar
> 
> In the abobe example we trigger the assertion because the inline extent's
> length is 21 bytes while the file size is 80 bytes. The fallocate() call
> merely updated the file's size and did not touch the existing inline
> extent, as expected.
> 
> So fix this by adjusting the assertion so that an inline extent length
> smaller then the file size is valid if the file size is smaller then the
> filesystem's sector size.
> 
> A test case for fstests follows soon.
> 
> Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAE5jQCfRSBC7n4pUTFJcmHh109=gwyT9mFkCOL+NKfzswmR=_Q@mail.gmail.com/
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
