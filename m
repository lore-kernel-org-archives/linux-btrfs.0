Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64F3C43334
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Jul 2022 20:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiGLUhh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 16:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGLUhg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Jul 2022 16:37:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511CFB197F;
        Tue, 12 Jul 2022 13:37:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 086663383C;
        Tue, 12 Jul 2022 20:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1657658254;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+trnDr+pJ3wLMVAOo1gWxDwo59FKwzr7H7Yzaf8eevI=;
        b=TkZUtJ/zJtDGMW+Po0eZTMCLNlc7r7X6Yk57RK2DkqUMd2+C3pTQ4M1BHdSg/R6nqxszok
        FabfKDihrviiMBchbp5XlIjYHmzvsF8MA9Jj8aszl5RyIcMcWJxrOM0V+UaZ8uLxeglfjj
        wIXef8ByyOWeox6BcIV0driTyMW0KHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1657658254;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+trnDr+pJ3wLMVAOo1gWxDwo59FKwzr7H7Yzaf8eevI=;
        b=Ww+lKtut8MSwQbl2P1XEcJO7G+G/2cb7pUxQRbkSc/QIkf69gsIEo2pFfCxR/wD/7XWqje
        3SNMqxx3RfcORbDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DB79013A94;
        Tue, 12 Jul 2022 20:37:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EfGHNI3bzWLlXQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 12 Jul 2022 20:37:33 +0000
Date:   Tue, 12 Jul 2022 22:32:44 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v2 00/13] btrfs: zoned: fix active zone tracking issues
Message-ID: <20220712203244.GE15169@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
References: <cover.1657321126.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1657321126.git.naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Jul 09, 2022 at 08:18:37AM +0900, Naohiro Aota wrote:
> This series addresses mainly two issues on zoned btrfs' active zone

Btw, I have one minor remark that's in many patches: please don't use
'zoned btrfs' when referring to it, either use 'zoned filesystem' or
'zoned mode'. I've fixed it where I noticed but in the future it would
be good to have it in the patches from the beginning. Thanks.
