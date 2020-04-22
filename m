Return-Path: <SRS0=dx4s=6G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B8AC55185
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 22:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3381F20776
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 22:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgDVW5z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 18:57:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:36160 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgDVW5z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 18:57:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 85983ABC7;
        Wed, 22 Apr 2020 22:57:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 629FEDA704; Thu, 23 Apr 2020 00:57:11 +0200 (CEST)
Date:   Thu, 23 Apr 2020 00:57:11 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] Btrfs: fix memory leak of transaction when
 deleting unused block group
Message-ID: <20200422225711.GV18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20200417144012.9269-1-fdmanana@kernel.org>
 <20200417153615.23832-1-fdmanana@kernel.org>
 <CAL3q7H47_MMqwT8-VLGDWJ-GJMoP1yOpwG8_+qE+ntaq_3xYDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H47_MMqwT8-VLGDWJ-GJMoP1yOpwG8_+qE+ntaq_3xYDQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 21, 2020 at 09:05:33AM +0100, Filipe Manana wrote:
> On Fri, Apr 17, 2020 at 4:38 PM <fdmanana@kernel.org> wrote:
> >
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When cleaning pinned extents right before deleting an unused block group,
> > we check if there's still a previous transaction running and if so we
> > increment its reference count before using it for cleaning pinned ranges
> > in its pinned extents iotree. However we ended up never decrementing the
> > reference count after using the transaction, resulting in a memory leak.
> >
> > Fix it by decrementing the reference count.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> 
> Fixes: fe119a6eeb6705 ("btrfs: switch to per-transaction pinned extents")
> 
> And missed that in v2, but had it in v1.

Patch updated, thanks.
