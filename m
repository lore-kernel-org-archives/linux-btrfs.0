Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC69C61DD8
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Nov 2020 15:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D704321D93
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Nov 2020 15:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgKPPQ6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 10:16:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:49474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730181AbgKPPQ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Nov 2020 10:16:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C4627ABF4;
        Mon, 16 Nov 2020 15:16:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4FB0ADA6E3; Mon, 16 Nov 2020 16:15:12 +0100 (CET)
Date:   Mon, 16 Nov 2020 16:15:12 +0100
From:   David Sterba <dsterba@suse.cz>
To:     xiakaixu1987@gmail.com
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] btrfs: remove the useless value assignment in
 block_rsv_release_bytes
Message-ID: <20201116151512.GJ6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, xiakaixu1987@gmail.com, clm@fb.com,
        josef@toxicpanda.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1605422363-14947-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605422363-14947-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Nov 15, 2020 at 02:39:23PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The variable qgroup_to_release is overwritten by the following if/else
> statement before it is used, so this assignment is useless. Remove it.

Again this lacks explanation why removing it is correct.
