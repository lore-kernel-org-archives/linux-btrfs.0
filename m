Return-Path: <SRS0=dgNO=D2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461A7C433E7
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Oct 2020 16:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3AB4222B8
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Oct 2020 16:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbgJSQwv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:52:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:55854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729879AbgJSQwv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Oct 2020 12:52:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 00A2EAE47;
        Mon, 19 Oct 2020 16:52:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5C328DA8EA; Mon, 19 Oct 2020 18:51:20 +0200 (CEST)
Date:   Mon, 19 Oct 2020 18:51:20 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: some readhead fixes after removing or
 replacing a device
Message-ID: <20201019165120.GX6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <cover.1602499587.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1602499587.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 12, 2020 at 11:55:22AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This patchset fixes use-after-free bugs and a hang after a device is removed
> or replaced. The hang only happens if a device replace happens while a scrub
> is running (on a device other then the source device of the replace operation),
> while the use-after-free bugs can happen without scrub involved.
> 
> The two first patches are the actual bug fixes, while the third patch just
> adds a lockdep assertion and the fourth and last patch just makes scrub not
> trigger readahead of the csums tree when it's not needed.
> 
> Filipe Manana (4):
>   btrfs: fix use-after-free on readahead extent after failure to create
>     it
>   btrfs: fix readahead hang and use-after-free after removing a device
>   btrfs: assert we are holding the reada_lock when releasing a readahead
>     zone
>   btrfs: do not start readahead for csum tree when scrubbing non-data
>     block groups

Thanks, added to misc-next.
