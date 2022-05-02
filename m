Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E077C433EF
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 May 2022 16:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243173AbiEBQeH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 May 2022 12:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243162AbiEBQeG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2022 12:34:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A015FFB
        for <linux-btrfs@vger.kernel.org>; Mon,  2 May 2022 09:30:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D086E1F388;
        Mon,  2 May 2022 16:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651509035;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=spW7xlNn3pCVp4PJbzycVBFtGSaU4tWTFjjO+r1DwvM=;
        b=KfiRrdD+tAO8bvLU6YQDtYhy7DIyc1X97WyU/izJUgbQ+2Ub+4ThxcyXO4XXh/9rhqaDov
        qNYajFS7Y8XULG+ij4bLTPtZdNEMBVRuW9WIqKQlWhzqeLnKi2yqJCPPyAcfswIjrHuRQB
        0Hd487QSNNAYWlVY4yvxc66iGqLZXfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651509035;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=spW7xlNn3pCVp4PJbzycVBFtGSaU4tWTFjjO+r1DwvM=;
        b=+PqRVMd09duGXYmKTLpm48PkCQjzaAh990T77aEHNjg2jcI8Uv6Z9avCWo1AsmMiWS+Ubs
        f3xCdQvo+5CXnrCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9D6AE13491;
        Mon,  2 May 2022 16:30:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SsmNJSsHcGJeagAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 02 May 2022 16:30:35 +0000
Date:   Mon, 2 May 2022 18:26:25 +0200
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 7/9] btrfs: rename io_failure_record::bio_flags to
 compress_type
Message-ID: <20220502162625.GL18596@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <cover.1651255990.git.dsterba@suse.com>
 <54b867c85b5891611c1a8f5a412abb06bbe5db61.1651255990.git.dsterba@suse.com>
 <PH0PR04MB74162830148A045DDBF6FB199BFE9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20220502151659.GK18596@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502151659.GK18596@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, May 02, 2022 at 05:16:59PM +0200, David Sterba wrote:
> On Sun, May 01, 2022 at 08:22:41PM +0000, Johannes Thumshirn wrote:
> > On 29/04/2022 11:32, David Sterba wrote:
> > > diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> > > index fdbfe801dbe2..1fa40ab561df 100644
> > > --- a/fs/btrfs/extent_io.h
> > > +++ b/fs/btrfs/extent_io.h
> > > @@ -266,7 +266,7 @@ struct io_failure_record {
> > >  	u64 start;
> > >  	u64 len;
> > >  	u64 logical;
> > > -	unsigned long bio_flags;
> > > +	unsigned int compress_type;
> > >  	int this_mirror;
> > >  	int failed_mirror;
> > >  };
> > 
> > 
> > Why 'unsigned int' and not 'enum btrfs_compression_type'?
> 
> Good point I'll change it, though it's not used almost anywhere else.

I'll fix up the 2 following patches as well, the type switch in parameters.
