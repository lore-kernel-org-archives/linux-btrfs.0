Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAD1C4338F
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Aug 2021 10:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C0D60F41
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Aug 2021 10:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbhHQKMS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 06:12:18 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:40210 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbhHQKMR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Aug 2021 06:12:17 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 527BE21D61;
        Tue, 17 Aug 2021 10:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629195104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SZ5TojIfeqMBzO0nHXS24zMY0/4UEL05GGUG4m8jSVA=;
        b=pjDkP1Y+d+zyV/aKri/K8akaRXBISPVnLyo4kD0K39Mw11unwGSXqsTSnNUml9QaZiReVZ
        WThI5lPfqwBt92OQGSQLEdItuo+w4GgcYar0gcBoYyAqLJdcr18zvEEzpTLE89T9CnmBDJ
        UBskjuHt1n5JYfsT65nzI60cz0uuuog=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 2B01E13318;
        Tue, 17 Aug 2021 10:11:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id fRjiB2CLG2ETEwAAGKfGzw
        (envelope-from <nborisov@suse.com>); Tue, 17 Aug 2021 10:11:44 +0000
Subject: Re: [PATCH v2 3/4] btrfs: introduce btrfs_subpage_bitmap_info
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20210817093852.48126-1-wqu@suse.com>
 <20210817093852.48126-4-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <7b9c1c27-1938-4702-e6b2-db5a840f7a84@suse.com>
Date:   Tue, 17 Aug 2021 13:11:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210817093852.48126-4-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 17.08.21 г. 12:38, Qu Wenruo wrote:
> Currently we use fixed size u16 bitmap for subpage bitmap.
> This is fine for 4K sectorsize with 64K page size.
> 
> But for 4K sectorsize and larger page size, the bitmap is too small,
> while for smaller page size like 16K, u16 bitmaps waste too much space.
> 
> Here we introduce a new helper structure, btrfs_subpage_bitmap_info, to
> record the proper bitmap size, and where each bitmap should start at.
> 
> By this, we can later compact all subpage bitmaps into one u32 bitmap.
> 
> This patch is the first step towards such compact bitmap.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ctree.h   |  1 +
>  fs/btrfs/disk-io.c | 12 +++++++++---
>  fs/btrfs/subpage.c | 35 +++++++++++++++++++++++++++++++++++
>  fs/btrfs/subpage.h | 36 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 81 insertions(+), 3 deletions(-)
> 

<snip>

> +/*
> + * Extra info for subpapge bitmap.
> + *
> + * For subpage we pack all uptodate/error/dirty/writeback/ordered
> + * bitmaps into one larger bitmap.
> + *
> + * This structure records how they are organized in such bitmap:
> + *
> + * /- uptodate_offset	/- error_offset	/- dirty_offset
> + * |			|		|
> + * v			v		v
> + * |u|u|u|u|........|u|u|e|e|.......|e|e| ...	|o|o|

nit: the 'e' that the dirty offset is pointing to should be a 'd', I'm
sure David can fix this while merging.

<snip>
