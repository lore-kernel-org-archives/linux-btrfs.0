Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F05EECAAD5
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Sep 2022 15:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbiIEPr2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Sep 2022 11:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237327AbiIEPr1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2022 11:47:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB8F5AC7C
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Sep 2022 08:47:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 871E51FAA3;
        Mon,  5 Sep 2022 15:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662392845;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uuphyaou6NjG+OuPxbJF5gNzHSz0uaEImPkavaeL9m4=;
        b=wEALsG5Mav49nhDFAkNsd/e2vXroz/17y6NsJMLqQm0Th/IIYD/4KIgH+026RoT9RGG2Aj
        OxTa4vwVu6PZfd/FG63vYFzcHAR8csOiDzpNHQRNoKO0O4b7BTx2oLGirts/wyz6cG1sF1
        aIGK3X/UeByM88vxo5r5XNiX+tPe7s8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662392845;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uuphyaou6NjG+OuPxbJF5gNzHSz0uaEImPkavaeL9m4=;
        b=8g30Y7Zt49OgWmwa1OQxOiaH8JvcyQR1aBHa+C/8sCyguj0ERrvOqBFf8XvJ37v/uE/Sua
        zadRSWjf9d58HQCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6089D139C7;
        Mon,  5 Sep 2022 15:47:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id u8LDFg0aFmPGYgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 05 Sep 2022 15:47:25 +0000
Date:   Mon, 5 Sep 2022 17:42:03 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: for-next: KCSAN failures on 6130a25681d4 (kdave/for-next) Merge
 branch 'for-next-next-v5.20-20220804' into for-next-20220804
Message-ID: <20220905154203.GJ13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <YvHU/vsXd7uz5V6j@hungrycats.org>
 <CAL3q7H7XCZnsCfiz9yAgfSP8rekx7YntVKphdDu8LLSehJ1EAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7XCZnsCfiz9yAgfSP8rekx7YntVKphdDu8LLSehJ1EAQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 09, 2022 at 08:35:42AM +0100, Filipe Manana wrote:
> On Tue, Aug 9, 2022 at 4:33 AM Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> >
> > Some KCSAN complaints I found while testing for other things...
> >
> > Here's one related to extent refs:
> 
> It's about the block reserves, nothing to do with extents refs.
> 
> These get reported every now and then like here:
> 
> https://lore.kernel.org/linux-btrfs/CAAwBoOJDjei5Hnem155N_cJwiEkVwJYvgN-tQrwWbZQGhFU=cA@mail.gmail.com/
> 
> It's actually harmless, but if we keep it like this, we'll keep
> getting reports in the future.

Can we add some kind of annotation so KCSAN understands that? The ->full
member would be accessed using a helper when outside of the lock so the
annotation can be there.
