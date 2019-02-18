Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967D0C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 16:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 716F5214DA
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 16:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732266AbfBRQNk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 11:13:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:48088 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730659AbfBRQNk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 11:13:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2938AF01;
        Mon, 18 Feb 2019 16:13:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A705DDA870; Mon, 18 Feb 2019 17:15:01 +0100 (CET)
Date:   Mon, 18 Feb 2019 17:15:00 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Alex Lyakas <alex@zadara.com>
Cc:     David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs fixes for 4.15-rc2
Message-ID: <20190218161500.GN9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Alex Lyakas <alex@zadara.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1511980478.git.dsterba@suse.com>
 <CAOcd+r2vJfDQcF+zqZStHMiz4PYw1irsvHYK=PjUJ5nYuUffug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOcd+r2vJfDQcF+zqZStHMiz4PYw1irsvHYK=PjUJ5nYuUffug@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 12:37:49PM +0200, Alex Lyakas wrote:
> Hi David,
> 
> >   Btrfs: incremental send, fix wrong unlink path after renaming file (2017-11-28 17:15:30 +0100)
> >
> > ----------------------------------------------------------------
> > David Sterba (2):
> >       btrfs: add missing device::flush_bio puts
> Is there a reason that this one should not be tagged as "stable"? At
> least the missing bio_put in  free_fs_devices is not an error case,
> and would happen every time.

2 years old, hard to remember if there was a reason or not. At that
time, not all patches got cc:stable because patches with Fixes: tag were
usually picked by stable team and that's what we relied on, as long as
the patch applied. This worked and still works, though I've started to
do more thorough review of various fixes against stable trees and add
the tag eventually.

The fix applies only to 4.14 stable, so it could be submitted there for
inclusion.
