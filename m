Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39688 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752923AbeADTFE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jan 2018 14:05:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w04J2BYP011123
        for <linux-btrfs@vger.kernel.org>; Thu, 4 Jan 2018 19:05:02 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2f9t2400w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jan 2018 19:05:02 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w04Itvxk031322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 4 Jan 2018 18:55:57 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w04Itu6P015434
        for <linux-btrfs@vger.kernel.org>; Thu, 4 Jan 2018 18:55:56 GMT
Date: Thu, 4 Jan 2018 10:50:35 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: not a disk error if the bio_add_page fails
Message-ID: <20180104185035.GC5829@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20180103080729.20804-1-anand.jain@oracle.com>
 <20180103135243.21169-1-anand.jain@oracle.com>
 <20180104174756.GB5829@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180104174756.GB5829@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 04, 2018 at 09:47:56AM -0800, Liu Bo wrote:
> On Wed, Jan 03, 2018 at 09:52:43PM +0800, Anand Jain wrote:
> > bio_add_page() can fail for logical reasons as from the bio_add_page()
> > comments:- 'This will only fail if either
> > bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.' Don't inc the
> > write error statistics for this. And set -EINVAL instead of -EIO.
> >
> 
> It's correct to skip increasing counter, but why -EINVAL?
> (its caller only cares about if it's non-zero.)

Well...there is no chance that bio_add_page() could return
non-PAGE_SIZE as this bio has been just created, we can remove the
error handling after bio_add_page().

thanks,
-liubo
> 
> thanks,
> 
> -liubo
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> > v1->v2: Add missing bio_put(). Thanks Filipe.
> > 
> >  fs/btrfs/scrub.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> > index ecfe3118d9dd..57ac39a3f046 100644
> > --- a/fs/btrfs/scrub.c
> > +++ b/fs/btrfs/scrub.c
> > @@ -4617,15 +4617,16 @@ static int write_page_nocow(struct scrub_ctx *sctx,
> >  	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
> >  	ret = bio_add_page(bio, page, PAGE_SIZE, 0);
> >  	if (ret != PAGE_SIZE) {
> > -leave_with_eio:
> > +		bio_put(bio);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (btrfsic_submit_bio_wait(bio)) {
> >  		bio_put(bio);
> >  		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
> >  		return -EIO;
> >  	}
> >  
> > -	if (btrfsic_submit_bio_wait(bio))
> > -		goto leave_with_eio;
> > -
> >  	bio_put(bio);
> >  	return 0;
> >  }
> > -- 
> > 2.15.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
