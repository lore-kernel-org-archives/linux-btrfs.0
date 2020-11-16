Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08291C63699
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Nov 2020 15:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C142620888
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Nov 2020 15:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbgKPPiN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 10:38:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:34418 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730522AbgKPPiN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Nov 2020 10:38:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 658D7AC0C;
        Mon, 16 Nov 2020 15:38:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E21FCDA6E3; Mon, 16 Nov 2020 16:36:27 +0100 (CET)
Date:   Mon, 16 Nov 2020 16:36:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove useless statement in split_node
Message-ID: <20201116153627.GN6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201112112402.784923-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112112402.784923-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 12, 2020 at 01:24:02PM +0200, Nikolay Borisov wrote:
> At the point when we set 'ret = 0' it's guaranteed that the function is
> going to return 0 so directly return 0. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to misc-next, thanks.
