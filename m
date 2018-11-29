Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1973C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 02:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 934F8206B2
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 02:21:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="IBABWwgr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 934F8206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbeK2NYk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 08:24:40 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36915 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbeK2NYk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 08:24:40 -0500
Received: by mail-pf1-f193.google.com with SMTP id y126so226875pfb.4
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 18:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+xBxlzLdOgUjA+rwVYpyLPHrP2t70NClUp58sJDLeSo=;
        b=IBABWwgrXcCT1WKx0aOP+SDJ6LrB2QoZut4pYAmU/padXum7mRkmkk9g+P4aICKJur
         G/XTylGZn5P4YCSbxCxXvtPR3OmasHswTZLGrKQq+ergy+kZhbZ0GiFvp/ttEQlz5QhD
         ckizUNqSowcj4lopzGqubImKzDtvVwUsUWli0ebrDugOBpmLbbPNuAKXtJ1fSD6Uonym
         84hc3x1+Y99BvUT8c+MCLkq/B9y0Ur5bYMQesTfwdJGjoYW0YHArWdp/xaKI7Emt8EGc
         inq+wd28VJpj2dXRSh3ZRwCDnn8Pml88K/P0uB/nqWThGfKETVv0AoGbckDmjkar/Z6z
         MWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+xBxlzLdOgUjA+rwVYpyLPHrP2t70NClUp58sJDLeSo=;
        b=isATUFDi2p+b7wCb5hIfCVg2IAh6hzi95Ic9Voyxub8g7LHGx0TT39KozFbbB+/2nw
         TWFu1wed99SREzDvwomX57qgJgCN1DXvnIIzNGp9RcDY7q86khaa2VUAbE/JrEpmhZUi
         kUhjRqZqTRExHsYlDpXfWrf4430UH5HYSTS1HfmkzBQ0NwLZOkjdd7j2uaBlSP4BjdiS
         nIaVvi8Dm9Q/kXJv6B/xdz1GA7ZdBb2Qk360/sJLePIq4RFyeKq+xND1RC3TykqIFKQN
         tK0/zmV/+MIrnIX4avb/1S6KMSFsOMetGgVFSoqQAekf1norHq7vKibfqg25J02fHTpb
         kXXg==
X-Gm-Message-State: AA+aEWbjg2OeaUrbLzEZ+c78LOsTxrv2maWxUn8kPfKtatZqPfmB3vOG
        ozpT8FNLAdi6GybFrVPSED74WQ==
X-Google-Smtp-Source: AFSGD/Xjmg+dfaPK5u6yWz2etb/IgmXW9IWv0GfBO/57N+6M+K3o2su7LsFsb2aC/3PCZgu8Zmu/Cw==
X-Received: by 2002:a62:68c5:: with SMTP id d188mr2809905pfc.194.1543458056775;
        Wed, 28 Nov 2018 18:20:56 -0800 (PST)
Received: from [192.168.1.121] (66.29.188.166.static.utbb.net. [66.29.188.166])
        by smtp.gmail.com with ESMTPSA id x3sm330869pgt.45.2018.11.28.18.20.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Nov 2018 18:20:55 -0800 (PST)
Subject: Re: [PATCH V12 00/20] block: support multi-page bvec
To:     Ming Lei <ming.lei@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>,
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
 <7096bc4e-0617-29d0-a90d-ae7caf09a16d@kernel.dk>
 <20181129012959.GC23249@ming.t460p>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1983a2f5-07be-4102-fedc-54e2ad2e16dc@kernel.dk>
Date:   Wed, 28 Nov 2018 19:20:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181129012959.GC23249@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11/28/18 6:30 PM, Ming Lei wrote:
>> I'm going back and forth on those one a bit. Any concerns with
>> pushing this to 4.22?
> 
> My only one concern is about the warning of
> "blk_cloned_rq_check_limits: over max segments limit" on dm multipath,
> and seems Ewan and Mike is waiting for this fix.

Not familiar with this issue, can you post a link to it? I'd be fine
working around anything until 4.22, it's not going to be a new issue.

-- 
Jens Axboe

