Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6654C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 21:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A57C82075E
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 21:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfDBVMI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 17:12:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:45920 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725965AbfDBVMI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 17:12:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 49ED7AF61;
        Tue,  2 Apr 2019 21:12:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5CDE8DA824; Tue,  2 Apr 2019 23:13:16 +0200 (CEST)
Date:   Tue, 2 Apr 2019 23:13:16 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4 RESEND] btrfs: fix property validate fail should not
 increment generation
Message-ID: <20190402211315.GE29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20190402100742.8355-1-anand.jain@oracle.com>
 <20190402100742.8355-6-anand.jain@oracle.com>
 <e13f6e8f-483e-85f5-e2aa-b0efaf66e621@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e13f6e8f-483e-85f5-e2aa-b0efaf66e621@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 02, 2019 at 04:45:23PM +0300, Nikolay Borisov wrote:
> 
> 
> On 2.04.19 г. 13:07 ч., Anand Jain wrote:
> > When the property fails to pass the prop_handlers::validate() check, the
> > thread should exit with no changes in the kernel, but as we are starting
> > the transaction too early, we have just updated the generation even if
> > there is no change.
> > 
> > For example:
> > btrfs prop get /btrfs compression
> >  compression=lzo
> > sync
> > btrfs in dump-super /dev/sdb | grep "^generation"
> >  generation		32
> > 
> > Try to set an incomplete compression type
> > 
> > btrfs prop set /btrfs compression zli
> >   ERROR: failed to set compression for /btrfs: Invalid argument
> > sync
> > 
> > Set failed but generation is incremented
> > btrfs in dump-super /dev/sdb | grep "^generation"
> >  generation		33  <--
> > 
> > Fix it by collapsing btrfs_set_prop_trans() into btrfs_set_prop(), which
> > provides flexibility to start the transaction after the
> > prop_handlers::validate() has been checked.
> > 
> > As of now if the prop_handlers::apply() fails then we still increment
> > the generation, but if there is strong prop_handlers::validate() then
> > the prop_handlers::apply() can never fail.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> SO what do we gain by this patch? Whether the transaction generation
> number (actually in your changelog it will be an improvement to mention
> transaction generation explicitly, because there is also inode
> generation...) is incremented or not is an implementation detail.

No, the problem is that the order of the preliminary checks and the
transaction start is reversed. So first the transaction, then do sanity
checks, that are otherwise don't depend on the transaction. Many other
places have been updatd to do the lighweight checks first and keep the
transaction region minimal.
