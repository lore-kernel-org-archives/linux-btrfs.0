Return-Path: <SRS0=Ri2p=4V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AED6C3F2CD
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Mar 2020 13:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 435992166E
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Mar 2020 13:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgCDNuc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 08:50:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:38734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729462AbgCDNuc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Mar 2020 08:50:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9E22BAF48;
        Wed,  4 Mar 2020 13:50:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 27CE0DA7B4; Wed,  4 Mar 2020 14:50:08 +0100 (CET)
Date:   Wed, 4 Mar 2020 14:50:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: inspect: make sure LOGICAL_INO_V2 args are
 zero-initialized
Message-ID: <20200304135008.GR2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs@vger.kernel.org
References: <20200131020823.29824-1-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131020823.29824-1-ce3g8jdj@umail.furryterror.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 30, 2020 at 09:08:23PM -0500, Zygo Blaxell wrote:
> LOGICAL_INO v1 ignored the reserved fields, so they could be filled
> with random stack garbage and have no effect.  LOGICAL_INO_V2 requires
> all unused reserved bits to be set to zero, and returns EINVAL if they
> are not, to guard against future kernel versions which may interpret
> non-zero bit values.
> 
> Sometimes when 'btrfs ins log' runs, the stack garbage is zeros, so the
> -o (ignore offsets) option for logical-resolve works.  Sometimes the
> stack garbage is something else, and 'btrfs ins log -o' fails with
> invalid argument.  This depends mostly on compiler version and build
> environment details, so a binary typically either always works or never
> works.
> 
> Fix by initializing logical-resolve's argument structure with a C99
> compound literal zero.
> 
> Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>

Added to devel, thanks.
