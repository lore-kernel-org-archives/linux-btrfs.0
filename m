Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31565C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 14:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0183A2083D
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 14:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfB0OKg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 09:10:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:55916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726299AbfB0OKf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 09:10:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C55A0AA85;
        Wed, 27 Feb 2019 14:10:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A6DEADA83C; Wed, 27 Feb 2019 15:11:55 +0100 (CET)
Date:   Wed, 27 Feb 2019 15:11:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     Nikolay Borisov <n.borisov.lkml@gmail.com>,
        linux-btrfs@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH 0/5] Unify the return value of alloc/clone_extent_buffer()
Message-ID: <20190227141155.GL24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Nikolay Borisov <n.borisov.lkml@gmail.com>,
        linux-btrfs@vger.kernel.org, dan.carpenter@oracle.com
References: <20190222101645.4403-1-wqu@suse.com>
 <b676a401-2eeb-f105-d363-742137a13ded@gmail.com>
 <b132529d-1246-4cb4-202a-37bf84e7ba43@suse.de>
 <7845f981-dbc3-6160-a329-33f0014ba973@gmail.com>
 <1afaf198-afc7-ed19-51bd-09ea1eb2ac45@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1afaf198-afc7-ed19-51bd-09ea1eb2ac45@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 22, 2019 at 09:31:29PM +0800, Qu Wenruo wrote:
> >> Nope.
> >>
> >>         for (i = 0; i < num_pages; i++) {
> >>                 eb->pages[i] = alloc_page(GFP_NOFS);
> >>                 if (!eb->pages[i])
> >>                         goto err; <<< Page alloc failure here
> >>         }
> >> ...
> >> err:
> >>         for (; i > 0; i--)
> >>                 __free_page(eb->pages[i - 1]);
> >>         __free_extent_buffer(eb);
> >>         return NULL; << We got NULL.
> > 
> > Right, I was looking at the code AFTER having applied your patches. So I
> > agree with yout. However, the ordering of your patches and the
> > changelogs make it rather hard to understand. What I'd suggest regarding
> > the changelogs is - forget about unification, just say what you are
> > doing, which is always ensuring that an error is returned from
> > __alloc_extent_buffer in one patch - this should involve both changes to
> > __alloc_extent_buffer as well as it's (in)direct callers. Then you do
> > the same for other function. Otherwise review is somewhat hindered.
> 
> Makes sense.
> 
> I'll reword and reorder the patches.

Yes please, I'll have another look at the updated series. So far I agree
that the unification to IS_ERR/PTR_ERR is desired. For the plain
allocator functions that are only kmalloc+initialization it's generally
ok to return NULL and let the callers do the conversion to PTR_ERR.

In case of the eb functions, there are wrappers like
alloc_dummy_extent_buffer that only forward the return value so this
would be inconsistent and needs one to remember which functions return
what. For this reason I think it's ok to convert all.

Another question is how to do it, ideally as separate patches but the
callchains are deep and half conversion is not what we want. I'll need
to see new patches first.

Also please drop all mentions of the 'never returns NULL' in the
comments, except the function that does the GFP_NOFAIL.
