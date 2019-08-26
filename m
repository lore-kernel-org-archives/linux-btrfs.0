Return-Path: <SRS0=7oLZ=WW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFFA5C3A59F
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Aug 2019 18:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B5102184D
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Aug 2019 18:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbfHZSdx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 14:33:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:35388 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727687AbfHZSdx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Aug 2019 14:33:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 528BAADF0;
        Mon, 26 Aug 2019 18:33:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C6E17DA98E; Mon, 26 Aug 2019 20:34:15 +0200 (CEST)
Date:   Mon, 26 Aug 2019 20:34:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] btrfs-progs: don't check nbytes on unlinked files
Message-ID: <20190826183415.GC2752@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20190809131831.26370-1-josef@toxicpanda.com>
 <dc439be8-0a2d-458d-c7c9-9558322c8c19@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dc439be8-0a2d-458d-c7c9-9558322c8c19@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Aug 10, 2019 at 09:06:22AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/8/9 下午9:18, Josef Bacik wrote:
> > We don't update the inode when evicting it, so the nbytes will be wrong
> > in between transaction commits.  This isn't a problem, stop complaining
> > about it to make generic/269 stop randomly failing.
> 
> Would you like to add the same check for lowmem mode?
> 
> Or mind me to do that?

Yes please. Thanks.
