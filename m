Return-Path: <SRS0=AaGw=3S=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09F0C2D0DB
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jan 2020 13:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9056720716
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jan 2020 13:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgA2Npm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 08:45:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:34874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgA2Npl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Jan 2020 08:45:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 30D95AD3A;
        Wed, 29 Jan 2020 13:45:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 38EA2DA730; Wed, 29 Jan 2020 14:45:21 +0100 (CET)
Date:   Wed, 29 Jan 2020 14:45:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/3][v2] clean up how we mark block groups read only
Message-ID: <20200129134520.GD3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20200117140739.42560-1-josef@toxicpanda.com>
 <cda6acc2-b91e-c6f6-757e-92b5628cec29@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cda6acc2-b91e-c6f6-757e-92b5628cec29@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 29, 2020 at 02:05:33PM +0800, Qu Wenruo wrote:
> Hi David,
> 
> This is also an important patchset, mostly to solve the false ENOSPC
> from btrfs_inc_block_group_ro() calls.
> One obvious example is btrfs/182 test case.
> 
> Would you mind to merge it for misc-next?

No, I don't mind and various other patchsets are next first to be merged
once merge window ends.
