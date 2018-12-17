Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC03C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 19:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E1620874
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 19:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389345AbeLQT7q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 14:59:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:41856 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732483AbeLQT7q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 14:59:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B420ADC8
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 19:59:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 902F8DA7C9; Mon, 17 Dec 2018 20:59:21 +0100 (CET)
Date:   Mon, 17 Dec 2018 20:59:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] btrfs-progs: check update
Message-ID: <20181217195921.GU23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181126060438.26075-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126060438.26075-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 02:04:38PM +0800, Qu Wenruo wrote:
> Hi David,
> 
> Please merge this pull request:
> https://github.com/kdave/btrfs-progs/pull/155
> 
> 
> This patch can be fetch from the following branch:
> https://github.com/adam900710/btrfs-progs/tree/check-next
> 
> The base commit is:
> commit 5d64c40240135cc22f4ba2b902bfe20418a599ea (david/devel)
> Author: David Sterba <dsterba@suse.com>
> Date:   Tue Nov 20 11:13:08 2018 +0100
> 
>     btrfs-progs: docs: fix rendering of exponents in manual pages
>     
>     Reported on IRC that the inode number limit appears to be 264, while the
>     actual value is 2^64. Fix that for the manual page backend by redefining
>     the format.
>     
>     Signed-off-by: David Sterba <dsterba@suse.com>
> 
> 
> This small patchset contains 2 check related functionality:
> 1) Ability to repair dir item with mismatch hash
>    Both lowmem and original check, along with test case update.
> 
> 2) Check qgroup limit exceed
>    The patch to deprecate BTRFS_QGROUP_LIMIT_RSV_RFER|EXCL is dropped
>    for this pull request, as it's still uncertain if it's OK or not, and
>    it's very easy to rebase that patch.
> 
> The patchset passes all selftest with one exception:
> misc-tests/021-image-multi-devices
> 
> That test case failure is caused by poorly recovered multi-device
> btrfs-image.
> The problem exists from the very beginning, just recent enhanced kernel
> code will refuse to mount and I'll address it later in another patchset.
> 
> There is some other check related patches, naming "btrfs-progs: fixes of
> file extent in original and lowmem check" from Fujitsu, which is still
> being updated. I'll push them in next update.
> 
> Thanks,
> Qu
> 
> Qu Wenruo (5):
>   btrfs-progs: lowmem check: Add ability to repair dir item with
>     mismatch hash
>   btrfs-progs: original check: Use mismatch_dir_hash_record to record
>     bad dir items

This patch changes the output style from "report when it happens" to
"print a summary". I find the latter a bit more unfriendly as it can
take long time before something gets printed at all and it looks like
there's no problem with the dir items until that point.
Also if memory allocation fails at the time the entry is added to list,
the information is lost.

We can do both but would need to set the verbosity, the default can be
the summary. For the verbose level 'more-is-better'. The output of check
needs to be improved, that's known, so I'll take the patch as-is, the
overall output changes would need a full code audit anyway.


>   btrfs-progs: original check: Add ability to repair dir item with
>     invalid hash
>   btrfs-progs: fsck-tests: Make 026-bad-dir-item-name test case to
>     verify if btrfs-check can also repair it

The patches look good.

>   btrfs-progs: qgroup-verify: Check if qgroup limit is exceeded

This patch has very short changelog compared to what it does, can you
please update and resend? Thanks.
