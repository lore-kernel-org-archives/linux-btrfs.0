Return-Path: <SRS0=lTFz=DA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801E8C2D0A8
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Sep 2020 09:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5556420725
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Sep 2020 09:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgIWJrB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 05:47:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:44874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgIWJrB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Sep 2020 05:47:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 87125AFCF;
        Wed, 23 Sep 2020 09:47:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8479ADA6E3; Wed, 23 Sep 2020 11:45:43 +0200 (CEST)
Date:   Wed, 23 Sep 2020 11:45:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Xiaofei Tan <tanxiaofei@huawei.com>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH] btrfs: block-group: fix a doc warning in block-group.c
Message-ID: <20200923094543.GL6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Xiaofei Tan <tanxiaofei@huawei.com>,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
References: <1600778241-24895-1-git-send-email-tanxiaofei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600778241-24895-1-git-send-email-tanxiaofei@huawei.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 22, 2020 at 08:37:21PM +0800, Xiaofei Tan wrote:
> Fix following warning caused by mismatch bewteen function parameters
> and comments.
> fs/btrfs/block-group.c:1649: warning: Function parameter or member 'fs_info' not described in 'btrfs_rmap_block'

IIRC there are way more formatting errors for the kernel-doc, so I'd
rather fix them in one patch. Also for static functions or internal
helpers the proper formatting is not that important as it's read by
people and the acual parameters are what matters.
