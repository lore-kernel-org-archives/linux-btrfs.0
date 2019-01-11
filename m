Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02547C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 15:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDCB820874
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 15:09:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="xZSRMiI8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388505AbfAKPJp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:09:45 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:43928 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388182AbfAKPJo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 10:09:44 -0500
Received: by mail-yb1-f193.google.com with SMTP id t16so5932837ybk.10
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2019 07:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AgLZ3lze+FZuAHs35BdV80UmLxbLGRzZKHUHZjl2UT8=;
        b=xZSRMiI8kY1pzWMDhDecKa/0hzGljVf8rB7McvFIO7cT3tkKrukNvjoOmhveOcYYaW
         8cC/KxxoB4cqwouIgpl8WMB/Pk2vZyzSJbZm2B1HkiWTEqngcZEdqi90LpZoolJthCyn
         Bhbh/Tz36XvQ2yZWioIhtgbRsd6v65LIHSg1R5deeAqlhJYR+Z3F0apSlvZlwex8P08a
         WSFdNXJLLYgjAbut9zhdwI1QLX0vEd6v4UrWqkgBRWPsZbVz2MYK/G0xVg0EZUezD/Kw
         IUfJ9aX+PzpQELzcwvesyTXLvGxmpex05Xxh/iIC/mM3o63l7WT08Z39tNM2aObMqFUy
         FLtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AgLZ3lze+FZuAHs35BdV80UmLxbLGRzZKHUHZjl2UT8=;
        b=WOo/gRpSMo912MSmEOp8Yar5xfEpZvxy80A1jaJY0tMk1J9ZRoAVDf9FcuS9VjBeVH
         9UqX/IF5dayNze/LhL4LkhCoOVJsnT0AFv4r3gPUo+TwAmOu6AE+FrcTclFVhn9wqOZ6
         8z8bzJBnSqLM9R/ygjmqVdENvuPUyFWvX0MYOBAxu4e83BLtDJUNOhuhOaUxJcaPe/oG
         yr+sesqT7c1fU9DJUaqBzFHiKQZSDPv0y7X8Fn7dwkyh1RfvDoM2RU74OYHXR/3y/Pan
         yjCefOZHcSQW+MyOBga7FUoaN5yjLP2s8BtZyAzfO4dLcOo1Edk8MKq6GLWuW9CBD3HE
         Fh6g==
X-Gm-Message-State: AJcUukc9e8b/HgkFWf965NG/JCgnOZV6ipRUk3ph6nMwGCJ6Nt1qJR1X
        tKUuLP6utskhS9kRrMfpd1xwUw==
X-Google-Smtp-Source: ALg8bN6WIGYNWBGhSww6vwM5wbGiql9A18rnfYWG28XKUzxVr+qQJ9dbWFiLw5ZpeRIrW4T+zYXkjg==
X-Received: by 2002:a25:bd86:: with SMTP id f6mr13964426ybh.508.1547219382765;
        Fri, 11 Jan 2019 07:09:42 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:1566])
        by smtp.gmail.com with ESMTPSA id c127sm32029419ywb.67.2019.01.11.07.09.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Jan 2019 07:09:41 -0800 (PST)
Date:   Fri, 11 Jan 2019 10:09:40 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/3][V2] Delayed iput fixes
Message-ID: <20190111150939.k7ddtqayqa5hnkdj@macbook-pro-91.dhcp.thefacebook.com>
References: <20181203160652.25078-1-josef@toxicpanda.com>
 <20190108153438.GG23615@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108153438.GG23615@twin.jikos.cz>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 08, 2019 at 04:34:39PM +0100, David Sterba wrote:
> On Mon, Dec 03, 2018 at 11:06:49AM -0500, Josef Bacik wrote:
> > v1->v2:
> > - only wakeup if the cleaner isn't currently doing work.
> > - re-arranged some stuff for running delayed iputs during flushint.
> > - removed the open code wakeup in the waitqueue patch.
> > 
> > -- Original message --
> > 
> > Here are some delayed iput fixes.  Delayed iputs can hold reservations for a
> > while and there's no real good way to make sure they were gone for good, which
> > means we could early enospc when in reality if we had just waited for the iput
> > we would have had plenty of space.  So fix this up by making us wait for delayed
> > iputs when deciding if we need to commit for enospc flushing, and then cleanup
> > and rework how we run delayed iputs to make it more straightforward to wait on
> > them and make sure we're all done using them.  Thanks,
> 
> I'd like to push this patchset to 5.0, can you please post the missing
> rationale for 2/3? I'm not expecting any code changes so it's just the
> text, I can update the patch, no need to resend the whole series.
> Thanks.

Sorry I saw this earlier this week and then promptly forgot about it, I'll send
it shortly.  Thanks,

Josef
