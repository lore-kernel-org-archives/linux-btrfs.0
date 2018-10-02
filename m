Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F08C64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 19:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AECB1206B2
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 19:24:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="DfSWeYOn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AECB1206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbeJCCJT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Oct 2018 22:09:19 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38248 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbeJCCJT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2018 22:09:19 -0400
Received: by mail-pf1-f193.google.com with SMTP id x17-v6so451062pfh.5
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2018 12:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DAjaC3gcdXCzGp9WFxc9jpPFNSSiGFBDxa0BfMHhFWw=;
        b=DfSWeYOnYBJPD9wboZDO5cBin6R1WQdgPycmJfV4b8JZd2bc8wrcw9olF0QyE/DxkK
         y1jOFc56zbkXN0v116Fftj+WX/bthFmq+E8rurGG+9WojuQqHCZN5Mt76PMs/g38r96R
         JrRUqPxI0Y3E1Us4vivJPp4RrxgNX0LYaAajcyW+3MgzsXa0zbWZmOThDe9RnYGIPHNQ
         6uLAME0RQ6E/LiJdImZy22rveQL/RXonTeKJ01PR9YmnDgy40RQ7rcJifwDcExxdJD4z
         H4xCHGoadPs6iMHQOE5U1o5uZ0hzoRhd+qjJSCB9GrT7iTGn1Jh1dc0zOTAZOe1GL9wv
         1V0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DAjaC3gcdXCzGp9WFxc9jpPFNSSiGFBDxa0BfMHhFWw=;
        b=Hk6rvSCOydkDyKnsx0VBY5ZWWPibFiCehLAXNImJIqBCynsaZdQC4+GDXtH6tgR0vx
         5RLlxmosb309Spy3ZxaLiCn+6D5E7v8XvQLvWqtzQw8J9TxuBkI5mWHTe0UkLZlVumzU
         +G4wIJ+kWlykbwd0i8HpkDnDLuBLdRPlYNd1eVMr1FMHUhjIzvucbPzwagng1u8O+JtM
         KeYpFSEhCAYGcXtzFUThVHsEDJbgqsJt3fA6CAk+Dc2aiSVAHbwYpCxBfeg0p2FUj9Hw
         A7N0BeP886bCB9Im/8AXiD5z2AgItvyVbPkCq5kDNTsDfv2NWAmQ/1ZcwBZ71n/7q43u
         ptrg==
X-Gm-Message-State: ABuFfoirRj3sGocnL94pfX6hq3ohLeZNAMxX6GkJROFHrWSnF1x8OQYR
        6VzqtZ1a7ssixHsF3sD6DLleuA==
X-Google-Smtp-Source: ACcGV61PSn+BHuEjNK/aRrvyk8KeBIW8VogLWcX+zKiHUv2fp7DfWrM4ofbUjS9zeXlYlKQVJerKpA==
X-Received: by 2002:a62:da03:: with SMTP id c3-v6mr14686948pfh.52.1538508263908;
        Tue, 02 Oct 2018 12:24:23 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::5:4e24])
        by smtp.gmail.com with ESMTPSA id h77-v6sm24072781pfh.13.2018.10.02.12.24.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Oct 2018 12:24:23 -0700 (PDT)
Date:   Tue, 2 Oct 2018 12:24:22 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/10] btrfs-progs: Add extent buffer bitmap manipulation
 infrastructure
Message-ID: <20181002192422.GB25437@vader>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-3-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538405181-25231-3-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:46:13PM +0300, Nikolay Borisov wrote:
> Those functions are in preparation for adding the freespace tree
> repair code since it needs to be able to deal with bitmap based fsts.
> This patch adds extent_buffer_bitmap_set and extent_buffer_bitmap_clear
> functions. Since in userspace we don't have to deal with page mappings
> their implementation is vastly simplified by simply setting each bit in
> the passed range.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  extent_io.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  extent_io.h |  4 ++++
>  2 files changed, 60 insertions(+)
> 
> diff --git a/extent_io.c b/extent_io.c
> index 198492699438..de47c2c59ae9 100644
> --- a/extent_io.c
> +++ b/extent_io.c
> @@ -204,6 +204,62 @@ static int clear_state_bit(struct extent_io_tree *tree,
>  	return ret;
>  }
>  
> +/**
> + * extent_buffer_bitmap_set - set an area of a bitmap
> + * @eb: the extent buffer
> + * @start: offset of the bitmap item in the extent buffer
> + * @pos: bit number of the first bit
> + * @len: number of bits to set
> + */
> +void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
> +                              unsigned long pos, unsigned long len)
> +{
> +	u8 *p = (u8 *)eb->data + start + BIT_BYTE(pos);
> +	const unsigned int size = pos + len;
> +	int bits_to_set = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
> +	u8 mask_to_set = BITMAP_FIRST_BYTE_MASK(pos);
> +
> +	while (len >= bits_to_set) {
> +		*p |= mask_to_set;
> +		len -= bits_to_set;
> +		bits_to_set = BITS_PER_BYTE;
> +		mask_to_set = ~0;
> +		p++;
> +	}
> +	if (len) {
> +		mask_to_set &= BITMAP_LAST_BYTE_MASK(size);
> +		*p |= mask_to_set;
> +	}
> +}
> +
> +
> +/**
> + * extent_buffer_bitmap_clear - clear an area of a bitmap
> + * @eb: the extent buffer
> + * @start: offset of the bitmap item in the extent buffer
> + * @pos: bit number of the first bit
> + * @len: number of bits to clear
> + */
> +void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
> +                                unsigned long pos, unsigned long len)
> +{
> +	u8 *p = (u8 *)eb->data + start + BIT_BYTE(pos);
> +	const unsigned int size = pos + len;
> +	int bits_to_clear = BITS_PER_BYTE - (pos % BITS_PER_BYTE);
> +	u8 mask_to_clear = BITMAP_FIRST_BYTE_MASK(pos);
> +
> +	while (len >= bits_to_clear) {
> +		*p &= ~mask_to_clear;
> +		len -= bits_to_clear;
> +		bits_to_clear = BITS_PER_BYTE;
> +		mask_to_clear = ~0;
> +		p++;
> +	}
> +	if (len) {
> +		mask_to_clear &= BITMAP_LAST_BYTE_MASK(size);
> +		*p &= ~mask_to_clear;
> +	}
> +}
>  /*
>   * clear some bits on a range in the tree.
>   */
> diff --git a/extent_io.h b/extent_io.h
> index d407d93d617e..b67c6fc40e89 100644
> --- a/extent_io.h
> +++ b/extent_io.h
> @@ -175,4 +175,8 @@ int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
>  			u64 bytes, int mirror);
>  int write_data_to_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
>  		       u64 bytes, int mirror);
> +void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
> +                                unsigned long pos, unsigned long len);
> +void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
> +                              unsigned long pos, unsigned long len);
>  #endif
> -- 
> 2.7.4
> 
