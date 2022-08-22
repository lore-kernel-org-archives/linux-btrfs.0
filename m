Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B03DC28D13
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Aug 2022 18:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237453AbiHVSAr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 14:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237375AbiHVSAY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2022 14:00:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027ED45F61
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Aug 2022 11:00:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AEFE85C89F;
        Mon, 22 Aug 2022 18:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661191222;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tHlpmf2c5DY+XmcM/YzM/gmmhiIY6FstoACNGhf/7T0=;
        b=JZIL0Va2hrKLShbm8/oT9Ar8LBRKRFHxwiO9q9LczG7Dh0YFTdomcfYoTdqvDAebxixLCI
        FvtCDdNpeGwsFW85tV2M66Y+D8fg6x/OS1UJ+U/J9PjxjWF/Jky7SYSxpO/kAG3gVC+E43
        mKR1MYefu5HJ2KM6Fq70jOrbA2ap7do=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661191222;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tHlpmf2c5DY+XmcM/YzM/gmmhiIY6FstoACNGhf/7T0=;
        b=WdCWfyqyUsBLDRuTiUyhjtWQGFVnneo5WOAz/Db2v+qAFju3Ai8FVelWI57OpgjboNZLH/
        +KFMCAoZWYN0cgAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8F17A1332D;
        Mon, 22 Aug 2022 18:00:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yob0ITbEA2OAUAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 22 Aug 2022 18:00:22 +0000
Date:   Mon, 22 Aug 2022 19:55:09 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: zoned: revert mistakenly removed space accounting
Message-ID: <20220822175509.GC13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org
References: <20220822040840.614891-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822040840.614891-1-naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 22, 2022 at 01:08:40PM +0900, Naohiro Aota wrote:
> The commit ee1cd63d10a8 ("btrfs: convert block group bit field to use bit
> helpers") removed an accounting of space_info->active_total_bytes, maybe by
> mistake. Revert it back to make the active zone tracking properly work
> again.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Good catch, added to misc-next, thanks.
