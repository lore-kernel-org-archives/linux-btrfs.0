Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F1AC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5044217F9
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:46:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j33jrigh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfC1OqE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 10:46:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56032 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfC1OqD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 10:46:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2SEcU9l066070;
        Thu, 28 Mar 2019 14:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=GT9tQLgXvDY7tozOviD5oUnkmmr0HkZ2t61MNE0uqhc=;
 b=j33jrighRLugiD1HJe4UaxMt5TyyzppPfJoeIB6VhZhmQcFZyvSMeqVnml58oqrDNbQ/
 chEeN6d5dK4Wkzvm6k+g8O8JXBztR8TuTPS2shjEfqNwu8cPAhjL022VLF0VayRkXJ8s
 5rXlPewKBL0IH1VT9xNIakvGphEYIhvl4hpWQEgpigCUmS2mDVsCDRZ+hWUww1BBRErS
 e7jXX93iHtU+MGOwGX6zuBrvrVAMdxhA5mpEdYcY2OVNopLYB/mehKHv39FnwhZdt446
 Bl4ihQZF0D5QOulbf2WryXV4La4FjTk/bg+nj8XMxp7LeOTobcBY48+sbSmp2bntNbhK hA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2re6g172vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 14:46:00 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2SEjxgc025395
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 14:45:59 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2SEjwkh029816;
        Thu, 28 Mar 2019 14:45:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 07:45:58 -0700
Date:   Thu, 28 Mar 2019 07:45:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/15] dax: Introduce IOMAP_F_COW for copy-on-write
Message-ID: <20190328144556.GC1172@magnolia>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-5-rgoldwyn@suse.de>
 <20190327175414.GB1172@magnolia>
 <20190327185853.cxb6oou3bwla3jsy@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327185853.cxb6oou3bwla3jsy@merlin>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9208 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903280100
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 27, 2019 at 01:58:53PM -0500, Goldwyn Rodrigues wrote:
> On 10:54 27/03, Darrick J. Wong wrote:
> > On Tue, Mar 26, 2019 at 02:02:50PM -0500, Goldwyn Rodrigues wrote:
> > > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > > 
> > > The IOMAP_F_COW is a flag to notify dax that it needs to copy
> > > the data from iomap->cow_addr to iomap->addr, if the start/end
> > > of I/O are not page aligned.
> > > 
> > > This also introduces dax_to_dax_copy() which performs a copy
> > > from one part of the device to another, to a maximum of one page.
> > > 
> > > Question: Using iomap.cow_addr == 0 means the CoW is to be copied
> > > (or memset) from a hole. Would this be better handled through a flag?
> > > 
> > > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > > ---
> > >  fs/dax.c              | 36 ++++++++++++++++++++++++++++++++++++
> > >  include/linux/iomap.h |  3 +++
> > >  2 files changed, 39 insertions(+)
> > > 
> > > diff --git a/fs/dax.c b/fs/dax.c
> > > index ca0671d55aa6..e254535dd830 100644
> > > --- a/fs/dax.c
> > > +++ b/fs/dax.c
> > > @@ -1051,6 +1051,28 @@ static bool dax_range_is_aligned(struct block_device *bdev,
> > >  	return true;
> > >  }
> > >  
> > > +static void dax_to_dax_copy(struct iomap *iomap, loff_t pos, void *daddr,
> > > +			    size_t len)

Hmm... is this a dax copy-in function?  I think what's going on here is
that we have a request to copy into the file @len bytes at offset @pos;
@daddr is the pmemory address of file offset @pos, and the @iomap is
supposed to have a cow address (or nothing).

(Would love a comment here, even if it is a static helper.)

