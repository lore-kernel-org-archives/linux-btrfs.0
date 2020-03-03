Return-Path: <SRS0=NN0a=4U=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D028C3F2C6
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D72F214D8
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgCCQbG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 11:31:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:40768 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgCCQbG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Mar 2020 11:31:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C1949B36A;
        Tue,  3 Mar 2020 16:31:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 59466DA7AE; Tue,  3 Mar 2020 17:30:42 +0100 (CET)
Date:   Tue, 3 Mar 2020 17:30:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/19] btrfs: Move generic backref cache build functions
 to backref.c
Message-ID: <20200303163041.GH2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200303071409.57982-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303071409.57982-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 03, 2020 at 03:13:50PM +0800, Qu Wenruo wrote:
> The patchset is based on previous backref_cache_refactor branch, which
> is further based on misc-next.
> 
> The whole series can be fetched from github:
> https://github.com/adam900710/linux/tree/backref_cache_code_move
> 
> All the patches in previous branch is not touched at all, thus they are
> not re-sent in this patchset.

The patches are cleanups and code moving, please fix the coding style
issues you find.

* missing lines between declarations and statements
* exported functions need btrfs_ prefix
* comments should start with an upper case letter unless it's an
  identifier, formatted to 80 columns

As this patchset depends on another one I'm not sure if it's right time
to update it now, before the other one is merged as I think the same
code is touched and this would cause extra work.

Overall it makes sensed to add more to backref.[hc] and export that as
an internal API.
