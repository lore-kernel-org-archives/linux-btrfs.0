Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240F5C43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 17:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4B2A2064A
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 17:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfCGRJc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 12:09:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:41564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726127AbfCGRJc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 12:09:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AD700ACD7
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2019 17:09:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5EBD5DA83C; Thu,  7 Mar 2019 18:10:44 +0100 (CET)
Date:   Thu, 7 Mar 2019 18:10:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs: Introduce extent_io_tree::owner to
 distinguish different io_trees
Message-ID: <20190307171042.GL31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190301024800.17649-1-wqu@suse.com>
 <20190301024800.17649-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301024800.17649-3-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 01, 2019 at 10:47:59AM +0800, Qu Wenruo wrote:
> +enum {
> +	IO_TREE_FS_INFO_FREED_EXTENTS0,
> +	IO_TREE_FS_INFO_FREED_EXTENTS1,
> +	IO_TREE_INODE_IO_TREE,
> +	IO_TREE_INODE_IO_FAILURE_TREE,
> +	IO_TREE_RELOC_BLOCKS,
> +	IO_TREE_TRANSACTION_DIRTY_PAGES,
> +	IO_TREE_ROOT_DIRTY_LOG_PAGES,
> +	IO_TREE_SELFTEST_TMP,

Well, I guess that's always something that sounds like a pointless
nitpicking but future code readers will complain, so allow me to
complain now.

IO_TREE_INODE_IO_TREE repeats the 'IO_TREE', so my idea is do only
IO_TREE_INODE_IO, similarly IO_TREE_INODE_IO_FAILURE.

And IO_TREE_SELFTEST, the 'TMP' part seems redundant.
