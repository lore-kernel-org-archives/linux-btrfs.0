Return-Path: <SRS0=j6ri=4T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806BDC3F2D1
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Mar 2020 20:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52D8B21556
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Mar 2020 20:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCBUCz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 15:02:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:42594 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgCBUCz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Mar 2020 15:02:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B004EB133;
        Mon,  2 Mar 2020 20:02:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CDF2ADA733; Mon,  2 Mar 2020 21:02:31 +0100 (CET)
Date:   Mon, 2 Mar 2020 21:02:31 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Marcos Paulo de Souza <marcos@mpdesouza.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] progs: Remove manpages of not packaged binaries
Message-ID: <20200302200231.GU2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Marcos Paulo de Souza <marcos@mpdesouza.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
References: <20200301033344.808-1-marcos@mpdesouza.com>
 <20200301033344.808-2-marcos@mpdesouza.com>
 <e8a6bb6a-5c8b-5898-d00a-39a739816664@gmx.com>
 <7a2549f38537c5a0f9262ae5e7aefd82e8464fb0.camel@mpdesouza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a2549f38537c5a0f9262ae5e7aefd82e8464fb0.camel@mpdesouza.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Mar 01, 2020 at 11:28:55AM -0300, Marcos Paulo de Souza wrote:
> On Sun, 2020-03-01 at 16:26 +0800, Qu Wenruo wrote:
> > 
> > On 2020/3/1 上午11:33, Marcos Paulo de Souza wrote:
> > > From: Marcos Paulo de Souza <mpdesouza@suse.com>
> > > 
> > > btrfs-find-root and btrfs-select-super stopped to be shipped in
> > 2014, so
> > > remove all references to these manpages as well.
> > 
> > Nope, my distro is still shipping it, and I find it kinda useful for
> > certain recovery scenario.
> > 
> > Thus it's better to keep their documents.
> 
> Thanks for checking this Qu. What do you think about the other two
> patches?
> 
> David, do you think you can only patches 2 and 3? The first patch can
> be skipped, since only the later two solve the issue.

I was not expecing to see actual removal of the manual pages but rather
removing manual pages installed by distro packages without the related
binaries. In the long term we want to migrate the functionality of
find-root and select-super to the 'rescue' subcommand and at that time
the manual pages' text will be moved. Until then it should be kept but
it's up to the distro package to either ship the binaries + manual pages
or neither.
