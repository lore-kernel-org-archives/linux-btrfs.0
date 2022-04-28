Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291DAC433F5
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Apr 2022 16:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349926AbiD1QuA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 12:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348684AbiD1Qt5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Apr 2022 12:49:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFAC4B855
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2022 09:46:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 737DF2186F;
        Thu, 28 Apr 2022 16:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651164400;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mJZjxCR/69F0qTYWQpskPPKpwne1oROpvYk7MwP1a1g=;
        b=tsrKnYwjMtX2e9HlExqFzPhshfKobDC33Ups84/UlcfHYlqwtWSsaqp9z13tSYOld0K9Rf
        kpqfDEZdw/PaYcNGxGqv3WW/xt/c6h620Cqr7Os5KL2b6umGxRSotwQFXVDH/P2G/cp2vy
        1in/13fjD6MP/rtGEiiead4h4o1dvQY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651164400;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mJZjxCR/69F0qTYWQpskPPKpwne1oROpvYk7MwP1a1g=;
        b=A25WGhQUV/DQq12Gm75lqPUyY8xLfdOBwnnuu37vG6hW98CpXcH09OKKgTF7lGk22PbFJf
        EMThEPxrEuXCe5CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 51CED13AF8;
        Thu, 28 Apr 2022 16:46:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Oyf1EvDEamKgKgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 28 Apr 2022 16:46:40 +0000
Date:   Thu, 28 Apr 2022 18:42:32 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, Dave Sterba <DSterba@suse.com>
Subject: Re: [PATCH] btrfs: Derive compression type from extent map during
 reads
Message-ID: <20220428164232.GE18596@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org, Dave Sterba <DSterba@suse.com>
References: <20220426134734.dxxdrf2hutbmimtc@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426134734.dxxdrf2hutbmimtc@fiona>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 26, 2022 at 08:47:34AM -0500, Goldwyn Rodrigues wrote:
> Derive the compression type from extent map as opposed to the bio flags
> passed. This makes it more precise and not reliant on function
> parameters.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Added to misc-next, thanks.
