Return-Path: <SRS0=9t/X=63=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DA1CA90AF
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 May 2020 14:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8670C2064E
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 May 2020 14:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388604AbgEMOCw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 May 2020 10:02:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:33168 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387608AbgEMOCv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 May 2020 10:02:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 866F5AD5E;
        Wed, 13 May 2020 14:02:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 515FDDA70B; Wed, 13 May 2020 16:01:59 +0200 (CEST)
Date:   Wed, 13 May 2020 16:01:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Don't set SHAREABLE flag for data reloc tree
Message-ID: <20200513140157.GK18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200513061611.111807-1-wqu@suse.com>
 <20200513061611.111807-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513061611.111807-3-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 13, 2020 at 02:16:11PM +0800, Qu Wenruo wrote:
> -	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
> +	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID &&
> +	    root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID) {

>  	if (test_bit(BTRFS_ROOT_SHAREABLE, &root->state) ||
> -	    root == fs_info->tree_root)
> +	    root == fs_info->tree_root || root == fs_info->dreloc_root)

>  		if (found_extent &&
>  		    (test_bit(BTRFS_ROOT_SHAREABLE, &root->state) ||
> -		     root == fs_info->tree_root)) {
> +		     root == fs_info->tree_root ||
> +		     root == fs_info->dreloc_root)) {

Lots of repeated conditions, though not all of them exactly the same. I
was thinking about adding some helpers but don't have a good suggestion.

The concern is about too much special casing, it's eg tree_root +
data_reloc_tree, or SHAREABLE + tree_reloc + data_reloc, etc. The
helpers should capture the common semantics of the condition and also
reduce the surface for future errors.
