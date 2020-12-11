Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA01AC433FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Dec 2020 18:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4075723DE3
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Dec 2020 18:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732853AbgLKRDQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:03:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:42290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405125AbgLKRDA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Dec 2020 12:03:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C42B8ADCD;
        Fri, 11 Dec 2020 17:02:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 77B0CDA7C8; Fri, 11 Dec 2020 18:00:42 +0100 (CET)
Date:   Fri, 11 Dec 2020 18:00:41 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs-progs: fix invalid size check for extent items
Message-ID: <20201211170041.GN6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <c85b0bbcfff13bafec48f8cd266fb73b345c43c3.1605820453.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c85b0bbcfff13bafec48f8cd266fb73b345c43c3.1605820453.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 19, 2020 at 04:14:20PM -0500, Josef Bacik wrote:
> While trying to run down a corruption problem I needed to use
> btrfs-image to generate known good states in between tests.  At some
> point this started failing with
> 
> either extent tree is corrupted or deprecated extent ref format
> 
> This is because the fs had an extent item that was large enough that it
> no longer had inline extent references, they were all keyed extent
> references.  The check is bogus, we can have extent items that are >=
> the extent item size, not just > than the extent item size.  Fix the
> check so that we can generate metadata dumps properly.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to devel, thanks.
