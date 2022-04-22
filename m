Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3590BC433F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Apr 2022 22:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiDVWUB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbiDVWSG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Apr 2022 18:18:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B858D329355
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2022 14:09:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 60716210F1;
        Fri, 22 Apr 2022 21:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1650661771;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZrrNCVB9AUtjcchFXjPvWjvk+V1s4dnwgbh+GMX9Mro=;
        b=w07bi9icV4fm/HLe1QuxImzDRLsafr2/neuKk3PdxeOG5H7DHIRUIXJH+AfrVmCyQWql4P
        0PhsdorhyfDnx00S8t41l+RuwXlKqEeXHVzEsHmRW6IN/E9Dg9fOjyVYc2sQml3DpP5Acq
        VMI97kDBklLVV0stcxa5evwLanLXSI8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1650661771;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZrrNCVB9AUtjcchFXjPvWjvk+V1s4dnwgbh+GMX9Mro=;
        b=jcUyDHithm5J0Dv1wbR07Qy5tHJ75gCv3gy2SCSy2hVPqyuv5nKSJsRpEHfacZdSqRV8NK
        shgpYLD9thVxC8DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 388F713AE1;
        Fri, 22 Apr 2022 21:09:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DbztDIsZY2LeDgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 22 Apr 2022 21:09:31 +0000
Date:   Fri, 22 Apr 2022 23:05:25 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: simplify WQ_HIGHPRI handling in struct
 btrfs_workqueue
Message-ID: <20220422210525.GL18596@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20220418044311.359720-1-hch@lst.de>
 <20220418044311.359720-2-hch@lst.de>
 <03ea07cb-d724-26f6-bfce-99befb3ab15e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03ea07cb-d724-26f6-bfce-99befb3ab15e@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 18, 2022 at 04:03:43PM +0800, Qu Wenruo wrote:
> > -struct __btrfs_workqueue {
> > +struct btrfs_workqueue {
> >   	struct workqueue_struct *normal_wq;
> 
> I guess we can also rename @normal_wq here, as there is only one wq in 
> each btrfs_workqueue, no need to distinguish them in btrfs_workqueue.

Yeah now the 'normal_' prefix does not make sense.

> And since we're here, doing a pahole optimization would also be a good 
> idea (can be done in a sepearate patchset).
> 
> Especially there is a huge 16 bytes hole between @ordered_list and 
> @list_lock.

On a release build the packing is good, I don't see any holes there:

struct btrfs_work {
        btrfs_func_t               func;                 /*     0     8 */
        btrfs_func_t               ordered_func;         /*     8     8 */
        btrfs_func_t               ordered_free;         /*    16     8 */
        struct work_struct         normal_work;          /*    24    32 */
        struct list_head           ordered_list;         /*    56    16 */
        /* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
        struct btrfs_workqueue *   wq;                   /*    72     8 */
        long unsigned int          flags;                /*    80     8 */

        /* size: 88, cachelines: 2, members: 7 */
        /* last cacheline: 24 bytes */
};

The fs_info structure grew a bit but it's a large one and there's still
enough space before it hits 4K.
