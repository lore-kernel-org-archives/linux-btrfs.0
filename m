Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB18C07E96
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Jul 2021 18:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 552D661452
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Jul 2021 18:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhGFSg1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:36:27 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:60414 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhGFSg0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jul 2021 14:36:26 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 819681FFBC;
        Tue,  6 Jul 2021 18:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625596426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bUxEph1nr0bfnrE9L+5CCL2n2EnLQpOfq6omttjep00=;
        b=DE2iEfelz+sElYa8CF3cs+VBkkRl2jQogXQehiSpM/59U6je3IOmLgwiScwl0uTsXRsy9n
        MANvoa+6+G5BwIjKdgi1t1Ns83kd1YDz3RlObLpWmCPCc4wA+f24BRvWoSDrkxaXThKy2t
        nqQNRvriYBXVJdfBOx9qmW0lSocZV0E=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 4274D13418;
        Tue,  6 Jul 2021 18:33:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id jJ3KDAqi5GBBegAAGKfGzw
        (envelope-from <nborisov@suse.com>); Tue, 06 Jul 2021 18:33:46 +0000
Subject: Re: [PATCH] btrfs: ctree: Remove max argument from generic_bin_search
To:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.com
References: <20210706181325.6749-1-mpdesouza@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <a274fd4a-eafd-1be5-00d4-ec8143f6627b@suse.com>
Date:   Tue, 6 Jul 2021 21:33:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706181325.6749-1-mpdesouza@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 6.07.21 г. 21:13, Marcos Paulo de Souza wrote:
> Both callers use btrfs_header_nritems to feed the max argument.
> Remove the argument and let generic_bin_search call it itself.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
