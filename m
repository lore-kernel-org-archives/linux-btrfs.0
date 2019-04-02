Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC21C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 21:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6246A2084C
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 21:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfDBVkM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 17:40:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:49348 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725822AbfDBVkM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 17:40:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 778D7AD55;
        Tue,  2 Apr 2019 21:40:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 68544DA824; Tue,  2 Apr 2019 23:41:21 +0200 (CEST)
Date:   Tue, 2 Apr 2019 23:41:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4 RESEND] btrfs: open code btrfs_set_prop in
 inherit_prop
Message-ID: <20190402214121.GF29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20190402100742.8355-1-anand.jain@oracle.com>
 <20190402100742.8355-5-anand.jain@oracle.com>
 <8fedbab1-6fec-92cb-25b2-c9b9ff264103@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8fedbab1-6fec-92cb-25b2-c9b9ff264103@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 02, 2019 at 04:35:12PM +0300, Nikolay Borisov wrote:
> On 2.04.19 г. 13:07 ч., Anand Jain wrote:
> > When an inode inherits property from its parent, we call btrfs_set_prop().
> > btrfs_set_prop() does an elaborate checks, which is not required in the
> > context of inheriting a property. Instead just open-code only the required
> > items from btrfs_set_prop() and then call btrfs_setxattr() directly. So
> > now the only user of btrfs_set_prop() is gone, (except for the wraper
> > function btrfs_set_prop_trans()).
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> >  fs/btrfs/props.c | 27 +++++++++++++++++++++------
> >  1 file changed, 21 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> > index 72a06c4d3c70..fb84e76f3b1d 100644
> > --- a/fs/btrfs/props.c
> > +++ b/fs/btrfs/props.c
> > @@ -367,20 +367,35 @@ static int inherit_props(struct btrfs_trans_handle *trans,
> >  		if (!value)
> >  			continue;
> >  
> > +		/* may be removed */
> 
> This comment brings no value. Either explain *why* it can be removed or
> remove it altogether.
> 
> > +		ret = h->validate(value, strlen(value));
> > +		if (ret)
> > +			continue;
> > +
> >  		num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
> >  		ret = btrfs_block_rsv_add(root, trans->block_rsv,
> >  					  num_bytes, BTRFS_RESERVE_NO_FLUSH);
> >  		if (ret)
> > -			goto out;
> > -		ret = btrfs_set_prop(trans, inode, h->xattr_name, value,
> > +			return ret;
> > +
> > +		ret = btrfs_setxattr(trans, inode, h->xattr_name, value,
> >  				     strlen(value), 0);
> > +		if (!ret) {
> > +			ret = h->apply(inode, value, strlen(value));
> > +			if (ret)
> > +				btrfs_setxattr(trans, inode, h->xattr_name,
> > +					       NULL, 0, 0);
> > +			else
> > +				set_bit(BTRFS_INODE_HAS_PROPS,
> > +					&BTRFS_I(inode)->runtime_flags);
> > +		}
> > +
> >  		btrfs_block_rsv_release(fs_info, trans->block_rsv, num_bytes);
> 
> (not related to this patch) but should the reservation be released after
> setxattr is called, even if it succeeds, since we need to hold it until
> the reservation is committed. E.g. if we have to inherit 2 props then in
> the first iteration of the loop we reserve space, we call btrfs_Setxattr
> with enough reserved space, then in the 2nd reservation we need another
> reservation on top of the previous one, no ?

I think that's the problem Josef's patches were supposed to fix.
