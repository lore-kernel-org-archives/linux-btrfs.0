Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497EDC433EF
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Jun 2022 20:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiFAU51 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 16:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiFAU5Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2022 16:57:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22B560D81
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2022 13:57:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7084521AC4;
        Wed,  1 Jun 2022 19:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654112301;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BSCNWv/em99pWtcR9FuzMqUGDSKVeF6m25ptmosBtM0=;
        b=AJ6q6xNbSqBCByvwbd0zJ6UvzX1Ocp2/Y46FKKPYVQn30LLWhcO9MsDZmm4hWMxYL4Kp0S
        XN/NzfXCnt0cG/zsu/9u1qI2mRzYnQMqEHqOowqP12mQvX/KtrItFOjE4xVAD/4NKvvt9k
        RaHywcFXBI8UzNgcwK0T/CHu7paUtWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654112301;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BSCNWv/em99pWtcR9FuzMqUGDSKVeF6m25ptmosBtM0=;
        b=i+db5JTd1uzkDSgGTn0uhJ0lwR+AbNmGhl1IxN6Kc5IshxeijUKDY9RggvuGM0IUxoIlMU
        ZTAHSDpp4gieQCCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47C191330F;
        Wed,  1 Jun 2022 19:38:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VBOEEC3Al2JpFgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 01 Jun 2022 19:38:21 +0000
Date:   Wed, 1 Jun 2022 21:33:55 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/10] btrfs: don't use btrfs_bio_wq_end_io for
 compressed writes
Message-ID: <20220601193355.GS20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20220526073642.1773373-1-hch@lst.de>
 <20220526073642.1773373-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526073642.1773373-7-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 26, 2022 at 09:36:38AM +0200, Christoph Hellwig wrote:
> -	/* for reads, this is the bio we are copying the data into */
> -	struct bio *orig_bio;
> +	union {
> +		/* for reads, this is the bio we are copying the data into */

Comments should start witha capital letter unelss it's referring to an
identifier.

> +		struct bio *orig_bio;
> +		struct work_struct write_end_work;
> +	};
>  
>  	/*
>  	 * the start of a variable length array of checksums only
