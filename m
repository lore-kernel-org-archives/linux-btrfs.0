Return-Path: <SRS0=YQmm=C2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DACCC43461
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Sep 2020 12:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2531B206BE
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Sep 2020 12:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgIQMzV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 08:55:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:36174 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbgIQMzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Sep 2020 08:55:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1FA82AC3C;
        Thu, 17 Sep 2020 12:55:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C904DDA7C7; Thu, 17 Sep 2020 14:53:54 +0200 (CEST)
Date:   Thu, 17 Sep 2020 14:53:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     YueHaibing <yuehaibing@huawei.com>, clm@fb.com,
        josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] btrfs: Make btrfs_sysfs_add_fs_devices static
Message-ID: <20200917125354.GT1791@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        YueHaibing <yuehaibing@huawei.com>, clm@fb.com,
        josef@toxicpanda.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200916142604.37744-1-yuehaibing@huawei.com>
 <9d4c2521-338a-8bce-46a7-b48818ddad66@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d4c2521-338a-8bce-46a7-b48818ddad66@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Sep 17, 2020 at 09:47:24AM +0800, Anand Jain wrote:
> 
> 
> 
> On 16/9/20 10:26 pm, YueHaibing wrote:
> > Fix sparse warning:
> > 
> > fs/btrfs/sysfs.c:1386:5: warning:
> >   symbol 'btrfs_sysfs_add_fs_devices' was not declared. Should it be static?
> 
> 
>   misc-next branch has it declared static. It was fixed later.

Yeah it's fixed, the k.org for-next got a bit behind the snapshot
branches, I'll do an update today.
