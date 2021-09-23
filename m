Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BE8C433EF
	for <linux-btrfs@archiver.kernel.org>; Thu, 23 Sep 2021 08:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2D7A60F6D
	for <linux-btrfs@archiver.kernel.org>; Thu, 23 Sep 2021 08:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239974AbhIWIiF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 04:38:05 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:52316 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239953AbhIWIiE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Sep 2021 04:38:04 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9F82D2231C;
        Thu, 23 Sep 2021 08:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632386192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WDHMAFexef9d7oGm48evvXTOrMO6s9sF6o9K89WILbs=;
        b=g6PurybvsP+a5lmzBVUOG5ObqK3M/JQCC5/NLNgfv6MurVytFq1ra/jAKyH6f1xAZHn7sF
        b+2Y89qlAyhyHDmTaB1kjVJQG9V2DR/Xo3uH8kPWRhH2oLy+W7sMP2k8bje80CFPwzTTX0
        PXQt0EoN1ZhU1qkVG1nOgyu6/Mu7isM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 777AF13DCA;
        Thu, 23 Sep 2021 08:36:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MVqBGpA8TGGOIQAAMHmgww
        (envelope-from <nborisov@suse.com>); Thu, 23 Sep 2021 08:36:32 +0000
Subject: Re: [PATCH 1/2] btrfs: make sure btrfs_io_context::fs_info is always
 initialized
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20210923060009.53821-1-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <7d87d000-9cf6-ec5d-24f7-61d060bffa60@suse.com>
Date:   Thu, 23 Sep 2021 11:36:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210923060009.53821-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 23.09.21 г. 9:00, Qu Wenruo wrote:
> Currently btrfs_io_context::fs_info is only initialized in
> btrfs_map_block(), but there are call sites like btrfs_map_sblock()

s/btrfs_map_block/btrfs_map_bio and indeed this is done across function
boundaries which is ugly as hell.

> which calls __btrfs_map_block() directly, leaving bioc::fs_info
> uninitialized (NULL).
> 
> Currently this is fine, but later cleanup will rely on bioc::fs_info to
> grab fs_info, and this can be a hidden problem for such usage.
> 
> This patch will remove such hidden uninitialized member by always
> assigning bioc::fs_info at alloc_btrfs_io_context().
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

With the changelog change so that it's consistent with the changed code:


Reviewed-by: Nikolay Borisov <nborisov@suse.com>
