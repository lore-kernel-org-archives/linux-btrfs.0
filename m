Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B63C433ED
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 May 2021 20:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 894F860E0B
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 May 2021 20:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhEMUyp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 May 2021 16:54:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:37892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhEMUyp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 May 2021 16:54:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0F491B1F3;
        Thu, 13 May 2021 20:53:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E16F9DAEB9; Thu, 13 May 2021 22:51:02 +0200 (CEST)
Date:   Thu, 13 May 2021 22:51:02 +0200
From:   David Sterba <dsterba@suse.cz>
To:     riteshh <riteshh@linux.ibm.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs/232 crashing on 5.13-rc1?
Message-ID: <20210513205102.GK7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, riteshh <riteshh@linux.ibm.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20210513190355.GA9610@magnolia>
 <20210513191318.t36ivziw27cstfpl@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513191318.t36ivziw27cstfpl@riteshh-domain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, May 14, 2021 at 12:43:18AM +0530, riteshh wrote:
> On 21/05/13 12:03PM, Darrick J. Wong wrote:
> > Hi everyone,
> >
> > Sorry if this has already been fixed somewhere else, but I noticed the
> > following crash in btrfs/232 on 5.13-rc1.  It's not quite vanilla, but
> > the only changes to the kernel source are some unexciting xfs realtime
> > bug fixes:
> 
> Below is the fix for that.
> https://patchwork.kernel.org/project/linux-btrfs/patch/f24fb4c9f8613fe76f5a7201752152637647f8ba.1619797915.git.riteshh@linux.ibm.com/

It's been merged to master as commit 9b8a233bc294dd71d3c7d3.
