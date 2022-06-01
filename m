Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15ABECCA473
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Jun 2022 20:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiFAUmY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 16:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiFAUmW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2022 16:42:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB1F323417
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2022 13:22:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DBF8E1F948;
        Wed,  1 Jun 2022 19:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654112649;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QAcU2VbQhjj+nlZ+1bvFiHMvObePCocQ/riYTrnKyzc=;
        b=Jz2TlPVZJzTIcAVeQ/CvOYMaZdEvebUdsg45DpQsiTj2kp988N65EO0BgOzKiKW3dgTBs+
        sCFKe2V4jCEZZMUX4EidEUN9bnrsES0lgGvd+WD5hid9pV8U4m+m8T5krCMyZIq3QsFRfl
        /UsRZJG1ECQ4jLn3pd566SBia9QpTqs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654112649;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QAcU2VbQhjj+nlZ+1bvFiHMvObePCocQ/riYTrnKyzc=;
        b=MFnrJHN5jcBk2GBuNV5cECr1ISI1PsFuvoZ2KgwljQGgQI/8IfOQICTes6eFibWJA0SH0R
        yd7yGNXE51vnJXBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BA0BC1330F;
        Wed,  1 Jun 2022 19:44:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hSKlLInBl2KUGAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 01 Jun 2022 19:44:09 +0000
Date:   Wed, 1 Jun 2022 21:39:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/10] btrfs: do not allocate a btrfs_bio for low-level
 bios
Message-ID: <20220601193943.GU20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20220526073642.1773373-1-hch@lst.de>
 <20220526073642.1773373-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526073642.1773373-11-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 26, 2022 at 09:36:42AM +0200, Christoph Hellwig wrote:
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -412,7 +412,10 @@ static inline void btrfs_bio_free_csum(struct btrfs_bio *bbio)
>  
>  struct btrfs_io_stripe {
>  	struct btrfs_device *dev;
> -	u64 physical;
> +	union {
> +		u64 physical;			/* block mapping */
> +		struct btrfs_io_context *bioc;	/* for the endio handler */

The preferred struct comment style is on a separate line, so

		/* Block mapping */
		u64 physical;
		/* For the endio handler */
		struct btrfs_io_context *bioc;

The mostly complete list of style preferences is in
https://btrfs.wiki.kernel.org/index.php/Development_notes#Coding_style_preferences
