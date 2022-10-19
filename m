Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457EAC4167E
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Oct 2022 15:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiJSPjy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Oct 2022 11:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbiJSPjB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2022 11:39:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7BC15F32C
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2022 08:35:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 95BA1203B7;
        Wed, 19 Oct 2022 15:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666193637;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XtGvOCTL/P1WGJik6/UR2L8oC8EvmqKRLjcUJMt/qRY=;
        b=Qymukee2lnNVDLrxshhHjatXOih0/WaTakrcsc/KfNGKiTkCVHnW3Xjkqs7DySS+Nmpr0r
        aHNL69q7tE5kSX6X7jlUkq39fL1VN5HDS1Wv2KsHLnXruKC+E4aOIugGwevPp7jzxOSNMl
        Ldc9cVSUnf553t5h28FX8oYeUXjTftM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666193637;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XtGvOCTL/P1WGJik6/UR2L8oC8EvmqKRLjcUJMt/qRY=;
        b=+B1o8fFLn61sum00whnK74yMz9e0c2+U8a3+6W6GKotl6cWx1jivRwYNXjzib5IJ1OYrqk
        TwGkzhbVo6+4T4DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6CCD313345;
        Wed, 19 Oct 2022 15:33:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EjFqGeUYUGP/UgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 19 Oct 2022 15:33:57 +0000
Date:   Wed, 19 Oct 2022 17:33:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add macro BTRFS_SEND_BUF_SIZE_V2
Message-ID: <20221019153347.GD13389@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20221019081001.58288-1-wangyugui@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019081001.58288-1-wangyugui@e16-tech.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 19, 2022 at 04:10:01PM +0800, Wang Yugui wrote:
> Add a macro BTRFS_SEND_BUF_SIZE_V2 and save it just after
> BTRFS_SEND_BUF_SIZE_V1.
> 
> This is a refactor without any function change.
> 
> Signed-off-by: Wang Yugui <wangyugui@e16-tech.com>

Added to misc-next, thanks.
