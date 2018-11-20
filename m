Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA00CC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 00:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9276020870
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 00:49:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9276020870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbeKTLP5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 06:15:57 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33705 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbeKTLP4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 06:15:56 -0500
Received: by mail-oi1-f193.google.com with SMTP id c206so182104oib.0;
        Mon, 19 Nov 2018 16:49:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7CBbdv0ulPnXsLCam4JfS2nGT12Bm868cidHI1ernlM=;
        b=kZtkbGtXmCjkkF1yrdTZ5qCK1p6//S+oZxJngjlwOlnI/WUZ9giIyD/sphGlAdNeVY
         XRrtHEUIMfGNEY8KqwecM+m1TrGN0k1JQEnnAydTxIwAvoN/99rJKK1t5UxyTUaOmMJP
         d5+Ldh1mwj5/0xyp723vK69zQ4ltJc1H4g47qGAiKTZB1nrgR47Eva1eEO4fFHk+cVii
         1Ec9uB/sP/Z02n9i/suW5Jrbq/MuOT389/CFzqFX+rAD9Ny+B0naMXc78zSOf+ROjqyX
         GEjyEO/qQHv+jEXGu2MhBUK+5usIESi/X62/UlT8J7WL047MICym61C70iJuH3YKEs1O
         OqZA==
X-Gm-Message-State: AGRZ1gJRy276X0hyngt29ccJZ59j2lJ3jNV+ECNHEN89ZNjE5nFM4Gzs
        66ZQIwYPdBYSYnK7nR+j7kU=
X-Google-Smtp-Source: AJdET5cCiZpGIYzpXT1scMG4axH9cV15b1us9DIOc575JSz+SmBa40dFRidPpQX05TUMe2SZsu92Ug==
X-Received: by 2002:a54:4d8d:: with SMTP id y13-v6mr6226830oix.18.1542674972198;
        Mon, 19 Nov 2018 16:49:32 -0800 (PST)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id c78sm3016694oig.30.2018.11.19.16.49.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Nov 2018 16:49:31 -0800 (PST)
Subject: Re: [PATCH V10 09/19] block: introduce bio_bvecs()
To:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <dchinner@redhat.com>,
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
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
Date:   Mon, 19 Nov 2018 16:49:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181116134541.GH3165@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


> The only user in your final tree seems to be the loop driver, and
> even that one only uses the helper for read/write bios.
> 
> I think something like this would be much simpler in the end:

The recently submitted nvme-tcp host driver should also be a user
of this. Does it make sense to keep it as a helper then?
