Return-Path: <SRS0=tFs+=D4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFACC4363A
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Oct 2020 11:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AED0721741
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Oct 2020 11:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ia0iqF4L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441959AbgJULXu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Oct 2020 07:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439401AbgJULXt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Oct 2020 07:23:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88B8C0613CE;
        Wed, 21 Oct 2020 04:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3V0/Bb3LwjBu6uRAPXv5oMASy+tz1kgrI0sESWPAlSM=; b=Ia0iqF4Lnxi+SbMZ49oMYApzG5
        LFisTDWar7PM1eEprUl2N9H7nlX9P9C8kog2pBgEXPeRdquzNn6MEpuYVXlUuXD/TccPDrG1oh2a5
        czhSkctkDade+e+Z88kanhyr5i1Xc/B/YeY8uHQwf+/kjcSIEExhtf+Y11BsrgJKfc7QR5gv0uFry
        91ovM2tloEjlX8Uvr31H87Yx0ptl0yvJ1XTadV2NR3TBoDRaclYoTjlVr9Sjuko0edI4+Z1+Gkcew
        wLM7k+J6lqYU+mXAU/lfdP0wiiI0pCDr0dkpAss1TvGSL9uFC3Pg7nfz75Mw1XXv8gzIv+rT1r/hp
        sMY1UPgg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVCDb-0001gz-VU; Wed, 21 Oct 2020 11:23:48 +0000
Date:   Wed, 21 Oct 2020 12:23:47 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: UBSAN: shift-out-of-bounds in get_init_ra_size()
Message-ID: <20201021112347.GI20115@casper.infradead.org>
References: <SN4PR0401MB3598C9C5B4D7ED74E79F28A09B1C0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB3598C9C5B4D7ED74E79F28A09B1C0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 21, 2020 at 10:57:02AM +0000, Johannes Thumshirn wrote:
> Hi Willy,
> 
> I've encountered a USBSN [1] splat when running xfstests (hit it with generic/091)
> on the latest iteration of our btrfs-zoned patchset.
> 
> It doesn't look related to our patchset but it looks reproducible:

Seems pretty easy to understand ...

static unsigned long get_init_ra_size(unsigned long size, unsigned long max)
{
        unsigned long newsize = roundup_pow_of_two(size);

if you pass in a 'size' of 0:

unsigned long __roundup_pow_of_two(unsigned long n)
{
        return 1UL << fls_long(n - 1);
}

fls_long of ~0UL will return 64, and will produce the UBSAN splat.

Of course, this isn't the only value for which roundup_pow_of_two() will
produce an invalid result.  Anything with the top bit set will also produce
UB.  But it's the only one we care about, so just doing something like this:

-	unsigned long newsize = roundup_pow_of_two(size);
+	unsigned long newsize = size ? roundup_pow_of_two(size) : size;

would fix the ubsan splat.  Or maybe you should stop passing 0 to
get_init_ra_size()?  ;-)
