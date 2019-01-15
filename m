Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE96C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 03:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CA8D20859
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 03:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="G/lpLBsq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfAODpE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 22:45:04 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46412 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728007AbfAODpE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 22:45:04 -0500
Received: by mail-pl1-f193.google.com with SMTP id t13so610251ply.13
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 19:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JgSlqc6nlGoNjXQeGb5wA3jDIxX1QCLJM2o4CbLmhgM=;
        b=G/lpLBsqVhUl7c0qjPyfLig1mTn5h+wVHd8tPdPmkgbn56m+sNQDjqLhPndxTDNbF+
         C8HKFU+N/MvKnoi5sOh3lIYPGBRwr9sBaPwctKm5CZq4quVBA/kGx30M08BlZN6IwFUX
         0lcVIgAxUaGJkKkZ/5o6DgJo9u3xBQ/LsJc+BZk4GV3z8ZKxU57XynZ7q3kCKLM8SoU0
         pDNd6rsE53Sftzh8vBkTELhp4eHrQvOaYVkmqmfh1GZZMph1kIM0i6dgUptJR0k4cYnq
         BoWepXaHfSvErZT9ibW0Wj3uK3M7KTqpXa+Mxg2u61HtBMmqKeI8Qs1nehPA3PiSx+FM
         WIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JgSlqc6nlGoNjXQeGb5wA3jDIxX1QCLJM2o4CbLmhgM=;
        b=FTJQXgdYHnNiX8m2vgubS7xuDFHcpsGx0XfOTfH5a8tJCYX3UxGvh34XKeFkJYjbzn
         SrfK+oMJHawh0hNhF0IpdjrckZwOBmS/2hvf1dBptWs1SWnVIP9HEfWIqIvb/isEzufU
         KfgkW48hbkJxRXzoYPiCjpNbjTCkwoEfma5CHzsRbhVXhih2jvg8lz+5zJvVV6+oXyP6
         sdoLgWo+YaCuqW7sYWIM/06M/Zdw57PD3yg69jD2ztK4BoMKZdDh2KV0/+Z0c8uDccEx
         KYvKXwXXxo2/zVMWQ3cmgcLV9lyvN1KUGxrTnd70l+eO5JI3nMS95+xPFZ8lr0wv/2uR
         aX/A==
X-Gm-Message-State: AJcUukeJjkOSFIWcPOu2FiMuJTit3LVFKfr+CpWY5L991d6RI5LGNbYi
        egsZcPEmYRgifKyEUK9/wVRBGA==
X-Google-Smtp-Source: ALg8bN5teNbXhSCJO9tQ0AQE99WfUNUrtoThv9dSlItrMG/o7uRqGRYe+xX3MznvZx3JJf4lAux2KA==
X-Received: by 2002:a17:902:7d82:: with SMTP id a2mr1952138plm.163.1547523903354;
        Mon, 14 Jan 2019 19:45:03 -0800 (PST)
Received: from [192.168.1.121] (66.29.188.166.static.utbb.net. [66.29.188.166])
        by smtp.gmail.com with ESMTPSA id b7sm2553305pfa.52.2019.01.14.19.45.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 19:45:02 -0800 (PST)
Subject: Re: [PATCH V13 00/19] block: support multi-page bvec
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
References: <20190111110127.21664-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <49d610a4-0c2b-f7e7-6505-9dde59343b75@kernel.dk>
Date:   Mon, 14 Jan 2019 20:44:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190111110127.21664-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 1/11/19 4:01 AM, Ming Lei wrote:
> Hi,
> 
> This patchset brings multi-page bvec into block layer:
> 
> 1) what is multi-page bvec?
> 
> Multipage bvecs means that one 'struct bio_bvec' can hold multiple pages
> which are physically contiguous instead of one single page used in linux
> kernel for long time.
> 
> 2) why is multi-page bvec introduced?
> 
> Kent proposed the idea[1] first. 
> 
> As system's RAM becomes much bigger than before, and huge page, transparent
> huge page and memory compaction are widely used, it is a bit easy now
> to see physically contiguous pages from fs in I/O. On the other hand, from
> block layer's view, it isn't necessary to store intermediate pages into bvec,
> and it is enough to just store the physicallly contiguous 'segment' in each
> io vector.
> 
> Also huge pages are being brought to filesystem and swap [2][6], we can
> do IO on a hugepage each time[3], which requires that one bio can transfer
> at least one huge page one time. Turns out it isn't flexiable to change
> BIO_MAX_PAGES simply[3][5]. Multipage bvec can fit in this case very well.
> As we saw, if CONFIG_THP_SWAP is enabled, BIO_MAX_PAGES can be configured
> as much bigger, such as 512, which requires at least two 4K pages for holding
> the bvec table.
> 
> With multi-page bvec:
> 
> - Inside block layer, both bio splitting and sg map can become more
> efficient than before by just traversing the physically contiguous
> 'segment' instead of each page.
> 
> - segment handling in block layer can be improved much in future since it
> should be quite easy to convert multipage bvec into segment easily. For
> example, we might just store segment in each bvec directly in future.
> 
> - bio size can be increased and it should improve some high-bandwidth IO
> case in theory[4].
> 
> - there is opportunity in future to improve memory footprint of bvecs. 
> 
> 3) how is multi-page bvec implemented in this patchset?
> 
> Patch 1 ~ 4 parpares for supporting multi-page bvec. 
> 
> Patches 5 ~ 15 implement multipage bvec in block layer:
> 
> 	- put all tricks into bvec/bio/rq iterators, and as far as
> 	drivers and fs use these standard iterators, they are happy
> 	with multipage bvec
> 
> 	- introduce bio_for_each_bvec() to iterate over multipage bvec for splitting
> 	bio and mapping sg
> 
> 	- keep current bio_for_each_segment*() to itereate over singlepage bvec and
> 	make sure current users won't be broken; especailly, convert to this
> 	new helper prototype in single patch 21 given it is bascially a mechanism
> 	conversion
> 
> 	- deal with iomap & xfs's sub-pagesize io vec in patch 13
> 
> 	- enalbe multipage bvec in patch 14 
> 
> Patch 16 redefines BIO_MAX_PAGES as 256.
> 
> Patch 17 documents usages of bio iterator helpers.
> 
> Patch 18~19 kills NO_SG_MERGE.
> 
> These patches can be found in the following git tree:
> 
> 	git:  https://github.com/ming1/linux.git  for-4.21-block-mp-bvec-V12
> 
> Lots of test(blktest, xfstests, ltp io, ...) have been run with this patchset,
> and not see regression.
> 
> Thanks Christoph for reviewing the early version and providing very good
> suggestions, such as: introduce bio_init_with_vec_table(), remove another
> unnecessary helpers for cleanup and so on.
> 
> Thanks Chritoph and Omar for reviewing V10/V11/V12, and provides lots of
> helpful comments.

Thanks for persisting in this endeavor, Ming, I've applied this for 5.1.

-- 
Jens Axboe

