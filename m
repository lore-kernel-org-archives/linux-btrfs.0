Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE655C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2ED12145D
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 03:20:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2ED12145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbeKUNxZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 08:53:25 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34198 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbeKUNxZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 08:53:25 -0500
Received: by mail-pl1-f195.google.com with SMTP id f12-v6so3336975plo.1;
        Tue, 20 Nov 2018 19:20:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YUDK3byES5Clx+gNUxLq8kbY4gy4QnhkCiPin39VMxU=;
        b=jXyUi5l9NdbIs24pP1OZovAfd2v6oIrojxCkmmIZmnGPBtd9cv5iusJJsZMcAKwE/D
         +sx8zMVTBKTHhvYqVbmfiD6ZrD60aIBpIK8pLbes71cmZXF6S9HKawMX9gVQgA+L/2F7
         U+Md3MM8p1udCjHF2eZO9nCuoBDZzx6hDM63nYXdk2fv9DAiSN21YvsSo4WBw4Mtlp09
         Nj6ugtqp878LkVj1NOD+llU8Ourkjlf+lEv0Isaf0ygzecfz0vrIQUC5HfQgybecFk9S
         zwXerpnJwyV2NCgyim7aaoSoxfi8k4B/PSlU8H3Ab+ypHVCv/eJvdG884mySGDXRkJpV
         9l+Q==
X-Gm-Message-State: AGRZ1gK7INY9GGd9aVsQecyoDR0XYBkBLZYzgtnhB+z5Tcu9IFyY4cbl
        Xi7LGaUy+QEFINnfKDTOxtA=
X-Google-Smtp-Source: AJdET5dJiV7FzcfTUZjsrEJPVAyWFsSbjIeiHP2PByBbx+NhoOUpUwU76NXXgVdSoo5Gt6sLjpYIqA==
X-Received: by 2002:a62:b9a:: with SMTP id 26mr5096104pfl.196.1542770454986;
        Tue, 20 Nov 2018 19:20:54 -0800 (PST)
Received: from ?IPv6:2601:647:4800:973f:8a0:7611:3223:f4db? ([2601:647:4800:973f:8a0:7611:3223:f4db])
        by smtp.gmail.com with ESMTPSA id t90sm36137627pfj.23.2018.11.20.19.20.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Nov 2018 19:20:54 -0800 (PST)
Subject: Re: [PATCH V10 09/19] block: introduce bio_bvecs()
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>,
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
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-10-ming.lei@redhat.com> <20181116134541.GH3165@lst.de>
 <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
 <20181120161651.GB2629@lst.de>
 <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
 <20181121005902.GA31748@ming.t460p>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <2d9bee7a-f010-dcf4-1184-094101058584@grimberg.me>
Date:   Tue, 20 Nov 2018 19:20:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181121005902.GA31748@ming.t460p>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


> Not sure I understand the 'blocking' problem in this case.
> 
> We can build a bvec table from this req, and send them all
> in send(),

I would like to avoid growing bvec tables and keep everything
preallocated. Plus, a bvec_iter operates on a bvec which means
we'll need a table there as well... Not liking it so far...

> can this way avoid your blocking issue? You may see this
> example in branch 'rq->bio != rq->biotail' of lo_rw_aio().

This is exactly an example of not ignoring the bios...

> If this way is what you need, I think you are right, even we may
> introduce the following helpers:
> 
> 	rq_for_each_bvec()
> 	rq_bvecs()

I'm not sure how this helps me either. Unless we can set a bvec_iter to
span bvecs or have an abstract bio crossing when we re-initialize the
bvec_iter I don't see how I can ignore bios completely...

> So looks nvme-tcp host driver might be the 2nd driver which benefits
> from multi-page bvec directly.
> 
> The multi-page bvec V11 has passed my tests and addressed almost
> all the comments during review on V10. I removed bio_vecs() in V11,
> but it won't be big deal, we can introduce them anytime when there
> is the requirement.

multipage-bvecs and nvme-tcp are going to conflict, so it would be good
to coordinate on this. I think that nvme-tcp host needs some adjustments
as setting a bvec_iter. I'm under the impression that the change is 
rather small and self-contained, but I'm not sure I have the full
picture here.
