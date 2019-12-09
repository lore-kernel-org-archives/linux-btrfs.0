Return-Path: <SRS0=15Oe=Z7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC8CC00454
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Dec 2019 17:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FCFE2080D
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Dec 2019 17:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfLIRuF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 Dec 2019 12:50:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:46882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726379AbfLIRuE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Dec 2019 12:50:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 312BEB15B;
        Mon,  9 Dec 2019 17:50:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0F44DDA82A; Mon,  9 Dec 2019 18:49:56 +0100 (CET)
Date:   Mon, 9 Dec 2019 18:49:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs kconfig update for 5.5-rc2
Message-ID: <20191209174955.GO2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        torvalds@linux-foundation.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1575911345.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1575911345.git.dsterba@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 09, 2019 at 06:31:12PM +0100, David Sterba wrote:
> Hi,
> 
> this is a separate pull request based on 5.5-rc1 that adds config
> dependency integrating the crypto code and btrfs support for blake2b
> (added in this dev cycle, via different trees). Without it the option
> has to be selected manually. Please pull, thanks.
> 
> The following changes since commit e42617b825f8073569da76dc4510bfa019b1c35a:
> 
>   Linux 5.5-rc1 (2019-12-08 14:57:55 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.5-rc1-kconfig

There's also the signed tag that I forgot to update in the mail:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.5-rc1-kconfig-tag
