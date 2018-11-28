Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C59FC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 15:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE88520832
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 15:22:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE88520832
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbeK2CYh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 21:24:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:40814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727726AbeK2CYg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 21:24:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C89E5AED5;
        Wed, 28 Nov 2018 15:22:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 00DB5DAC7F; Wed, 28 Nov 2018 16:22:17 +0100 (CET)
Date:   Wed, 28 Nov 2018 16:22:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/9] btrfs: switch BTRFS_FS_STATE_* to enums
Message-ID: <20181128152217.GP2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <4365d4183bf65240273c8602faa0a75e88906d38.1543348078.git.dsterba@suse.com>
 <20181128002403.GI846@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128002403.GI846@vader>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 04:24:03PM -0800, Omar Sandoval wrote:
> On Tue, Nov 27, 2018 at 08:53:41PM +0100, David Sterba wrote:
> > We can use simple enum for values that are not part of on-disk format:
> > global filesystem states.
> 
> Reviewed-by: Omar Sandoval <osandov@fb.com>
> 
> Some typos/wording suggestions below.
> 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/ctree.h | 25 +++++++++++++++++++------
> >  1 file changed, 19 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index a98507fa9192..f82ec5e41b0c 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -109,13 +109,26 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
> >  }
> >  
> >  /*
> > - * File system states
> > + * Runtime (in-memory) states of filesystem
> >   */
> > -#define BTRFS_FS_STATE_ERROR		0
> > -#define BTRFS_FS_STATE_REMOUNTING	1
> > -#define BTRFS_FS_STATE_TRANS_ABORTED	2
> > -#define BTRFS_FS_STATE_DEV_REPLACING	3
> > -#define BTRFS_FS_STATE_DUMMY_FS_INFO	4
> > +enum {
> > +	/* Global indicator of serious filesysystem errors */
> 
> filesysystem -> filesystem
> 
> > +	BTRFS_FS_STATE_ERROR,
> > +	/*
> > +	 * Filesystem is being remounted, allow to skip some operations, like
> > +	 * defrag
> > +	 */
> > +	BTRFS_FS_STATE_REMOUNTING,
> > +	/* Track if the transaction abort has been reported */
> 
> Which one is "the" transaction abort? This gives me the impression that
> this is a flag on the transaction, but it's actually filesystem state.
> Maybe "Track if a transaction abort has been reported on this
> filesystem"?

Your wording is more clear and I've used it in the patch.

> > +	BTRFS_FS_STATE_TRANS_ABORTED,
> > +	/*
> > +	 * Indicate that replace source or target device state is changed and
> > +	 * allow to block bio operations
> > +	 */
> 
> Again, this makes it sound like it's device state, but it's actually
> filesystem state. How about "Bio operations should be blocked on this
> filesystem because a source or target device is being destroyed as part
> of a device replace"?

Same. Thanks.
