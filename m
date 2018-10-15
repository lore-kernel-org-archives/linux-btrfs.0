Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACCDC71133
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 16:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48E432064A
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 16:42:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zreQlITJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48E432064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbeJPA2p (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 20:28:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60086 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbeJPA2o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 20:28:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9FGcuwi162645;
        Mon, 15 Oct 2018 16:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=nsqCdfEYOIAr5OaTW7s+iNGDYlTNmPuH47g6zQefVHI=;
 b=zreQlITJGeB8hKaLBxiXAANVSD+wD7MqihOmpP6hPElpQKrbC3qQtPbv1BvZyVn7QwMB
 HUqeZWD9tSG7cCRSCUKJJ7Xy8JO6f5Uj9GnrsKhB2uO465SnKuZ71mnYAD+4ayajtM07
 h19lVdPxy8rdoZhRhvDNMEa1omncD5vQafLDnti8IxOmlC8zFLapWWghNUsjG8ubrx/q
 OavhrvPVAWG1gy/29+44GWVh6CKtK9YeVKjVgacWGCkueTOhsUkLyP6ID5cItY2u3cEz
 bllB1T+Ss1GeGFNFGCvt6bPUmxjH14bN+V9O2UUwjuJGCYRBprjDVB+cu/KNd8o91clL Ug== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2n384tusax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Oct 2018 16:42:25 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9FGgOI0018511
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Oct 2018 16:42:24 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9FGgMwO004019;
        Mon, 15 Oct 2018 16:42:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 09:42:22 -0700
Date:   Mon, 15 Oct 2018 09:42:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 07/25] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181015164220.GL28243@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938919123.8361.13059492965161549195.stgit@magnolia>
 <20181014171927.GD30673@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014171927.GD30673@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810150147
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Oct 14, 2018 at 10:19:27AM -0700, Christoph Hellwig wrote:
> >  	unsigned (*mmap_capabilities)(struct file *);
> >  #endif
> >  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
> > -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> > -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> > +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> > +				struct file *file_out, loff_t pos_out,
> > +				u64 len, unsigned int remap_flags);
> 
> None of the other methods in this file name their parameters.  While
> I generally don't like people leaving them out, in the end consistency
> is even more important.
> 
> > +int btrfs_remap_file_range(struct file *src_file, loff_t off,
> > +		struct file *dst_file, loff_t destoff, u64 len,
> > +		unsigned int remap_flags)
> >  {
> > +	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
> > +		return -EINVAL;
> > +
> > +	if (remap_flags & RFR_SAME_DATA) {
> 
> So at least for btrfs there seems to be no shared code at all below
> the function calls.  This kinda speaks against the argument that
> they fundamentally are the same..

They /do/ share/ code -- eventually both btrfs_extent_same and
btrfs_clone_files call btrfs_clone.  xfs and ocfs2 call the same paths
internally too; it's only the vfs helpers that have the extra page cache
comparisons if it's a dedup operation.

> > +/*
> > + * These flags control the behavior of the remap_file_range function pointer.
> > + *
> > + * RFR_SAME_DATA: only remap if contents identical (i.e. deduplicate)
> > + */
> > +#define RFR_SAME_DATA		(1 << 0)
> > +
> > +#define RFR_VALID_FLAGS		(RFR_SAME_DATA)
> 
> RFR?  Why not REMAP_FILE_*  Also why not the well understood
> REMAP_FILE_DEDUP instead of the odd SAME_DATA?

Sure.  I had begin to dislike typing RFR anyway.

> > +
> > +/*
> > + * Filesystem remapping implementations should call this helper on their
> > + * remap flags to filter out flags that the implementation doesn't support.
> > + *
> > + * Returns true if the flags are ok, false otherwise.
> > + */
> > +static inline bool remap_check_flags(unsigned int remap_flags,
> > +				     unsigned int supported_flags)
> > +{
> > +	return (remap_flags & ~(supported_flags & RFR_VALID_FLAGS)) == 0;
> > +}
> 
> Any reason to even bother with a helper for this?  ->fallocate
> seems to be doing fine without the helper, and the resulting code
> seems a lot easier to understand to me.

(Will respond to these at the current end of the flags thread.)

> > @@ -1759,10 +1779,9 @@ struct file_operations {
> >  #endif
> >  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *,
> >  			loff_t, size_t, unsigned int);
> > -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t,
> > -			u64);
> > -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t,
> > -			u64);
> > +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> > +				struct file *file_out, loff_t pos_out,
> > +				u64 len, unsigned int remap_flags);
> 
> Same comment here.  Didn't we have some nice doc tools to avoid this
> duplication? :)

We do, but vfs.txt hasn't been ported to any of that.

--D
