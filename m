Return-Path: <SRS0=F9iR=U2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88913C48BD6
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Jun 2019 14:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AEB52086D
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Jun 2019 14:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfF0O6J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Jun 2019 10:58:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:38530 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726370AbfF0O6I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jun 2019 10:58:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0BCFAFD4;
        Thu, 27 Jun 2019 14:58:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 879D1DA811; Thu, 27 Jun 2019 16:58:51 +0200 (CEST)
Date:   Thu, 27 Jun 2019 16:58:49 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: inode: Don't compress if NODATASUM or
 NODATACOW set
Message-ID: <20190627145849.GA20977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180515073622.18732-1-wqu@suse.com>
 <20180515073622.18732-2-wqu@suse.com>
 <95e8171b-6d08-e989-a835-637ccf2efe76@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95e8171b-6d08-e989-a835-637ccf2efe76@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jun 25, 2019 at 04:24:57PM +0800, Qu Wenruo wrote:
> Ping?
> 
> This patch should fix the problem of compressed extent even when
> nodatasum is set.
> 
> It has been one year but we still didn't get a conclusion on where
> force_compress should behave.

Note that pings to patches sent year ago will get lost, I noticed only
because you resent it and I remembered that we had some discussions,
without conclusions.

> But at least to me, NODATASUM is a strong exclusion for compress, no
> matter whatever option we use, we should NEVER compress data without
> datasum/datacow.

That's correct, but the way you fix it is IMO not right. This was also
noticed by Nikolay, that there are 2 locations that call
inode_need_compress but with different semantics.

One is the decision if compression applies at all, and the second one
when that's certain it's compression, to do it or not based on the
status decision of eg. heuristics.
