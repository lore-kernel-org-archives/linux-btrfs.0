Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9730DC433E0
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Mar 2021 17:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6771F64F5F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Mar 2021 17:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbhCDRi3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 12:38:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:43612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239217AbhCDRiB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Mar 2021 12:38:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DDD58AE1C
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Mar 2021 17:37:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C82AEDA81D; Thu,  4 Mar 2021 18:35:23 +0100 (CET)
Date:   Thu, 4 Mar 2021 18:35:23 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove mirror argument from
 btrfs_csum_verify_data()
Message-ID: <20210304173523.GU7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org
References: <20210303125537.x2moj2kocknnsm6n@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303125537.x2moj2kocknnsm6n@fiona>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 03, 2021 at 06:55:37AM -0600, Goldwyn Rodrigues wrote:
> Unused variable: mirror.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Added to misc-next, thanks.
