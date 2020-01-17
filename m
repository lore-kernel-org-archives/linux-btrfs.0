Return-Path: <SRS0=6qVc=3G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB5BC33CB1
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 13:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9F80206E6
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 13:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgAQNzs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:55:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:56816 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgAQNzs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Jan 2020 08:55:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4EDB6AE74;
        Fri, 17 Jan 2020 13:55:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5E374DA871; Fri, 17 Jan 2020 14:55:32 +0100 (CET)
Date:   Fri, 17 Jan 2020 14:55:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] btrfs: tests: Fix an NULL vs IS_ERR() test
Message-ID: <20200117135532.GE3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200117053432.k46ftoqf67dezauh@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117053432.k46ftoqf67dezauh@kili.mountain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 17, 2020 at 08:34:32AM +0300, Dan Carpenter wrote:
> The btrfs_alloc_dummy_device() function never returns NULL, it returns
> error pointers.
> 
> Fixes: 5d9a4f871168 ("btrfs: Add self-tests for btrfs_rmap_block")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, folded to the original patch.
