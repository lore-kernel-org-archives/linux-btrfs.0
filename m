Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F9FC10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22ED920675
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388858AbfDRNmF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:42:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:44458 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389467AbfDRNmD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 09:42:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 138EEB690;
        Thu, 18 Apr 2019 13:42:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9D8F8DA871; Thu, 18 Apr 2019 15:43:06 +0200 (CEST)
Date:   Thu, 18 Apr 2019 15:43:05 +0200
From:   David Sterba <dsterba@suse.cz>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] btrfs: Remove set but not used variable 'fs_info'
Message-ID: <20190418134304.GN20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, YueHaibing <yuehaibing@huawei.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20190418064356.10418-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190418064356.10418-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 18, 2019 at 06:43:56AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> fs/btrfs/free-space-tree.c: In function 'load_free_space_tree':
> fs/btrfs/free-space-tree.c:1535:24: warning:
>  variable 'fs_info' set but not used [-Wunused-but-set-variable]
> 
> It's not used since commit 05e9d3137d47 ("btrfs: get fs_info from block group
> in search_free_space_info"),  so can be removed.

Thanks, as this is in a development branch I'll fold the change to the
patch that introduced it.
