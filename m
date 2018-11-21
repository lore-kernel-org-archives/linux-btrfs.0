Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E780C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 04:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21F9E2145D
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 04:42:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21F9E2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbeKUPOz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 10:14:55 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46812 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbeKUPOz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 10:14:55 -0500
Received: by mail-pl1-f194.google.com with SMTP id t13so3573825ply.13;
        Tue, 20 Nov 2018 20:42:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=beNzxtekC3eXWHufu9KYAAFX95VFF++NlzuARk/OlmM=;
        b=OtGo04Uq2QpF0OwfLkHXvcJkd6Qgo4FtDHwcw1PLV7ZutmqvcCH9n05BcvPbN9epud
         AvrARewg1IxOuuZTbEv9Ff+I4p2oKJrQFirTu4nNJjN62JARofS2egUQjF6gf4NtlgZg
         hOgNGZjV/GNFEjVlNOb0eNQAIBmETBl0UtZPT96Pg/HiUNFaflL6X228M/ljpjBrH++R
         EYnvlnf/oYyEUDr1mSdmlq86GoCwqRJB/whBF2jdYjpPkC4I3OQwOD/QDlzZ7x1YKVmW
         ViWCVfp/oq+uz8+m4hxO8G+QSWOQ4QjBZtqcFQsJxckJZTaAhZFumjnq8/y6nx/dZtFV
         K0zQ==
X-Gm-Message-State: AA+aEWY/NG424koZUjf0EADULCbDS5H/+YCOrrB9fSb+KASvNWPdknGE
        nv/U3XdrSFC+YYo+38hmtB0=
X-Google-Smtp-Source: AFSGD/VfQU9yeCQvEyKVSqmkBBv3/CBEFUNv2FLAgZo9cuQAsWuO+IksYjy7sC2dMkjEksRN1uHK8Q==
X-Received: by 2002:a63:f006:: with SMTP id k6mr4563792pgh.259.1542775327338;
        Tue, 20 Nov 2018 20:42:07 -0800 (PST)
Received: from ?IPv6:2601:647:4800:973f:8a0:7611:3223:f4db? ([2601:647:4800:973f:8a0:7611:3223:f4db])
        by smtp.gmail.com with ESMTPSA id v20-v6sm49421268pfm.114.2018.11.20.20.42.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Nov 2018 20:42:06 -0800 (PST)
Subject: Re: [PATCH V10 09/19] block: introduce bio_bvecs()
From:   Sagi Grimberg <sagi@grimberg.me>
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
 <2d9bee7a-f010-dcf4-1184-094101058584@grimberg.me>
 <20181121034415.GA8408@ming.t460p>
 <2a47d336-c19b-6bf4-c247-d7382871eeea@grimberg.me>
Message-ID: <7378bf49-5a7e-5622-d4d1-808ba37ce656@grimberg.me>
Date:   Tue, 20 Nov 2018 20:42:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <2a47d336-c19b-6bf4-c247-d7382871eeea@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


>> Yeah, that is the most common example, given merge is enabled
>> in most of cases. If the driver or device doesn't care merge,
>> you can disable it and always get single bio request, then the
>> bio's bvec table can be reused for send().
> 
> Does bvec_iter span bvecs with your patches? I didn't see that change?

Wait, I see that the bvec is still a single array per bio. When you said
a table I thought you meant a 2-dimentional array...

Unless I'm not mistaken, I think that the change is pretty simple then.
However, nvme-tcp still needs to be bio aware unless we have some
abstraction in place.. Which will mean that nvme-tcp will need to
open-code bio_bvecs.
