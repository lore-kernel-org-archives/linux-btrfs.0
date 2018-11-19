Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C11C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 08:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED97E20823
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 08:09:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED97E20823
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbeKSScQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 13:32:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbeKSScP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 13:32:15 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CBA0881F12;
        Mon, 19 Nov 2018 08:09:23 +0000 (UTC)
Received: from ming.t460p (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D98F5C63A;
        Mon, 19 Nov 2018 08:09:04 +0000 (UTC)
Date:   Mon, 19 Nov 2018 16:09:00 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V10 07/19] btrfs: use bvec_last_segment to get bio's last
 page
Message-ID: <20181119080854.GD16519@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-8-ming.lei@redhat.com>
 <20181116133710.GF3165@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116133710.GF3165@lst.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 19 Nov 2018 08:09:24 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 16, 2018 at 02:37:10PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 15, 2018 at 04:52:54PM +0800, Ming Lei wrote:
> > index 2955a4ea2fa8..161e14b8b180 100644
> > --- a/fs/btrfs/compression.c
> > +++ b/fs/btrfs/compression.c
> > @@ -400,8 +400,11 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
> >  static u64 bio_end_offset(struct bio *bio)
> >  {
> >  	struct bio_vec *last = bio_last_bvec_all(bio);
> > +	struct bio_vec bv;
> >  
> > -	return page_offset(last->bv_page) + last->bv_len + last->bv_offset;
> > +	bvec_last_segment(last, &bv);
> > +
> > +	return page_offset(bv.bv_page) + bv.bv_len + bv.bv_offset;
> 
> I don't think we need this.  If last is a multi-page bvec bv_offset
> will already contain the correct offset from the first page.

Yeah, it is true for this specific case, looks we can drop this patch.


thanks,
Ming
