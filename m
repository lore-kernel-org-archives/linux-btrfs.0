Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DECC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 05:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E931B21104
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 05:35:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E931B21104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbeKUQIK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 11:08:10 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36546 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbeKUQIK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 11:08:10 -0500
Received: by mail-pl1-f195.google.com with SMTP id y6-v6so3776208plt.3;
        Tue, 20 Nov 2018 21:35:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uw2Rc/+SN/AQ2BCQF67M559YyvRnmu3XKYQrGvf+BK4=;
        b=J3V8cWzJgIRg5cI/uFjFq6RzxJcszoO5u1FeQuG6n8nOJPx+49XnivAVd3vIK20cWc
         BAsFneKl3ts/xYgp07jxKFxzGb6mEpTMe6yOLv/s3gSiCoXBSGsZFhpIMeMd4ehDj/tT
         XLz084oQqInS+MfbQXGbSbD+/X7LxFcWI1SyZlYKjYFeXH/ZQER6yvFvKeYfbJ9aAd7f
         D0ebC2Q5z005XpBrp75yzonBw0o/Ln2lYb42DjulbhWRqinJltFNHRTnXdpSFV8bRa23
         8CT+JgKue7G1KLcDu/D0fZDqBkIymqT1DYlygBitaSCK3Wb0VfFnmJOv83zEE3JsjFmK
         Skng==
X-Gm-Message-State: AA+aEWb8Hpcnblk+XGpFNpZnVXC3sfU10djgKmOgoFuW3+yoNbyz3KYu
        Vccz16UpJFzem29qH1ZWVCo=
X-Google-Smtp-Source: AFSGD/WkT/yqAhpG/m/H/089gI8a+YTXF6dmZ52eIxWlemBQhNwe4w7mEaT1whWhxkeR4rRsjCwFKg==
X-Received: by 2002:a17:902:1126:: with SMTP id d35mr1769887pla.1.1542778511439;
        Tue, 20 Nov 2018 21:35:11 -0800 (PST)
Received: from ?IPv6:2601:647:4800:973f:8a0:7611:3223:f4db? ([2601:647:4800:973f:8a0:7611:3223:f4db])
        by smtp.gmail.com with ESMTPSA id 19sm42960007pfs.108.2018.11.20.21.35.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Nov 2018 21:35:10 -0800 (PST)
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
References: <20181115085306.9910-10-ming.lei@redhat.com>
 <20181116134541.GH3165@lst.de>
 <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
 <20181120161651.GB2629@lst.de>
 <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
 <20181121005902.GA31748@ming.t460p>
 <2d9bee7a-f010-dcf4-1184-094101058584@grimberg.me>
 <20181121034415.GA8408@ming.t460p>
 <2a47d336-c19b-6bf4-c247-d7382871eeea@grimberg.me>
 <7378bf49-5a7e-5622-d4d1-808ba37ce656@grimberg.me>
 <20181121050359.GA31915@ming.t460p>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <fc268b0e-61b5-aacc-67be-cb7b266c6d8f@grimberg.me>
Date:   Tue, 20 Nov 2018 21:35:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181121050359.GA31915@ming.t460p>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


>> Wait, I see that the bvec is still a single array per bio. When you said
>> a table I thought you meant a 2-dimentional array...
> 
> I mean a new 1-d table A has to be created for multiple bios in one rq,
> and build it in the following way
> 
>             rq_for_each_bvec(tmp, rq, rq_iter)
>                      *A = tmp;
> 
> Then you can pass A to iov_iter_bvec() & send().
> 
> Given it is over TCP, I guess it should be doable for you to preallocate one
> 256-bvec table in one page for each request, then sets the max segment size as
> (unsigned int)-1, and max segment number as 256, the preallocated table
> should work anytime.

256 bvec table is really a lot to preallocate, especially when its not
needed, I can easily initialize the bvec_iter on the bio bvec. If this
involves preallocation of the worst-case than I don't consider this to
be an improvement.
