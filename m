Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2220C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Feb 2021 14:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79D5C64E37
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Feb 2021 14:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhBOOgc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Feb 2021 09:36:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:47138 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhBOOgX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Feb 2021 09:36:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8324FAC32;
        Mon, 15 Feb 2021 14:35:41 +0000 (UTC)
Date:   Mon, 15 Feb 2021 14:35:35 +0000
From:   Michal Rostecki <mrostecki@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Michal Rostecki <mrostecki@suse.com>
Subject: Re: [PATCH RFC 5/6] btrfs: sysfs: Add directory for read policies
Message-ID: <20210215143535.GA21872@wotan.suse.de>
References: <20210209203041.21493-1-mrostecki@suse.de>
 <20210209203041.21493-6-mrostecki@suse.de>
 <YCensH6UvkIp7Hnm@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCensH6UvkIp7Hnm@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 13, 2021 at 11:19:28AM +0100, Greg KH wrote:
> On Tue, Feb 09, 2021 at 09:30:39PM +0100, Michal Rostecki wrote:
> > From: Michal Rostecki <mrostecki@suse.com>
> > 
> > Before this change, raid1 read policy could be selected by using the
> > /sys/fs/btrfs/[fsid]/read_policy file.
> > 
> > Change it to /sys/fs/btrfs/[fsid]/read_policies/policy.
> > 
> > The motivation behing creating the read_policies directory is that the
> > next changes and new read policies are going to intruduce settings
> > specific to read policies.
> 
> No Documentation/ABI/ update for this change?
> 

Good point. As far as I see, we have no btrfs-related file there. I will
add it to Documentation/ABI/testing in v2.

I guess we also need to document all the options from btrfs that are
unaffected by this particular patchset? Would it make sense to cover
them in a separate patch?
