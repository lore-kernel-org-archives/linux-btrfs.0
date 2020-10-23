Return-Path: <SRS0=6VRt=D6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4123C388F9
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Oct 2020 16:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55EEF2192A
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Oct 2020 16:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751413AbgJWQQ0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 12:16:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:33204 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750251AbgJWQQ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Oct 2020 12:16:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D6476AD66;
        Fri, 23 Oct 2020 16:16:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1A2BDDA7F1; Fri, 23 Oct 2020 18:14:53 +0200 (CEST)
Date:   Fri, 23 Oct 2020 18:14:52 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: lookup global roots with our backref commit root
 helper
Message-ID: <20201023161452.GJ6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <d9fc7a26e9424237f3174bacc3e728f966c7562f.1603468749.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9fc7a26e9424237f3174bacc3e728f966c7562f.1603468749.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 23, 2020 at 11:59:53AM -0400, Josef Bacik wrote:
> I messed up with my backref commit root helper, I assumed we would only
> ever want to look up fs roots, but the relocation code now uses the
> backref code, and we can find data extents in the tree_root because of
> space cache v1.  Fix this by looking up the global root first, so we
> make sure to always find the root that we're looking for.
> 
> Fixes: f4f9794a5aa1 ("btrfs: add a helper to read the tree_root commit root for backref lookup")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> Dave, I assume you'll want to just fold this into the fixes, I just added the
> fixes so you knew what patch to roll this into.

Yep that works, folded, thanks.
