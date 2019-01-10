Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F19DC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 21:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7F65208E3
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 21:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbfAJVEm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 16:04:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:38486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727846AbfAJVEm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 16:04:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A60BFB0BF
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2019 21:04:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 52B5CDA780; Thu, 10 Jan 2019 22:04:09 +0100 (CET)
Date:   Thu, 10 Jan 2019 22:04:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Fix incorrectly created uuid tree
Message-ID: <20190110210409.GA27146@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190103073221.10525-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190103073221.10525-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 03:32:16PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/uuid_tree_support
> Which is based on v4.19.1 tag.
> 
> Qu Wenruo (5):
>   btrfs-progs: Export btrfs_create_tree() and move it to disk-io.c
>   btrfs-progs: mkfs: Create data reloc tree from scratch
>   btrfs-progs: uuid: Port kernel btrfs_uuid_tree_lookup()
>   btrfs-progs: uuid: Port btrfs_uuid_tree_add() function
>   btrfs-progs: Create uuid tree with proper contents

Added to devel, thanks.
