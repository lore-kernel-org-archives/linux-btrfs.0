Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37138 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966464AbeEYQHL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 12:07:11 -0400
Date: Fri, 25 May 2018 18:04:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: add parent_transid parameter to
 veirfy_level_key
Message-ID: <20180525160425.GQ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526612375-95875-1-git-send-email-bo.liu@linux.alibaba.com>
 <05c18348-3dd1-802e-21a4-3e1b464cdb1d@suse.com>
 <528aef5d-ba56-1b3d-71a1-3db87344591b@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <528aef5d-ba56-1b3d-71a1-3db87344591b@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2018 at 01:10:59PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年05月18日 13:02, Nikolay Borisov wrote:
> > 
> > 
> > On 18.05.2018 05:59, Liu Bo wrote:
> >> As verify_level_key() is checked after verify_parent_transid(), i.e.
> >>
> >> if (verify_parent_transid())
> >>    ret = -EIO;
> >> else if (verify_level_key())
> >>    ret = -EUCLEAN;
> >>
> >> if parent_transid is 0, verify_parent_transid() skips verifying
> >> parent_transid and considers eb as valid, and if verify_level_key()
> >> reports something wrong, we're not going to know if it's caused by
> >> corrupted metadata or non-checkecd eb (e.g. stale eb).
> > 
> > It's really unclear (from the changelog) how the stale eb ties with
> > parent_transid. You should have explained the relationship between
> > checking parenttransid and stale/non-stale ebs
> 
> It's in fact related to the fixing patch:
> Btrfs: fix the corruption by reading stale btree blocks
> 
> But whatever, extra mention won't hurt.

I've added reference to the patch as it has more details so we don't
have to repeat it in the changelog.

Patch added to misc-next, thanks.
