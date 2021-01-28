Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75AE4C433DB
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Jan 2021 10:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E8D864DD6
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Jan 2021 10:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhA1KrX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 05:47:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:34504 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231264AbhA1KrU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jan 2021 05:47:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3F663AC45;
        Thu, 28 Jan 2021 10:46:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 42982DA7D9; Thu, 28 Jan 2021 11:44:50 +0100 (CET)
Date:   Thu, 28 Jan 2021 11:44:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Abaci Team <abaci-bugfix@linux.alibaba.com>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Simplify the calculation of variables
Message-ID: <20210128104450.GH1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Abaci Team <abaci-bugfix@linux.alibaba.com>, clm@fb.com,
        josef@toxicpanda.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1611735097-101599-1-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611735097-101599-1-git-send-email-abaci-bugfix@linux.alibaba.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 27, 2021 at 04:11:37PM +0800, Abaci Team wrote:
> Fix the following coccicheck warnings:
> 
> ./fs/btrfs/delayed-inode.c:1157:39-41: WARNING !A || A && B is
> equivalent to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Suggested-by: Jiapeng Zhong <oswb@linux.alibaba.com>
> Signed-off-by: Abaci Team <abaci-bugfix@linux.alibaba.com>

Added to misc-next, thanks.
