Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EAFC433EF
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Mar 2022 15:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245344AbiCTPfG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 20 Mar 2022 11:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbiCTPfF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Mar 2022 11:35:05 -0400
Received: from out20-37.mail.aliyun.com (out20-37.mail.aliyun.com [115.124.20.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9034205C7;
        Sun, 20 Mar 2022 08:33:40 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08608971|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0130863-0.00146123-0.985452;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047202;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.N8cK4eb_1647790417;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.N8cK4eb_1647790417)
          by smtp.aliyun-inc.com(33.37.75.176);
          Sun, 20 Mar 2022 23:33:37 +0800
Date:   Sun, 20 Mar 2022 23:33:37 +0800
From:   Eryu Guan <guan@eryu.me>
To:     dsterba@suse.cz, Gabriel Niebler <gniebler@suse.com>,
        fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: fix btrfs/255 to fail on deadlock
Message-ID: <YjdJUaOK6PTthAik@desktop>
References: <20220216100535.4231-1-gniebler@suse.com>
 <YhJ1VwUqPWkgPx2V@desktop>
 <20220223171126.GQ12643@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223171126.GQ12643@twin.jikos.cz>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 23, 2022 at 06:11:26PM +0100, David Sterba wrote:
> On Mon, Feb 21, 2022 at 01:07:35AM +0800, Eryu Guan wrote:
> > On Wed, Feb 16, 2022 at 11:05:35AM +0100, Gabriel Niebler wrote:
> > > In its current implementation, the test btrfs/255 would hang forever
> > > on any kernel w/o patch "btrfs: fix deadlock between quota disable
> > > and qgroup rescan worker", rather than failing, as it should.
> > > Fix this by introducing generous timeouts.
> > > 
> > > Signed-off-by: Gabriel Niebler <gniebler@suse.com>
> > 
> > If deadlock was already triggered, I don't think killing the userspace
> > program with timeout will help, as the kernel already deadlocked, and
> > filesystem and/or device can't be used by next test either.
> > 
> > I think we should just exclude the test when running tests on unpatched
> > kernel.
> 
> I don't see a way how to detect it at runtime, or do you mean to use the
> expunge files?

Yes, use expunge file and run fstests with './check -E <path_to_expunge_file>'

Thanks,
Eryu
