Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D5FC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 16:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E809218DE
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 16:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbfABQlU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 11:41:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:43948 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729513AbfABQlU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 11:41:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6474FAD8A;
        Wed,  2 Jan 2019 16:41:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7EB55DA781; Wed,  2 Jan 2019 17:40:48 +0100 (CET)
Date:   Wed, 2 Jan 2019 17:40:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Julia Lawall <Julia.Lawall@lip6.fr>
Cc:     Chris Mason <clm@fb.com>, kernel-janitors@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/20] Btrfs: drop useless LIST_HEAD
Message-ID: <20190102164048.GZ23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Julia Lawall <Julia.Lawall@lip6.fr>,
        Chris Mason <clm@fb.com>, kernel-janitors@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
 <1545555435-24576-12-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545555435-24576-12-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Dec 23, 2018 at 09:57:06AM +0100, Julia Lawall wrote:
> Drop LIST_HEAD where the variable it declares is never used.
> 
> The uses were removed in 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC
> handling for balance"), but not the declaration.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier x;
> @@
> - LIST_HEAD(x);
>   ... when != x
> // </smpl>
> 
> Fixes: 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC handling for balance")
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Added to patch queue, thanks. I've dropepd the Fixes: line as it's not
really a fix that would need to go to stable. The original commit is
mentioned in the changelog which is IMHO sufficient.
