Return-Path: <SRS0=OHkO=4B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D36C352A3
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 20:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD38E21734
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 20:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="XjsBTev6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgBMUBB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 15:01:01 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39630 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727910AbgBMUBA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Feb 2020 15:01:00 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so2765141plp.6
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2020 12:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JxgDLSKSR8M9VrJIw7HffiyJDgF2S8yDRAYo5FP4E7w=;
        b=XjsBTev6DCTGWwq87dGspGaWW6MXUTckBOxEwGjTK3yA7QB97sawNQOvVsU0OId/Dw
         MdIq/RXtOoVEUia9YhxCrvQwT+RS5lP3lnKWnnTF3yp7uJN0I9qc5L5rseQSC7DB9UyD
         i9QerVpg54Skzb6HVKkHuqcDbayrclzCXKpWF0OyBrMD4vlHD8HIuVh1QLYwExBvuSET
         VQkNTxVdbPo3oICJfeh8ketYDlIc6RwwJHwY1XjmOuJk/x/yClpgEjAkUvvKIxtgial2
         z4mGYqiiQxqBuq20GStwlIAAXcQnci5HbjRCm73KVR9iiplT4ISpEoXQRKFH7GK+qWRr
         HE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JxgDLSKSR8M9VrJIw7HffiyJDgF2S8yDRAYo5FP4E7w=;
        b=oUrqUEg+2/LzcRcokxnLTlpwNdNR4bwz7XSrJMgSMfKMntCggjzrD5QVUZ58cmaSLm
         L+NCf8pwLc/qLdozV7otAlQqA2tobynIgKeU8kjpUz0+fgGeIcTi2fu0DkGRN0ECNACj
         r7mFSDNfPAtuGGf1pj4MAk2M8YMzUFmL5XsTA1HjjpYbvpi92XsXHgpl+d28ot0G06TS
         pe1HLjFT5CekZGUIHPsIZj8DNy6q1uKoD2u1tlPC/8LV4aU8kDyKFlfVdiX1dXq3CXZX
         fHpR56FBUS3898U5vE8CXOBcNXGxJp/mvNX4WRBAIOmndr63cl7z627B0t3Guy1n5iOp
         7DQQ==
X-Gm-Message-State: APjAAAUhOWm89PZeQazRbO3W8phpOof+K6wJnRpcbDFec8oYdfWTSo1C
        MRvWhCNUGa0Txe/0wG8XoYdToIBErKs=
X-Google-Smtp-Source: APXvYqzKmq2yFPSCvjfCmKSOUlRtzBG0JP7zn1FLORW3AlJrKN1//MJEfI29JVpFgx9pMDQCa+MTEA==
X-Received: by 2002:a17:902:7b92:: with SMTP id w18mr14980801pll.72.1581624059378;
        Thu, 13 Feb 2020 12:00:59 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21cf::1150? ([2620:10d:c090:400::5:249c])
        by smtp.gmail.com with ESMTPSA id f9sm4067360pfd.141.2020.02.13.12.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 12:00:58 -0800 (PST)
Subject: Re: [PATCH v2 1/4] btrfs: relocation: Introduce error injection
 points for cancelling balance
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20200211053729.20807-1-wqu@suse.com>
 <20200211053729.20807-2-wqu@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <19c7b5f8-69d0-4831-5459-ce6e18d2699f@toxicpanda.com>
Date:   Thu, 13 Feb 2020 15:00:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200211053729.20807-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/11/20 12:37 AM, Qu Wenruo wrote:
> Introduce a new error injection point, should_cancel_balance().
> 
> It's just a wrapper of atomic_read(&fs_info->balance_cancel_req), but
> allows us to override the return value.
> 
> Currently there are only one locations using this function:
> - btrfs_balance()
>    It checks cancel before each block group.
> 
> There are other locations checking fs_info->balance_cancel_req, but they
> are not used as an indicator to exit, so there is no need to use the
> wrapper.
> 
> But there will be more locations coming, and some locations can cause
> kernel panic if not handled properly.
> 
> So introduce this error injection to provide better test interface.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
