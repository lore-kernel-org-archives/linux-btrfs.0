Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6776C43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 14:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B46B220842
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 14:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfCEO4e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 09:56:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:35852 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727245AbfCEO4e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Mar 2019 09:56:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5907AF7A;
        Tue,  5 Mar 2019 14:56:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 15F26DA8A5; Tue,  5 Mar 2019 15:57:50 +0100 (CET)
Date:   Tue, 5 Mar 2019 15:57:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v1.1] btrfs-progs: inspect-dump-tree: Allow '-b|--block'
 to be specified multiple times
Message-ID: <20190305145750.GB31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180601051526.19564-2-wqu@suse.com>
 <20180601082746.3638-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180601082746.3638-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jun 01, 2018 at 04:27:46PM +0800, Qu Wenruo wrote:
> Reuse extent-cache facility to record multiple bytenr so '-b|--block'
> can be specified multiple times.
> 
> Despite that, add a sector size alignment check before we try to print a
> tree block.
> (Please note that, nodesize alignment check is not suitable here as meta
> chunk start bytenr could be unaligned to nodesize)
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

I'm going to add this patch to devel, but there's a crash when there's
not valid block on the offset, eg. 'btrfs inspect dump-tree -b 8192
/dev/'

$ ./btrfs inspect dump-tree -b 1024 -b 2048 -b 4096 -b 8192 zimg
btrfs-progs v4.20.2 
ERROR: tree block bytenr 1024 is not aligned to sectorsize 4096
ERROR: tree block bytenr 2048 is not aligned to sectorsize 4096
Couldn't map the block 4096
Invalid mapping for 4096-20480, got 13631488-22020096
Couldn't map the block 4096
bad tree block 4096, bytenr mismatch, want=4096, have=0
ERROR: failed to read tree block 4096
extent_io.c:665: free_extent_buffer_internal: BUG_ON `eb->refs < 0`
triggered, value 1
./btrfs[0x426e57]
./btrfs(free_extent_buffer+0xe)[0x427701]
./btrfs(alloc_extent_buffer+0x3f)[0x427872]
./btrfs(btrfs_find_create_tree_block+0xf)[0x415b3c]
./btrfs(read_tree_block+0x5c)[0x4171b5]
./btrfs(cmd_inspect_dump_tree+0x587)[0x46fb75]
./btrfs(handle_command_group+0x44)[0x40df89]
./btrfs(cmd_inspect+0x15)[0x44b569]
./btrfs(main+0x8b)[0x40e032]
/lib64/libc.so.6(__libc_start_main+0xeb)[0x7f2001a54b7b]
./btrfs(_start+0x2a)[0x40dd1a]
Aborted (core dumped)

I think the fix will be simple so I'll fold it in, otherwise the
multiple block offsets work and using the cache is ok.
