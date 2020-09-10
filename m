Return-Path: <SRS0=1Lxm=CT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB44C433E2
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Sep 2020 19:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 077BF206DB
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Sep 2020 19:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgIJTUg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 15:20:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:40646 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730940AbgIJPyU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Sep 2020 11:54:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4E0B1AA55;
        Thu, 10 Sep 2020 15:54:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6FFCBDA730; Thu, 10 Sep 2020 17:53:03 +0200 (CEST)
Date:   Thu, 10 Sep 2020 17:53:03 +0200
From:   David Sterba <dsterba@suse.cz>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        nborisov@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] btrfs: Remove unused function
 calc_global_rsv_need_space()
Message-ID: <20200910155303.GK18399@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, YueHaibing <yuehaibing@huawei.com>,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        nborisov@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200909135142.27352-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909135142.27352-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 09, 2020 at 09:51:42PM +0800, YueHaibing wrote:
> It is not used since commit 0096420adb03 ("btrfs: do not
> account global reserve in can_overcommit")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Added to misc-next, thanks.
