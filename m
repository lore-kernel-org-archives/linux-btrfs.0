Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F73C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FE4120989
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:22:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FE4120989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbeK2AYP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 19:24:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:41536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727823AbeK2AYO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 19:24:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8AE20AC55;
        Wed, 28 Nov 2018 13:22:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 01D66DAC7E; Wed, 28 Nov 2018 14:22:17 +0100 (CET)
Date:   Wed, 28 Nov 2018 14:22:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/9] btrfs: switch BTRFS_*_LOCK to enums
Message-ID: <20181128132217.GL2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <5293feb9eb97fdaaa34db024ead13c5ec19234e3.1543348078.git.dsterba@suse.com>
 <20181128003716.GO846@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128003716.GO846@vader>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 04:37:16PM -0800, Omar Sandoval wrote:
> On Tue, Nov 27, 2018 at 08:53:55PM +0100, David Sterba wrote:
> > We can use simple enum for values that are not part of on-disk format:
> > tree lock types.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/locking.h | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
> > index 29135def468e..684d0ef4faa4 100644
> > --- a/fs/btrfs/locking.h
> > +++ b/fs/btrfs/locking.h
> > @@ -6,10 +6,12 @@
> >  #ifndef BTRFS_LOCKING_H
> >  #define BTRFS_LOCKING_H
> >  
> > -#define BTRFS_WRITE_LOCK 1
> > -#define BTRFS_READ_LOCK 2
> > -#define BTRFS_WRITE_LOCK_BLOCKING 3
> > -#define BTRFS_READ_LOCK_BLOCKING 4
> > +enum {
> > +	BTRFS_WRITE_LOCK,
> 
> See btrfs_set_path_blocking() and btrfs_release_path(); 0 means no lock,
> so this needs to be BTRFS_WRITE_LOCK = 1. I imagine that lockdep would
> catch this.

Oh right of course, thanks for catching it. I'll drop the patch for now,
0 could be added to the set as BTRFS_NO_LOCK and replaced in the code
which is beyond what this series does.
