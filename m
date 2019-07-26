Return-Path: <SRS0=ht5M=VX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15F3C7618B
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Jul 2019 15:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 910C622BE8
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Jul 2019 15:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387747AbfGZPMt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Jul 2019 11:12:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:57000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727645AbfGZPMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jul 2019 11:12:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1BA92B11C;
        Fri, 26 Jul 2019 15:12:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2AE5CDA811; Fri, 26 Jul 2019 17:13:23 +0200 (CEST)
Date:   Fri, 26 Jul 2019 17:13:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Tejun Heo <tj@kernel.org>
Cc:     josef@toxicpanda.com, clm@fb.com, dsterba@suse.com,
        axboe@kernel.dk, jack@suse.cz, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCHSET v3 btrfs/for-next] btrfs: fix cgroup writeback support
Message-ID: <20190726151321.GF2868@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Tejun Heo <tj@kernel.org>,
        josef@toxicpanda.com, clm@fb.com, dsterba@suse.com, axboe@kernel.dk,
        jack@suse.cz, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190710192818.1069475-1-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710192818.1069475-1-tj@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 10, 2019 at 12:28:13PM -0700, Tejun Heo wrote:
> Hello,
> 
> This patchset contains only the btrfs part of the following patchset.
> 
>   [1] [PATCHSET v2 btrfs/for-next] blkcg, btrfs: fix cgroup writeback support
> 
> The block part has already been applied to
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/ for-linus
> 
> with some naming changes.  This patchset has been updated accordingly.

I'm going to add this patchset to for-next to get some testing coverage,
there are some comments pending, but that are changelog updates and
refactoring.
