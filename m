Return-Path: <SRS0=qdEb=3C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BA2C33CA9
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 Jan 2020 21:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FDB02072B
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 Jan 2020 21:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgAMVwo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 16:52:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:44926 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgAMVwo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Jan 2020 16:52:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6FC39AC22;
        Mon, 13 Jan 2020 21:52:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1230ADA730; Mon, 13 Jan 2020 22:52:30 +0100 (CET)
Date:   Mon, 13 Jan 2020 22:52:29 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Long An <lan@suse.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: fix path for btrfs-corrupt-block
Message-ID: <20200113215229.GB3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Long An <lan@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1578649752.3609.6.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578649752.3609.6.camel@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 10, 2020 at 09:49:13AM +0000, Long An wrote:
> btrfs-corrupt-block path is wrong on exported testsutie. Fix this issue
> for below tests:
> fsck-tests/037-freespacetree-repair
> misc-tests/038-backup-root-corruption

Thanks, btrfs-corrupt-block and fssum need to be handled specially for
the testsuite. I found one more test
(fsck-tests/013-extent-tree-rebuild) with wrong path so fixed it as
well.
