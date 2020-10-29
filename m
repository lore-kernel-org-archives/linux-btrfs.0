Return-Path: <SRS0=/Od+=EE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543A7C2D0A3
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Oct 2020 23:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCC842074A
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Oct 2020 23:34:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rere.qmqm.pl header.i=@rere.qmqm.pl header.b="NP//49X0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgJ2Xem (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 19:34:42 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:30784 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ2Xel (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Oct 2020 19:34:41 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4CMhcH5l0sz4K;
        Fri, 30 Oct 2020 00:34:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1604014479; bh=YpSLTTDehGE7OsVNogX89Rg1fBfEWPzF9RmcsNHBnU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NP//49X00FXSix6qWViWiRY63t4Uw+zmGlzv1pBPDZwiK656jQJIAJLjD17Wf3JjF
         YiV/ZuMIYRVUM94w7oKHQHQ8ekRD7leM6xQK9u5wct36lmk83qb1b7Hau2jN8MCB9u
         FMk+hMhzfLwtB+UsciE9Z905ItvHApapd2oZImdcS1vk+r2ew8l+Cwo9dY4yLDniaU
         1/gtzeMEjbDY0ZpmWQHgPh3CJVjzvlTJpMuTJD4i3gR2J+RRo3wtpv4X9eBR95oE/8
         y4OWe7fNVOM+OGcs3Q2LAUTVgZDUnr5i3GtGNWVRHO66jg+AmDYNzB9GXpq08FkxE+
         Sknl0hDKU3Ciw==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.102.4 at mail
Date:   Fri, 30 Oct 2020 00:34:38 +0100
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 42/68] btrfs: allow RO mount of 4K sector size fs on
 64K page system
Message-ID: <20201029233438.GA30165@qmqm.qmqm.pl>
References: <20201021062554.68132-1-wqu@suse.com>
 <20201021062554.68132-43-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201021062554.68132-43-wqu@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 21, 2020 at 02:25:28PM +0800, Qu Wenruo wrote:
> This adds the basic RO mount ability for 4K sector size on 64K page
> system.
> 
> Currently we only plan to support 4K and 64K page system.
[...]

Why this restriction? I briefly looked at this patch and some of the
previous and it looks like the code doesn't really care about anything
more than order(PAGE_SIZE) >= order(sectorsize).

Best Regards,
Micha³ Miros³aw
