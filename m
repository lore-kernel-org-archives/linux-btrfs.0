Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D81AC10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 13:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A0342084D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 13:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="MFUyNoAE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfDLNai (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:30:38 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:37677 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfDLNah (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 09:30:37 -0400
Received: by mail-yw1-f66.google.com with SMTP id w66so3370152ywd.4
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 06:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=UXvxf1OXXeoruXLJbh5+06YXN/1mL5HmL5lQUAc7+sk=;
        b=MFUyNoAEqoKL9wqUgqub3MuZPL5NUyP4LscCiKaTLjxB62jgiAsSem0ObrW6UhQsf3
         C5GSsL49C+mJmC+5T8Kd+kr5ICWvhdZo4ZjY2AMCif3AR8bwrCgbPokU3nuzHcniiUAW
         nQQSthN7k157N+bwVaggiidcEdjAg+I72/S5BrwpL2t5+gLQD0j+U/SAsIQZzY1fChS5
         ToqgxN5hSiZ68RwjhkwqsbVsVAENh+fn2O/7E8FqoBHN25GG33OOHnGy4G1i5sjxsiMu
         /btR/KF1mYCLpXoGRJGqyxQSvh3qlEHIO6evwzLVuKBgRK/DZywrpTmNc68Vd+1T0h8G
         WsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=UXvxf1OXXeoruXLJbh5+06YXN/1mL5HmL5lQUAc7+sk=;
        b=uiuI48OofUmgfXdmTFpcop9QFB7EKt+T82CkKvoQeHiBSg+ITjZzt5Ebyx2ik4Xi77
         qiCOlW2/YMXWKZUGoSc8PxldtXKYNBwXtZ85LywdGkdh3H1sCO5rr0RAHofGn3dSFBxY
         ih3+WzFIItInMz6YIR/uP+BWahidQR7VbTnAb+s3sHVreW5UkMiQVNEeqs2XXNkIDiKO
         4znKKMyak75UbpaI5nwNQn3y2BN8Jar4A5GEPmRoWr0kka/l3qWhwyqGDTC6nvJkBKKv
         UQtFPgj1OW2FeyiJA2gdvTVBlCwBWFcVw/VTFVOWOVnLVOvRFnQV8SuTvHaCX5wcgIUC
         JRxg==
X-Gm-Message-State: APjAAAXQqBi+AWHlU6EnZ0sC/ZRXyaEh48g/Vm1RQFCA7R4q4cLfXF67
        vuPW7TDb4i19sDZj9eutEx9ehQ==
X-Google-Smtp-Source: APXvYqzYYAZAOMb1pma8x2mfbH8fT2TnJ+5hEqDc7mXLJsDP6xXIi3iOZg0hsksZfz/RB8d/1iRlew==
X-Received: by 2002:a81:3007:: with SMTP id w7mr46117881yww.26.1555075837089;
        Fri, 12 Apr 2019 06:30:37 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::d607])
        by smtp.gmail.com with ESMTPSA id g133sm24204992ywg.84.2019.04.12.06.30.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 06:30:36 -0700 (PDT)
Date:   Fri, 12 Apr 2019 09:30:35 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: track odirect bytes in flight
Message-ID: <20190412133034.zhkkbei2vlx5lmit@macbook-pro-91.dhcp.thefacebook.com>
References: <20190410195610.84110-1-josef@toxicpanda.com>
 <20190410195610.84110-2-josef@toxicpanda.com>
 <044fa7af-3c45-46ba-d15b-fdb606c83a3b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <044fa7af-3c45-46ba-d15b-fdb606c83a3b@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 12, 2019 at 01:17:40PM +0300, Nikolay Borisov wrote:
> 
> 
> On 10.04.19 г. 22:56 ч., Josef Bacik wrote:
> > When diagnosing a slowdown of generic/224 I noticed we were wasting a
> > lot of time in shrink_delalloc() despite all writes being O_DIRECT
> > writes.  O_DIRECT writes still have outstanding extents, but obviously
> > cannot be directly flushed, instead we need to wait on their
> > corresponding ordered extent.  Track the outstanding odirect write bytes
> > and if this amount is higher than the delalloc bytes in the system go
> > ahead and force us to wait on the ordered extents.
> 
> This is way too sparse. I've been running generic/224 to try and
> reproduce your slowdown. So far I can confirm that this test exhibits
> drastic swings in performance - I've seen it complete from 30s up to
> 300s. I've also been taking an offcputime[0] measurements in the case
> where high completion times were observed but so far I haven't really
> seen shrink_delalloc standing out.
> 

It's not, I shouldn't have said "wasting time" I should have said most calls to
shrink_delalloc did nothing.  The rest is self explanatory.  shrink_delalloc()
keys off of fs_info->delalloc_bytes, which is 0 if you have nothing but
O_DIRECT.  Thus we need a mechanism for seeing that there's O_DIRECT in flight
and we would benefit from waiting on ordered extents.  The slowdown is addressed
in patch 2, this patch just makes it so shrink_delalloc() actually does
something if we are O_DIRECT.  Thanks,

Josef
