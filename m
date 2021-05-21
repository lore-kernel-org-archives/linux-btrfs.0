Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4608C433B4
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 May 2021 12:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 937886108B
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 May 2021 12:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhEUM2e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 May 2021 08:28:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:41660 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhEUM2d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 May 2021 08:28:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1FEF4AC11;
        Fri, 21 May 2021 12:27:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BC818DA72C; Fri, 21 May 2021 14:24:35 +0200 (CEST)
Date:   Fri, 21 May 2021 14:24:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/2] btrfs_del_csums error handling fixes
Message-ID: <20210521122435.GG7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1621435862.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1621435862.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 19, 2021 at 10:52:44AM -0400, Josef Bacik wrote:
> Hello,
> 
> Here are two fixes related to deleting csums.  Doing error injection stress
> testing I was consistently seeing cases where we had a corrupt file system with
> csums that existed without the corresponding extents being written.  This was
> occuring because we were losing the return value in two cases, both of which
> would result in this style of corruption.  With these two patches I'm no longer
> seeing these errors.  Thanks,
> 
> Josef
> 
> Josef Bacik (2):
>   btrfs: fix error handling in btrfs_del_csums
>   btrfs: return errors from btrfs_del_csums in cleanup_ref_head

Added to misc-next, thanks.
