Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BIGNUM_EMAILS,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1785AC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 13:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAED221773
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 13:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbfDXNkx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 09:40:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:36056 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727755AbfDXNkx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 09:40:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E24DAE03;
        Wed, 24 Apr 2019 13:40:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C2447DA85E; Wed, 24 Apr 2019 15:41:55 +0200 (CEST)
Date:   Wed, 24 Apr 2019 15:41:53 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [bug report] btrfs: get fs_info from block group in
 write_pinned_extent_entries
Message-ID: <20190424134153.GW20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>,
        dsterba@suse.com, linux-btrfs@vger.kernel.org
References: <20190423141426.GA9375@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423141426.GA9375@mwanda>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 24, 2019 at 12:52:54PM +0300, Dan Carpenter wrote:
> Hello David Sterba,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch b4c7c5d50791: "btrfs: get fs_info from block group in
> write_pinned_extent_entries" from Mar 20, 2019, leads to the
> following Smatch complaint:
> 
>     fs/btrfs/free-space-cache.c:1052 write_pinned_extent_entries()
>     warn: variable dereferenced before check 'block_group' (see line 1047)
> 
> fs/btrfs/free-space-cache.c
>   1046	{
>   1047		struct btrfs_fs_info *fs_info = block_group->fs_info;
>                                                 ^^^^^^^^^^^^^^^^^^^^
> The patch adds a dereference
> 
>   1048		u64 start, extent_start, extent_end, len;
>   1049		struct extent_io_tree *unpin = NULL;
>   1050		int ret;
>   1051	
>   1052		if (!block_group)
>                      ^^^^^^^^^^^
> But the old code assumed it could be NULL.

Thanks for the report. The pointer will never be null as the caller will
pass a valid pointer, so the dereference is ok. This extra check is
redundant so I'll remove it.
