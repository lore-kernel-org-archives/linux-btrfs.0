Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC28C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 17:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED0F921871
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 17:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfABRom (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 12:44:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:52798 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbfABRom (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 12:44:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1A182AD7D;
        Wed,  2 Jan 2019 17:44:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 947AEDA781; Wed,  2 Jan 2019 18:43:34 +0100 (CET)
Date:   Wed, 2 Jan 2019 18:43:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not overwrite error return value in scrub
 progress ioctl
Message-ID: <20190102174334.GD23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181214194513.21741-1-fdmanana@kernel.org>
 <0b82526f-36b3-4b6d-c4b9-9c5b6d685412@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b82526f-36b3-4b6d-c4b9-9c5b6d685412@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 17, 2018 at 09:33:43AM +0200, Nikolay Borisov wrote:
> 
> 
> On 14.12.18 г. 21:45 ч., fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> > 
> > If the call to btrfs_scrub_progress() failed we would overwrite the error
> > returned to user space with -EFAULT if the call to copy_to_user() failed
> > as well. Fix that by calling copy_to_user() only if btrfs_scrub_progress()
> > returned success.
> > 
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/ioctl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 01d18e1a393e..76848214a39f 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -4331,7 +4331,7 @@ static long btrfs_ioctl_scrub_progress(struct btrfs_fs_info *fs_info,
> >  
> >  	ret = btrfs_scrub_progress(fs_info, sa->devid, &sa->progress);
> >  
> > -	if (copy_to_user(arg, sa, sizeof(*sa)))
> > +	if (ret == 0 && copy_to_user(arg, sa, sizeof(*sa)))
> 
> While this is ok it's a bit counter intuitive considering the code
> convention. Because you predicate the execution of copy_to_user on the
> ret value of btrfs_scrub_progress in the same if. Perhaps,
> 
> if (ret)
>   return ret;
> 
> if (copy_to_user)
>   return -EFAULT
> 
> 
> Same feedback applies to your other patches, but I'm fine if you leave
> it as is so:

I've checked how common is "if (ret == 0 && copy_to_user...)" and there
are several instances. The additional condition is quite short so the
copy_to_user call is not lost in the noise, so I'm ok with the proposed
style. I would not even mind to unify other calls that do not follow
some common pattern eg. in btrfs_ioctl_set_received_subvol or
btrfs_ioctl_get_fslabel.
