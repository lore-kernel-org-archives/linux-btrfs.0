Return-Path: <SRS0=R6Ud=C3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A053AC43463
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Sep 2020 12:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66D0A21582
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Sep 2020 12:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIRMJB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 08:09:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:40600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgIRMJB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Sep 2020 08:09:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1E192B1F6;
        Fri, 18 Sep 2020 12:09:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DF463DA6E0; Fri, 18 Sep 2020 14:07:46 +0200 (CEST)
Date:   Fri, 18 Sep 2020 14:07:46 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Low risc cleanups
Message-ID: <20200918120746.GC6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200918091553.29584-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918091553.29584-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 18, 2020 at 12:15:48PM +0300, Nikolay Borisov wrote:
> Here's an assortment of cleanups - mainly dealing with removing redundant
> arguments of some functions. Pretty self-explanatory.
> 
> Nikolay Borisov (5):
>   btrfs: Clean BTRFS_I usage in btrfs_destroy_inode
>   btrfs: Switch btrfs_remove_ordered_extent to btrfs_inode
>   btrfs: Sink inode argument in insert_ordered_extent_file_extent
>   btrfs: Remove inode argument from add_pending_csums
>   btrfs: Remove inode argument from btrfs_start_ordered_extent

Added to misc-next, thanks.
