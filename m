Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE4EC43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E8EA206BF
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="P/ArwRo5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfDYOKC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:10:02 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:44926 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfDYOKC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 10:10:02 -0400
Received: by mail-yw1-f67.google.com with SMTP id j4so4323875ywk.11
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 07:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=IP606cjhfK6mOvQ5/OTzzSzamNruVnU5pK60EGXNsUU=;
        b=P/ArwRo5XXO9SzPWi2taCC6QmLoMJ9tuFLiabPYAOflFjI4gZ/JvwdxGKojpyYl8Nn
         3wvEmrrwuVKkPcmUkLVr5HxD/AvIK45ZFkdI1M8umw8JQB5fN0z2YiZXpIV2f10Q9P3E
         LvMj791Y5ChQjPeD5/Sm7vSZB6higZgK4nwbgLj/g0axW1KLv9nRNTXrsSoh7FNnLxgL
         GetfaLYEeotUMyXre4spwiZoNVnA1frX1tBKGkx5QUYeXSOTnYaNXmVBWJ10fEyf5PVZ
         1IIXrx7hr2XyE8s8s6D2QDTHXrRjXmh+SSSPTG7DIZFdQs85f2I7exeYACgdbVfNcD11
         ORMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=IP606cjhfK6mOvQ5/OTzzSzamNruVnU5pK60EGXNsUU=;
        b=nhEL7T51ft8tYEIh32NJ+kIJ2QSmdXPztOSFTRDZsYvtJjqBVCZbRSEDLyhjfBypJ8
         rxJCGb1zA7Ik6jgLvRTiWZpeT2zI+kVL6g6f/CkOpIS4+cZo1R4/e6X6Pa2x7M/YolPo
         DPIZaGeCeEle4p2BMkz5+UD+vZ0HJsY2H5ktS745gPf8kMhNJZCxeBuORzfRq/vbKmHL
         INJmSvoKY0Qk/jKduORhfP8L0z6wRv4rM5b1Rf87zISCiQ73CoCu248AH8FFTZgJ7+az
         2t9cbjKGRIUyTykSb5NllEzN1yToFyboui4x/kdogFAT9WDG4HNBhFzbADWu0chDmzpH
         5zgA==
X-Gm-Message-State: APjAAAX1hWnAaGWQL9S17EFaRGunSbEEXWM7rJW54IgzngCj6wa9VgSR
        FTeS5rqb4rlZKxmA3xohrSRGpg==
X-Google-Smtp-Source: APXvYqyt5CqqTVVk0D2N1JT5cU1R4OHiVjqIcKilZ+5GDtEY8+5U0BrNYCYqX0P15hRFMbMnS76kyA==
X-Received: by 2002:a81:3ac7:: with SMTP id h190mr31941492ywa.351.1556201401392;
        Thu, 25 Apr 2019 07:10:01 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::46ed])
        by smtp.gmail.com with ESMTPSA id l81sm8724666ywl.108.2019.04.25.07.10.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2019 07:10:00 -0700 (PDT)
Date:   Thu, 25 Apr 2019 10:09:59 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, dsterba@suse.cz,
        Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: fallocate does not prevent ENOSPC on write
Message-ID: <20190425140957.oajm7seece2wfniz@macbook-pro-91.dhcp.thefacebook.com>
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
 <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
 <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 09:50:25PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/4/25 下午9:25, Josef Bacik wrote:
> [snip]
> >>>
> >>> What if the commit is reverted, if the problem is otherwise hard to fix?
> >>> This seems to break the semantics of fallocate so the performance should
> >>> not the main concern here.
> >>
> > 
> > Are we sure the ENOSPC is coming from the data reservation?  That change makes
> > us fall back on the old behavior, which means we should still succeed at making
> > the data reservation.
> > 
> > However it fallocate() _does not_ guarantee you won't fail the metadata
> > reservation, I suspect that may be what you are running into.
> 
> For this script, we only needs 4 file extents at most.
> Even the initial 8M metadata should be pretty enough, thus I don't think
> it's metadata causing the problem.
> ---
> #!/bin/bash
> 
> dev=/dev/test/test
> mnt=/mnt/btrfs
> 
> mkfs.btrfs -f $dev -b 512M
> 
> mount $dev $mnt
> 
> fallocate -l 384M $mnt/file1
> echo "fallocate success"
> sync
> dd if=/dev/zero bs=512K  oflag=direct conv=notrunc count=768 of=$mnt/file2
> 

Wellll we don't do the nocow check _at all_ for O_DIRECT, so mystery solved
there.

Josef
