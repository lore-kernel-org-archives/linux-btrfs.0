Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CE7C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30A3A20645
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbfAORnR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 12:43:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:56564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728025AbfAORnR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 12:43:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B8D68AD56;
        Tue, 15 Jan 2019 17:43:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2ECA3DA83D; Tue, 15 Jan 2019 18:42:47 +0100 (CET)
Date:   Tue, 15 Jan 2019 18:42:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 07/13] btrfs-progs: Fix Wmaybe-uninitialized warning
Message-ID: <20190115174247.GM2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181205064018.27755-1-wqu@suse.com>
 <20181205064018.27755-8-wqu@suse.com>
 <20181205134005.GB3905@twin.jikos.cz>
 <926908c6-14c0-5c10-7ce2-de4b810e702b@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <926908c6-14c0-5c10-7ce2-de4b810e702b@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 05, 2018 at 10:03:30PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/12/5 下午9:40, David Sterba wrote:
> > On Wed, Dec 05, 2018 at 02:40:12PM +0800, Qu Wenruo wrote:
> >> GCC 8.2.1 will report the following warning with "make W=1":
> >>
> >>   ctree.c: In function 'btrfs_next_sibling_tree_block':
> >>   ctree.c:2990:21: warning: 'slot' may be used uninitialized in this function [-Wmaybe-uninitialized]
> >>     path->slots[level] = slot;
> >>     ~~~~~~~~~~~~~~~~~~~^~~~~~
> >>
> >> The culprit is the following code:
> >>
> >> 	int slot;		<< Not initialized
> >> 	int level = path->lowest_level + 1;
> >>  	BUG_ON(path->lowest_level + 1 >= BTRFS_MAX_LEVEL);
> >>  	while(level < BTRFS_MAX_LEVEL) {
> >> 		slot = path->slots[level] + 1;
> >> 		^^^^^^ but we initialize @slot here.
> >> 		...
> >> 	}
> >> 	path->slots[level] = slot;
> >>
> >> It's possible that compiler doesn't get enough hint for BUG_ON() on
> >> lowest_level + 1 >= BTRFS_MAX_LEVEL case.
> >>
> >> Fix it by using a do {} while() loop other than while() {} loop, to
> >> ensure we will run the loop for at least once.
> > 
> > I was hoping that we can actually add the hint to BUG_ON so the code
> > does not continue if the condition is true.
> > 
> I checked that method, but I'm not that confident about things like:
> 
> bugon_trace()
> {
> 	if (!val)
> 		return;
> 	__bugon_trace();
> }
> 
> __attribute__ ((noreturn))
> static inline void __bugon_trace();
> 
> This is as simple as just one extra function call, but the original
> problem is just one more function call before hitting abort().
> 
> So I just give up screwing up things I'm not comfort enough to tweaking.
> 
> The current do {} while() loop is the most direct solution, if gcc one
> day still gives such warning then I could say some harsh word then.

I was not able to make it work properly, patch applied so we rid of the
warning. Thanks.
