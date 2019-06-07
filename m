Return-Path: <SRS0=hLEk=UG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13109C2BCA1
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Jun 2019 13:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E795320B7C
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Jun 2019 13:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbfFGNar (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Jun 2019 09:30:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:55594 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727862AbfFGNaq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Jun 2019 09:30:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C8A98AFBE
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Jun 2019 13:30:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 63BD1DA849; Fri,  7 Jun 2019 15:31:36 +0200 (CEST)
Date:   Fri, 7 Jun 2019 15:31:36 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Extent buffer lock cleanups
Message-ID: <20190607133136.GD30187@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1559233731.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1559233731.git.dsterba@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 30, 2019 at 06:30:57PM +0200, David Sterba wrote:
> There are 3 atomics that don't need to be, all related to writes where
> the exclusivity is guaranteed by the lock.
> 
> David Sterba (3):
>   btrfs: switch extent_buffer blocking_writers from atomic to int
>   btrfs: switch extent_buffer spinning_writers from atomic to int
>   btrfs: switch extent_buffer write_locks from atomic to int
> 
>  fs/btrfs/extent_io.c  |  6 ++---
>  fs/btrfs/extent_io.h  |  6 ++---
>  fs/btrfs/locking.c    | 62 +++++++++++++++++++------------------------
>  fs/btrfs/print-tree.c |  6 ++---
>  4 files changed, 37 insertions(+), 43 deletions(-)

Added to misc-next.
