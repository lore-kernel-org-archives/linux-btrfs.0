Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E681C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 16:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09DB221924
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 16:55:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C819nazz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388698AbfBOQzC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 11:55:02 -0500
Received: from mail-it1-f178.google.com ([209.85.166.178]:33319 "EHLO
        mail-it1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388663AbfBOQzC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 11:55:02 -0500
Received: by mail-it1-f178.google.com with SMTP id g137so8219860ita.0
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 08:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=z3th2DT/8KjKMjLlX0Bc5LvqsE2HPjUb2oLVFOAu4tQ=;
        b=C819nazzKEPhVk5S27KKr7wOyNWV9mbPco5R1ffVkudJR6TCrUdQRD/TJQMTnCxs2j
         UgXm0Kg4/htetW5+zsRoyUI26P3EdpOstlv5KtZoDI5VLHJOJKqRSZtTfzsrqgZmY1vR
         I7wJT+ConR+Pvi2LZTrZROZwFTrA9lyBOHMIfigE/HEKCTnRCkNbnYPudd3mAawAm7zc
         Z96UlbHrTkrVV8obgXkCdBU+f2ypAPzZ05PwYkxxpIuEPoFXx81fRKk/tr6zHSXer6aq
         /SETiuEpq9q0WSHrkuqarzRROVzwQGJcSWtSScLWV//lvtui0SUolG0Me6ScAlThKOUm
         FPFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z3th2DT/8KjKMjLlX0Bc5LvqsE2HPjUb2oLVFOAu4tQ=;
        b=EW5APHrM7AZh36d4Ss+cbDvU92jsUsVuuZGiyc9DeERwHz6ItVM+uR+/EXhol1poQ9
         3p5uJSkJqVCwvO57N+ewbTVu9YFsKKNKG3YaMG5TjEpkDvvvdy59ED3mQFtjafxxx72P
         yXyozsCBOoSGwy8GBVnGHS8pHCi3nzU/hdu2p6U3y2lokYiiFrYPH/NBZfvTXNUDrQYl
         y8ultghwhYk6quEtTDpPGPkZOFOBexdDp4zhYCq9/PJaUChgycVYxreXv3ZkuASG7VyO
         LwYDlx6uyqVsnBUGRn8p1MMSYB3nsogM/KGJnncxyU7y57QXCL+KVhf9wYey04Zw1viJ
         FDNg==
X-Gm-Message-State: AHQUAuZvHaU7TyRGPAsfLRykueKAeilbOxIJM2GC4rBRa3RMHSxTO1vH
        KM0pvIZZSZL51z/jDvTw6pWhwuAsQ5c=
X-Google-Smtp-Source: AHgI3Ia82Ll0hXXxoDEUp8myOzYsNuxyBE6EOLAZi9u7Jp8kehXoeTphhddotPevK8Ev3ZZT+6LD/g==
X-Received: by 2002:a24:7351:: with SMTP id y78mr5396130itb.12.1550249700119;
        Fri, 15 Feb 2019 08:55:00 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id r193sm2873386itb.6.2019.02.15.08.54.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 08:54:59 -0800 (PST)
Subject: Re: Better distribution of RAID1 data?
To:     Brian B <brian@sd85.net>, linux-btrfs@vger.kernel.org
References: <db678e75-6f56-a247-adb9-c7cca4d63528@sd85.net>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <91c2c290-5796-3f18-804e-0c19ae17f1db@gmail.com>
Date:   Fri, 15 Feb 2019 11:54:57 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <db678e75-6f56-a247-adb9-c7cca4d63528@sd85.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-02-15 10:40, Brian B wrote:
> It looks like the btrfs code currently uses the total space available on
> a disk to determine where it should place the two copies of a file in
> RAID1 mode.  Wouldn't it make more sense to use the _percentage_ of free
> space instead of the number of free bytes?
> 
> For example, I have two disks in my array that are 8 TB, plus an
> assortment of 3,4, and 1 TB disks.  With the current allocation code,
> btrfs will use my two 8 TB drives exclusively until I've written 4 TB of
> files, then it will start using the 4 TB disks, then eventually the 3,
> and finally the 1 TB disks.  If the code used a percentage figure
> instead, it would spread the allocations much more evenly across the
> drives, ideally spreading load and reducing drive wear.
> 
> Is there a reason this is done this way, or is it just something that
> hasn't had time for development?
It's simple to implement, easy to verify, runs fast, produces optimal or 
near optimal space usage in pretty much all cases, and is highly 
deterministic.

Using percentages reduces the simplicity, ease of verification, and 
speed (division is still slow on most CPU's, and you need division for 
percentages), and is likely to not be as deterministic (both because the 
choice of first devices is harder when all are 100% empty, and because 
of potential rounding errors), and probably won't produce optimal 
layouts quite as reliably (you either need to get into floating-point 
math (which is to be avoided in the kernel whenever possible), or you 
end up with much more quantized disk selection).

I could see an adapted percentage method that preferentially spreads 
across disks whenever possible _possibly_ making sense once we can 
properly parallelize disk access in BTRFS, but until then I see no 
reason to change something that is already working reasonably well.

In your particular case, I'd actually suggest using something under 
BTRFS to merge the smaller disks to get as many devices as close to 8TB 
as possible.  That should help spread load better.
