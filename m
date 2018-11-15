Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6C4C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 10:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B496C2086A
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 10:28:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B496C2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbeKOUfp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 15:35:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:34438 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728699AbeKOUfp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 15:35:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 639FFAD4B;
        Thu, 15 Nov 2018 10:28:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 845AADAC1D; Thu, 15 Nov 2018 11:28:12 +0100 (CET)
Date:   Thu, 15 Nov 2018 11:28:12 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20181115102812.GO24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Filipe Manana <fdmanana@gmail.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz>
 <20181113170724.GE24115@twin.jikos.cz>
 <CAL3q7H5H+c6XzwCQP9=bS_TdUam1fFh3HOiWojDkNfdDsKj=yQ@mail.gmail.com>
 <20181114190520.GJ24115@twin.jikos.cz>
 <ecdd1309-fe6b-0c73-b898-d08ff7c48a21@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ecdd1309-fe6b-0c73-b898-d08ff7c48a21@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 01:23:25PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/11/15 上午3:05, David Sterba wrote:
> > On Tue, Nov 13, 2018 at 05:58:14PM +0000, Filipe Manana wrote:
> >> That's the infinite loop issue fixed by one of the patches submitted
> >> for 4.20-rc2:
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v4.20-rc2&id=11023d3f5fdf89bba5e1142127701ca6e6014587
> >>
> >> The branch you used for testing doesn't have that fix?
> > 
> > That explains it, thanks.  The branch was based on 4.20-rc1 as I took it
> > from Qu's repository but did not check the base.
> 
> BTW should I always rebase my patches to misc-next or misc-4.20?

The misc-next can rebase as I add the tags or need to remove a patch
etc., so using last rc or the last pulled branch (ie. the exact commit
from misc-4.20, not the head itself) should be better option for you so
you don't need to catch up and rebase constantly.

I can handle rebases of your branches to current misc-next as long as
there are no major conflicts. 

> IMHO based on -rc tags should make it easier for David to rebase/apply,
> but if it's causing problem like this, I could definitely go misc-* based.

No, that was my fault. I review and rebase all topic branches at each rc
release, but taking the branch from your repo was a bit different step
in the workflow.
