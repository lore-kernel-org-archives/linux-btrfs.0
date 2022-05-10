Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E77C433F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 May 2022 11:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241005AbiEJLdP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 May 2022 07:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238682AbiEJLdN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 May 2022 07:33:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED17B24BB1C
        for <linux-btrfs@vger.kernel.org>; Tue, 10 May 2022 04:29:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AEE9021BB1;
        Tue, 10 May 2022 11:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652182155;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VTNw9a4bRarxegeE3tlhGZfduDHKGWdxRV3EB00Buxc=;
        b=HtdOm9x96riEoDx1gCE+AGPNl4WteZubX24z8ArGaNqPbM+oEaLrETCWhQLvmsq+3PyO5B
        f7TnGldaTpsFLu3gKsZLXrDHYOYZNvpqhWsAKxWUUVQdEL1puCWMHO7mdeyVSpM2Pgwq1z
        7cuLo1Q0La1M49m9GEkVKGzIb8gKIyw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652182155;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VTNw9a4bRarxegeE3tlhGZfduDHKGWdxRV3EB00Buxc=;
        b=zOOfUCFaFkLunRysLVDcYCOMhFvZLSaVDHRCmeOfi/WJMeAbpPF1g/MvW9VSq90lnt3fEK
        TX3SiSwf2jd9KJCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9292C13AA5;
        Tue, 10 May 2022 11:29:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Y6DXIotMemIDawAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 10 May 2022 11:29:15 +0000
Date:   Tue, 10 May 2022 13:25:01 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add "0x" prefix for unsupported optional features
Message-ID: <20220510112501.GK18596@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <bc87beb85ce5b31157385eb2bc55a0bfacefc9d4.1652166589.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc87beb85ce5b31157385eb2bc55a0bfacefc9d4.1652166589.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 10, 2022 at 03:10:18PM +0800, Qu Wenruo wrote:
> The following error message lack the "0x" obviously:
> 
>   cannot mount because of unsupported optional features (4000)
> 
> Just add the prefix before any complains.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next and tagged for stable as older kernels are more
likely to encounter unknown features.
