Return-Path: <SRS0=WNKx=B4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4F4C433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAC3220786
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:04:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="TGQoWdkb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgHRPEF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgHRPED (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Aug 2020 11:04:03 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EEEC061389
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2020 08:04:03 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id 6so15358514qtt.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2020 08:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ttf1iXJjpcNOVz4YBkuQzDK+InqOxAPI4DSgl/mFx+Y=;
        b=TGQoWdkb0uy71Rbtpsmcyes5Gqua6TdUBZPzOVoavbp0y17JlWZBPTGYEcKTa72jey
         ez0qI0VyNZGs9tW0+dnaF1LRYprNZ48Y4Pg7zyKYA/dHmKJ8M0IDOjk2exYQz2UPxgAs
         ZcRK8PuLhzJZWsgf0sJySB0H1moKacoe7/3dzPhFf0dTgWgwKQO5F+XGkTm+QObF7f0T
         rb0az+hYu+Im16Pt2622DnZVf5c72Ewy2eW4ZP/Cqp13oJ0xEcfctyKNlXd7NWrfheYm
         zvP1VZL4Vj/MC3tKmgNG28zg3bCAIYGsDHFBXTlCY2d275dYkHfoxVaDUumyQ50Q6nF4
         Gfpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ttf1iXJjpcNOVz4YBkuQzDK+InqOxAPI4DSgl/mFx+Y=;
        b=obvDZPMQ1d+6V8LDy2pzxt4oZhazevhNbIIvlUw16a+PQg6OFQh2CdFC1Y2NlECcxs
         Z+SvSnSk1so3oV02IG5sXfPo1hNElqbl44CVVX5ScUo7ezTKsLz+xoFUk5GYXOR9V0cM
         6wYVlWGZ3MRfFpg93ht070I9CmGMylsi67TlmvuEk0qa6gfI/Nc8BcSBIZhmy0KwLz0I
         YTtzU4uPkhWvfNa18LwO2UB1ze60PRMUG0v8naMEv7PzKJ8IO42Btu/eSkhNLntdExQL
         eiPpQcfjz2RyTcaVfg9LXroWnriINL7o/Vi9NN+t7/OgFDlJheBsevZkcWJSqn1BAI91
         /I+w==
X-Gm-Message-State: AOAM532SX5m2OY6Ehb/yep0Cxot3qykQPPerqL8d09LvOGowvupBI6at
        gzKCCbl/Iuo9AH1jcHvJ7WOL/QuyR0Hy7vaO
X-Google-Smtp-Source: ABdhPJwAv41VXzGDE3cOhsUp8PjCqqlk0shizNzLLYiiDzYjCWx/MqRLSKRaqdypQFa3/nCYm+RPNQ==
X-Received: by 2002:aed:20cb:: with SMTP id 69mr19010418qtb.106.1597763040739;
        Tue, 18 Aug 2020 08:04:00 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d9::1055? ([2620:10d:c091:480::1:66f8])
        by smtp.gmail.com with ESMTPSA id n127sm21577198qke.29.2020.08.18.08.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 08:03:59 -0700 (PDT)
Subject: Re: [PATCH 2/5] btrfs: Factor out loop logic from
 btrfs_free_extra_devids
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20200715104850.19071-1-nborisov@suse.com>
 <20200715104850.19071-3-nborisov@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <85602a22-578d-4319-8e0f-ca3b3a67d403@toxicpanda.com>
Date:   Tue, 18 Aug 2020 11:03:58 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200715104850.19071-3-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 7/15/20 6:48 AM, Nikolay Borisov wrote:
> This prepares the code to switching seeds devices to a proper list.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
