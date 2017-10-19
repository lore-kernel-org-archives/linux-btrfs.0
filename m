Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34516 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751738AbdJSW55 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 18:57:57 -0400
Date: Fri, 20 Oct 2017 06:57:44 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 11/49] btrfs: avoid access to .bi_vcnt directly
Message-ID: <20171019225743.GC27130@ming.t460p>
References: <20170808084548.18963-1-ming.lei@redhat.com>
 <20170808084548.18963-12-ming.lei@redhat.com>
 <20170810112959.GG20308@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170810112959.GG20308@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 10, 2017 at 04:29:59AM -0700, Christoph Hellwig wrote:
> > +static unsigned int get_bio_pages(struct bio *bio)
> > +{
> > +	unsigned i;
> > +	struct bio_vec *bv;
> > +
> > +	bio_for_each_segment_all(bv, bio, i)
> > +		;
> > +
> > +	return i;
> > +}
> 
> s/get_bio_pages/bio_nr_pages/ ?

Yeah, the name of bio_nr_pages() is much better.

> 
> Also this seems like a useful helper for bio.h

OK.


-- 
Ming