> > > +{
> > > +	loff_t blk_start, blk_pg;
> > > +	void *saddr;
> > > +	ssize_t map_len;
> > > +
> > > +	/* A zero address is a hole. */
> > > +	if (iomap->cow_addr == 0) {
> > > +		memset(daddr, 0, len);
> > > +		return;
> > > +	}
> > > +
> > > +	blk_start = iomap->cow_addr + pos - iomap->cow_pos;
> > > +	blk_pg = round_down(blk_start, PAGE_SIZE);
> > > +
> > > +	map_len = dax_direct_access(iomap->dax_dev, PHYS_PFN(blk_pg), PAGE_SIZE,
> > > +			&saddr, NULL);

/me wonders if we're supposed to do something with map_len here?

> > > +	saddr += blk_start - blk_pg;
> > > +	memcpy(daddr, saddr, len);
> > > +}
> > > +
> > >  int __dax_zero_page_range(struct block_device *bdev,
> > >  		struct dax_device *dax_dev, sector_t sector,
> > >  		unsigned int offset, unsigned int size)
> > > @@ -1143,6 +1165,20 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> > >  			break;
> > >  		}
> > >  
> > > +		if (iomap->flags & IOMAP_F_COW) {
> > > +			loff_t pg_end = round_up(end, PAGE_SIZE);
> > > +			/*
> > > +			 * Copy the first part of the page
> > > +			 * Note: we pass offset as length
> > > +			 */
> > > +			if (offset)
> > > +				dax_to_dax_copy(iomap, pos - offset, kaddr, offset);
> > > +
> > > +			/* Copy the last part of the range */
> > > +			if (end < pg_end)
> > > +				dax_to_dax_copy(iomap, end, kaddr + offset + length, pg_end - end);
> > > +		}
> > > +
> > >  		map_len = PFN_PHYS(map_len);
> > >  		kaddr += offset;
> > >  		map_len -= offset;
> > > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > > index 0fefb5455bda..391785de1428 100644
> > > --- a/include/linux/iomap.h
> > > +++ b/include/linux/iomap.h
> > 
> > Probably a good idea to cc the iomap maintainers on this (entire
> > patchset)... <cough>
> 
> Yup. Will include you and Christoph in the future iterations. This will
> not be the last iteration for this patchset.
> 
> Looks like fsdevel and btrfs was too narrow a list ;)

Not necessarily, I /did/ see this on both lists.  Just a friendly
reminder that iomap has maintainers now and is no longer adrift in the
VFS. :)

> > 
> > --D
> > 
> > > @@ -35,6 +35,7 @@ struct vm_fault;
> > >  #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
> > >  #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */
> > >  #define IOMAP_F_BUFFER_HEAD	0x04	/* file system requires buffer heads */
> > > +#define IOMAP_F_COW		0x08	/* cow before write */

This could use some more elaboration, since I couldn't figure out with
certainty how this mechanism is supposed to work...

> > >  
> > >  /*
> > >   * Flags that only need to be reported for IOMAP_REPORT requests:
> > > @@ -59,6 +60,8 @@ struct iomap {
> > >  	u64			length;	/* length of mapping, bytes */
> > >  	u16			type;	/* type of mapping */
> > >  	u16			flags;	/* flags for mapping */
> > > +	u64			cow_addr; /* read address to perform CoW */

Oh, I see, IOMAP_F_COW means @cow_addr points to the copy source
address, not the destination space we just allocated.

/*
 * A copy-on-write operation is necessary to maintain data integrity.
 * Write actors must copy the portion of the file that will not be
 * overwritten by the write from @cow_addr to @addr.
 */
#define IOMAP_F_COW		0x08

> > > +	loff_t			cow_pos; /* file offset of cow_addr */

Why wouldn't this be named @cow_offset?

And why wouldn't it be the same as @offset?

--D

> > >  	struct block_device	*bdev;	/* block device for I/O */
> > >  	struct dax_device	*dax_dev; /* dax_dev for dax operations */
> > >  	void			*inline_data;
> > > -- 
> > > 2.16.4
> > > 
> > 
> 
> -- 
> Goldwyn
