Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C056DC43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 19:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A1E6206B7
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 19:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfAGTKw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 14:10:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:56326 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727064AbfAGTKw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 14:10:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F2CAEAF6D
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Jan 2019 19:10:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0E461DA7E8; Mon,  7 Jan 2019 20:10:19 +0100 (CET)
Date:   Mon, 7 Jan 2019 20:10:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove impossible condition from mergable_maps
Message-ID: <20190107191019.GD23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181218131002.12480-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218131002.12480-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 18, 2018 at 03:10:02PM +0200, Nikolay Borisov wrote:
> We can never have extents marked as EXTENT_MAP_DELALLOC since this
> value is only ever used by btrfs_get_extent_fiemap. In this case the
> extent map is created by btrfs_get_extent_fiemap and is never really
> published, this flag is used to return the corresponding userspace one.
> Considering this, it's pointless having a check for EXTENT_MAP_DELALLOC
> in mergable_maps. Just remove it.

An assert would be good and a comment at EXTENT_MAP_DELALLOC definition
repeating what's in the changelog. Otherwise ok.
