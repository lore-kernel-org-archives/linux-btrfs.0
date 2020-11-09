Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CF8C63697
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Nov 2020 15:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 199792083B
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Nov 2020 15:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbgKIPM6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 10:12:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:49254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729868AbgKIPLY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Nov 2020 10:11:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 65D4FAFB0;
        Mon,  9 Nov 2020 15:11:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 918D5DA7D7; Mon,  9 Nov 2020 16:09:42 +0100 (CET)
Date:   Mon, 9 Nov 2020 16:09:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 02/14] btrfs: cleanup extent buffer readahead
Message-ID: <20201109150942.GX6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1604591048.git.josef@toxicpanda.com>
 <c064bd10eca6d335160fa3ab838816fbc87de7c1.1604591048.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c064bd10eca6d335160fa3ab838816fbc87de7c1.1604591048.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 05, 2020 at 10:45:09AM -0500, Josef Bacik wrote:
> +/**
> + * btrfs_readahead_tree_block - attempt to readahead a child block.
> + * @fs_info - the fs_info for the fs.
> + * @bytenr - the bytenr to read.
> + * @gen - the generation for the uptodate check, can be 0.

This should be formatted like

/**
 * btrfs_readahead_tree_block - attempt to readahead a child block
 * @fs_info:	the fs_info
 * @bytenr:	the bytenr to read
 * @gen:	the generation for the uptodate check, can be 0
 ...
 */

Ie the parameters are @name:<tab>
