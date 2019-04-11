Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717BCC10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 17:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D71C2082E
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 17:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfDKRvm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 13:51:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:56828 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726595AbfDKRvm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 13:51:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3C85BAC5F;
        Thu, 11 Apr 2019 17:51:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6A672DA85B; Thu, 11 Apr 2019 19:52:46 +0200 (CEST)
Date:   Thu, 11 Apr 2019 19:52:44 +0200
From:   David Sterba <dsterba@suse.cz>
To:     robbieko <robbieko@synology.com>
Cc:     linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [PATCH v2] Btrfs: fix data bytes_may_use underflow with
 fallocate due to failed quota reserve
Message-ID: <20190411175244.GB3476@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, robbieko <robbieko@synology.com>,
        linux-btrfs@vger.kernel.org, fdmanana@suse.com
References: <1553572571-15614-1-git-send-email-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553572571-15614-1-git-send-email-robbieko@synology.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 11:56:11AM +0800, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> When doing fallocate, we first add the range to the reserve_list
> and then reserve the quota.
> If quota reservation fails, we'll release all reserved parts of
> reserve_list.
> However, cur_offset is not updated to indicate that this
> range is already been inserted into the list.
> Therefore, the same range is freed twice.
> Once at list_for_each_entry loop, and once at the end of the
> function.
> This will result in WARN_ON on bytes_may_use when we free the
> remaining space.
> 
> At the end, under the 'out' label we have a call to:
>    btrfs_free_reserved_data_space(inode, data_reserved, alloc_start,
> alloc_end - cur_offset);
> The start offset, third argument, should be cur_offset.
> Everything from alloc_start to cur_offset was freed by the
> list_for_each_entry_safe_loop.
> 
> Fixes: 18513091af94 ("btrfs: update btrfs_space_info's bytes_may_use timely")
> Signed-off-by: Robbie Ko <robbieko@synology.com>

I see this error:

generic/102             [02:15:05]

[ 7731.223975] run fstests generic/102 at 2019-04-09 02:15:05
[ 7731.355111] BTRFS info (device vda): disk space caching is enabled
[ 7731.358367] BTRFS info (device vda): has skinny extents
[ 7731.407393] BTRFS: device fsid 99c22651-33bd-4543-96df-da02cc320166 devid 1 transid 5 /dev/vdb
[ 7731.419081] BTRFS info (device vdb): disk space caching is enabled
[ 7731.420671] BTRFS info (device vdb): has skinny extents
[ 7731.421955] BTRFS info (device vdb): flagging fs with big metadata feature
[ 7731.426107] BTRFS info (device vdb): checking UUID tree
[ 7865.389231] BTRFS info (device vdb): disk space caching is enabled
[ 7865.393289] BTRFS info (device vdb): has skinny extents
 [02:17:19]- output mismatch (see /tmp/fstests/results//generic/102.out.bad)
    --- tests/generic/102.out   2018-10-08 09:51:53.890556726 +0000
    +++ /tmp/fstests/results//generic/102.out.bad       2019-04-09 02:17:19.460000000 +0000
    @@ -1,7 +1,7 @@
     QA output created by 102
     wrote 838860800/838860800 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -wrote 838860800/838860800 bytes at offset 0
    +wrote 109707264/838860800 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
     wrote 838860800/838860800 bytes at offset 0
    ...
    (Run 'diff -u /tmp/fstests/tests/generic/102.out /tmp/fstests/results//generic/102.out.bad'  to see the entire diff)

This is with current misc-next, with 2 other patches to tree-checker
that are unrelated. I've run fstests twice to be sure that it's not some
random fluke, it happened in both cases.

Running with with one patch below the test passes so I'm reasonably sure
it's happening due to your patch.

For reference:

- misc-next top commit fbcee956b888abbcbfed295a2191b1d0eccb0f09
  (reproduced twice)

- one below your patch c8d27001b9067085bd62adf5fdf7cc8a53bd2f7f
  (not reproduced)
