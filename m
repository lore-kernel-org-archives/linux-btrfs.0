Return-Path: <SRS0=wjlZ=YE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6317FECE58C
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Oct 2019 11:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 399082190F
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Oct 2019 11:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ciwOIJ9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfJKLcL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 07:32:11 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]:36599 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfJKLcL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Oct 2019 07:32:11 -0400
Received: by mail-qt1-f177.google.com with SMTP id o12so13375493qtf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2019 04:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Y3kW3pF0a6aBfb/VeHtxCj7bKgxVAc4QlMeTD8taQjg=;
        b=ciwOIJ9WvC/C6/1EtF8SAyPR1THYzs/XV+zowmqcwhnSpC8irpR4Xw+e7WEPAagD8s
         emM/spIOEKukWioS2OJ/OnRMHsm/nmWRXYCmBthZ3oxnTJnkH4sDHH4H9XNXnIlCJvPy
         0phJ5Cp73FvA4GVNDRQ66LpzU4aUXpULCFu2HoTlM4YyrM/MDQZx+6fQbXwgzy75NF0M
         dXS+dW5Gzqw9Q1YaVeD7eC1ZnLvwDpRLSmPCvBD1Yzcy4z0nfjHcWMNa8ytVfZctaYAO
         uYFYL6pip1Hl2eg09rGcZvaNk2SNdt8QXLs23b28NKbTS3NvWiz4Ig8QoJcTZSryX3P1
         SFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y3kW3pF0a6aBfb/VeHtxCj7bKgxVAc4QlMeTD8taQjg=;
        b=GYD2zp8/2nQzdjqDfAOcYiORW7Ha2gTr2+m79HeW5/7n5JUNo3maFW+nk+l3ko+kyA
         cMYNDcQTNOkt16FWt9gpeIBF/AOAvvJY4ic/+goNIXyETvPr121oE7BupwbNZrfKsRYW
         hbrR6aYsLpX2jxxsOmm/evWkNjbRh+cfsPbLraYoB4jn1UAaeA8BiEIbJMSTd8blkVxd
         biY1u1kcHaQ8ueqGwJ/OZpiQvD1gUi6ihdAzp65nVD96gIxln6Ym127V7EYvmqity2KZ
         w2By6zAIKiqN+3AByTUAaa9Sx9P8z6yZICXfyHZJ2KC/Vuvc8SSdnK/2oRXD3QytgCLN
         iYLw==
X-Gm-Message-State: APjAAAV0JQ5ulRnLNwNzz4x7R1uFdvxGY1XpLQMl058VlwHXsOYQ6Qj8
        V1fwD1+j1Q/ycy5GFCqCEasD3XDDwJM=
X-Google-Smtp-Source: APXvYqwJ/5Be2yZF0yWmSF7ERnwcB27qIwhAMNU4z5zzaSmDA8gwRJjn1QvGKRg3oykYIHzzAfNTVg==
X-Received: by 2002:ac8:714e:: with SMTP id h14mr16113354qtp.147.1570793529924;
        Fri, 11 Oct 2019 04:32:09 -0700 (PDT)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id p56sm5659997qtp.81.2019.10.11.04.32.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2019 04:32:09 -0700 (PDT)
Subject: Re: rsync -ax and subvolumes
To:     linux-btrfs@vger.kernel.org
References: <20191010172011.GA3392@tik.uni-stuttgart.de>
 <CAMthOuMV7MgB4b87RsijYr9e0UsjMUDNk+QRXeauFdb3cZcTjw@mail.gmail.com>
 <20191010212133.GA3648@tik.uni-stuttgart.de>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <760c52db-34f4-3c84-c073-291a428ee475@gmail.com>
Date:   Fri, 11 Oct 2019 07:32:07 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191010212133.GA3648@tik.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-10-10 17:21, Ulli Horlacher wrote:
> On Thu 2019-10-10 (20:47), Kai Krakow wrote:
> 
>>> I run into the problem that "rsync -ax" sees btrfs subvolumes as "other
>>> filesystems" and ignores them.
>>
>> I worked around it by mounting the btrfs-pool at a special directory:
>>
>> mount -o subvolid=0 /dev/disk/by-label/rootfs /mnt/btrfs-pool
> 
> This is only possible by root, but not by regular users.
> Yes, there are true multi-user systems still out there :-)
And that is what `sudo` or capabilities are for.

`sudo` will even let you get as specific as command line arguments, so 
you can specify an exact mount command that can be run (including 
ensuring that it's read-only) and an exact unmount command that can be run.

If you want to go the capabilities route, you'll need CAP_MOUNT.  This 
is a lot riskier than using `sudo` though.

That said, if you really want _everything_, you're going to need to 
either be root anyway, or have the CAP_DAC_READ_SEARCH (or 
CAP_DAC_OVERRIDE) capability, because there are some files you just 
won't be able to read otherwise (at minimum the contents of `/root` and 
any properly secured authentication logs in `/var/log`, as well as 
possibly other things under `/var` and possibly some things under `/etc`).
> 
> 
>> Actually, you could also just bind-mount into /mnt/btrfs, bind-mounts
>> won't inherit other mounts but will still see pure subvolumes.
> 
> Again, only possible by root.
> 

