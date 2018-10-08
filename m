Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744BAC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 12:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 112F320858
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 12:30:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ChyTz0Ez"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 112F320858
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbeJHTl3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 15:41:29 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:37222 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbeJHTl3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 15:41:29 -0400
Received: by mail-io1-f46.google.com with SMTP id m16-v6so11491018ioj.4
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2018 05:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6eVi/+1B4MTsyZ/cySe2pHBtqXlHOlxNPq2wR5SwxNA=;
        b=ChyTz0EzW/Vm/vtt0AbyHh/UpbQp79wCgnYmTuiAU2mw4uxP59Oie9KzO54AMENE4o
         g53U44vOeMN3K5/8NILvIsL3PjpfsxTai1Ro4GfjHsrdc0yoyKSnOhGWAuwCrOSKF+t0
         SVpHRjstlCxDdfEjFYEzODmVmFPbW4KNFPjveA7lrZYW4eCxMM57VrMmdk6gWfy+M7vI
         tGyRv9YAyCXbD+tOAzYTVpNK35YqJ6bNWshyCvLBwkJX95+yFJ0V3yJloqnao1wZI+v9
         TcG2pbkrkvSuXeFel1tT2SmEHXXE/62jBDMRUU0fquvQBF3qFrSzPeGHC80ipRiA5e4m
         Ywxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6eVi/+1B4MTsyZ/cySe2pHBtqXlHOlxNPq2wR5SwxNA=;
        b=bb8XNz7DnbIg4YkCbRf6hT2gQ8PWwUMTzZSspNADYPC4IsSdOGt2vb0m2mWjhBj2HG
         cqiUlgscVIfgSU/SHNsxWaxKTj6byn4jLcr7BWs7vSrG6W66AisrSM/ok89QE+jty5Mx
         XdXzEJiHjA+KDCphKnmZf7eJ0Aic0OGUtewynH5u+0MzO2wRzQzg88Wtn/bXZwQFJ6lG
         iup1qkGyrBAHMk/ptwuIDnV6bTzasKYob1Wv0LjYjgVZI95wFqtpqEzsckf/HBg82xmf
         ykbtoHdJS2q4pSGeMXnEgNj8SY5GEwMHU0OSEWhBR9eIQSkcOix209D4mIg6YmOXDvjc
         4WNA==
X-Gm-Message-State: ABuFfoiY3KxjPhZQurG9Y3IXqYO3wAYxai51Aty/o/K5v4hKdLfbLUOX
        h85bvisosF/xio7bczle89ItBiEbyZE=
X-Google-Smtp-Source: ACcGV61rcYG6KtsQUpjAYMWSapTCkdMLyATxO9ijND4oWphBbAp36qjk08fDT72jTTyzyOmQTtImVw==
X-Received: by 2002:a6b:c6c4:: with SMTP id w187-v6mr15678936iof.79.1539001798580;
        Mon, 08 Oct 2018 05:29:58 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id k5-v6sm4383999ita.14.2018.10.08.05.29.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Oct 2018 05:29:57 -0700 (PDT)
Subject: Re: Monitoring btrfs with Prometheus (and soon OpenMonitoring)
To:     =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <02416de6-1c8c-235d-f59d-322bbcd68105@applied-asynchrony.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a99c18ce-e66e-3818-8af1-92d77709f8f6@gmail.com>
Date:   Mon, 8 Oct 2018 08:29:56 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <02416de6-1c8c-235d-f59d-322bbcd68105@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-10-07 09:37, Holger Hoffstätte wrote:
> 
> The Prometheus statistics collection/aggregation/monitoring/alerting system
> [1] is quite popular, easy to use and will probably be the basis for the
> upcoming OpenMetrics "standard" [2].
> 
> Prometheus collects metrics by polling host-local "exporters" that respond
> to http requests; many such exporters exist, from the generic node_exporter
> for OS metrics to all sorts of application-/service-specific varieties.
> 
> Since btrfs already exposes quite a lot of monitorable and - more
> importantly - actionable runtime information in sysfs it only makes sense
> to expose these metrics for visualization & alerting. I noodled over the
> idea some time ago but got sidetracked, besides not being thrilled at all
> by the idea of doing this in golang (which I *really* dislike).
> 
> However, exporters can be written in any language as long as they speak
> the standard response protocol, so an alternative would be to use one
> of the other official exporter clients. These provide language-native
> "mini-frameworks" where one only has to fill in the blanks (see [3]
> for examples).
> 
> Since the issue just came up in the node_exporter bugtracker [3] I
> figured I ask if anyone here is interested in helping build a proper
> standalone btrfs_exporter in C++? :D
> 
> ..just kidding, I'd probably use python (which I kind of don't really
> know either :) and build on Hans' python-btrfs library for anything
> not covered by sysfs.
> 
> Anybody interested in helping? Apparently there are also golang libs
> for btrfs [5] but I don't know anything about them (if you do, please
> comment on the bug), and the idea of adding even more stuff into the
> monolithic, already creaky and somewhat bloated node_exporter is not
> appealing to me.
> 
> Potential problems wrt. btrfs are access to root-only information,
> like e.g. the btrfs device stats/errors in the aforementioned bug,
> since exporters are really supposed to run unprivileged due to network
> exposure. The S.M.A.R.T. exporter [6] solves this with dual-process
> contortions; obviously it would be better if all relevant metrics were
> accessible directly in sysfs and not require privileged access, but
> forking a tiny privileged process every polling interval is probably
> not that bad.
> 
> All ideas welcome!
You might be interested in what Netdata [1] is doing.  We've already got 
tracking of space allocations via the sysfs interface (fun fact, you 
actually don't have to be root on most systems to read that data), and 
also ship some per-defined alarms that will trigger when the device gets 
close to full at a low-level (more specifically, if total chunk 
allocations exceed 90% of the total space of all the devices in the volume).

Actual data collection is being done in C (Netdata already has a lot of 
infrastructure for parsing things out of /proc or /sys), and there ahs 
been some discussion in the past of adding collection of device error 
counters (I've been working on and off on it myself, but I still don't 
have a good enough understanding of the C code to get anything actually 
working yet).

[1] https://my-netdata.io/
