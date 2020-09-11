Return-Path: <SRS0=ZNpj=CU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDDEC433E2
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Sep 2020 16:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8B222205
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Sep 2020 16:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgIKQgo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:36:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:58192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgIKPOu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Sep 2020 11:14:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3102FADC2;
        Fri, 11 Sep 2020 14:15:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 33379DA87D; Fri, 11 Sep 2020 16:13:40 +0200 (CEST)
Date:   Fri, 11 Sep 2020 16:13:39 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/9] btrfs: send: avoid copying file data
Message-ID: <20200911141339.GR18399@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <cover.1597994106.git.osandov@osandov.com>
 <be54e8e7658f85dd5e62627a1ad02beb7a4aeed8.1597994106.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be54e8e7658f85dd5e62627a1ad02beb7a4aeed8.1597994106.git.osandov@osandov.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Aug 21, 2020 at 12:39:52AM -0700, Omar Sandoval wrote:
> +static int put_data_header(struct send_ctx *sctx, u32 len)
> +{
> +	struct btrfs_tlv_header *hdr;
> +
> +	if (sctx->send_max_size - sctx->send_size < sizeof(*hdr) + len)
> +		return -EOVERFLOW;
> +	hdr = (struct btrfs_tlv_header *)(sctx->send_buf + sctx->send_size);
> +	hdr->tlv_type = cpu_to_le16(BTRFS_SEND_A_DATA);
> +	hdr->tlv_len = cpu_to_le16(len);

I think we need put_unaligned_le16 here, it's mapping a random buffer to
a pointer, this is not alignment safe in general.
