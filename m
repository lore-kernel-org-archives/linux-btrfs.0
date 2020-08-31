Return-Path: <SRS0=0DI8=CJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D4CC433E6
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 15:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 484B5207EA
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 15:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgHaPLg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 11:11:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:41096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgHaPKv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Aug 2020 11:10:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2247AB686;
        Mon, 31 Aug 2020 15:10:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id ED6D7DA840; Mon, 31 Aug 2020 17:09:38 +0200 (CEST)
Date:   Mon, 31 Aug 2020 17:09:38 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org,
        Tyler Richmond <t.d.richmond@gmail.com>
Subject: Re: [PATCH 0/3] btrfs-progs: check: add inode invalid transid detect
 and repair support
Message-ID: <20200831150938.GA28318@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Tyler Richmond <t.d.richmond@gmail.com>
References: <20200826005233.90063-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826005233.90063-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 26, 2020 at 08:52:30AM +0800, Qu Wenruo wrote:
> Really nothing interesting here for btrfs-progs, just reusing existing
> inode generation detect and repair code.
> 
> The interesting part is, how a wrongly copied error message delayed us
> so long to locate a bug.
> 
> Reported-by: Tyler Richmond <t.d.richmond@gmail.com>
> 
> Qu Wenruo (3):
>   btrfs-progs: check/lowmem: add inode transid detect and repair support
>   btrfs-progs: check/original: add inode transid detect and repair
>     support
>   btrfs-progs: tests/fsck: add test image for inode transid repair

Added to devel, thanks.
