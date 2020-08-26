Return-Path: <SRS0=f55l=CE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37154C433E3
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 10:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 226BA206EB
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 10:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgHZKt2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 06:49:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:42886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728586AbgHZKtY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Aug 2020 06:49:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8E342AC82;
        Wed, 26 Aug 2020 10:49:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 93232DA730; Wed, 26 Aug 2020 12:48:14 +0200 (CEST)
Date:   Wed, 26 Aug 2020 12:48:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] btrfs: Remove unused variable 'fs_info'
Message-ID: <20200826104814.GB28318@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, YueHaibing <yuehaibing@huawei.com>,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200826062752.20912-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200826062752.20912-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 26, 2020 at 02:27:52PM +0800, YueHaibing wrote:
> fs/btrfs/volumes.c: In function ‘btrfs_rm_dev_replace_free_srcdev’:
> fs/btrfs/volumes.c:2217:24: warning: unused variable ‘fs_info’ [-Wunused-variable]
>   struct btrfs_fs_info *fs_info = srcdev->fs_info;
>                         ^~~~~~~
> 
> Caused by commit 65237ee3b6b3 ("btrfs: get fs_info from device
> in btrfs_rm_dev_replace_free_srcdev")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Fixed in for-next, thanks.
