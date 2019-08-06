Return-Path: <SRS0=BA/r=WC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FF3C31E40
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Aug 2019 16:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8030820B1F
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Aug 2019 16:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbfHFQpe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Aug 2019 12:45:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:52076 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732117AbfHFQpe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Aug 2019 12:45:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93E8BAEB3;
        Tue,  6 Aug 2019 16:45:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9DD98DA7D7; Tue,  6 Aug 2019 18:46:05 +0200 (CEST)
Date:   Tue, 6 Aug 2019 18:46:05 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Sysfs updates
Message-ID: <20190806164604.GN28208@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1564505777.git.dsterba@suse.com>
 <939d08f0-e851-4f00-733e-c7de15685318@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <939d08f0-e851-4f00-733e-c7de15685318@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 06, 2019 at 11:17:09PM +0800, Anand Jain wrote:
> On 7/31/19 1:10 AM, David Sterba wrote:
> > Export the potential debugging data in the per-filesystem directories we
> > already have, so we can drop debugfs. The new directories depend on
> > CONFIG_BTRFS_DEBUG so they're not affecting normal builds.
> > 
> > David Sterba (2):
> >    btrfs: sysfs: add debugging exports
> >    btrfs: delete debugfs code
> > 
> >   fs/btrfs/sysfs.c | 68 +++++++++++++++++++++++-------------------------
> >   fs/btrfs/sysfs.h |  5 ----
> >   2 files changed, 32 insertions(+), 41 deletions(-)
> > 
> 
> For 2/2:
>   Reviewed-by: Anand Jain <anand.jain@oracle.com>
> 
> For 1/2:
>   IMO it would be better to delay this until we really have a debug hook
>   exposed at the sysfs.

Sorry, I don't understand what you mean.
