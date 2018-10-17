Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E910BECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 14:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA852214C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 14:11:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA852214C2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbeJQWGw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 18:06:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:48848 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726974AbeJQWGw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 18:06:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1BA00ABE3;
        Wed, 17 Oct 2018 14:10:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B2C97DAD55; Wed, 17 Oct 2018 16:10:50 +0200 (CEST)
Date:   Wed, 17 Oct 2018 16:10:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix the return value in case of error in
 'btrfs_mark_extent_written()'
Message-ID: <20181017141047.GD29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>, clm@fb.com,
        jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20181017091359.3763-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181017091359.3763-1-christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 17, 2018 at 11:13:59AM +0200, Christophe JAILLET wrote:
> We return 0 unconditionally in most of the error handling paths of
> 'btrfs_mark_extent_written()'.
> However, 'ret' is set to some error codes in several error handling paths.
> 
> Return 'ret' instead to propagate the error code.
> 
> Fixes: 9c8e63db1de9 ("Btrfs: kill BUG_ON()'s in btrfs_mark_extent_written")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch proposal is purely speculative.
> I'm not sure at all that returning 'ret' is correct (but it looks like it
> is :) )

Agreed.

> What puzzles me is when 'ret' is set, 'btrfs_abort_transaction()' is also
> called.
> However, the only caller of 'btrfs_mark_extent_written()' (i.e.
> 'btrfs_finish_ordered_io()') also calls 'btrfs_abort_transaction()' if an
> error is returned.
> So returning an error code here, would lead to a double call to this abort
> function.

Calling abort multiple times shuld not hurt, there's a bit set atomically
so that only the first time the stacktrace is printed. There's
possiblity of the trans->aborted value overwrite if two completely
different aborts happen exactly at the same time, but still both values
gen printed in the log so there's enough information.

> I'm usure of if it is correct and/or intented.
> If returning 'ret' is correct, should we also axe the 'btrfs_abort_transaction()'
> calls here, and leave the caller do the clean-up?

This depends on the context where the abort is used. Functions that do a
lot of things but do not start the transaction are allowed to call abort
after the first unrecoverable failure, so this possibly logs the exact
error. If the abort is only in the caller, we would not know which of
the many calls in btrfs_mark_extent_written failed.

> Before the commit in the Fixes tag, we were BUGing_ON in case of errror. So
> propagating the error was pointless.

Right, now the error must be propagated to btrfs_finish_ordered_io so
the "if (ret < 0) abort" is not skipped and code continues to
add_pending_csums, btrfs_update_inode_fallback etc.

Good catch, please resend with updated changelog, you can use the
relevant parts of my comments above to explain what's wrong. Thanks.
