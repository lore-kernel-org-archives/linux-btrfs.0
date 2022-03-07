Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48D1C433EF
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Mar 2022 14:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241255AbiCGOaR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 09:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiCGOaQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2022 09:30:16 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C6824BCB
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Mar 2022 06:29:22 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D48FF210F2;
        Mon,  7 Mar 2022 14:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1646663360;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UYqpmIKwM9wyOGNDOAYXiNsAI6VYnrpkee3B9dag/lc=;
        b=kD8V+pTpYifTUoA/oM6vtzGvLliQMCTIDcDpCZ4IMRXW4QeY9nOZckDlv/6Or6bK162+zi
        o/HhMGXAlj/c33jAU6kO6FkYz1UtMLcL+kc4HToh+0iVwjFzx1X9QCHTHrT/RqTWfbEsyz
        qEG6OQ39MwNGO1vrlUMeiic+EVx85+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1646663360;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UYqpmIKwM9wyOGNDOAYXiNsAI6VYnrpkee3B9dag/lc=;
        b=YxAfKuEI8/vntop71Zm5RGqMPO6FlVvULhigiW9COWjcEzHEOIKBf5Wl8xv+l/AiPxR1lD
        UqHBBSwqYApY/cBg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id CCB2FA3B81;
        Mon,  7 Mar 2022 14:29:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 575AADA7F7; Mon,  7 Mar 2022 15:25:26 +0100 (CET)
Date:   Mon, 7 Mar 2022 15:25:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] btrfs: zoned: two independent fixes for zoned
 btrfs
Message-ID: <20220307142526.GG12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1646649873.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1646649873.git.johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 07, 2022 at 02:47:16AM -0800, Johannes Thumshirn wrote:
> Two small and independent fixes for problems found while debugging other
> issues on zoned btrfs.
> 
> The first one is a possible deadlock and the second one is for removing
> leftover ASSERT()s.
> 
> Changes since v1:
> - Remove unrelated hunks
> 
> Johannes Thumshirn (2):
>   btrfs: zoned: use rcu list in btrfs_can_activate_zone
>   btrfs: zoned: remove left over ASSERT()

Added to misc-next, thanks.
