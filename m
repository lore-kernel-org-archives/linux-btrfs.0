Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D166FC433EF
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jun 2022 16:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiF0QpD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 12:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbiF0QpC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Jun 2022 12:45:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337F5DF8E
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2022 09:45:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D0E661F962;
        Mon, 27 Jun 2022 16:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1656348299;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pe0bw++kqVfCX9ds1gVanRif0ZFDN7EmbSZPhHHNNQA=;
        b=WDWftMJIwZyLnDLmLaQNeazXX8s1VtupxFwcsRd4EMyymsO7fyTqVLUy2HYMANEM8lN0CQ
        NUxEo9UYbu1U+Zgij22UAtL90djBXVjZDN0pxxQt3pvVk+9ywqLjgjhgXu7+jQY+b1srNz
        aTIA1r2BD6NjU57ydhynaJBrKUW1Vmo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1656348299;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pe0bw++kqVfCX9ds1gVanRif0ZFDN7EmbSZPhHHNNQA=;
        b=UBGVNfKBYyK6SQAf+718taKUl9rxFY+q6Sa+bqagD6BZFFdao/gme7IdpZLCbVTPmwx61p
        AxlPSq//JsBW+kBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A87AF13456;
        Mon, 27 Jun 2022 16:44:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ukwyKIveuWJYdwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 27 Jun 2022 16:44:59 +0000
Date:   Mon, 27 Jun 2022 18:40:19 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: use u8 type for btrfs_block_rsv::type
Message-ID: <20220627164018.GZ20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <cover.1656079178.git.dsterba@suse.com>
 <2ff62613189d8f58f8da90a1558ad5726172057b.1656079178.git.dsterba@suse.com>
 <PH0PR04MB74165896B1D1967356A84A7A9BB99@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB74165896B1D1967356A84A7A9BB99@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 27, 2022 at 06:51:30AM +0000, Johannes Thumshirn wrote:
> On 24.06.22 16:15, David Sterba wrote:
> > diff --git a/fs/btrfs/block-rsv.h b/fs/btrfs/block-rsv.h
> > index 0702d4087ff6..bb449c75ee4c 100644
> > --- a/fs/btrfs/block-rsv.h
> > +++ b/fs/btrfs/block-rsv.h
> > @@ -27,7 +27,8 @@ struct btrfs_block_rsv {
> >  	spinlock_t lock;
> >  	bool full;
> >  	bool failfast;
> > -	unsigned short type;
> > +	/* Block reserve type, one of BTRFS_BLOCK_RSV_* */
> > +	u8 type;
> >  
> 
> Is there any reason to not use the enum?

Enum would be 'int', 4 bytes to the space optimization would be
lost. Enum types can be shortened as

	enum btrfs_reserve type:8

but I'm not sure it's an improvement.
