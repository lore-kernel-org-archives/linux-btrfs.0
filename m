Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBD8C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 16:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3AC5214F1
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 16:46:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3AC5214F1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbeKVDVl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 22:21:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:40208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726941AbeKVDVk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 22:21:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6C230AECF;
        Wed, 21 Nov 2018 16:46:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 43D20DA871; Wed, 21 Nov 2018 17:46:10 +0100 (CET)
Date:   Wed, 21 Nov 2018 17:46:10 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix access to available allocation bits when
 starting balance
Message-ID: <20181121164609.GP24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181119094812.27296-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119094812.27296-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 19, 2018 at 09:48:12AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The available allocation bits members from struct btrfs_fs_info are
> protected by a sequence lock, and when starting balance we access them
> incorrectly in two different ways:
> 
> 1) In the read sequence lock loop at btrfs_balance() we use the values we
>    read from fs_info->avail_*_alloc_bits and we can immediately do actions
>    that have side effects and can not be undone (printing a message and
>    jumping to a label). This is wrong because a retry might be needed, so
>    our actions must not have side effects and must be repeatable as long
>    as read_seqretry() returns a non-zero value. In other words, we were
>    essentially ignoring the sequence lock;
> 
> 2) Right below the read sequence lock loop, we were reading the values
>    from avail_metadata_alloc_bits and avail_data_alloc_bits without any
>    protection from concurrent writers, that is, reading them outside of
>    the read sequence lock critical section.
> 
> So fix this by making sure we only read the available allocation bits
> while in a read sequence lock critical section and that what we do in the
> critical section is repeatable (has nothing that can not be undone) so
> that any eventual retry that is needed is handled properly.
> 
> Fixes: de98ced9e743 ("Btrfs: use seqlock to protect fs_info->avail_{data, metadata, system}_alloc_bits")
> Fixes: 14506127979a ("btrfs: fix a bogus warning when converting only data or metadata")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
