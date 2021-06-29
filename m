Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF1F2C11F67
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jun 2021 17:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C326961D8E
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jun 2021 17:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhF2RXN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jun 2021 13:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhF2RXK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jun 2021 13:23:10 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C68AC061766
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jun 2021 10:20:43 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id q16so10315487qke.10
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jun 2021 10:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/g9C8vLCxpxetYHMmmvMHDZ4rkR3+uVlFuhnglVYRGo=;
        b=N+8FEgPL4LPJUkZytSvzXk/NQU+4fS/ebf+uSYnSGtsPwtD8ih41fxs9n77SFtBGLP
         7VHnDtzlurQ1uYpD7vYrN2tolMHqra0tJHyh08buGKbteTNjvBI9HQ0LMlXbzeT6r2tT
         Bi9ZVHSjJZv+IJoNbx0FkZKHyYIvROvfe3PXBHM9id4jYzEU3VtdCf4gw4CTSaMsQs0N
         UueeXQcOBcuEoHfF02D1oQ4DMwcIvkUuHcXfBf4lkSopQ+T/zhmxKRgtS1xY5bTWpzaH
         7CrV7goIoYP3cDDeu2o0lDqU1O2Y8BD8ybqETuUi5SjmEbvjVGHl9TTPdAxpDmC7vsVR
         wvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/g9C8vLCxpxetYHMmmvMHDZ4rkR3+uVlFuhnglVYRGo=;
        b=iA03k5AxmUIk8S66h8z8sA1PIdxS0ESfq7R2ZA+z+tmmGP2nI0Xrq9CpMtBh5XNoO6
         8DwSWdp2ghCqlNzq70kVbex+O3JZYpHvJT92ervsO/uRtgdnGYAaXIwy2FdmkWugRxJH
         TX2gqgeFt56iWSmJsYyZ/OxrSa1qi+dmC+2nmRBP94jYbgiA6NFLR3XG6Lyhqm92YwC8
         Y2P5rfjYIr4z4/dpIdiw1k4uQ1a8kgBrO9tHZ95yxUoX45QoXImq7KnH6kMrC0J366OD
         quXKbsZn8Hsl+DoXVmzHEOTxkjJfgZRxf8J2tSah+NXAX3U+SXvDgxFD6s07m4cjKFIV
         U5cw==
X-Gm-Message-State: AOAM533h5E5YI1d+Pbs4qxC7odZf6RFVxfQ3btJdT0TnnO7VwyTG5gGc
        2sk8KpLkFsztMG4BBt03ukB7+w==
X-Google-Smtp-Source: ABdhPJykOZcrDnmOCKaUJRp9PsIrPnZo/Uuby9MJ0DopNbFrV0OF9l8f9Gld8423jiQ3X6pEPQZHgQ==
X-Received: by 2002:a05:620a:248b:: with SMTP id i11mr7745403qkn.153.1624987242047;
        Tue, 29 Jun 2021 10:20:42 -0700 (PDT)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id d129sm12430058qkf.136.2021.06.29.10.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 10:20:41 -0700 (PDT)
Subject: Re: [BUG] btrfs potential failure on 32 core LTP test (fallocate05)
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        "ltp@lists.linux.it" <ltp@lists.linux.it>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>
References: <a3b42abc-6996-ab06-ea9f-238e7c6f08d7@canonical.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <e4c71c01-ed70-10a6-be4d-11966d1fcb75@toxicpanda.com>
Date:   Tue, 29 Jun 2021 13:20:40 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a3b42abc-6996-ab06-ea9f-238e7c6f08d7@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 6/29/21 1:00 PM, Krzysztof Kozlowski wrote:
> Dear BTRFS folks,
> 
> I am hitting a potential regression of btrfs, visible only with
> fallocate05 test from LTP (Linux Test Project) only on 32+ core Azure
> instances (x86_64).
> 
> Tested:
> v5.8 (Ubuntu with our stable patches): PASS
> v5.11 (Ubuntu with our stable patches): FAIL
> v5.13 mainline: FAIL
> 
> PASS means test passes on all instances
> FAIL means test passes on other instance types (e.g. 4 or 16 core) but
> fails on 32 and 64 core instances (did not test higher),
> e.g.: Standard_F32s_v2, Standard_F64s_v2, Standard_D32s_v3,
> Standard_E32s_v3
> 
> Reproduction steps:
> git clone https://github.com/linux-test-project/ltp.git
> cd ltp
> ./build.sh && make install -j8
> cd ../ltp-install
> sudo ./runltp -f syscalls -s fallocate05
> 

This thing keeps trying to test ext2, how do I make it only test btrfs?  Thanks,

Josef
