Return-Path: <SRS0=fvYO=T3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B122C04AB3
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 May 2019 14:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C5BB2146F
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 May 2019 14:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfE0OLa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 May 2019 10:11:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:39760 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726302AbfE0OLa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 May 2019 10:11:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5E6E8AC3F
        for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2019 14:11:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AF29BDA86B; Mon, 27 May 2019 16:12:24 +0200 (CEST)
Date:   Mon, 27 May 2019 16:12:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Output extent tree leaf if we failed to
 find a backref
Message-ID: <20190527141224.GK15290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190527042204.27666-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527042204.27666-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, May 27, 2019 at 12:22:04PM +0800, Qu Wenruo wrote:
> There is a bug report of BUG_ON() which is caused by __free_extent()
> failed to lookup a backref extent:
>   Failed to find [1429288337408, 168, 16384]
>   btrfs unable to find ref byte nr 1429288583168 parent 0 root 2 owner 0 offset 0
>   convert/source-ext2.c:834: ext2_copy_inodes: BUG_ON ret triggered, value -5
>   ./btrfs-convert[0x410941]
>   ./btrfs-convert(main+0x1fdc)[0x40d3b8]
>   /lib64/libc.so.6(__libc_start_main+0xf3)[0x7f93bb7d2f33]
>   ./btrfs-convert(_start+0x2e)[0x40a96e]
> 
> It's still uncertain how this bug can be triggered, but adding such
> debug output will provide more info for us to debug.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to devel, thanks.
