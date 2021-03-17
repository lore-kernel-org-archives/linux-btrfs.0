Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED55C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Mar 2021 17:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE75C64E90
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Mar 2021 17:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCQRHv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Mar 2021 13:07:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:59406 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhCQRHf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Mar 2021 13:07:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BD68CAE27;
        Wed, 17 Mar 2021 17:07:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 99686DA6E2; Wed, 17 Mar 2021 18:05:31 +0100 (CET)
Date:   Wed, 17 Mar 2021 18:05:31 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Victor Erminpour <victor.erminpour@oracle.com>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Use immediate assignment when referencing
 cc-option
Message-ID: <20210317170531.GU7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Victor Erminpour <victor.erminpour@oracle.com>, clm@fb.com,
        josef@toxicpanda.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1615997328-24677-1-git-send-email-victor.erminpour@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615997328-24677-1-git-send-email-victor.erminpour@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 17, 2021 at 09:08:48AM -0700, Victor Erminpour wrote:
> Calling cc-option will use KBUILD_CFLAGS, which when lazy setting
> subdir-ccflags-y produces the following build error:
> 
> scripts/Makefile.lib:10: *** Recursive variable `KBUILD_CFLAGS' \
> 	references itself (eventually).  Stop.
> 
> Use single := assignment for subdir-ccflags-y. The cc-option calls
> are done right away and we don't end up with KBUILD_CFLAGS
> referencing itself.
> 
> Signed-off-by: Victor Erminpour <victor.erminpour@oracle.com>
> ---
>  fs/btrfs/Makefile | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
> index b634c42115ea..583ca2028e08 100644
> --- a/fs/btrfs/Makefile
> +++ b/fs/btrfs/Makefile
> @@ -1,16 +1,16 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
>  # Subset of W=1 warnings
> +subdir-ccflags-y := $(call cc-option, -Wunused-but-set-variable) \
> +	$(call cc-option, -Wunused-const-variable) \
> +	$(call cc-option, -Wpacked-not-aligned) \
> +	$(call cc-option, -Wstringop-truncation)

That's still overwriting the value unconditionally, the idea was a
separate variable

https://lore.kernel.org/linux-btrfs/20210317104313.17028-1-dsterba@suse.com
