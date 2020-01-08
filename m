Return-Path: <SRS0=jJu9=25=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1BDC282DD
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jan 2020 13:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B944320720
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jan 2020 13:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgAHNkv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 08:40:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:49116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgAHNkv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Jan 2020 08:40:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C0BC6AE07;
        Wed,  8 Jan 2020 13:40:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 47359DA791; Wed,  8 Jan 2020 14:40:37 +0100 (CET)
Date:   Wed, 8 Jan 2020 14:40:36 +0100
From:   David Sterba <dsterba@suse.cz>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] btrfs: remove set but not used variable
 'root_objectid'
Message-ID: <20200108134036.GE3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, YueHaibing <yuehaibing@huawei.com>,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200108125835.45768-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108125835.45768-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 08, 2020 at 08:58:35PM +0800, YueHaibing wrote:
> fs/btrfs/inode.c: In function btrfs_rename:
> fs/btrfs/inode.c:9196:6: warning: variable root_objectid set but not used [-Wunused-but-set-variable]
> 
> commit f8b3030e0807 ("btrfs: rework arguments of btrfs_unlink_subvol")
> left behind this unused variable.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Thanks, I'll fold it to the patch.
