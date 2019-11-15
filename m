Return-Path: <SRS0=NtSv=ZH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B489BC432C3
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Nov 2019 16:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E33920692
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Nov 2019 16:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfKOQUk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 11:20:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:38216 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727423AbfKOQUk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Nov 2019 11:20:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ED724AEEE;
        Fri, 15 Nov 2019 16:20:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E3BBFDA7D3; Fri, 15 Nov 2019 17:20:41 +0100 (CET)
Date:   Fri, 15 Nov 2019 17:20:41 +0100
From:   David Sterba <dsterba@suse.cz>
To:     damenly.su@gmail.com
Cc:     linux-btrfs@vger.kernel.org, Damenly_Su@gmx.com
Subject: Re: [PATCH 1/2] btrfs-progs: add comments of block group lookup
 functions
Message-ID: <20191115162041.GA3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, damenly.su@gmail.com,
        linux-btrfs@vger.kernel.org, Damenly_Su@gmx.com
References: <20191111084226.475957-1-Damenly_Su@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111084226.475957-1-Damenly_Su@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 11, 2019 at 04:42:25PM +0800, damenly.su@gmail.com wrote:
> From: Su Yue <Damenly_Su@gmx.com>
> 
> The progs side function btrfs_lookup_first_block_group() calls
> find_first_extent_bit() to find block group which contains bytenr
> or after the bytenr. This behavior differs from kernel code, so
> add the comments.
> 
> Add the coments of btrfs_lookup_block_group() too, this one works
> like kernel side.
> 
> Signed-off-by: Su Yue <Damenly_Su@gmx.com>

1 and 2 added to devel, thanks.
