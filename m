Return-Path: <SRS0=7yWS=DU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5757C433E7
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Oct 2020 16:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94B8125250
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Oct 2020 16:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbgJMQOp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 12:14:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:42844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgJMQOp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Oct 2020 12:14:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CC4D9AC6D;
        Tue, 13 Oct 2020 16:14:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1EF52DA7C3; Tue, 13 Oct 2020 18:13:17 +0200 (CEST)
Date:   Tue, 13 Oct 2020 18:13:16 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v8 04/41] btrfs: Check and enable ZONED mode
Message-ID: <20201013161316.GG6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
References: <cover.1601572459.git.naohiro.aota@wdc.com>
 <c6d9f70f9b9264497aa630d6c95d8d387b012d57.1601574234.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6d9f70f9b9264497aa630d6c95d8d387b012d57.1601574234.git.naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 02, 2020 at 03:36:11AM +0900, Naohiro Aota wrote:
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -588,6 +588,9 @@ struct btrfs_fs_info {
>  	struct btrfs_root *free_space_root;
>  	struct btrfs_root *data_reloc_root;
>  
> +	/* Zone size when in ZONED mode */
> +	u64 zone_size;
> +
>  	/* the log root tree is a directory of all the other log roots */
>  	struct btrfs_root *log_root_tree;

This is misplaced, new members should be placed to an existing location
if there is one or at the end of the structure. What's the logic behind
putting zone_size and later max_zone_append_size into the tree root
pointers?
