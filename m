Return-Path: <SRS0=z0ck=YD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3F9ECE596
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Oct 2019 17:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51AE820B7C
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Oct 2019 17:14:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="RDNV1xs3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfJJROE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Oct 2019 13:14:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36310 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJJROE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Oct 2019 13:14:04 -0400
Received: by mail-qt1-f194.google.com with SMTP id o12so9801625qtf.3
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Oct 2019 10:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wI3kzCPobilUY7+XIsZ+xqh1q6BKkBMXLQXqT7nofCk=;
        b=RDNV1xs3BqvUgtx8OImqbxQ3boCSGV+YTqATt1BiMyWsoLtGZkcFbJBATKCsmdqFZ1
         WWWXZRUq3j+ys0G1a1hzOAglb3fI/wX5LUkQyerhj+TbG8xH0K9sK2wyAHKibIZBUj0V
         8GU3UdWSQq6rA+uVSJa3iXEOkegqi+S1ylv7plg1FN0f6wPvClO0xUQWSC743WgcxsAY
         mxe9gXuVCuSG6OgEIEQAjD1Bfk6qOJ5CueMlS+7+doiASmkxbc6EJJzbMew87dUotM3c
         SbGVsRclVGRoy5dChcjR2Rm6wh/yXiw90wv/mFOEK3tuAES3zhouDL1jN9fsC8shxFZc
         dAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wI3kzCPobilUY7+XIsZ+xqh1q6BKkBMXLQXqT7nofCk=;
        b=TRS0ccX+CI7zqC5PQXSEnHBFaoDkidSc5KvxaSOgUI1DGAwzeTKqFhNguF5tmZK7u9
         zPo5NVT/sBmiFCGTykou1tMrq1Umms7X8CsWQVBbNTTbFjkUbvSN5AkenruMSTxhd1j2
         szZ2C+9LqgS5rBo3xSAyOt+GAkhDe2uZEEG2DEiv+jJsNQcc3ZoPQvPhJ5T4WFfxcS8V
         uwbpCuLwvHBY1J46KonF7RkOq46OB6cOP5iNg/7L8DRZ78onllQmTCKuB3N17U0R3QSf
         3dnHsTTM8jF2R2S0LXdAZuye53yVgTpRcslFc3jp6UGfvqKwBz4Hgzpj2Q1w/5dd9tWd
         iWWw==
X-Gm-Message-State: APjAAAXs7JpdUkL+Kytr3HyyCdZmbttGiWpbQ24+6bOww7RKocixUNCS
        tb0yxiEpQeWmv4hIa5KZuYVCOw==
X-Google-Smtp-Source: APXvYqxkuDUYXaS7Ow4pssw61Vib+RBvWenBA5s1mnv+m9+U1tlOoAoCR9ZsJ7rj5YDybd8suxqIaQ==
X-Received: by 2002:ac8:6783:: with SMTP id b3mr11920178qtp.25.1570727641821;
        Thu, 10 Oct 2019 10:14:01 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::18ce])
        by smtp.gmail.com with ESMTPSA id p36sm4241345qtc.0.2019.10.10.10.14.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 10:14:01 -0700 (PDT)
Date:   Thu, 10 Oct 2019 13:13:59 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 17/19] btrfs: add async discard header
Message-ID: <20191010171358.m2dcf2zhjrkxlk4w@macbook-pro-91.dhcp.thefacebook.com>
References: <cover.1570479299.git.dennis@kernel.org>
 <497ce83624b2d2947ce85a8381f39123bd4e7a53.1570479299.git.dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497ce83624b2d2947ce85a8381f39123bd4e7a53.1570479299.git.dennis@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 07, 2019 at 04:17:48PM -0400, Dennis Zhou wrote:
> Give a brief overview for how async discard is implemented.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> ---

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
