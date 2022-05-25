Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78E7C433F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 May 2022 14:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbiEYO5T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 May 2022 10:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiEYO5S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 May 2022 10:57:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC566C0FE
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2022 07:57:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A82501F92A;
        Wed, 25 May 2022 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653490636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9+bINIakm/S4oxeEAvFeLwZJBxaveRPYS3YVAg1NKEA=;
        b=b/GeFosefrU638PYw2xBCbzNlOz2fRylFMv4R1Bww/ygXcwUfefD9NMOjcg2GMIQ4DmzGF
        OX9jE2bpLj78MS2pBcZiUtvwbpwI+PwtdSegVztVdRuCpiFqiijggp/NDFNcxmxQ20mLaK
        Fph3zfc13MqI0PFuLz5fsGD+XvZkOb0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 48C0E13ADF;
        Wed, 25 May 2022 14:57:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id x+XwDsxDjmJUegAAMHmgww
        (envelope-from <nborisov@suse.com>); Wed, 25 May 2022 14:57:16 +0000
Message-ID: <56c20a53-bdab-1e8e-d494-274e2a62f2cb@suse.com>
Date:   Wed, 25 May 2022 17:57:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5/8] btrfs: refactor end_bio_extent_readpage
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20220522114754.173685-1-hch@lst.de>
 <20220522114754.173685-6-hch@lst.de>
From:   Nikolay Borisov <nborisov@suse.com>
In-Reply-To: <20220522114754.173685-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 22.05.22 г. 14:47 ч., Christoph Hellwig wrote:
> Untangle the goto mess and remove the pointless 'ret' local variable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
