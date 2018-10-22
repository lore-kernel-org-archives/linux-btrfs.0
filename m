Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4766CC004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 19:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E05720652
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 19:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="eCx+EDdt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E05720652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbeJWDij (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 23:38:39 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41954 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbeJWDij (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 23:38:39 -0400
Received: by mail-qt1-f196.google.com with SMTP id l41-v6so47661778qtl.8
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 12:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w+W2LXNT24uKuYXTzyAntXoLdOB7pKyGkQ3xsNpMDAg=;
        b=eCx+EDdt4jtB9swxxe9uv3edz61Z4aX1yVIdi6OYyojIBz0SdnoDkWlvOiywVle7TI
         wk1rn2oKJPWWKU06Ww0xcOIGpvTW9394wNlY7hLyDi+cg2SQk0IuwWBMMhT9ZWAivduK
         vHDEwNCuyJB/nncRhDCjwzyOIFqz8xBAbuxCNWnxZN1l3NqzKCAu/jAF470L3cMBdDgW
         0A4r1NasQC17uAEt3LDfS9oVj6j2IgKqNyz3kohHK7afcq2C0eHc6xHRAbW08PM4G1gg
         MSYgfBhPVw0SniSY1T/+SHhTA2wwNAPCCPsSHZ2CGTdciGAqkC+jsrbe523Wn+Xff2mr
         jpXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w+W2LXNT24uKuYXTzyAntXoLdOB7pKyGkQ3xsNpMDAg=;
        b=YmEN5e4icKzWtgBw1E5WHMJzHthSlLQRmvPxni9xL/S3VXzMHUNVFPv0pW4XhJ6NXx
         71/gMs0GloBdj9b7sbT08L0c9XvuBDqhjUGxN1XFLsFltvOZGxYcl5XeTs+ZaAFx6+t7
         o5/zz7Goyjzo9DGv3ola7vlU0wbGfnlCLkP+Qi5KzBJrr/Ur+96Psu+eaOGx4fjuYEd4
         qlZLaLeVOgCyCiNw0ZrGXLx020vVKoleuBF/KcCD/Dl88HRE4MHpQGGIUo5iy+gf+leZ
         csJbnpAMGQ/NgEnkqmQE+AKXM7il6tHpov9V/eCqXBZC4/NqCQ+Z0UG+dkWNKcA9HZn+
         yVpg==
X-Gm-Message-State: ABuFfoho1etExk9TGVhffdnWnZLGW9ypMyDc+DteiYwK6pKdK0uIFKJk
        uau6OFl1gw6jeAcNh3dzTMcHcA==
X-Google-Smtp-Source: ACcGV61PPkxZQ1pOsVp3aqkiUrczxVwDOOjxTYxi3c4OXj/h80CWvHIqlDphb0KfWj5yHCKZmMuMug==
X-Received: by 2002:ac8:6941:: with SMTP id n1-v6mr44764434qtr.372.1540235931912;
        Mon, 22 Oct 2018 12:18:51 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c44-v6sm11282814qtc.7.2018.10.22.12.18.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Oct 2018 12:18:50 -0700 (PDT)
Date:   Mon, 22 Oct 2018 15:18:50 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org, josef@toxicpanda.com,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v3] Btrfs: fix deadlock on tree root leaf when finding
 free extent
Message-ID: <20181022191848.awvitym7tw24kpgx@destiny>
References: <20181022090946.1150-1-fdmanana@kernel.org>
 <20181022191037.18471-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181022191037.18471-1-fdmanana@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 08:10:37PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When we are writing out a free space cache, during the transaction commit
> phase, we can end up in a deadlock which results in a stack trace like the
> following:
> 
>  schedule+0x28/0x80
>  btrfs_tree_read_lock+0x8e/0x120 [btrfs]
>  ? finish_wait+0x80/0x80
>  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
>  btrfs_search_slot+0xf6/0x9f0 [btrfs]
>  ? evict_refill_and_join+0xd0/0xd0 [btrfs]
>  ? inode_insert5+0x119/0x190
>  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
>  ? kmem_cache_alloc+0x166/0x1d0
>  btrfs_iget+0x113/0x690 [btrfs]
>  __lookup_free_space_inode+0xd8/0x150 [btrfs]
>  lookup_free_space_inode+0x5b/0xb0 [btrfs]
>  load_free_space_cache+0x7c/0x170 [btrfs]
>  ? cache_block_group+0x72/0x3b0 [btrfs]
>  cache_block_group+0x1b3/0x3b0 [btrfs]
>  ? finish_wait+0x80/0x80
>  find_free_extent+0x799/0x1010 [btrfs]
>  btrfs_reserve_extent+0x9b/0x180 [btrfs]
>  btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
>  __btrfs_cow_block+0x11d/0x500 [btrfs]
>  btrfs_cow_block+0xdc/0x180 [btrfs]
>  btrfs_search_slot+0x3bd/0x9f0 [btrfs]
>  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
>  ? kmem_cache_alloc+0x166/0x1d0
>  btrfs_update_inode_item+0x46/0x100 [btrfs]
>  cache_save_setup+0xe4/0x3a0 [btrfs]
>  btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
>  btrfs_commit_transaction+0xcb/0x8b0 [btrfs]
> 
> At cache_save_setup() we need to update the inode item of a block group's
> cache which is located in the tree root (fs_info->tree_root), which means
> that it may result in COWing a leaf from that tree. If that happens we
> need to find a free metadata extent and while looking for one, if we find
> a block group which was not cached yet we attempt to load its cache by
> calling cache_block_group(). However this function will try to load the
> inode of the free space cache, which requires finding the matching inode
> item in the tree root - if that inode item is located in the same leaf as
> the inode item of the space cache we are updating at cache_save_setup(),
> we end up in a deadlock, since we try to obtain a read lock on the same
> extent buffer that we previously write locked.
> 
> So fix this by skipping the loading of free space caches of any block
> groups that are not yet cached (rare cases) if we are COWing an extent
> buffer from the root tree and space caching is enabled (-o space_cache
> mount option). This is a rare case and its downside is failure to
> find a free extent (return -ENOSPC) when all the already cached block
> groups have no free extents.
> 
> Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
> Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
> Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Great, thanks,

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Josef
