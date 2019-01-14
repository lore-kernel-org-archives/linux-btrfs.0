Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60E4C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 17:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5B7C2070B
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 17:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfANRVh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 12:21:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:59338 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726673AbfANRVg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:21:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 71D45AEB4
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 17:21:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 35961DA847; Mon, 14 Jan 2019 18:21:07 +0100 (CET)
Date:   Mon, 14 Jan 2019 18:21:07 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3.1 3/7] btrfs: relocation: Delay reloc tree deletion
 after merge_reloc_roots()
Message-ID: <20190114172107.GE2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190107054151.18662-1-wqu@suse.com>
 <20190107054151.18662-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107054151.18662-4-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 07, 2019 at 01:41:47PM +0800, Qu Wenruo wrote:
> +/*
> + * Helper structure to keep record of a file tree whose reloc
> + * root needs to be cleaned up.
> + *
> + * Since reloc_control is used less frequently than btrfs_root, this should
> + * prevent us to add another structure in btrfs_root.
> + */
> +struct dirty_source_root {
> +	struct rb_node node;
> +
> +	/* Root must be file tree */

The naming starts here and is used in the following patches too: the
naming is IMO confusing, here it's still ok but variables like
'file_bytenr' or 'file_parent' sound weird in context of relocation.

The file tree is the subvolume right, or would it be confusing in
another way?
