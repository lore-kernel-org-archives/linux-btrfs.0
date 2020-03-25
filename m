Return-Path: <SRS0=KM0e=5K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AD5C2D0E5
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Mar 2020 18:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2141B206F6
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Mar 2020 18:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgCYSbM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 14:31:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:50590 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgCYSbL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Mar 2020 14:31:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B72AFAC79;
        Wed, 25 Mar 2020 18:31:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E7B75DA730; Wed, 25 Mar 2020 19:30:38 +0100 (CET)
Date:   Wed, 25 Mar 2020 19:30:38 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 00/39] btrfs: qgroup: Use backref cache based backref
 walk for commit roots
Message-ID: <20200325183038.GF5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200317081125.36289-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317081125.36289-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 17, 2020 at 04:10:46PM +0800, Qu Wenruo wrote:
> This patchset is based on an OLD misc-next branch, please inform me
> before trying to merge, so I can rebase it to latest misc-next.
> (There will be tons of conflicts)

The were, I tried to get a sense how much work it would be. There are
some new patches in misc-next that are not in the misc-next you used,
causing conflicts.

The branch misc-5.7 is now in freeze mode, I'm not expecting any changes
so you could rebase it on top of that, any further rebase should be
easy.

New patches are on the way to misc-next, so this won't be a good base
for the upcoming weeks but the pull request branch and later 5.7-rc1
are.
