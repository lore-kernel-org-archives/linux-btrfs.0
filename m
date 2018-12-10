Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8A7C04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 16:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD13C20672
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 16:54:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="JvQY5p0B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD13C20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbeLJQyu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 11:54:50 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38867 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbeLJQyu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 11:54:50 -0500
Received: by mail-lj1-f194.google.com with SMTP id c19-v6so10281387lja.5
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Dec 2018 08:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=wYVJbpj9RjQXgvpqRFSTTrOuHCEvNpXbco45JcSVI3s=;
        b=JvQY5p0BHc6Je7MPRw/HAILeITQ/ulSEbIz9R46wZDJ8KPVmRl87BwLbddf4v4CpUF
         YbpGy9AxfMNHjG47Z5Bb63TRKxq4gwymFmuIYm6rCp+Q6yMOJOq92uL2pSL/VA3qSkmT
         KpaECIsJq5TYLkp8xyJGIXUddRsdOq2iQY82yLFQloxeQKY+3IQl/3F3pmfB60kWvRmL
         alzOuIAHDwym9mPSe7rUmTH+pWNnU3XaSAZah9YuzD9880FzUN2f6rVWspYa+xDITW//
         LMXjVHcgrBMcnj42bRXnIcj313WMReh78f1Bu6LnQQNJMVs2ymzkw0V1Myxh9Bgrf2Zn
         z7/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=wYVJbpj9RjQXgvpqRFSTTrOuHCEvNpXbco45JcSVI3s=;
        b=K0kzGZu74fKhKfmKQFnHw5hHJXWDrjRWK1yc+aUSTUa3Gr4MfJKcQ6YheOrvY0BXxb
         yIbuxvh+MaipdBRMS2jKhCDYs48wNTPew2fgeFWxE2901v6RR/BVRUNx68b8+aK7nNlU
         SfXiZKhJlZLequXTndyOpFFgMfFWU8gRtH1qd9/OKDnzzOgjDsVC+6mqTdmXG7v7CGLp
         kttijbJm62OLRbi/wQI00OU2zf4c5wmJpWFo+DLmPHPd8AY4RRQCTcts2fOhcSDtxqj6
         LhNGt/A+YBuJj2HtyDmtafBoGC11uJudwSvbKV4PyR91hhcNivMzjFk88SPeqih33cYq
         BFcQ==
X-Gm-Message-State: AA+aEWbprcpTnzp59N53JFuPu5S0huZkZLE/vU8gQ6aFJeG6lActy4Lg
        8GNJClHD3afGHtQJlmw+0m5OZnQSrkzgnVX2udGFvw==
X-Google-Smtp-Source: AFSGD/XM6jJKLGZE+dKmq1nLOCqRpppUbW2CP88q58dV8iThJ3tj19bQv//EYC4t258ZqE5A2S2pk77n2jsD6SAN2fM=
X-Received: by 2002:a2e:841:: with SMTP id g1-v6mr8276573ljd.21.1544460888434;
 Mon, 10 Dec 2018 08:54:48 -0800 (PST)
MIME-Version: 1.0
References: <20181210120514.GA14828@cuci.nl>
In-Reply-To: <20181210120514.GA14828@cuci.nl>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 10 Dec 2018 09:54:36 -0700
Message-ID: <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
Subject: Re: Kernel traces
To:     srb@cuci.nl, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I suggest reproducing the problem and issuing sysrq+w and then post
the entire resulting output for a developer to evaluate. I find it's
best to have the sysrq setup in a shell before hand so all you have to
do is hit return, and of course you can test the before the problem
happens. It dumps to dmesg and can sometimes overflow the default size
buffer, so either increase the buffer, or get it from 'journalctl -k'
redirected to a file. The entire kernel message might be helpful, but
I also note the kernel isn't tainted so what you're getting is mostly
info noise about the hang.

I see this is btrfs-receive workload, so I wouldn't guess it's
suvolume lock contention unless the contention is happening with a
single shared parent subvolume into which all the receive subvolumes
are going (e.g. subvol id 5). I'm not sure how to alleviate it.


Chris Murphy


Chris Murphy
