Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5407DC433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B71F22D08
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbhASWqm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 17:46:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:55706 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729001AbhASWqa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jan 2021 17:46:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 50648AAAE;
        Tue, 19 Jan 2021 22:45:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 76A72DA6E3; Tue, 19 Jan 2021 23:43:53 +0100 (CET)
Date:   Tue, 19 Jan 2021 23:43:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/13] btrfs: Fix function description format
Message-ID: <20210119224353.GU6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210119122649.187778-1-nborisov@suse.com>
 <20210119122649.187778-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119122649.187778-4-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 19, 2021 at 02:26:39PM +0200, Nikolay Borisov wrote:
> This fixes following W=1 warnings:
> 
> fs/btrfs/file-item.c:27: warning: Cannot understand  * @inode:  the inode we want to update the disk_i_size for
>  on line 27 - I thought it was a doc line
> fs/btrfs/file-item.c:65: warning: Cannot understand  * @inode - the inode we're modifying
>  on line 65 - I thought it was a doc line
> fs/btrfs/file-item.c:91: warning: Cannot understand  * @inode - the inode we're modifying
>  on line 91 - I thought it was a doc line
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/file-item.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 6ccfc019ad90..868b27e887b1 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -24,8 +24,10 @@
>  				       PAGE_SIZE))
>  
>  /**
> - * @inode - the inode we want to update the disk_i_size for
> - * @new_i_size - the i_size we want to set to, 0 if we use i_size
> + * btrfs_inode_safe_disk_i_size_write

This is the part I don't like about kdoc but as we've talked about that,
we can use a less strict formatting and follow this scheme:

/**
 * Function summary description in one or two sentences.
 *
 * @param1:    description
 * @param2:    description
 *
 * Long description of the function.
 *
 * Return value semantics
 */

The kdoc checker is fine with the first line and validates the
arguments, which is what we want. The validator can be enabled at build
time as well by adding

cmd_checkdoc = $(srctree)/scripts/kernel-doc -none $<

to our Makefile.

> + *
> + * @inode:  the inode we want to update the disk_i_size for
> + * @new_i_size: the i_size we want to set to, 0 if we use i_size

Please align the descriptions
