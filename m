Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111B6C282CE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 14:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D174C21841
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 14:20:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="qA9Wop88"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfDHOUE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 10:20:04 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36175 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfDHOUD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2019 10:20:03 -0400
Received: by mail-pg1-f196.google.com with SMTP id 85so7419609pgc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Apr 2019 07:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lQgyRVQMhwhNfDKJFputJ0dNdN+zl/Igi5n8+/IvFQ8=;
        b=qA9Wop88U75g5vtp0n7Y/cwScIbISoInU9Xt8SLjpFbZXDnqOOjFBxz8GmYVoUaTPl
         JXY6CXr2gmb+3/6p8FhlpSTQEy8Pa6PIczy7531PhBi2jPJb7KeHerzi8Wtnk3REeOxU
         mg+9kMYSVnbN2zTHTGJlnan/KL2Xko3x/ftT7dcs/kML//ZzK4xMsG1MJDRWIH+BDMZ8
         07o/w2DM5xlZhPRD6Q4gbTU/N6CTbQF9Ekh5KS70XVHO/gDllUmvaTvWG450nQ+3R+7D
         Q35vTk9onWm7ORA7PUTB+55JMcEVpbMzIwUkPWNpO/N50s+ktfo2b7h0hrAKDRGskOYs
         vyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lQgyRVQMhwhNfDKJFputJ0dNdN+zl/Igi5n8+/IvFQ8=;
        b=Y1GNaDp2JYh7Ag9J3StNEFboGmreiwAmosOuGfaBxpb9PCpB35pVy6E3KUgOP9I4wZ
         J7pfy6lGoDljzypYH25XFLe8g+87wqhw0z3DD66YHFfrf+VeIWJZtWC0oTuyVX4mLbQ3
         hxYRjZL/PfNCVDdjSbc0M7zOtZXEVHYN49z1LtB5jCrlq+vPBrBsLlpr3xNCc7MsXdyk
         OgSyw3QbgddR7LUajoErofAqAK3BIwa1/V0S4lrgnxBGem9Wbsq8yVlcx6aSAHd4K7mB
         Oe1RjlsoK2VdKs4w+Rn721mB5Ny7lv6yUnLiaPLkJ0HMZgkfP7obD0tF8HSAaBtWPW3p
         DEWg==
X-Gm-Message-State: APjAAAXsmuXfEY5Nru5iGSAFSIAoH8rW3DdHM/62fwV8jZ8vqkrXk35D
        ZSvhzGHxyBXEPzNtK+POgDmePg==
X-Google-Smtp-Source: APXvYqypos+WZqgxIdWQWpmgkc+L0zQSC4QNHKTlmS7Cy36EZ9n820nLyR0zq67g3pBfg0T34o2y0Q==
X-Received: by 2002:aa7:8d9a:: with SMTP id i26mr18143314pfr.220.1554733202894;
        Mon, 08 Apr 2019 07:20:02 -0700 (PDT)
Received: from [192.168.1.121] (66.29.188.166.static.utbb.net. [66.29.188.166])
        by smtp.gmail.com with ESMTPSA id d11sm33348781pgq.6.2019.04.08.07.20.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 07:20:01 -0700 (PDT)
Subject: Re: [PATCH V3] block: don't use for-inside-for in
 bio_for_each_segment_all
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>
References: <20190408110238.30478-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b55becef-d644-6f6d-428b-e25216016218@kernel.dk>
Date:   Mon, 8 Apr 2019 08:19:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408110238.30478-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 4/8/19 5:02 AM, Ming Lei wrote:
> Commit 6dc4f100c175 ("block: allow bio_for_each_segment_all() to
> iterate over multi-page bvec") changes bio_for_each_segment_all()
> to use for-inside-for.
> 
> This way breaks all bio_for_each_segment_all() call with error out
> branch via 'break', since now 'break' can only break from the inner
> loop.
> 
> Fixes this issue by implementing bio_for_each_segment_all() via
> single 'for' loop, and now the logic is very similar with normal
> bvec iterator.

Applied, thanks Ming.

-- 
Jens Axboe

