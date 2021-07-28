Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADBBC4338F
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Jul 2021 13:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24AFC61019
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Jul 2021 13:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbhG1N0j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:26:39 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58030 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhG1N0j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jul 2021 09:26:39 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id EA44A22327;
        Wed, 28 Jul 2021 13:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1627478796;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t/oKY32DVgQodID2MMSqyb/AbQTpB3rMemcaWD0QWyI=;
        b=O4/vWLVKvDEuxfpHt6hjIPkVzNw0dfLj/4F15MxRc7agVtnapG9kBcsnox+P484uuiUT3N
        IqBVJRwgzpjWHycW3v5/+WXnGyPbmaB/AMB+b/oe3J/oJIKGPsJk7Hha3yoyNGUPhimREe
        BQOL5e42L2yDTAz1uJwQulfxkOuvvu8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1627478796;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t/oKY32DVgQodID2MMSqyb/AbQTpB3rMemcaWD0QWyI=;
        b=D4zDbKrI6iAqS9x/jObyZTY7EKL/PKqRJS6dCJow2EXgVDwR4SO6KNBZmLbv9djNSzuCD/
        o1KYgqgozeMNCYBg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id E344AA3B87;
        Wed, 28 Jul 2021 13:26:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CDBE4DA8A7; Wed, 28 Jul 2021 15:23:51 +0200 (CEST)
Date:   Wed, 28 Jul 2021 15:23:51 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v8 05/18] btrfs: rework btrfs_decompress_buf2page()
Message-ID: <20210728132351.GG5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210726063507.160396-1-wqu@suse.com>
 <20210726063507.160396-6-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726063507.160396-6-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 26, 2021 at 02:34:54PM +0800, Qu Wenruo wrote:
> +	while (cur_offset < decompressed + buf_len) {
> +		struct bio_vec bvec = bio_iter_iovec(orig_bio,
> +						     orig_bio->bi_iter);
> +		size_t copy_len;
> +		u32 copy_start;
> +		u32 bvec_offset; /* Offset inside the full decompressed extent */

Please put such comments on a separate line, before the variable
declaration.
