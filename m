Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB71C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 14:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2371206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 14:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391074AbfAKOjb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 09:39:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:48218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391049AbfAKOja (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 09:39:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42707AC3E;
        Fri, 11 Jan 2019 14:39:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 76A84DA780; Fri, 11 Jan 2019 15:38:57 +0100 (CET)
Date:   Fri, 11 Jan 2019 15:38:56 +0100
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] Btrfs: use cross mount point check for cloning and
 deduplication
Message-ID: <20190111143855.GF27146@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181212180559.15249-1-fdmanana@kernel.org>
 <20181212180559.15249-3-fdmanana@kernel.org>
 <20181213160224.GD23615@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213160224.GD23615@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 05:02:24PM +0100, David Sterba wrote:
> On Wed, Dec 12, 2018 at 06:05:57PM +0000, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> > 
> > There is no reason why this check was performed for clone operations but
> > not for deduplication operations, after all deduplication is a special
> > case of cloning. So make the check happen for deduplication as well.
> > 
> > This check used to be done and got removed by accident in commit
> > 2b3909f8a7fe9 ("btrfs: use new dedupe data function pointer").
> > 
> > Fixes: 2b3909f8a7fe9 ("btrfs: use new dedupe data function pointer").
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/ioctl.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 1e90d10b5638..ffe940ceb80a 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -3912,12 +3912,12 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> >  
> >  		if (btrfs_root_readonly(root_out))
> >  			return -EROFS;
> > -
> > -		if (file_in->f_path.mnt != file_out->f_path.mnt ||
> > -		    inode_in->i_sb != inode_out->i_sb)
> > -			return -EXDEV;
> >  	}
> >  
> > +	if (file_in->f_path.mnt != file_out->f_path.mnt ||
> > +	    inode_in->i_sb != inode_out->i_sb)
> > +		return -EXDEV;
> 
> I'm checking if this is or is not a change in the dedupe behaviour
> regarding dedupe on different mont points.
> 
> I can't see the f_path.mnt check anywhere in the VFS calls so after that
> patch deduping stops to work in some cases.

Dedupe on cross-mount has been broken (or working) since 4.5, that's a
lot of releases with at least 4 stables in between. Changing that back
might break applications, I've asked on irc but none of the widely used
tools depend on that.

As usual we can never know for sure, so I'd like to explore the option
to keep it working. We'd also like to drop the cross-mount limitation
for clone that's something users do want. However this still has some
opposition from VFS people.

Unless there's a technical/stability reason to add the check back, I'd
like to keep it working.
