Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7927CC77B61
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Apr 2023 23:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344409AbjD0XOV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 19:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344325AbjD0XOU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2023 19:14:20 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F1D4680
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Apr 2023 16:14:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9F7CE21CBB;
        Thu, 27 Apr 2023 23:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1682637253;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vMpophVEwcf3F8rI6cogrSVF2Lz8n0LSYeZoElmoAO8=;
        b=bDoSraGDebWF99dlx4btU/F8T36ZpacBL6HlhpoVkJ2kdaPeTaLMuYHSclZGy6zzJ9P+5N
        Du0U08+bEl0mQOIlO0aHpFadSdxUwMiiY7Y/y9z/RUDD35zSoC9FgmOp9aNlK6VmlHJL1S
        2QQrhusIlnF2N2K5lubzMHOyq7zh3NQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1682637253;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vMpophVEwcf3F8rI6cogrSVF2Lz8n0LSYeZoElmoAO8=;
        b=f9vjq+LKEsGgjXMCnn0/g2taaVbVj80rNeSlpbLG4Gy5xPRpJuL5yGfNxvIWSlfhuHlu5P
        Qc7p/WhEbfZQEOBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 87D43138F9;
        Thu, 27 Apr 2023 23:14:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fGk5IMUBS2SoCQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 27 Apr 2023 23:14:13 +0000
Date:   Fri, 28 Apr 2023 01:13:59 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: improve sibling keys check failure report
Message-ID: <20230427231359.GJ19619@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1682505780.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1682505780.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 26, 2023 at 11:51:34AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This makes reporting of sibling key check failures more useful, by
> printing more exact stack traces in case the extent buffers are leaves
> and dumping the extent buffers. This is motivated by a recent report [1].
> More details on the changelogs of each patch.
> 
> [1] https://lore.kernel.org/linux-btrfs/20230423222213.5391.409509F4@e16-tech.com/
> 
> Filipe Manana (3):
>   btrfs: abort transaction when sibling keys check fails for leaves
>   btrfs: print extent buffers when sibling keys check fails
>   btrfs: tag as unlikely the key comparison when checking sibling keys

Added to misc-next, thanks.
