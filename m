Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D250CCCA473
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Jun 2022 13:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbiFFNRu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 09:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbiFFNRp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2022 09:17:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C535C59314
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Jun 2022 06:17:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3127921A21;
        Mon,  6 Jun 2022 13:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654521462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JGkG0uE59eIk04KEyafy0SbZyw9Tv1PXlbuZCpCJRHQ=;
        b=CsS+oW8/9H0m5pVesmt5c4pZvvNBEMtZtFuozzZVa1i9lkSlh7FaiSBnHJN043xlz2sMI7
        zLkTaH9RH4Ax628euATBXJG2mNHUFIU5ku+qCklQoOERmPSjMLwD/7Hk1g21ZLVjQqKw0y
        SkzuxM9MnTddLtcvePkdlHNnWhjyExQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E20DF139F5;
        Mon,  6 Jun 2022 13:17:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1Z5hNHX+nWLjSgAAMHmgww
        (envelope-from <nborisov@suse.com>); Mon, 06 Jun 2022 13:17:41 +0000
Message-ID: <41edb271-6559-8efc-ab3a-69ffaa29f240@suse.com>
Date:   Mon, 6 Jun 2022 16:17:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] btrfs: split discard handling out of btrfs_map_block
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, josef@toxicpanda.com,
        dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org
References: <20220603065725.40708-1-hch@lst.de>
From:   Nikolay Borisov <nborisov@suse.com>
In-Reply-To: <20220603065725.40708-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.06.22 г. 9:57 ч., Christoph Hellwig wrote:
> Mapping block for discard doesn't really share any code with the regular
> block mapping case.  Split it out into an entirely separate helper
> that just returns an array of btrfs_discard_stripe structures and the
> number of stripes.
> 
> This removes the need for the length field in the btrfs_io_context
> structure, so remove tht.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

