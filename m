Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D84C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 15:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1D0B206BA
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 15:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfCKPSv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:18:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:39566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726352AbfCKPSv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 11:18:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D086EACC8
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2019 15:18:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3D848DA8D5; Mon, 11 Mar 2019 16:20:06 +0100 (CET)
Date:   Mon, 11 Mar 2019 16:20:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs: Introduce extent_io_tree::owner to
 distinguish different io_trees
Message-ID: <20190311152006.GX31119@twin.jikos.cz>
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
>  struct extent_io_tree {
>  	struct rb_root state;
>  	struct btrfs_fs_info *fs_info;
>  	void *private_data;
>  	u64 dirty_bytes;
> -	int track_uptodate;
> +	bool track_uptodate;

Next time please do such change in a separate patch, I did that myself
for now.
