Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AB7C433EF
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Sep 2021 13:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B81560E52
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Sep 2021 13:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbhICNIP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 Sep 2021 09:08:15 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36436 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhICNIO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Sep 2021 09:08:14 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CCFF122376;
        Fri,  3 Sep 2021 13:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630674433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WmDaKpje87XQUjHDg+/5jDXfFVEivNdCdjRzjPE5NlM=;
        b=RJd5CqvSdRmNg94cVoMXYzy/IguGmkOQyMn4JfjvgK9BNUwlQSMxMJmtUYKTCATSDC6sKA
        DkaRARhSmIoffr7xlZ+fhNM/HNqe+EwxfMt6uh4hbXthM1UuPAnBj9zyFXhrO2lNq7lPET
        3fz5/c4bfcwrtg/XwD7x3Idn8qjYGFc=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id A05B0137D4;
        Fri,  3 Sep 2021 13:07:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id IedgIwEeMmGAOAAAGKfGzw
        (envelope-from <nborisov@suse.com>); Fri, 03 Sep 2021 13:07:13 +0000
Subject: Re: [PATCH] btrfs: unexport repair_io_failure()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20210903124514.71575-1-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <c4b123d3-2121-e07f-663a-699840080966@suse.com>
Date:   Fri, 3 Sep 2021 16:07:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210903124514.71575-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.09.21 г. 15:45, Qu Wenruo wrote:
> Function repair_io_failure() is no longer used out of extent_io.c since
> commit 8b9b6f255485 ("btrfs: scrub: cleanup the remaining nodatasum
> fixup code"), which removes the last external caller.
> 
> Just unexport it.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
