Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26234C11F66
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Jul 2021 12:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D1C461C99
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Jul 2021 12:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhGGMDu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 08:03:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:49742 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbhGGMDt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jul 2021 08:03:49 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C34542006A;
        Wed,  7 Jul 2021 12:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625659268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tEla79BRPc18RqG3uFtLCOzF35+/BEBCAH/+EHaWceI=;
        b=f6FaaXbjxgTthhKlfKXsWra/+lDg1MOwbUYsky15xfJJIfByOXBAcONDpOBS3avZak7B7V
        FfRkx8aeXKFFZqJb6pAwUcw1nIW9Q8HSKlg2KrgxxDIWRJy9kZbR0mtIX7oaI5sX3U9/pN
        jRyAOT7KYAuvQja6YbBYWsOMxAHkYcE=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 975FF1398A;
        Wed,  7 Jul 2021 12:01:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id YtfzIYSX5WBxcQAAGKfGzw
        (envelope-from <nborisov@suse.com>); Wed, 07 Jul 2021 12:01:08 +0000
Subject: Re: [PATCH] btrfs: zoned: fix wrong mutex unlock on failure to
 allocate log root tree
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <11314a6ca7a70deee42785d3ee79c97813b528ab.1625656963.git.fdmanana@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <0b159f83-be03-f01f-5637-8f228425d862@suse.com>
Date:   Wed, 7 Jul 2021 15:01:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <11314a6ca7a70deee42785d3ee79c97813b528ab.1625656963.git.fdmanana@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 7.07.21 г. 14:23, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When syncing the log, if we fail to allocate the root node for the log
> root tree:
> 
> 1) We are unlocking fs_info->tree_log_mutex, but at this point we have
>    not yet locked this mutex;
> 
> 2) We have locked fs_info->tree_root->log_mutex, but we end up not
>    unlocking it;
> 
> So fix this by unlocking fs_info->tree_root->log_mutex instead of
> fs_info->tree_log_mutex.
> 
> Fixes: e75f9fd194090e ("btrfs: zoned: move log tree node allocation out of log_root_tree->log_mutex")
> CC: stable@vger.kernel.org # 5.13+
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
