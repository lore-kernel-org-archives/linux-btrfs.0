Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF399C07E9B
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Jul 2021 11:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8AB461CB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Jul 2021 11:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhGGLF7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 07:05:59 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41732 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhGGLF7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jul 2021 07:05:59 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E1C512006F;
        Wed,  7 Jul 2021 11:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625655797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lD/a6KRa4Q05tm1TjeYcQ1POQZo4x0q/MUXn+5Y+jBw=;
        b=e61HKwAekyGpMqfEblBZuQ/9D7UJgRpJOz0rccBgGPh5u85xg1wsSU+LxWH7eYa+JSS4oh
        CyqZxrPA7FPOp0J2gs0jG/r2fVN6UpgCh6GX2FdwjninFpI8SOgtyaSiJdJbCvc+El7CWG
        qBqwghH7L1nnfKGW7zyFvU/c/oGr1OA=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 9F28613998;
        Wed,  7 Jul 2021 11:03:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id n0nxI/WJ5WDDXgAAGKfGzw
        (envelope-from <nborisov@suse.com>); Wed, 07 Jul 2021 11:03:17 +0000
Subject: Re: [PATCH v2 6/8] btrfs: use the filemap_fdatawrite_wbc helper for
 delalloc shrinking
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-fsdevel@vger.kernel.org
References: <cover.1624974951.git.josef@toxicpanda.com>
 <2acb56dd851d31d7b5547099821f0cbf6dfb5d29.1624974951.git.josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <9c8caddc-a511-2012-d458-4e8c7ca34315@suse.com>
Date:   Wed, 7 Jul 2021 14:03:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2acb56dd851d31d7b5547099821f0cbf6dfb5d29.1624974951.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 29.06.21 г. 16:59, Josef Bacik wrote:
> sync_inode() has some holes that can cause problems if we're under heavy
> ENOSPC pressure.  If there's writeback running on a separate thread
> sync_inode() will skip writing the inode altogether.  What we really
> want is to make sure writeback has been started on all the pages to make
> sure we can see the ordered extents and wait on them if appropriate.
> Switch to this new helper which will allow us to accomplish this and
> avoid ENOSPC'ing early.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
