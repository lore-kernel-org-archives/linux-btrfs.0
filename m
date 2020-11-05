Return-Path: <SRS0=jnhB=EL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E03C2D0A3
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Nov 2020 01:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8B5A2072E
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Nov 2020 01:01:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="NxTLqzuc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731188AbgKEBA7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 4 Nov 2020 20:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbgKEBA7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Nov 2020 20:00:59 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D294C0613CF
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2020 17:00:59 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id v5so86186wmh.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2020 17:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2NCdtnTTij0m0fPXAKYG8veDP1MlVq/MzQWY7aMft6E=;
        b=NxTLqzucRATKIUGXlb7E5ZUxxuVPWJK5KIPyYFYCxYpJKO1oLjxDxfCPmn/6GNnLGR
         ATbWs86nSWbndWHe3E0QcryzEeLxu5pe9ZvevgMLUH+JjcZYC/5uz5RwqQtF3omT+d1V
         gSx8HMXSXonaNIZ+25YxKWk4ENuJuZqWf8Ri2OpO3B70YIPfBqs3/gS0Rk59A2eQWi+B
         81a5gB0nyW0Gpsm9ybJz7lYgD5mzdtbp/votVnAMDCZpntcZfuInKeF+hEQ/jd5IDQPt
         YmSfOonbJvgCFyWzGdBoyN618fbaEoOpBnsj9SofoKRPCiFEgbAnbckz0gK4Zuo9Tuyx
         HA7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2NCdtnTTij0m0fPXAKYG8veDP1MlVq/MzQWY7aMft6E=;
        b=Y0m1wrNgLmr5rrTBjYYksi63LysP9v5LEfap+6cZCHKIHahXd9XX7ZZpVB7zYqsM7y
         kvrhetcBKhMYvUGguauPJwF/0gDRFOuM6HoJwL8Yt3TcQO197wf+SArTpQi85wL2RX2W
         qEFdNq2dopK56OKoqp7OBTZw79tHMMygu4KgFhwV8XXxngbccLvnsgtbjvcWwocwDvbH
         FoljhABnuK9+VPei5Mx4EfkGU+HC1rrG0SYPaNwBUV/NwarjQlNa/I9ss8clnsRfD27d
         DdTinu34mP2Y6RtomHvABHfkv8/BJzDrbDHj/YP0W6T1h1+o4wGe1b2hpuvQLSOn8jur
         w7Cw==
X-Gm-Message-State: AOAM531djXMnJknjn4g19/rLmDqmOYktRvPiw6zCqpV1xtEQCVrHc539
        EBatWgdgkNnEDEK17YhJ5Ydr8jLpWINh4u3oLqYaft8E3oxlYF0Z
X-Google-Smtp-Source: ABdhPJyviWzy5YBj3v8Y3L8pwu2Mg9nlLZiRzwRvxc4Os7EKH68YXdAvcpW/3JjpLcjF776hjdaBTM43WUXAwW5fUWQ=
X-Received: by 2002:a7b:cd99:: with SMTP id y25mr193369wmj.128.1604538057915;
 Wed, 04 Nov 2020 17:00:57 -0800 (PST)
MIME-Version: 1.0
References: <ddaef86e-3487-369d-5528-2e2f0e0e9ba4@rqc.ru>
In-Reply-To: <ddaef86e-3487-369d-5528-2e2f0e0e9ba4@rqc.ru>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 4 Nov 2020 20:00:41 -0500
Message-ID: <CAJCQCtRA94QCpi6hqNgxBapnGGz_APGgTegiWTM=50chdFRi9A@mail.gmail.com>
Subject: Re: Restore btrfs partition
To:     Alexey Isaev <a.isaev@rqc.ru>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 3, 2020 at 4:21 AM Alexey Isaev <a.isaev@rqc.ru> wrote:
>
> Hello!
>
> I have accidentally overwritten partition table on hdd with btfs
> filesystem. Is it possible to restore it?
> There was only one partition on disk with btrfs.

Yes, pretty straightforward. Main idea is to find the first super
block . From that you can figure out what that start LBA is for the
partition; and from reading the superblock you can get the device
size, and make the partition exactly that size.

This does assume that it's only the partition map that's been
overwritten and not some part of the file system itself. They are
completely separate things with no overlap, so if the assumption
holds, the file system is unharmed.



-- 
Chris Murphy
