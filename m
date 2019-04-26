Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797FAC43219
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 11:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49D2B2077B
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 11:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfDZLsL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:48:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:55028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbfDZLsJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 07:48:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5D45AE04;
        Fri, 26 Apr 2019 11:48:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A9929DA847; Fri, 26 Apr 2019 13:49:12 +0200 (CEST)
Date:   Fri, 26 Apr 2019 13:49:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/10] cleanup btrfs_ioctl_setflags and btrfs_set_prop
Message-ID: <20190426114912.GQ20156@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20190420114900.15472-1-anand.jain@oracle.com>
 <20190424151432.GX20156@twin.jikos.cz>
 <e2c545dd-3339-05b4-66d9-5408f97f69da@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2c545dd-3339-05b4-66d9-5408f97f69da@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 26, 2019 at 02:20:08PM +0800, Anand Jain wrote:
> On 24/4/19 11:14 PM, David Sterba wrote:
> > On Sat, Apr 20, 2019 at 07:48:50PM +0800, Anand Jain wrote:
> >> A set of pathes to clean up btrfs_ioctl_setflags(), btrfs_set_prop_trans()
> >> and btrfs_set_prop(). So as to avoidi duplicate code in
> >> btrfs_ioctl_setflags() and killing of btrfs_set_prop_trans().
> >>
> >> Anand Jain (10):
> >>    btrfs: refactor btrfs_set_props to validate externally
> >>    btrfs: export btrfs_set_prop
> >>    btrfs: start transaction in btrfs_ioctl_setflags()
> >>    btrfs: drop useless inode i_flags copy and restore
> >>    btrfs: make a local copy of btrfs_inode flags before update
> >>    btrfs: drop old_fsflags in btrfs_ioctl_setflags
> >>    btrfs: drop local copy of inode i_mode
> >>    btrfs: start transaction in xattr_handler_set_prop
> >>    btrfs: delete unused function btrfs_set_prop_trans
> >>    btrfs: btrfs_set_prop trans is never null
> > 
> > Looks good to me, I'll add it to misc-next as it's only a cleanup
> > series, now that we're getting close to 5.2 code freeze.
> > 
> Thanks.
> I thought I will take a look, looks like its not yet pushed?
> Which is the most updated? repo gitlab/github?

It's been in for-next until yesterday and I've merged it to misc-next
after that so it'll be out today.
