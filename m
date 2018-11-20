Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D55DC4161D
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 19:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8877D2087E
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 19:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="EUyyLY8d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8877D2087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbeKUFbe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 00:31:34 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36072 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbeKUFbe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 00:31:34 -0500
Received: by mail-yw1-f67.google.com with SMTP id y194so1208904ywg.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 11:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8vOBOARxSVwJJnmbaBjTRSCzYzEf2tyyk9AWeHYVzUk=;
        b=EUyyLY8dvMJwpkLL8FZIdydbewq0GG0uJTp52JnO7x3GtUIwKd1rvo6pOGL/tS4VZ4
         RUViKIE8E5xEwPdJK1FsAYCOn6vNOLZraC9l3jBKRYdhK9YhYxj6IFEd585T4TJk1OIJ
         JYB5c7raRNxcZHs3wvK95lt8WtjqI5jlB8v7LYWrxRlbi7QYAnZ5RbLTzI46JYoI0iPO
         laEScTkSCMyj7Sb1Ktgg8tuoFuDbtK9hED+p/qBWsxQjqEZSz/dc4Dt41YoucWCkAFld
         2mR/EBL+tSs9S0WMi0BAlxm9fK+IbggrbJEb/uza0ZM0PvpCS+LBEsV87XT+1gAlKahe
         Boig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8vOBOARxSVwJJnmbaBjTRSCzYzEf2tyyk9AWeHYVzUk=;
        b=eI65CfLq5s4IY/2jkNpktl49GALrraS1bxf2hPiQwORnBnCUIXzLUdvIh/BcZ7Ql6e
         zIman8H3i8tNrRDXkawEqO0z8zcRY4W736uQHexRMwzyRpmjEvndWc8/HVQRSSSDm1Rk
         N5njp7h+0WJmVVyu95uOaFlgSPzWd4htGtrbQGH/MKpf2oh0kXEbT6c7RFrQrRx++aTZ
         82xlk9sRizl9ZHAIKuHQlMQ7ZiMt6Apx9aaAmB88SLjBVizNGcdcid/1yRr29g9umiti
         AQk1th9U8P6WGgX+FlVlhv/L/zfKRWKZxPdFJdx2Nc+0F6yinTX50jQqr1DjG+wS5CP3
         vxsw==
X-Gm-Message-State: AGRZ1gIXf1CvsKz4RGS6zcObGhicuo7Y19zPjdsvbPAp+LqPXkhcWRQ3
        4nFUzs7HFUFpdWx1RJUO+Cn/VA==
X-Google-Smtp-Source: AJdET5eZNDMYuPzXP0mbQWmMp0p+P/ydLr8SWxcPE8CS4QxhPdCQ6PqgpY6GKcF9trj91GGpS2Dm8w==
X-Received: by 2002:a81:5a89:: with SMTP id o131-v6mr3319277ywb.121.1542740454171;
        Tue, 20 Nov 2018 11:00:54 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:e1be])
        by smtp.gmail.com with ESMTPSA id z74sm7347997ywz.51.2018.11.20.11.00.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Nov 2018 11:00:53 -0800 (PST)
Date:   Tue, 20 Nov 2018 14:00:52 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org, wqu@suse.com
Subject: Re: [PATCH v2] btrfs: Fix error handling in
 btrfs_cleanup_ordered_extents
Message-ID: <20181120190050.u4pyaa6m5p5tck27@macbook-pro-91.dhcp.thefacebook.com>
References: <1540554115-11226-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540554115-11226-1-git-send-email-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 26, 2018 at 02:41:55PM +0300, Nikolay Borisov wrote:
> Running btrfs/124 in a loop hung up on me sporadically with the
> following call trace:
> 	btrfs           D    0  5760   5324 0x00000000
> 	Call Trace:
> 	 ? __schedule+0x243/0x800
> 	 schedule+0x33/0x90
> 	 btrfs_start_ordered_extent+0x10c/0x1b0 [btrfs]
> 	 ? wait_woken+0xa0/0xa0
> 	 btrfs_wait_ordered_range+0xbb/0x100 [btrfs]
> 	 btrfs_relocate_block_group+0x1ff/0x230 [btrfs]
> 	 btrfs_relocate_chunk+0x49/0x100 [btrfs]
> 	 btrfs_balance+0xbeb/0x1740 [btrfs]
> 	 btrfs_ioctl_balance+0x2ee/0x380 [btrfs]
> 	 btrfs_ioctl+0x1691/0x3110 [btrfs]
> 	 ? lockdep_hardirqs_on+0xed/0x180
> 	 ? __handle_mm_fault+0x8e7/0xfb0
> 	 ? _raw_spin_unlock+0x24/0x30
> 	 ? __handle_mm_fault+0x8e7/0xfb0
> 	 ? do_vfs_ioctl+0xa5/0x6e0
> 	 ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
> 	 do_vfs_ioctl+0xa5/0x6e0
> 	 ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
> 	 ksys_ioctl+0x3a/0x70
> 	 __x64_sys_ioctl+0x16/0x20
> 	 do_syscall_64+0x60/0x1b0
> 	 entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Turns out during page writeback it's possible that the code in
> writepage_delalloc can instantiate a delalloc range which doesn't
> belong to the page currently being written back. This happens since
> find_lock_delalloc_range returns up to BTRFS_MAX_EXTENT_SIZE delalloc
> range when asked and doens't really consider the range of the passed
> page. When such a foregin range is found the code proceeds to
> run_delalloc_range and calls the appropriate function to fill the
> delalloc and create ordered extents. If, however, a failure occurs
> while this operation is in effect then the clean up code in
> btrfs_cleanup_ordered_extents will be called. This function has the
> wrong assumption that caller of run_delalloc_range always properly
> cleans the first page of the range hence when it calls
> __endio_write_update_ordered it explicitly ommits the first page of
> the delalloc range. This is wrong because this function could be
> cleaning a delalloc range that doesn't belong to the current page. This
> in turn means that the page cleanup code in __extent_writepage will
> not really free the initial page for the range, leaving a hanging
> ordered extent with bytes_left set to 4k. This bug has been present
> ever since the original introduction of the cleanup code in 524272607e88.
> 
> Fix this by correctly checking whether the current page belongs to the
> range being instantiated and if so correctly adjust the range parameters
> passed for cleaning up. If it doesn't, then just clean the whole OE
> range directly.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Fixes: 524272607e88 ("btrfs: Handle delalloc error correctly to avoid ordered extent hang")

Can we just remove the endio cleanup in __extent_writepage() and make this do
the proper cleanup?  I'm not sure if that is feasible or not, but seems like it
would make the cleanup stuff less confusing and more straightforward.  If not
you can add

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
