Return-Path: <SRS0=NQJ8=5G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA16C4332D
	for <linux-btrfs@archiver.kernel.org>; Sat, 21 Mar 2020 17:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFE68206F9
	for <linux-btrfs@archiver.kernel.org>; Sat, 21 Mar 2020 17:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgCURqZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 21 Mar 2020 13:46:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:55188 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgCURqY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Mar 2020 13:46:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BBBB6AB8F;
        Sat, 21 Mar 2020 17:46:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E97A8DA70B; Sat, 21 Mar 2020 18:45:53 +0100 (CET)
Date:   Sat, 21 Mar 2020 18:45:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix removal of raid[56|1c34} incompat flags after
 removing block group
Message-ID: <20200321174553.GK12659@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20200320184348.845248-1-fdmanana@kernel.org>
 <8107ef53-5317-327c-674e-d5bd1b9d1e4d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8107ef53-5317-327c-674e-d5bd1b9d1e4d@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 21, 2020 at 09:43:21AM +0800, Qu Wenruo wrote:
> 
> 
> On 2020/3/21 上午2:43, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> > 
> > We are incorrectly dropping the raid56 and raid1c34 incompat flags when
> > there are still raid56 and raid1c34 block groups, not when we do not any
> > of those anymore. The logic just got unintentionally broken after adding
> > the support for the raid1c34 modes.
> > 
> > Fix this by clear the flags only if we do not have block groups with the
> > respective profiles.
> > 
> > Fixes: 9c907446dce3 ("btrfs: drop incompat bit for raid1c34 after last block group is gone")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> 
> The fix is OK.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> Just interesting do we really need to remove such flags?
> To me, keep the flag is completely sane.

So you'd suggest to keep a flag for a feature that's not used on the
filesystem so it's not possible to mount the filesystem on an older
kernel?
