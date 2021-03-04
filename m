Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2C8C4332E
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Mar 2021 16:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4253F64F59
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Mar 2021 16:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbhCDQyN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 11:54:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:43894 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238641AbhCDQyA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Mar 2021 11:54:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CECFBAC1F;
        Thu,  4 Mar 2021 16:53:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CBF23DA81D; Thu,  4 Mar 2021 17:51:22 +0100 (CET)
Date:   Thu, 4 Mar 2021 17:51:22 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] btrfs: add btree read ahead for send operations
Message-ID: <20210304165122.GS7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <cover.1614351671.git.fdmanana@suse.com>
 <cover.1614590582.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1614590582.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 01, 2021 at 09:26:41AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This patchset adds btree read ahead for full and incremental send operations,
> which results in some nice speedups. Test and results are mentioned in the
> change log of each patch.

Thanks, added to misc-next. The first patch has probably the best ratio
of changed lines vs performance gain.
