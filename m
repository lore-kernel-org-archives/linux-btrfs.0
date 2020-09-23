Return-Path: <SRS0=lTFz=DA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D603C4363D
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Sep 2020 15:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4930F206FB
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Sep 2020 15:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIWPKp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 11:10:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:45512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIWPKo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Sep 2020 11:10:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 51E7AAB54;
        Wed, 23 Sep 2020 15:11:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 01B5BDA6E3; Wed, 23 Sep 2020 17:09:27 +0200 (CEST)
Date:   Wed, 23 Sep 2020 17:09:27 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] btrfs: Remove struct extent_io_ops
Message-ID: <20200923150927.GQ6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200918133439.23187-1-nborisov@suse.com>
 <20200918133439.23187-8-nborisov@suse.com>
 <20200921203808.GW6756@twin.jikos.cz>
 <94e97e0e-7b91-a877-aad1-446e231b27d5@suse.com>
 <20200923141947.GP6756@twin.jikos.cz>
 <4ea33725-98e0-20b9-369d-a18209dcfaa9@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ea33725-98e0-20b9-369d-a18209dcfaa9@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 23, 2020 at 05:23:05PM +0300, Nikolay Borisov wrote:
> 
> 
> On 23.09.20 г. 17:19 ч., David Sterba wrote:
> > On Wed, Sep 23, 2020 at 09:25:50AM +0300, Nikolay Borisov wrote:
> >>
> >>
> >> On 21.09.20 г. 23:38 ч., David Sterba wrote:
> >>> On Fri, Sep 18, 2020 at 04:34:39PM +0300, Nikolay Borisov wrote:
> >>>
> >>> You should really write changelogs for patches that not obviously
> >>> trivial.
> >>>
> >>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> >>>
> >>
> >>
> >> I thought this patch was rather self-explanatory - just removing no
> >> longer used struct and related functions but I guess that's just me
> >> given I have written the previous 6 patches, so will add a changelog in
> >> the next iteration. Thanks.
> > 
> > The subject says "remove some struct", but when somebody reads it it's
> > missing the "..., because ..." part. It becomes clear after reading the
> > patch that is' not used anymore, but there should be some clue in the
> > changelog from the beginning.
> > 
> 
> Since you are going to update the patches inline can you add the following:
> 
> "
> Since it's no longer used just remove the function and any related code
> which was initialising it for inodes. No functional changes.
> "

Will update. There are no direct functional changes, but the
extent_io_tree is shrunk by 8 bytes and there are eg. 3 instances in the
btrfs_inode, so this removes 24 bytes in total.
