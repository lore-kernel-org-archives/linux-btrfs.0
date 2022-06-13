Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DA5C43334
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 Jun 2022 19:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344038AbiFMTyT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344519AbiFMTyD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Jun 2022 15:54:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D659AE71
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jun 2022 11:25:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 18A1A21AFB;
        Mon, 13 Jun 2022 18:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655144707;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kqANefmTiNy9E8yunobFxwQ8QDWMn2XaQS5N/mO/buk=;
        b=gApU8myCYl0W15ar+W/vm930ijpajLoyiM+shIXTjgE1uXff8EjzmcSIQ6I55Y6TEqArVK
        xDEtG4SGlk26wDW3LmDVs6kpMsuFias8ol/+SLWORFNxkqA41X80rGrQdpQvyoWPxVQynJ
        eUZsayOPfffXwlv7gULrWHRg/2e7v08=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655144707;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kqANefmTiNy9E8yunobFxwQ8QDWMn2XaQS5N/mO/buk=;
        b=1LNvGDXcUwUFU9HXoyb4QO4V0nIVzlCHqMRS/OiIevjJyOIGrbXLuh/Dyi+fGNlPNTdbg+
        vSwiQSL28ZvYq3CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E11E6134CF;
        Mon, 13 Jun 2022 18:25:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qF7wNQKBp2L7HAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 13 Jun 2022 18:25:06 +0000
Date:   Mon, 13 Jun 2022 20:20:34 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: cleanup related to the 1MiB reserved space
Message-ID: <20220613182034.GC20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1655103954.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1655103954.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 13, 2022 at 03:06:33PM +0800, Qu Wenruo wrote:
> The 1MiB reserved space is only introduced in v4.1 btrfs-progs, and
> kernel has the same reserved space around the same time.

Kernel had this since the beginnning, or do you have pointer for the
commits? I know that progs wrongly allocated some of the tree roots
under 1M and this got fixed, but otherwise kernel never used the 1st
megabyte for allocations.

> But there are two small nitpicks:
> 
> - Kernel never has a unified MACRO for this
>   We just use SZ_1M, with extra comments on this.
> 
>   This makes later write-intent bitmap harder to implement, as the
>   incoming write-intent bitmap will enlarge the reserved space to
>   2MiB, and use the extra 1MiB for write-intent bitmap.
>   (of course with extra RO compat flags)
> 
>   This will be addressed in the first patch, with a new
>   BTRFS_DEFAULT_RESERVED macro.

Cleaning up the raw 1M value and the comments makes sense, but I'm not
sure about making it dynamic. We used to have mount option and mkfs
parameter alloc_offset and it got removed.

>   Later write-intent bitmap code will use BTRFS_DEFAULT_RESERVED as a
>   beacon to ensure btrfs never touches the enlarged reserved space.

Ok, I'll wait with further comments until I see the patches.
