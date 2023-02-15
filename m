Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F6CC636CC
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Feb 2023 20:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjBOUM7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Feb 2023 15:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBOUM6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2023 15:12:58 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316B11024C
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2023 12:12:57 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E30F21FD71;
        Wed, 15 Feb 2023 20:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1676491975;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j/z+Ah0MTQ9qLIg/4lLeWyZNbojAodVUsHGcboCRTaQ=;
        b=t+S8WMI/HMuTBDwxbgkexp7yNqyTT9/DO2GK+sxCo2xxleSDd6kj9+LjkJfUK4vI4RiQJY
        H6Wh9ZcnXIkXMtmT9iEKjR4CU4OudO7H8K4IjcHNVtNEL1t0/iVz9zsRu+D+ZyT3FwFa48
        pj0gJarmTGIwVIqgdU/CP+dRcAPufYQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1676491975;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j/z+Ah0MTQ9qLIg/4lLeWyZNbojAodVUsHGcboCRTaQ=;
        b=ZaDw4Y61heAFDSm6GJcyADCmSBiilvYGju27DYT/tU5SPGrSbySrUezhLxWgPk9gjSUV61
        2iBM9uhNLxebLXCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C6041134BA;
        Wed, 15 Feb 2023 20:12:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yuhpL8c87WMqGQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 15 Feb 2023 20:12:55 +0000
Date:   Wed, 15 Feb 2023 21:07:03 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] btrfs: replace btrfs_io_context::raid_map[] with
 a fixed u64 value
Message-ID: <20230215200703.GW28288@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1675743217.git.wqu@suse.com>
 <f82eed6746d19cf3bea15631a120648eadf20852.1675743217.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f82eed6746d19cf3bea15631a120648eadf20852.1675743217.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 07, 2023 at 12:26:15PM +0800, Qu Wenruo wrote:
> +		/* RAID5/6 */
> +		for (i = 0; i < nr_data_stripes; i++) {
> +			const u64 data_stripe_start = full_stripe_logical +
> +						(i << BTRFS_STRIPE_LEN_SHIFT);

BTRFS_STRIPE_LEN_SHIFT is from another patchset and there's no metion of
that dependency in the cover letter. I've converted that back to
(i * BTRFS_STRIPE_LEN).
