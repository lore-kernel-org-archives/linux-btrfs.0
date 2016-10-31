Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39670 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S943145AbcJaSAf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 14:00:35 -0400
Date: Mon, 31 Oct 2016 11:58:29 -0600
From: Chris Mason <clm@fb.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>,
        <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 26/60] btrfs: set NO_MP for request queues behind BTRFS
Message-ID: <20161031175828.GB48277@clm-mbp.thefacebook.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
 <1477728600-12938-27-git-send-email-tom.leiming@gmail.com>
 <20161031153644.GK30919@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <20161031153644.GK30919@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2016 at 08:36:44AM -0700, Christoph Hellwig wrote:
>On Sat, Oct 29, 2016 at 04:08:25PM +0800, Ming Lei wrote:
>> There are lots of direct access to .bi_vcnt & .bi_io_vec
>> of bio, and it isn't ready to support multipage bvecs
>> for BTRFS, so set NO_MP for these request queues.
>
>For one bio is an I/O submitter, it has absolutely no business changing
>queue flags - if we need to stick to this limitation it simply needs
>a version of bio_add_page that doesn't create multi-page bvecs.
>
>Second I don't think making it multipage bvec aware is all that hard,
>and we should aim for doing the proper thing.

Yeah, I'd rather make us less special.  The direct access was a short 
term fix to adjust to the new bio interfaces, we should clean it up.

-chris

