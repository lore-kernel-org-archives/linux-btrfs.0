Return-Path: <SRS0=iRg2=DB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B48CC4363D
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 15:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1262C2311A
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 15:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgIXPXn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 11:23:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:48162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgIXPXn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Sep 2020 11:23:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 41E88AC8B;
        Thu, 24 Sep 2020 15:23:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 44AAFDA6E3; Thu, 24 Sep 2020 17:22:25 +0200 (CEST)
Date:   Thu, 24 Sep 2020 17:22:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 0/2] Fix init for device stats for seed devices
Message-ID: <20200924152224.GY6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1600809318.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1600809318.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 22, 2020 at 05:18:28PM -0400, Josef Bacik wrote:
> v2->v3:
> - fixed the name and arguments in the first patch.
> - use goto out for the error case with seed devices.
> 
> v1->v2:
> - Rework initial fix to work with the new seed_list.
> - Add a follow up patch to address the fact that we were ignoring errors on
>   reading the device tree.
> 
> Hello,
> 
> We see a lot of messages in the fleet where we use seed devices because we're
> not init'ing the stats for seed devices properly.  I have an xfstest that shows
> this (which I need to update), and this patch fixes the problem.  It's
> relatively straightforward, simply init the stats on seed devices at the same
> time we init them on our primary devices.  Thanks,
> 
> Josef
> 
> Josef Bacik (2):
>   btrfs: init device stats for seed devices
>   btrfs: return error if we're unable to read device stats

Added to misc-next, thanks.
