Return-Path: <SRS0=35yg=BE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10D8C433E0
	for <linux-btrfs@archiver.kernel.org>; Sat, 25 Jul 2020 10:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B71020656
	for <linux-btrfs@archiver.kernel.org>; Sat, 25 Jul 2020 10:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SPuAMiGk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgGYKEe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 25 Jul 2020 06:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgGYKEe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Jul 2020 06:04:34 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB49CC0619D3
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2020 03:04:33 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id a21so8847012otq.8
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2020 03:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZtZwq7wRBz6f04apIR/UJILGX7V51nNfL7c6rI+quzs=;
        b=SPuAMiGkMSE8rN6Dp6j0EM82UlSDmeJgjNGsdJLiUd1H9cK8E5ak7H3KMVPS60L2lv
         ruIfATremZlLL2RmtRLijGagi9tGxxpva/2nOVsLYYOmV6rMAF9h2khEZ79Gl2YX4/AE
         nX/ALkQBMLcq6XyW7o0nkNcDWhqnStLxo31W9jc4qyglB4YV5zHDoigHzoMWonEK8hQ2
         WkNrG/ufF4PJzdHrsVa2GnOsXgTPH2KLu3Nqm6hYfgpWuaaaFUG4nAHk2LGky22pudpV
         Dycm8M445OiVt3ddeXka6vMwZVYaVDe+Ww5S5fM9JVFbb2K1XXRkzQRj9cgqnJmaYH5l
         Zc3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZtZwq7wRBz6f04apIR/UJILGX7V51nNfL7c6rI+quzs=;
        b=j2kCg1+qtXJtZE59Ef2uaCjed54QD1xZkwc8BpXXjvsd7dcVuAUtj329GhN8+rpGaA
         5pEVD5juBk7nOSB8Jfe7+bqUAwwu0sOn7n+Z0nVknDtlMmsE0phPyYVURwL63okON3hu
         Oo7mqrzPqGda1eCbkZBT0FJrGmxQLOzluJDNrfvj/IkS4GuEhtpmZUJeQnydEWDZ6omp
         CvbgFsXwvqf3AYYJ25mm5gCx5PjzkDKGhxUBg9wFot6uDtbvwLdSC8W90rof6xjnXSmW
         q/RKoqFwxy9EzBHqe0+/HvVaa4jQQVa8whhXPY0gLaqMZlROTn2TufPVYBV90uwMxy1x
         9Xww==
X-Gm-Message-State: AOAM5323Y45nAXPfOaWnFpozpI+tgirpmGjJMfbMMccVrdhOK03zLosG
        zaKWPDN0V44FM5zDUBvRIPq2F5Dv4zMwNKo3UDPRe/DuOLA=
X-Google-Smtp-Source: ABdhPJyzE5TYJQYVGGQPKFgGg/Qyq/9IgEiFsera/i7v5xgg3Th6Bt2nVoaupJYlsLhIs3+xL6heidBjEgA8acAz0EE=
X-Received: by 2002:a9d:4801:: with SMTP id c1mr12098916otf.10.1595671472020;
 Sat, 25 Jul 2020 03:04:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAHzMYBTU=JuEsRX7YXzMJMELy63TXrm3J6onKnhGSOOzTnnMBg@mail.gmail.com>
 <CAJCQCtS6eS7a+wHR__A_aDujANWNJEmUMApjChVMk1WNuZ0BKg@mail.gmail.com>
 <CAHzMYBT8a9D817i2TRqdRiJFdmF-c3WVyo6HNgbv8bJqqOyr5g@mail.gmail.com>
 <CAJCQCtSeAKD_bVk7GUVyLdzdSZqR8O9zEX40kCmyR--DyWtSRw@mail.gmail.com>
 <dd11313f-3b9c-c743-257c-71ba1da4dde0@gmail.com> <446adc05-b03b-488a-c8a3-6c31cabdb3d0@gmail.com>
In-Reply-To: <446adc05-b03b-488a-c8a3-6c31cabdb3d0@gmail.com>
From:   Jorge Bastos <jorge.mrbastos@gmail.com>
Date:   Sat, 25 Jul 2020 11:04:21 +0100
Message-ID: <CAHzMYBTUx5Xp9HVhB5r-eQRrL=8fdQwKY=awfGTCxqczCHSsHA@mail.gmail.com>
Subject: Re: df free space not correct with raid1 pools with an odd number of devices
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Jul 25, 2020 at 8:43 AM Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>

>
> OTOH, this is the correct if the most pessimistic estimation either. If
> you have three 250G RAID1 devices and you allocate 250G data in one file
> you consume two full devices and won't be able to allocate new data at
> all (or for that matter no new metadata either).
>
>
> So whatever value btrfs returns will be wrong for some allocation pattern.

I considered that but wouldn't a single file still be stripped and
blocks allocated to all devices, on a most free space basis?

E.g.: 3 x 500GB RAID1 pool:

$ btrfs fi usage -T /mnt/cache
Overall:
    Device size:                   1.36TiB
    Device allocated:              2.13GiB
    Device unallocated:            1.36TiB
    Device missing:                  0.00B
    Used:                        288.00KiB
    Free (estimated):            697.61GiB      (min: 697.61GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:                3.25MiB      (used: 32.00KiB)
    Multiple profiles:                  no

             Data     Metadata  System
Id Path      RAID1    RAID1     RAID1    Unallocated
-- --------- -------- --------- -------- -----------
 1 /dev/sdb1 36.00MiB         - 32.00MiB   465.69GiB
 2 /dev/sde1 36.00MiB   1.00GiB 32.00MiB   464.69GiB
 3 /dev/sdf1        -   1.00GiB        -   464.76GiB
-- --------- -------- --------- -------- -----------
   Total     36.00MiB   1.00GiB 32.00MiB     1.36TiB
   Used         0.00B 128.00KiB 16.00KiB



$ fallocate -l 690G /mnt/cache/file
$ btrfs fi usage -T /mnt/cache
Overall:
    Device size:                   1.36TiB
    Device allocated:              1.35TiB
    Device unallocated:           13.15GiB
    Device missing:                  0.00B
    Used:                          1.35TiB
    Free (estimated):              7.61GiB      (min: 7.61GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:                3.25MiB      (used: 0.00B)
    Multiple profiles:                  no

             Data      Metadata  System
Id Path      RAID1     RAID1     RAID1     Unallocated
-- --------- --------- --------- --------- -----------
 1 /dev/sdb1 461.04GiB         -  32.00MiB     4.69GiB
 2 /dev/sde1 460.04GiB   1.00GiB  32.00MiB     4.69GiB
 3 /dev/sdf1 461.00GiB   1.00GiB         -     3.76GiB
-- --------- --------- --------- --------- -----------
   Total     691.04GiB   1.00GiB  32.00MiB    13.15GiB
   Used      690.00GiB 976.00KiB 112.00KiB

Jorge
