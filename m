Return-Path: <SRS0=RJN2=AN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980FFC433E0
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 13:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A8BC20772
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 13:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgGBNMv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 09:12:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:50540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgGBNMv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Jul 2020 09:12:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 776C6B16F;
        Thu,  2 Jul 2020 13:12:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 99FDBDA781; Thu,  2 Jul 2020 15:11:43 +0200 (CEST)
Date:   Thu, 2 Jul 2020 15:11:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Revert "btrfs: qgroup: Commit transaction in advance
 to reduce early EDQUOT"
Message-ID: <20200702131143.GK27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200702001434.7745-1-wqu@suse.com>
 <20200702001434.7745-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702001434.7745-4-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 02, 2020 at 08:14:34AM +0800, Qu Wenruo wrote:
> This reverts commit a514d63882c3d2063b21b865447266ebcb18b04c.
> 
> Since we have the ability to retry qgroup reservation, and do qgroup
> space flushing, there is no need for the BTRFS_FS_NEED_ASYNC_COMMIT
> mechanism anymore.
> 
> Just revert that commit to make the code a little simpler.

Interestingly, the same comment from
https://lore.kernel.org/linux-btrfs/20180629114629.GO2287@twin.jikos.cz/

applies to your patch sans the references to the other patch:

"
I do not recommend to do a revert here.  Even if a patch reverts
functionality because it's not needed anymore, then it's a "forward"
change.  There are also other changes that may affect the behaviour and
in this case it's 47dba17171a76ea2a2a71 that removes rcu barrier, so the
patch has to be put into the context of current code.

The commit is almost 2 years old, the idea of reverts is IMHO more to
provide an easy way do a small step back during one devlopment cycle
when the moving parts are still in sight.

Back then the commit fixed a deadlock, a revert here would read as 'ok,
we want the deadlock back'.

So, the code is ok. The subject needs to drop the word 'revert' and
changelg maybe mention a few more references why the logic is not needed
anymore.
"
