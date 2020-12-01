Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5DA5C64E7B
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Dec 2020 17:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E50206D8
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Dec 2020 17:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgLARP3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 12:15:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:51052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbgLARP3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Dec 2020 12:15:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 35FC7AC2F;
        Tue,  1 Dec 2020 17:14:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A7747DA6E1; Tue,  1 Dec 2020 18:13:15 +0100 (CET)
Date:   Tue, 1 Dec 2020 18:13:15 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.cz, kernel-team@fb.com
Subject: Re: [PATCH] btrfs-progs: Sort main help menu
Message-ID: <20201201171315.GM6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Daniel Xu <dxu@dxuuu.xyz>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <e54b68968ee84f69fac0aa58db8495b99c845a82.1604103293.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e54b68968ee84f69fac0aa58db8495b99c845a82.1604103293.git.dxu@dxuuu.xyz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 30, 2020 at 05:15:20PM -0700, Daniel Xu wrote:
> `btrfs help` is quite long and requires scrolling. For someone
> who has a vague idea of what a subcommand is called but not quite sure,
> alphabetical listing can help them find what they're looking for faster.
> 
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>

Added to devel, thanks.
