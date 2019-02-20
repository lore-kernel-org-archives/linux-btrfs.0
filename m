Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CC4C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 18:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 361CB206B7
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 18:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfBTSY0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 13:24:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:57884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725822AbfBTSY0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 13:24:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 24C88ABC3
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2019 18:24:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3F14ADA851; Wed, 20 Feb 2019 19:25:45 +0100 (CET)
Date:   Wed, 20 Feb 2019 19:25:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
Message-ID: <20190220182544.GZ9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190218052753.24138-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218052753.24138-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 01:27:41PM +0800, Qu Wenruo wrote:
> Patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/write_time_tree_checker
> Which is based on v5.0-rc1 tag.

Please base the patches on something new, a recent rc is fine (rc6 or
rc7 depends what you've tested).

> Also there is no conflict rebasing the patchset to misc-next.

The patches can apply on top of misc-next, but I've seen some hunks
applied with offset. While git is good, mismerges can still happen, so
if you do the rebase on your side it lowers the risk.

> This patchset has the following 3 features:
> - Tree block validation output enhancement
>   * Output validation failure timing (write time or read time)
>   * Always output tree block level/key mismatch error message
>     This part is already submitted and reviewed.
> 
> - Write time tree block validation check
>   To catch memory corruption either from hardware or kernel.
>   Example output would be:
> 
>     BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
>     BTRFS error (device dm-3): block=1350630375424 write time tree block corruption detected
>     BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
>     BTRFS info (device dm-3): forced readonly
>     BTRFS warning (device dm-3): Skipping commit of aborted transaction.
>     BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=-5 IO failure
>     BTRFS info (device dm-3): delayed_refs has NO entry
> 
> - Better error handling before calling flush_write_bio()
>   One hidden reason of calling flush_write_bio() under all cases is,
>   flush_write_bio() will trigger endio function and endio function of
>   epd->bio will free the bio under all cases.
>   So we're in fact abusing flush_write_bio() as cleanup.
> 
>   Since now flush_write_bio() has its own return value, we shouldn't call
>   flush_write_bio() no-brain, here we introduce proper cleanup helper,
>   end_write_bio(). Now we call flush_write_bio() like:
>               New                 |           Old
>   --------------------------------------------------------------
>   ret = do_some_evil(&epd);       | ret = do_some_evil(&epd);
>   if (ret < 0) {                  | flush_write_bio(&epd);
>   	end_write_bio(&epd, ret); | ^^^ submitting half-backed epd->bio?
>   	return ret;               | return ret;
>   }                               |
>   ret = flush_write_bio(&epd);    |
>   return ret;                     |
> 
>   Above code should be more streamline for the error handling part.
> 
> Changelog:
> v2:
> - Unlock locked pages in lock_extent_buffer_for_io() for error handling.
> - Added Reviewed-by tags.
> 
> v3:
> - Remove duplicated error message.
> - Use IS_ENABLED() macro to replace #ifdef.
> - Added Reviewed-by tags.
> 
> v4:
> - Re-organized patch split
>   Now each BUG_ON() cleanup has its own patch
> - Dig much further into the call sites to eliminate unexpected >0 return
>   May be a little paranoid and abuse some ASSERT(), but it should be
>   much safer against further code change.
> - Fix the false alert caused by balance and memory pressure
>   The fix it skip owner checker for non-essential tree at write time.
>   Since owner root can't always be reliable, either due to commit root
>   created in current transaction or balance + memory pressure.
> 
> v5:
> - Do proper error-out handling other than relying on flush_write_bio()
>   to clean up.
>   This has a side effect that no Reviewed-by tags for modified patches.
> - New comment for why we don't need to do anything about ebp->bio when
>   submit_one_bio() fails.
> - Add some Reviewed-by tag.
> 
> v5.1:
> - Add "block=%llu " output for write/read time error line.
> - Also output read time error message for fsid/start/level check.

The patchset is in a good shape, I like the detailed changelogs and
example messages. I'll give it some more testing though merging to 5.1
does not seem to be feasible now but we'll see. The improved error
handling is not really a feature so a late pull request could be ok for
that.

Thanks.
