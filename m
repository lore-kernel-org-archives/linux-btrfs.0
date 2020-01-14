Return-Path: <SRS0=snfn=3D=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF2AC33C9E
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Jan 2020 21:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 478D024670
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Jan 2020 21:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgANVVY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:21:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:50632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbgANVVY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Jan 2020 16:21:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B3AA5AE5E;
        Tue, 14 Jan 2020 21:21:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 39208DA795; Tue, 14 Jan 2020 22:21:08 +0100 (CET)
Date:   Tue, 14 Jan 2020 22:21:07 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Implement lazytime
Message-ID: <20200114212107.GM3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Kusanagi Kouichi <slash@ac.auone-net.jp>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200114085325045.JFBE.12086.ppp.dion.ne.jp@dmta0008.auone-net.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114085325045.JFBE.12086.ppp.dion.ne.jp@dmta0008.auone-net.jp>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 14, 2020 at 05:53:24PM +0900, Kusanagi Kouichi wrote:
> I tested with xfstests and lazytime didn't cause any new failures.

The changelog should describe what the patch does (the 'why' part too,
but this is obvious from the subject in this case). That fstests pass
without new failures is nice but there should be a specific test for
that or instructions in the changelog how to test.
