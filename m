Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7887C4338F
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Aug 2021 14:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C405060F41
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Aug 2021 14:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241665AbhHJOIH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 10:08:07 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33682 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237375AbhHJOIG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Aug 2021 10:08:06 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A3D0A22062;
        Tue, 10 Aug 2021 14:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1628604463;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DMs8nU2YD+I63e26L5U8N070O+IQMQlSVoygDwr3Uvw=;
        b=ejDPTWR/eg3J4pM9qmPRjnZmy1CrbHXU+e8FC6FCYHevR4gosTaO97lhratox4wa6IdQzw
        Alcn5uqkHTo9V59my6MPQdfrKJBojdSBpgV1yzAxr7n0WKr9DbKs3uA7c8h9r1LQiTNCxE
        +Yl3ZDox9UC41YkS+Hdbn/kTVSyjxgE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1628604463;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DMs8nU2YD+I63e26L5U8N070O+IQMQlSVoygDwr3Uvw=;
        b=1A6Swlb4XGuY/JkIBhVjKtQu2/8ze2+baDutUG3lk8NLH3jRNI5rowxkD3E7IZNT0rbbtH
        KOBtaqQJSbwDNYBA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 4B555A3B88;
        Tue, 10 Aug 2021 14:07:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 23065DA880; Tue, 10 Aug 2021 16:04:51 +0200 (CEST)
Date:   Tue, 10 Aug 2021 16:04:51 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: zoned: add ASSERTs on splitting extent_map
Message-ID: <20210810140451.GW5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Filipe Manana <fdmanana@suse.com>
References: <20210809002918.2686884-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809002918.2686884-1-naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 09, 2021 at 09:29:18AM +0900, Naohiro Aota wrote:
> We call split_zoned_em() on an extent_map on submitting a bio for it. Thus,
> we can assume the extent_map is PINNED, not LOGGING, and in the modified
> list. Add ASSERT()s to ensure the  extent_maps after the split also has the
> proper flags set and are in the modified list.
> 
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Suggested-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Added to misc-next, thanks.
