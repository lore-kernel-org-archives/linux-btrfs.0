Return-Path: <SRS0=psRn=TV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBEEC04AAF
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 May 2019 08:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F7DE20863
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 May 2019 08:56:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lTdLTv9g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfEUI4o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 21 May 2019 04:56:44 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:44859 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfEUI4n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 May 2019 04:56:43 -0400
Received: by mail-wr1-f52.google.com with SMTP id w13so6844973wru.11
        for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2019 01:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xSLeVATyZeKxzIPJI5s4Ygp4G1qEfpuN/TPytiRyXJQ=;
        b=lTdLTv9gc/xOdr36tP2z5tMPHxog+TWB2u/Z5oSXtM0jClAgQ4Bq+ab/s/mbWonUnQ
         96ykb8hcIeLMeczaJdEETW+WDoub2Xdn7QqGv+5xkoVwNoxhctR9b3E8GYW7xhstXosq
         KIsEcd6lZIpM7f74R4OIPM8Lx5jkzCNRc6Q+Xrj5/vklt6HW6mJ62led5Bk0kRZA7KXt
         w9ZmHhpDlYI7Wsydn56ucU1w62av601WCAXOe3f3CsmP2ubB2F8UQis7OdvhcZMnR6Ij
         IxyEk7t5yFgRFV2iUhzNOAHC+FYIjH6cNiYdIsYFG6cPH+rrFmR8t6+/9OKU5kRQYLuf
         612w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xSLeVATyZeKxzIPJI5s4Ygp4G1qEfpuN/TPytiRyXJQ=;
        b=daHzFTCwiADtapose5nIjg/CqlrevSyOk4444eGFRvY7FMg6d2crPCDzVnnqGM1MQv
         N1WMM2xgPhsw1zS+RFmYjc6GFJfADAy179sMvSXgF31KovjcCxdLydRkG8+im9zD6Ps4
         kLxw4bJgdGmxku3X+0pCtrWXDK04+e5kOZQj0fLkdCAEuJreLzUDEGutKUY4IoX5atGX
         BoH0t/kMajbytiCNL+2PNQqtwhaOykdPqobKn0b9qiGAgDkHw/0GM4DJitvGgxW8Mxih
         4VEAhCJZsgKaTfI5bY1OY7iOlfeD8AN0oCrb8C14+R+d8IME70rSm8bajn6efTrdMZp/
         4OsQ==
X-Gm-Message-State: APjAAAXz8/W9VgDChRFRV87I3F7Cd7yA26PNTrIMcsxandPnQnwjsrCw
        Vdz9907EQ1VW8N6xE2BRuSgYj0oyntvbqVg4doWyvQ==
X-Google-Smtp-Source: APXvYqxKrGcrcHbC8kJ2NDiKjDtoHQX0i4lNAN2kBbgsBjoq4otQiOIEgvAQ5al4HLE/r29ze7J/cYz7blfDjAaQQMU=
X-Received: by 2002:adf:c188:: with SMTP id x8mr39183345wre.256.1558429002239;
 Tue, 21 May 2019 01:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj6ewO7PGBoN565WYz_bqL6nGszweNouP-Fphok9+GGpGn8gg@mail.gmail.com>
In-Reply-To: <CAMj6ewO7PGBoN565WYz_bqL6nGszweNouP-Fphok9+GGpGn8gg@mail.gmail.com>
From:   Patrik Lundquist <patrik.lundquist@gmail.com>
Date:   Tue, 21 May 2019 10:56:30 +0200
Message-ID: <CAA7pwKPi5L9GT5t3CfhHa07TkLmdhpdM+7417kdLEbnkm7RSaw@mail.gmail.com>
Subject: Re: "bad tree block start" when trying to mount on ARM
To:     Erik Jensen <erikjensen@rkjnsn.net>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 21 May 2019 at 10:35, Erik Jensen <erikjensen@rkjnsn.net> wrote:
>
> I have a 5-drive btrfs filesystem. (raid-5 data, dup metadata).

I don't know about ARM but you should use raid1 for the metadata since
dup can place both copies on the same drive.
