Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA47C10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 15:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD97320855
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 15:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfDDPXW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 11:23:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:60592 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727525AbfDDPXW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 11:23:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D9641B008
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2019 15:23:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1B109DA8A7; Thu,  4 Apr 2019 17:24:30 +0200 (CEST)
Date:   Thu, 4 Apr 2019 17:24:29 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Remove comprehensive root owner
 check
Message-ID: <20190404152429.GT29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190404034708.3399-1-wqu@suse.com>
 <20190404034708.3399-2-wqu@suse.com>
 <6a3d979f-aa45-422e-d415-0a7fbb26a06d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a3d979f-aa45-422e-d415-0a7fbb26a06d@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 04, 2019 at 09:23:11AM +0300, Nikolay Borisov wrote:
> 
> 
> On 4.04.19 г. 6:47 ч., Qu Wenruo wrote:
> > Commit 1ba98d086fe3 ("Btrfs: detect corruption when non-root leaf has
> > zero item") introduced comprehensive root owner checker.
> > 
> > However it's pretty expensive tree search to locate the owner root,
> > especially when it get reused by mandatory read and write time
> > tree-checker.
> > 
> > This patch will remove that check, and completely rely on owner based
> > empty leaf check, which is much faster and still works fine for most
> > case.
> > 
> > And since we skip the old root owner check, now write time tree check
> > can be merged with btrfs_check_leaf_full().
> > 
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> This patch was sent yesterday, now it's sent again with no material
> changes whatsoever? What's the point?

The core change is the same, but there are removed hunks compared to v1.
We've discussed that yesterday and Qu did it right.
