Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E12AC07E9B
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Jul 2021 11:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4091361C88
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Jul 2021 11:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhGGLMH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 07:12:07 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55936 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhGGLMG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jul 2021 07:12:06 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9CB8922450;
        Wed,  7 Jul 2021 11:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625656165; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ygA8SalZ9CFMZkicJ1Yn1mfdMnL928ILJauhTs6ySZ8=;
        b=KeEaM2L4+58pJrF6sjqt7aj4UrlDEDpgWtC9Ic3/e2Blln09sgVAm17+vd5xw3j+M7+KR0
        0ir7x1xPYVeQqcnuo4xhBBTclUV1t1AotZyjBWEPeSyaJcsDaIu4gd1KgDzjxXmMhyOIwv
        FXxUff9aErnx+gr9TEdEbJ9C9zkA+lU=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 4C31D13998;
        Wed,  7 Jul 2021 11:09:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id XeH7DmWL5WC/YAAAGKfGzw
        (envelope-from <nborisov@suse.com>); Wed, 07 Jul 2021 11:09:25 +0000
Subject: Re: [PATCH v2 3/8] btrfs: wait on async extents when flushing
 delalloc
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-fsdevel@vger.kernel.org
References: <cover.1624974951.git.josef@toxicpanda.com>
 <0ee87e54d0f14f0628d146e09fef34db2ce73e03.1624974951.git.josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <49f999e5-7efd-a235-6e21-b269bfc2381e@suse.com>
Date:   Wed, 7 Jul 2021 14:09:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0ee87e54d0f14f0628d146e09fef34db2ce73e03.1624974951.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 29.06.21 г. 16:59, Josef Bacik wrote:
> I've been debugging an early ENOSPC problem in production and finally
> root caused it to this problem.  When we switched to the per-inode in
> 38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in
> shrink_delalloc") I pulled out the async extent handling, because we
> were doing the correct thing by calling filemap_flush() if we had async
> extents set.  This would properly wait on any async extents by locking
> the page in the second flush, thus making sure our ordered extents were
> properly set up.
> 
> However when I switched us back to page based flushing, I used
> sync_inode(), which allows us to pass in our own wbc.  The problem here
> is that sync_inode() is smarter than the filemap_* helpers, it tries to
> avoid calling writepages at all.  This means that our second call could
> skip calling do_writepages altogether, and thus not wait on the pagelock
> for the async helpers.  This means we could come back before any ordered
> extents were created and then simply continue on in our flushing
> mechanisms and ENOSPC out when we have plenty of space to use.
> 
> Fix this by putting back the async pages logic in shrink_delalloc.  This
> allows us to bulk write out everything that we need to, and then we can
> wait in one place for the async helpers to catch up, and then wait on
> any ordered extents that are created.
> 
> Fixes: e076ab2a2ca7 ("btrfs: shrink delalloc pages instead of full inodes")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

This patch really depend on the next one in order for it to be correct.
Imo this dependency should be explicitly stated in the change log and
the patches re-ordered.
