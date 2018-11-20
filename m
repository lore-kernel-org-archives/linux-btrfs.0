Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D69BC46463
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 20:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23C3122513
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 20:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23C3122513
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbeKUGmf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 01:42:35 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43936 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbeKUGme (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 01:42:34 -0500
Received: by mail-oi1-f196.google.com with SMTP id u18so2575541oie.10;
        Tue, 20 Nov 2018 12:11:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+nDOz9mjqo4L3rzgAR7CUb2HdO4CSp5KgwQNxh2bwe8=;
        b=Xh3kdG12xmlmj21e7ZO8IEInjYVYIEQIrMm3zbzHJwrHOd2xnpumbiaCdLhfXCkzJC
         BtXnhe9VqNaZgv1izOhaI4nU+9fS2pkNUHkJJEPb47s9Dg8ttKZud0taRZJFk0gjo9Vj
         H8HQIfg/rSNHvyyrr66lNqMmRggNN8mmM1UWduw0VsXATL6UHPoxKjN5Fpl1P+9SLjqk
         1oZHrvoBrV+4z9ibjWeS+H8R+uGuQS/Kktw/7gycGVj46w7W14PI1BBSnIdkpr6RqY2L
         wp4AqUhsZfF0vzaxK+4aEiJVZPmglVHYfS5NIgvJtayY2jGRxiAoxIB8tagAmeBAbKZn
         7OkQ==
X-Gm-Message-State: AGRZ1gK5hztfaZOmTBrEGaWzaYP5pEobcP1sPjDpWNcLnJAGnc2H6cJn
        z/1MRWvdzn3kXXhX+bxhIQo=
X-Google-Smtp-Source: AJdET5f5ehNN96vcKRz2NXaqMQda85YBO55TqjtSMuwNpXqePnneNcb7NjbLve3qt0sZ+FBHzugBOA==
X-Received: by 2002:a05:6808:13:: with SMTP id u19mr2037670oic.57.1542744699917;
        Tue, 20 Nov 2018 12:11:39 -0800 (PST)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id i35sm13742439ote.69.2018.11.20.12.11.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Nov 2018 12:11:39 -0800 (PST)
Subject: Re: [PATCH V10 09/19] block: introduce bio_bvecs()
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
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
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
Date:   Tue, 20 Nov 2018 12:11:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181120161651.GB2629@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


>>> The only user in your final tree seems to be the loop driver, and
>>> even that one only uses the helper for read/write bios.
>>>
>>> I think something like this would be much simpler in the end:
>>
>> The recently submitted nvme-tcp host driver should also be a user
>> of this. Does it make sense to keep it as a helper then?
> 
> I did take a brief look at the code, and I really don't understand
> why the heck it even deals with bios to start with.  Like all the
> other nvme transports it is a blk-mq driver and should iterate
> over segments in a request and more or less ignore bios.  Something
> is horribly wrong in the design.

Can you explain a little more? I'm more than happy to change that but
I'm not completely clear how...

Before we begin a data transfer, we need to set our own iterator that
will advance with the progression of the data transfer. We also need to
keep in mind that all the data transfer (both send and recv) are
completely non blocking (and zero-copy when we send).

That means that every data movement needs to be able to suspend
and resume asynchronously. i.e. we cannot use the following pattern:
rq_for_each_segment(bvec, rq, rq_iter) {
	iov_iter_bvec(&iov_iter, WRITE, &bvec, 1, bvec.bv_len);
	send(sock, iov_iter);
}

Given that a request can hold more than a single bio, I'm not clear on
how we can achieve that without iterating over the bios in the request
ourselves.

Any useful insight?
