Return-Path: <SRS0=ihwP=S6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C3DC43218
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 14:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3776B206A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 14:56:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=purdea.ro header.i=@purdea.ro header.b="NEUUPV1f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfD1O44 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Apr 2019 10:56:56 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43801 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfD1O44 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Apr 2019 10:56:56 -0400
Received: by mail-wr1-f51.google.com with SMTP id a12so11885302wrq.10
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Apr 2019 07:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purdea.ro; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=3C2kUCYXNG5sn32IDp24aK8GmglGMRfhNaPs8aHh1Co=;
        b=NEUUPV1f1PGS4N27YNZ2kaxEWImDYS5v+4bZ8BEJt6sT3Us59iVoqk7SCVhvedNd19
         L7URomNJZeB2IIMy25aS+JHPhkmyvrKqG8IFxbLvW6//jlecZHu43N6UEYgYXta6dXpQ
         qMmEzDlr4lXksnOY52JN6dmW4ghoOtZ9G6iSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=3C2kUCYXNG5sn32IDp24aK8GmglGMRfhNaPs8aHh1Co=;
        b=b+ttr/rSYr1JYGQEk278uOE/s1GBRKFZXNvTZjSgutD1sl5JsEm26DPARTQfZJ5QQr
         L8HM8/nVQ1L32vo9+0Uvt+j5zQZ6TTEIibE9/h/TuweD7Som69q74mreqVYe7QJsXrEO
         iiStMZx1wQa3eVacRXGWF+4wT9CZ5Hejms1VkxsyzIhefTVLjRfu6T8O36kg2TqucfPk
         tm1k3l1VsKV2QesCoRf912EmGbcwV4Y8JunW9tLNiHhhQyeOijPObBQ7wxGRhBatoQEt
         WGDbt6oCGED8DF+3Ba6P70ls7WkguVKl+/Upo7yUStjEwnTMwppkab/kAMvh9DwroKQ7
         jCOQ==
X-Gm-Message-State: APjAAAV5mAM0e0tVtaCEYCCFNaH2/HVbw1avVOzq0RmeN3LsQeWGxRmN
        T0RzgSdb/U61R8aICj0R/J3Cs5yeBpRcbU0np4qXStCrsg==
X-Google-Smtp-Source: APXvYqxTPDz+y08zDRa7CsPk3sZ+2IX+g74fDNzeKSPzsMmdOWD25SdEGetnuhKQWGWWtTNDxCWQWIbu0XyPgkBmJ90=
X-Received: by 2002:adf:ec0d:: with SMTP id x13mr10218489wrn.268.1556463414143;
 Sun, 28 Apr 2019 07:56:54 -0700 (PDT)
MIME-Version: 1.0
References: <CA+mMEgfz_t__SRCxi2jHbsbGU+MMHb=ti9N43StHjfv7j4btFQ@mail.gmail.com>
In-Reply-To: <CA+mMEgfz_t__SRCxi2jHbsbGU+MMHb=ti9N43StHjfv7j4btFQ@mail.gmail.com>
From:   Andrei Purdea <andrei@purdea.ro>
Date:   Sun, 28 Apr 2019 17:56:43 +0300
Message-ID: <CA+mMEgeVVFLPHDh_2hr=G9jDjjou+HOTy5VFGaxyGdrif7q8EQ@mail.gmail.com>
Subject: Re: Corruption of newly created files after degraded mount of a raid1 filesystem
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> [/dev/sda2].write_io_errs 161
> [/dev/sda2].read_io_errs 0
> [/dev/sda2].flush_io_errs 0
> [/dev/sda2].corruption_errs 1863
> [/dev/sda2].generation_errs 0
> [/dev/sdb2].write_io_errs 2230
> [/dev/sdb2].read_io_errs 51
> [/dev/sdb2].flush_io_errs 0
> [/dev/sdb2].corruption_errs 37
> [/dev/sdb2].generation_errs 0

I just found some of my older notes. These numbers have not increased
since 2017.
I think they were caused by a bad sata cable when I first built the machine.

Thanks,
Andrei
