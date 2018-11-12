Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B905C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 21:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44BE02241E
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 21:31:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44BE02241E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbeKMH0R (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 02:26:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:46090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725861AbeKMH0R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 02:26:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 64937B102;
        Mon, 12 Nov 2018 21:31:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 05FE3DAFAE; Mon, 12 Nov 2018 22:30:57 +0100 (CET)
Date:   Mon, 12 Nov 2018 22:30:56 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, wqu@suse.com, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: Always try all copies when reading extent buffers
Message-ID: <20181112213056.GR24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, wqu@suse.com, josef@toxicpanda.com
References: <20181106144020.3446-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106144020.3446-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 06, 2018 at 04:40:20PM +0200, Nikolay Borisov wrote:
> When a metadata read is served the endio routine btree_readpage_end_io_hook
> is called which eventually runs the tree-checker. If tree-checker fails
> to validate the read eb then it sets EXTENT_BUFFER_CORRUPT flag. This
> leads to btree_read_extent_buffer_pages wrongly assuming that all
> available copies of this extent buffer are wrong and failing prematurely.
> Fix this modify btree_read_extent_buffer_pages to read all copies of
> the data.
> 
> This failure was exhibitted in xfstests btrfs/124 which would
> spuriously fail its balance operations. The reason was that when balance
> was run following re-introduction of the missing raid1 disk
> __btrfs_map_block would map the read request to stripe 0, which
> corresponded to devid 2 (the disk which is being removed in the test):
> 
>     item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 3553624064) itemoff 15975 itemsize 112
> 	length 1073741824 owner 2 stripe_len 65536 type DATA|RAID1
> 	io_align 65536 io_width 65536 sector_size 4096
> 	num_stripes 2 sub_stripes 1
> 		stripe 0 devid 2 offset 2156920832
> 		dev_uuid 8466c350-ed0c-4c3b-b17d-6379b445d5c8
> 		stripe 1 devid 1 offset 3553624064
> 		dev_uuid 1265d8db-5596-477e-af03-df08eb38d2ca
> 
> This caused read requests for a checksum item that to be routed to the
> stale disk which triggered the aforementioned logic involving
> EXTENT_BUFFER_CORRUPT flag. This then triggered cascading failures of
> the balance operation.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Fixes: a826d6dcb32d ("Btrfs: check items for correctness as we search")

Added to misc-next, thanks.
