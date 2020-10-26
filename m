Return-Path: <SRS0=jG/5=EB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB145C55178
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4C25206C1
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406110AbgJZX1j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:27:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:58504 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406106AbgJZX1i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Oct 2020 19:27:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BD86DABB2;
        Mon, 26 Oct 2020 23:27:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 29CC2DA6E2; Tue, 27 Oct 2020 00:26:03 +0100 (CET)
Date:   Tue, 27 Oct 2020 00:26:02 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 01/68] btrfs: extent-io-tests: remove invalid tests
Message-ID: <20201026232602.GV6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201021062554.68132-1-wqu@suse.com>
 <20201021062554.68132-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021062554.68132-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 21, 2020 at 02:24:47PM +0800, Qu Wenruo wrote:
> In extent-io-test, there are two invalid tests:
> - Invalid nodesize for test_eb_bitmaps()
>   Instead of the sectorsize and nodesize combination passed in, we're
>   always using hand-crafted nodesize.
>   Although it has some extra check for 64K page size, we can still hit
>   a case where PAGE_SIZE == 32K, then we got 128K nodesize which is
>   larger than max valid node size.
> 
>   Thankfully most machines are either 4K or 64K page size, thus we
>   haven't yet hit such case.
> 
> - Invalid extent buffer bytenr
>   For 64K page size, the only combination we're going to test is
>   sectorsize = nodesize = 64K.
>   In that case, we'll try to create an extent buffer with 32K bytenr,
>   which is not aligned to sectorsize thus invalid.
> 
> This patch will fix both problems by:
> - Honor the sectorsize/nodesize combination
>   Now we won't bother to hand-craft a strange length and use it as
>   nodesize.
> 
> - Use sectorsize as the 2nd run extent buffer start
>   This would test the case where extent buffer is aligned to sectorsize
>   but not always aligned to nodesize.

The code has evolved since it was added in 0f3312295d3ce1d823 ("Btrfs:
add extent buffer bitmap sanity tests") and "page * 4" is intentional to
provide buffer where the shifted bitmap is tested. The logic has not
changed, only the ppc64 case was added.

And I remember that tweaking this code tended to break on a real machine
so there are a few things that bother me:

- the test does something and I'm not sure it's invalid (I think it's
  not)
- test on a real 64k page machine is needed
- you reduce the scope of the test to fewer combinations

If there are combinations that would make it hard for the subpage then
it would be better to add it as an exception but otherwise the main
usecase is for 4K page and this allows more combinations to test.
