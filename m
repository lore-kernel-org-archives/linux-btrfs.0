Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF304C32789
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 12:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91AAE2086C
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 12:12:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91AAE2086C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbeKHVr1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:47:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:52698 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726405AbeKHVr1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 16:47:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB544B072;
        Thu,  8 Nov 2018 12:12:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B2AC5DAC61; Thu,  8 Nov 2018 13:11:59 +0100 (CET)
Date:   Thu, 8 Nov 2018 13:11:59 +0100
From:   David Sterba <dsterba@suse.cz>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] btrfs: remove set but not used variable 'tree'
Message-ID: <20181108121159.GH24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, YueHaibing <yuehaibing@huawei.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <1541643283-109411-1-git-send-email-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541643283-109411-1-git-send-email-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 08, 2018 at 02:14:43AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> fs/btrfs/extent_io.c: In function 'end_extent_writepage':
> fs/btrfs/extent_io.c:2406:25: warning:
>  variable 'tree' set but not used [-Wunused-but-set-variable]
> 
> It not used any more after
> commit 2922040236f9 ("btrfs: Remove extent_io_ops::writepage_end_io_hook")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Thanks, the patches are still out of mainline so the commit id is not
stable and I can fold in the fixup. Same for the other one.
