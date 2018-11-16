Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B3B5C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 09:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5039E208E7
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 09:20:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5039E208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbeKPTb1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 14:31:27 -0500
Received: from verein.lst.de ([213.95.11.211]:48230 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbeKPTb1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 14:31:27 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id E4DAB68D60; Fri, 16 Nov 2018 10:19:56 +0100 (CET)
Date:   Fri, 16 Nov 2018 10:19:56 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <dchinner@redhat.com>,
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
Message-ID: <20181116091956.GA17604@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com> <20181115085306.9910-4-ming.lei@redhat.com> <20181115202028.GC9348@vader> <20181115210510.GA24908@redhat.com> <20181115221847.GD9348@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115221847.GD9348@vader>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 02:18:47PM -0800, Omar Sandoval wrote:
> My only reason to prefer unsigned int is consistency. unsigned int is
> much more common in the kernel:
> 
> $ ag --cc -s 'unsigned\s+int' | wc -l
> 129632
> $ ag --cc -s 'unsigned\s+(?!char|short|int|long)' | wc -l
> 22435
> 
> checkpatch also warns on plain unsigned.

Talk about chicken and egg.  unsigned is perfectly valid C, and being
shorter often helps being more readable.  checkpath is as so often
wrongly opinionated..
