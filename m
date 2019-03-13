Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F8BC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 18:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E345213A2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 18:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfCMSCB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 14:02:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:58354 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbfCMSCB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 14:02:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0ED21B625
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 18:02:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D1F82DA875; Wed, 13 Mar 2019 19:03:14 +0100 (CET)
Date:   Wed, 13 Mar 2019 19:03:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Correctly free extent buffer in case
 btree_read_extent_buffer_pages fails
Message-ID: <20190313180314.GH31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190312131847.20311-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190312131847.20311-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 12, 2019 at 03:18:47PM +0200, Nikolay Borisov wrote:
> If a an eb fails to be read for whatever reason - it's corrupted on disk
> and parent transid/key validations fail or IO for eb pages fail then
> this buffer must be removed from the buffer cache. Currently the code
> calls free_extent_buffer if an error occurs. Unfortunately this doesn't
> achieve the desired behavior since btrfs_find_create_tree_block returns
> with eb->refs == 2. On the other hand free_extent_buffer will only
> decrement the refs once leavin it added to the buffer cache radix tree.
> This enables later code to look up the buffer from the cache and utilize
> it potentially leading to a crash.
> 
> The correct way to free the buffer is call free_extent_buffer_stale.
> This function will correctly call atomic_dec explicitly for the buffer
> and subsequently call release_extent_buffer which will decrement the
> final reference thus correctly remove the invalid buffer from buffer
> cache. This change affects only newly allocated buffers since they have
> eb->refs == 2.

Following the same pattern, should every use of
btrfs_find_create_tree_block be followed by free_extent_buffer_stale in
case of errors?

There's almost the same sequence in readahead_tree_block as you update
in reada_tree_block_flagged:

  btrfs_find_create_tree_block
  read_extent_buffer_pages
  free_extent_buffer

so should be the _stale variant used there too?

free_extent_buffer_stale is normally used in other contexts where the
'stale' part means that the eb is known to be disconnected.

I think that btrfs_find_create_tree_block needs a dedicated freeing
function that will make sure all invariants (refs == 2, no other
structures connected) are met and then do effectively the same what
_stale does now.
