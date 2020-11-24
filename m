Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7AEC2D0E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Nov 2020 15:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 020C82067C
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Nov 2020 15:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389695AbgKXPlU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 10:41:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:51142 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389364AbgKXPlU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Nov 2020 10:41:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 786E9AC2D;
        Tue, 24 Nov 2020 15:41:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8E97BDA818; Tue, 24 Nov 2020 16:39:50 +0100 (CET)
Date:   Tue, 24 Nov 2020 16:39:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove noinline attribute from wait_for_commit
Message-ID: <20201124153950.GA1803@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201124144502.3168362-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124144502.3168362-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 24, 2020 at 04:45:02PM +0200, Nikolay Borisov wrote:
> The function is a plain wrapper that noinline makes no sense.

Or it is a way to let the function name appear in a stack trace, which
could be useful for debugging or analyzing system state.
