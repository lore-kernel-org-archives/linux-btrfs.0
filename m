Return-Path: <SRS0=fkno=ZU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2BFC432C0
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Nov 2019 11:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E636021775
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Nov 2019 11:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfK1LpD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Nov 2019 06:45:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:42214 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbfK1LpC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Nov 2019 06:45:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5483FABC4;
        Thu, 28 Nov 2019 11:45:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EB24ADA971; Thu, 28 Nov 2019 12:44:58 +0100 (CET)
Date:   Thu, 28 Nov 2019 12:44:58 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs: Do not check for PagePrivate twice
Message-ID: <20191128114458.GG2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20191018181544.26515-1-rgoldwyn@suse.de>
 <CAL3q7H7kvKGFmKgoMuQFv7Qx4PCV02gfX6yWMa-tL5RakU1h=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7kvKGFmKgoMuQFv7Qx4PCV02gfX6yWMa-tL5RakU1h=Q@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 21, 2019 at 10:52:06AM +0100, Filipe Manana wrote:
> On Sat, Oct 19, 2019 at 10:05 AM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> > We are checking PagePrivate twice, once with lock and once without.
> > Perform the check only once.
> 
> Have you checked if there's some performance degradation after
> removing the check?
> My guess is it's there to avoid taking the lock, as the lock can be
> heavily used on a system under heavy load (maybe even if it's not too
> heavy, since we generate a lot of dirty metadata due to cow).
> The page may have been released after locking the mapping, that's why
> we check it twice, and after unlocking we are sure it can not be
> released due to taking a reference on the extent buffer.

That's my understanding as well, so the duplicate unlocked check should
stay.
