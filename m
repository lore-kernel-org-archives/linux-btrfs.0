Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3472BC433FE
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Feb 2022 19:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343983AbiBJT1r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Feb 2022 14:27:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243946AbiBJT1p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Feb 2022 14:27:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E92D220;
        Thu, 10 Feb 2022 11:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JI8a3ZfNxrXQN+RTo9neg+lGRkT+LYOdMdTu+InSIZE=; b=gdiYTz0bvA1Ia5tOyAJ+sLb9Gj
        6Ti+dZfVeeiwCn2WNvcwuiIXCSVf6PrXQMzHToMimDqpKy4CjDAo6oatuH854P7A/SFDnX6h+Av6G
        j6vuefzauTCiCurmN2UgBh1Dng+3b488PU8MSuZZtsq/QlzBtqTP+xzl/jeK5tHKRajXu/vUqzc9f
        HqNhqNQWl07naE5SFX/FWJoQvEz1k4k3Zc2UB/B81WP0zdrVrnGmfCGONU0M9+z3gf9EHEAohXwF4
        7MKc1kkDhQfd/+oajcl+d5dLAExA14vRKO6plvX5HcEhdn49kBXBQxztI3fzYKQdke7Jmq0ybZnso
        Li9uKFVQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nIF6V-009hI2-3X; Thu, 10 Feb 2022 19:27:43 +0000
Date:   Thu, 10 Feb 2022 19:27:43 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dhowells@redhat.com, fvogt@suse.com
Subject: Re: [PATCH] Fix read-only superblock in case of subvol RO remount
Message-ID: <YgVnL//Q7gMCfxFN@casper.infradead.org>
References: <20220210165142.7zfgotun5qdtx4rq@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210165142.7zfgotun5qdtx4rq@fiona>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 10, 2022 at 10:51:42AM -0600, Goldwyn Rodrigues wrote:
>  	WRITE_ONCE(sb->s_flags, ((sb->s_flags & ~fc->sb_flags_mask) |
> -				 (fc->sb_flags & fc->sb_flags_mask)));
> +				 (sb->s_flags & fc->sb_flags_mask)));
> +

what?

(a & ~b) | (a & b) == a, no?
