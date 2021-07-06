Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD51C07E96
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Jul 2021 13:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E638619B8
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Jul 2021 13:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhGFNo2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 09:44:28 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57228 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbhGFNo1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jul 2021 09:44:27 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 299F622709;
        Tue,  6 Jul 2021 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625578908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yxbf1hVaYC7vdG6vdR/VLmLw0N1cXJSne/7f2G9x42k=;
        b=hJfygZeVqdQ40PQ2JofmzJ09jkr2PEH2XllbheHIrAlebQKWiYLiRtjQtOpCeJBHt4aoLi
        nd0Wdu2hvEYAdGTX8YZmSUXwqkUOigTlsxit1qpJvpS8nWOt1y4u8+ECCKvUKqD6SQofZk
        A1bR5KzQXvQ7Pes6yT5kinsGqgXpTY4=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id D4D3E133D0;
        Tue,  6 Jul 2021 13:41:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id mQYdMJtd5GCUJAAAGKfGzw
        (envelope-from <nborisov@suse.com>); Tue, 06 Jul 2021 13:41:47 +0000
Subject: Re: [PATCH] btrfs-progs: default to SINGLE profile on zoned devices
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
References: <20210706091922.38650-1-johannes.thumshirn@wdc.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <e2168115-5025-5281-94d5-3a962d0e92af@suse.com>
Date:   Tue, 6 Jul 2021 16:41:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706091922.38650-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 6.07.21 г. 12:19, Johannes Thumshirn wrote:
> On zoned devices we're currently not supporting any other block group
> profile than the SINGLE profile, so pick it as default value otherwise a
> user would have to specify it manually at mkfs time for rotational zoned
> devices.
> 
> Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
