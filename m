Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E818C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 16:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 767952184A
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 16:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732689AbfB1Q4H (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:56:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:49780 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725918AbfB1Q4H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 11:56:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8F7A1AEEE
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 16:56:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 15E7CDA944; Thu, 28 Feb 2019 17:57:26 +0100 (CET)
Date:   Thu, 28 Feb 2019 17:57:25 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 06/12] btrfs: Introduce new bits for device allocation
 tree
Message-ID: <20190228165725.GO31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190211083510.27591-1-nborisov@suse.com>
 <20190211083510.27591-7-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211083510.27591-7-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 11, 2019 at 10:35:04AM +0200, Nikolay Borisov wrote:
> Rather than hijacking the existing defines let's just define new bits,
> with more descriptive names. Instead of using yet more (currently at 18)
> bits for the new flags, use the fact those flags will be specific to
> the device allocation tree so define them using existing EXTENT_* flags.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent_io.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index d7beb2b3bc7d..af7e00a3678c 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -29,6 +29,10 @@
>  				 EXTENT_CLEAR_DATA_RESV)
>  #define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING)
>  
> +
> +/* Redefined bits above which are used only in the device allocation tree */
> +#define CHUNK_ALLOCATED EXTENT_DIRTY

I see that 18 and more flags can be a lot, though for clarity could we
use unique values? The bitmask is u32 or unsigned, so still some left to
use. And I ve seen only 2 new more so it's not like you need 10, there
it would make more sense to reuse.

As the extent_io tree is used in different contexts, we can add some
sanity checks based on the disjoint sets of flags, but that's just an
idea and I don't have concrete examples.
