Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB17AC6FA82
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Sep 2022 14:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237706AbiIBOW4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Sep 2022 10:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbiIBOWg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Sep 2022 10:22:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31E0166A9E
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Sep 2022 06:48:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8BA66346C4;
        Fri,  2 Sep 2022 13:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662126506;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DVozy1XCQii0d3kssW/DWS+H2Kmgs/W82pDjHHWhH6o=;
        b=kj0mUBJ8zoZurWFfIoF7vCfRiMittSuThNf+QJIqKf4MVXP6pIkCGzPr4qhmlK8Mj+c5HM
        gvrk29ZNPCNBY0RIObx9S6c0nCRuSu2yFxd1RuI7gwgJzhra00dpOc8bIx+STdm6pOA51I
        o7/5buQKdhEka8Jsfe0XnLn1aXq3MEo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662126506;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DVozy1XCQii0d3kssW/DWS+H2Kmgs/W82pDjHHWhH6o=;
        b=nG0alBTePgSieA2pIRTuqonO6VXY0De7B9sSBcIeZu2kKiYnaKOoirZ5lNm8alt9xRDEJ3
        ssdEcmpG+uG/BVBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7128F1330E;
        Fri,  2 Sep 2022 13:48:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +rV8GqoJEmO7CwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 02 Sep 2022 13:48:26 +0000
Date:   Fri, 2 Sep 2022 15:43:06 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/2] btrfs: output more info for -ENOSPC caused
 transaction abort
Message-ID: <20220902134306.GY13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1661410915.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1661410915.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 25, 2022 at 03:09:08PM +0800, Qu Wenruo wrote:
> [Changelog]
> v3:
> - Drop the multi-line output change
>   The biggest problem is, for the space info dump, it can be ratelimited
>   especially for enospc_debug mount option.
>   Thus multi-line can be more confusing when it's related-limited or
>   interrupted by other lines.
> 
>   So this version will reuse the old single line output.

Added to misc-next, thanks.
