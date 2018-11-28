Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43F0C04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68C482147C
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="z6atr7yQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68C482147C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbeK2Apu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 19:45:50 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42912 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbeK2Aps (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 19:45:48 -0500
Received: by mail-pg1-f195.google.com with SMTP id d72so9516233pga.9
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 05:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7zDTfHt/ugH4s9MDSR3+6OcGT1VGlctx6MQg0nD7ryE=;
        b=z6atr7yQ3iFy6c+mjsKbGtJKtoY4INRIDKLn2ctg3Xp5JT6x7ocMzEZ2HPxv9dHQTK
         iijiZCJLg9jEmNS89Id8ye5JAjUXqQJQr6mGAWvONxa0Zh7vUWCrN4Uf+UeabhKijE/1
         34E/tod9+3QfnjbAD9gRnVDmsQn5Wt8P2XzRNETPBUeWJsWy4/kqLmPBoILTF8lRVOf6
         pBSdGhHY0cVZ+BOiI5ZTUD5xjSMICY7sVkTod4fkrIfWxG4hZgYLFockgeTx3eHYpP6T
         +oKZfOv9sStHO9kpfKBmSnsZE4W/8gxQnwt8rHsHMN9ZdvdQ107GNLbCW62zgksaAg+T
         /7fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7zDTfHt/ugH4s9MDSR3+6OcGT1VGlctx6MQg0nD7ryE=;
        b=I5WaUuKoBQFfw90is1nR1qKCv2DATxKZk3pNEsaB10CflMeC1rG/HqQkG562fhBKe+
         inU3HW5kxNs56YXjxcPCIVW0w7lyRaaOd3km/V40OX2a2J2O4graGiI8nH+8jZLIWugA
         Q4l4Q7IlspJ+O6zVl9h7lm3Wc+hRLiUoDd4SBZC+akJcyTp/G4F17a5Om9VL0jp6jFtM
         TyC0kn9UKmKWNCpGW/UBwNqwd65fZDASQeaFKDWUczQv0AAKrQ/+1aBk7ADxRLBk/NTH
         xIIQkAblLUcsEKLUxJFeie0NCY9t4CgNVXtJ4rgoB7h1cFPMbtyn/aZ8imnXiW6dReq/
         3teg==
X-Gm-Message-State: AA+aEWYNoCIV4ObiqfmG3OO3X5ARW0ldiuBB94CO5aipo2Al2YMB4x70
        gjzuZ9NgdgRtW4GAOmpp3lN5Hg==
X-Google-Smtp-Source: AFSGD/VpgWFbWqw7HHw4H6IebL4oKrh/k/zhasDsE54IK5/AtyaiHcazONlEr8g8biKk8VA/p/HR1g==
X-Received: by 2002:a63:441e:: with SMTP id r30mr33671645pga.128.1543412645990;
        Wed, 28 Nov 2018 05:44:05 -0800 (PST)
Received: from [192.168.1.121] (66.29.188.166.static.utbb.net. [66.29.188.166])
        by smtp.gmail.com with ESMTPSA id n22sm14673393pfh.166.2018.11.28.05.44.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Nov 2018 05:44:04 -0800 (PST)
Subject: Re: [PATCH V12 00/20] block: support multi-page bvec
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
References: <20181126021720.19471-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7096bc4e-0617-29d0-a90d-ae7caf09a16d@kernel.dk>
Date:   Wed, 28 Nov 2018 06:44:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181126021720.19471-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11/25/18 7:17 PM, Ming Lei wrote:
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

I'm pretty happy with this patchset at this point, looks like it just
needs a respin to address the last comments. My only concern is whether
it's a good idea to target this for 4.21, or if we should wait until
4.22. 4.21 has a fairly substantial amount of changes in terms of block
already, it's not the best timing for something of this magnitude too.

I'm going back and forth on those one a bit. Any concerns with
pushing this to 4.22?

-- 
Jens Axboe

