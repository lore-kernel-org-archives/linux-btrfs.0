Return-Path: <SRS0=PX3t=BX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FD5C433DF
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Aug 2020 14:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7611F20771
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Aug 2020 14:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgHMOGI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 10:06:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:47878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbgHMOGG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Aug 2020 10:06:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2E181AE87;
        Thu, 13 Aug 2020 14:06:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8BBC4DA6EF; Thu, 13 Aug 2020 16:05:03 +0200 (CEST)
Date:   Thu, 13 Aug 2020 16:05:03 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v4 1/4] btrfs: extent_io: Do extra check for extent
 buffer read write functions
Message-ID: <20200813140503.GH2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20200812060509.71590-1-wqu@suse.com>
 <20200812060509.71590-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812060509.71590-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 12, 2020 at 02:05:06PM +0800, Qu Wenruo wrote:
> +/*
> + * Check if the [start, start + len) range is valid before reading/writing
> + * the eb.
> + * NOTE: @start and @len are offset *INSIDE* the eb, *NOT* logical address.
> + *
> + * Caller should not touch the dst/src memory if this function returns error.
> + */
> +static int check_eb_range(const struct extent_buffer *eb, unsigned long start,
> +			  unsigned long len)
> +{
> +	/* start, start + len should not go beyond eb->len nor overflow */
> +	if (unlikely(start > eb->len || start + len > eb->len ||
> +		     len > eb->len)) {
> +		btrfs_warn(eb->fs_info,
> +"btrfs: bad eb rw request, eb bytenr=%llu len=%lu rw start=%lu len=%lu\n",
> +			   eb->start, eb->len, start, len);
> +		WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG));
> +		return -EINVAL;
> +	}
> +	return 0;
> +}

This helper is similar to the check_setget_bounds that have some
performance impact,
https://lore.kernel.org/linux-btrfs/20200730110943.GE3703@twin.jikos.cz/
.

The extent buffer helpers are not called that often as the setget
helpers but still it could be improved to avoid the function call
penalty on the hot path.

static inline in check_eb_range(...) {
	if (unlikely(out of range))
		return report_eb_range(...)
	return 0;
}

In the original code the range check was open coded and the above will
lead to the same asm output, while keeping the C code readable.
