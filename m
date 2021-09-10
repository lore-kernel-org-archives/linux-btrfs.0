Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAF3C433F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Sep 2021 10:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0236F61153
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Sep 2021 10:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhIJKpj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 10 Sep 2021 06:45:39 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54352 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbhIJKpj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Sep 2021 06:45:39 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8986E20056;
        Fri, 10 Sep 2021 10:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631270667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p9vvsDKl+dq2GMJNZJsywtDsXwIKTFqUuYDrqtMrcao=;
        b=J6dW3rs/WtJqMMdjseU4qhaYtnWF2KOiy7WFTbFuy7/KD0/ZEz+YNTGumTlO80eq5qBxKU
        /j+4XyeBIJl7178ivwSgCAU42TdJ9FNshAkIbol0ceq7x+xIDmxWswELD94NV2f8PE0Kgo
        UUGliASfBSzHDwugbTbDkRh/2IgBTqI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6268513D27;
        Fri, 10 Sep 2021 10:44:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9buQFQs3O2EmGwAAMHmgww
        (envelope-from <nborisov@suse.com>); Fri, 10 Sep 2021 10:44:27 +0000
Subject: Re: [PATCH] btrfs: add new filter for missing devices
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
References: <20210903105047.1118101-1-nborisov@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <59684928-304d-24a3-6c0b-90963344b953@suse.com>
Date:   Fri, 10 Sep 2021 13:44:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210903105047.1118101-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.09.21 г. 13:50, Nikolay Borisov wrote:
> There are pending changes to btrfs progs which make the output of
> 'btrfs fi show' more useful w.r.t to misisng devices. I.e instead of
> printing a single '*** Some devices missing'  at the end it now produces
> one line per missing device:
> 
> Total devices 2 FS bytes used 128.00KiB
> 	devid    1 size 5.00GiB used 1.26GiB path /dev/loop0
> 	devid    2 size 0 used 0 path /dev/loop1 ***MISSING***
> 
> This obviously will break all existing tests so in anticipation for this
> change landing the filter is being added.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Please ignore this patch for now as we haven't decided on what the
format of the output should be so I'll likely be sending a V2 once this
is decided.
