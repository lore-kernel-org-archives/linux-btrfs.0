Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC2CAC433ED
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Apr 2021 15:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98E2A613C9
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Apr 2021 15:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbhD0PsW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 11:48:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:59760 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhD0PsW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Apr 2021 11:48:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 21248B118;
        Tue, 27 Apr 2021 15:47:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7604EDA732; Tue, 27 Apr 2021 17:45:12 +0200 (CEST)
Date:   Tue, 27 Apr 2021 17:45:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Naohiro Aota <Naohiro.Aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 04/26] btrfs-progs: zoned: add new ZONED feature flag
Message-ID: <20210427154512.GJ7604@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>
References: <cover.1619416549.git.naohiro.aota@wdc.com>
 <c222a684214512e36fc721ee23ded5145bf9d89c.1619416549.git.naohiro.aota@wdc.com>
 <PH0PR04MB74167CC07BDF6C03906AC6999B429@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB74167CC07BDF6C03906AC6999B429@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 26, 2021 at 07:45:23AM +0000, Johannes Thumshirn wrote:
> On 26/04/2021 08:28, Naohiro Aota wrote:
> > diff --git a/common/fsfeatures.c b/common/fsfeatures.c
> > index 569208a9e5b1..c0793339b531 100644
> > --- a/common/fsfeatures.c
> > +++ b/common/fsfeatures.c
> > @@ -100,6 +100,14 @@ static const struct btrfs_feature mkfs_features[] = {
> >  		NULL, 0,
> >  		NULL, 0,
> >  		"RAID1 with 3 or 4 copies" },
> > +#ifdef BTRFS_ZONED
> > +	{ "zoned", BTRFS_FEATURE_INCOMPAT_ZONED,
> > +		"zoned",
> > +		NULL, 0,
> > +		NULL, 0,
> > +		NULL, 0,
> > +		"support Zoned devices" },
> > +#endif
> 
> Shouldn't we set the compat version to 5.12?
> I.e.:
> #ifdef BTRFS_ZONED
> 	{ "zoned", BTRFS_FEATURE_INCOMPAT_ZONED,
> 		"zoned",
> 		VERSION_TO_STRING2(5,12),
> 		NULL, 0,
> 		NULL, 0,
> 		"support Zoned devices" },
> #endif

Folded in, thanks.
