Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AFFC169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 13:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0C59217D8
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 13:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfBHNWt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:22:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:37672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726585AbfBHNWt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Feb 2019 08:22:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7FC19AD55;
        Fri,  8 Feb 2019 13:22:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3A21CDA83D; Fri,  8 Feb 2019 14:22:09 +0100 (CET)
Date:   Fri, 8 Feb 2019 14:22:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] btrfs: add zstd compression level support
Message-ID: <20190208132208.GN2900@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190204202008.51652-1-dennis@kernel.org>
 <20190207165925.GJ2900@twin.jikos.cz>
 <20190207173654.GA27942@dennisz-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207173654.GA27942@dennisz-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 07, 2019 at 12:36:54PM -0500, Dennis Zhou wrote:
> On Thu, Feb 07, 2019 at 05:59:26PM +0100, David Sterba wrote:
> > On Mon, Feb 04, 2019 at 03:19:56PM -0500, Dennis Zhou wrote:
> > > Dennis Zhou (12):
> > >   btrfs: add helpers for compression type and level
> > >   btrfs: rename workspaces_list to workspace_manager
> > >   btrfs: manage heuristic workspace as index 0
> > >   btrfs: unify compression ops with workspace_manager
> > >   btrfs: add helper methods for workspace manager init and cleanup
> > >   btrfs: add compression interface in (get/put)_workspace()
> > >   btrfs: move to fn pointers for get/put workspaces
> > >   btrfs: plumb level through the compression interface
> > >   btrfs: change set_level() to bound the level passed in
> > >   btrfs: zstd use the passed through level instead of default
> > >   btrfs: make zstd memory requirements monotonic
> > >   btrfs: add zstd compression level support
> > 
> > The patchset has been added to msic-next, scheduled for 5.1. I've left
> > out the changes to warn on wrong level, so currently it falls back to
> > the default. I don't want to make a last minute change of that sort, so
> > this needs to go as a separate patch.
> 
> Regarding the bug report from Dan, do you want me to send you a patch
> for it on top of the topic branch or do you mind fixing the missing:
> 
> unsigned int level = 0;

It's been fixed in the pushed branch.
