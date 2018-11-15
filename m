Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A823C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 22:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAB9A2087A
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 22:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="IcBGrQSb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAB9A2087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389138AbeKPI2b (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 03:28:31 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33943 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbeKPI2b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 03:28:31 -0500
Received: by mail-pl1-f195.google.com with SMTP id f12-v6so10144885plo.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 14:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eiPUQDMcyLe1qryFS+h85cw5yfttl+lBQ3gum2+5lr8=;
        b=IcBGrQSbjZ9YgNwf/yIoRrh4U4kL4OAJ4bNfD0+z85sAsv1FBg0U0VIae+SOJL73gR
         m5iGIxNqBW3HbSYVz/575grywjRaIQ+RGxjIytA4AIFeJekWG/JDFpWafzQKa0GnzSWA
         t+WVZwoKjqt6U6KD32Wgy/c3yRwy5x7Jht3JYW1xNLqHB5kyNatXUkNL5XWDvyce9sek
         72tN+JR7NdX/G5Sj7fXiC6ymfTWk28YPdL6hek7mirykIAXKa+8mwqTq4hRw7cO/5eyO
         bCzB2Yvk1uvS4sPUt1qoxfFM34TxVP3nUuhcYz7CyJLxKBHmIztLAsa5sJvC8xgd6+7C
         8Gew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eiPUQDMcyLe1qryFS+h85cw5yfttl+lBQ3gum2+5lr8=;
        b=Ny8lVlrApqwVA5fNP5+r5VV8Lz6uD5YYfDnaUY5QRhniZGHrl1kx9nwVlYwnl2Ki3q
         NAluI/47tHd9h3JwbLq/wTMa+MItrzZxxhx2vh4OZ8nam/6bTWRDz8QFLPFpCxAG+Dvi
         4N/Ij+8xzUypbU8Srn/g5brvFqiSOFyEQHxTrw2Mxxz+t9b3HfpfCVBdT5X5hbxSoV8W
         TaBFiJwFgLKVdohWGlmSDAJz4gLxFqAyUAAfRTmKJFNMVNkouokANY+txLG6LKg/SPG9
         SAthDTNK4LVwGHSAgWDlt+glSoajb/VF2VaYQOHAFvzu6mj3pfJ36VYMU/9yZsKn6Bib
         E18w==
X-Gm-Message-State: AGRZ1gIZrv3frxjTFOgF18PJSB/peMkcgdbDkohQMmYA+PDhDzf5qcPU
        em9doRyoAztuj1kwSQC8AzXIYQ==
X-Google-Smtp-Source: AJdET5cs3sa8Rk/U6yq6j78iq0R3mMPPd2LHreR0afsziQ3xvuaogNh6x/LCSfHaB7bkozQ5MxlnMQ==
X-Received: by 2002:a17:902:3103:: with SMTP id w3-v6mr8286210plb.18.1542320330206;
        Thu, 15 Nov 2018 14:18:50 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id m12-v6sm34829559pff.173.2018.11.15.14.18.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 14:18:49 -0800 (PST)
Date:   Thu, 15 Nov 2018 14:18:47 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V10 03/19] block: use bio_for_each_bvec() to compute
 multi-page bvec count
Message-ID: <20181115221847.GD9348@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-4-ming.lei@redhat.com>
 <20181115202028.GC9348@vader>
 <20181115210510.GA24908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115210510.GA24908@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:05:10PM -0500, Mike Snitzer wrote:
> On Thu, Nov 15 2018 at  3:20pm -0500,
> Omar Sandoval <osandov@osandov.com> wrote:
> 
> > On Thu, Nov 15, 2018 at 04:52:50PM +0800, Ming Lei wrote:
> > > First it is more efficient to use bio_for_each_bvec() in both
> > > blk_bio_segment_split() and __blk_recalc_rq_segments() to compute how
> > > many multi-page bvecs there are in the bio.
> > > 
> > > Secondly once bio_for_each_bvec() is used, the bvec may need to be
> > > splitted because its length can be very longer than max segment size,
> > > so we have to split the big bvec into several segments.
> > > 
> > > Thirdly when splitting multi-page bvec into segments, the max segment
> > > limit may be reached, so the bio split need to be considered under
> > > this situation too.
> > > 
> > > Cc: Dave Chinner <dchinner@redhat.com>
> > > Cc: Kent Overstreet <kent.overstreet@gmail.com>
> > > Cc: Mike Snitzer <snitzer@redhat.com>
> > > Cc: dm-devel@redhat.com
> > > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > > Cc: linux-fsdevel@vger.kernel.org
> > > Cc: Shaohua Li <shli@kernel.org>
> > > Cc: linux-raid@vger.kernel.org
> > > Cc: linux-erofs@lists.ozlabs.org
> > > Cc: David Sterba <dsterba@suse.com>
> > > Cc: linux-btrfs@vger.kernel.org
> > > Cc: Darrick J. Wong <darrick.wong@oracle.com>
> > > Cc: linux-xfs@vger.kernel.org
> > > Cc: Gao Xiang <gaoxiang25@huawei.com>
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Cc: Theodore Ts'o <tytso@mit.edu>
> > > Cc: linux-ext4@vger.kernel.org
> > > Cc: Coly Li <colyli@suse.de>
> > > Cc: linux-bcache@vger.kernel.org
> > > Cc: Boaz Harrosh <ooo@electrozaur.com>
> > > Cc: Bob Peterson <rpeterso@redhat.com>
> > > Cc: cluster-devel@redhat.com
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >  block/blk-merge.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++---------
> > >  1 file changed, 76 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/block/blk-merge.c b/block/blk-merge.c
> > > index 91b2af332a84..6f7deb94a23f 100644
> > > --- a/block/blk-merge.c
> > > +++ b/block/blk-merge.c
> > > @@ -160,6 +160,62 @@ static inline unsigned get_max_io_size(struct request_queue *q,
> > >  	return sectors;
> > >  }
> > >  
> > > +/*
> > > + * Split the bvec @bv into segments, and update all kinds of
> > > + * variables.
> > > + */
> > > +static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
> > > +		unsigned *nsegs, unsigned *last_seg_size,
> > > +		unsigned *front_seg_size, unsigned *sectors)
> > > +{
> > > +	bool need_split = false;
> > > +	unsigned len = bv->bv_len;
> > > +	unsigned total_len = 0;
> > > +	unsigned new_nsegs = 0, seg_size = 0;
> > 
> > "unsigned int" here and everywhere else.
> 
> Curious why?  I've wondered what govens use of "unsigned" vs "unsigned
> int" recently and haven't found _the_ reason to pick one over the other.

My only reason to prefer unsigned int is consistency. unsigned int is
much more common in the kernel:

$ ag --cc -s 'unsigned\s+int' | wc -l
129632
$ ag --cc -s 'unsigned\s+(?!char|short|int|long)' | wc -l
22435

checkpatch also warns on plain unsigned.
