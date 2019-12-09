Return-Path: <SRS0=15Oe=Z7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE58C43603
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Dec 2019 15:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8BD820692
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Dec 2019 15:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfLIPcy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 Dec 2019 10:32:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:40308 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726483AbfLIPcy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Dec 2019 10:32:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3028AAD0E;
        Mon,  9 Dec 2019 15:32:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D5EFADA783; Mon,  9 Dec 2019 16:32:45 +0100 (CET)
Date:   Mon, 9 Dec 2019 16:32:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs: misc/016 hangs at ioctl
Message-ID: <20191209153244.GI2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <3b8f824f-0c55-b54b-e23d-257ad1b2f239@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b8f824f-0c55-b54b-e23d-257ad1b2f239@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 04, 2019 at 02:06:11PM +0800, Qu Wenruo wrote:
> Hi,
> 
> Found a strange failure at btrfs-progs selftest misc/016.
> 
> It hangs at current master 63de37476ebd ("Merge tag
> 'tag-chrome-platform-for-v5.5' of
> git://git.kernel.org/pub/scm/linux/kernel/git/chrome-platform/linux").
> 
> What makes it even more mysterious is, misc-5.5 passes.
> 
> Since there is no other btrfs pull, it's caused by some upstream
> non-btrfs commits.

For the record, 5.5-rc1 is ok again (several fixes in fs/pipe.c). So I'm
going to rebase misc-next on top of that.
