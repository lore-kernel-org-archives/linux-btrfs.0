Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E2AEC004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 14:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7A80207DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 14:30:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7A80207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbeJXW6o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 18:58:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:36512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726577AbeJXW6o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 18:58:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19FA8B0D4;
        Wed, 24 Oct 2018 14:30:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5A8A8DABAA; Wed, 24 Oct 2018 16:30:15 +0200 (CEST)
Date:   Wed, 24 Oct 2018 16:30:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Deprecate unused super block member
 log_root_transid
Message-ID: <20181024143015.GT16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181012064258.27033-1-wqu@suse.com>
 <20181012064258.27033-2-wqu@suse.com>
 <2b4ff29a-ff9b-8b56-ef13-4b76e72a281f@suse.com>
 <fbb5f43e-8eb0-08c6-a1c9-855efd960d3d@gmx.com>
 <cb6dd0fa-68e9-9e7c-c9cc-6ac609f9d9fc@suse.com>
 <152d099f-b431-b169-f33a-11ff7e88eee6@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152d099f-b431-b169-f33a-11ff7e88eee6@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 05:57:29PM +0800, Qu Wenruo wrote:
> >>>> +	printf("log_root_transid (deprecated)\t%llu\n",
> >>>> +	       le64_to_cpu(sb->__unused_log_root_transid));
> >>>
> >>> This should be entirely removed.
> >>
> >> It looks OK to me.
> >> Just like the old leafsize.
> >>
> >> And if we try to use this member again, even old progs could show it
> >> without problem.
> > 
> > But what is the point of having something which always shows 0 and is
> > essentially unused?
> 
> Personally speaking, even it's in fact never used, it is still part of
> the specification of btrfs super blocks.
> 
> Even it's a bad decision we made a long time ago, we still need to mark
> it as unused, other than converting it back to "reserved".
> 
> To make it short and clear, if some member is specified in early
> specification, even it's never used, we still need to mark it unused and
> keep part of naming.

Agreed, follows the same patern as the leafsize. The superblock dump is
a debugging and bug report tool, the full output is desirable.
