Return-Path: <SRS0=Vihw=2F=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61410C43603
	for <linux-btrfs@archiver.kernel.org>; Sun, 15 Dec 2019 12:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E0C2054F
	for <linux-btrfs@archiver.kernel.org>; Sun, 15 Dec 2019 12:20:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rGuorTMc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfLOMU4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 15 Dec 2019 07:20:56 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:35542 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfLOMUz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Dec 2019 07:20:55 -0500
Received: by mail-ot1-f44.google.com with SMTP id o9so5254519ote.2
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Dec 2019 04:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I2IreTQ93dL5ePJ58xne5SlIrHlddgsBPfpXJi8+oag=;
        b=rGuorTMcyK1XCxKltons+4V3qgramX04z6SMcSEp03caMfgF2GzsFBqGYOZ8PkXvGo
         Q4Z0a+ae++wSi4WD3q5yeXTNvR5l1vZkADUkRW1M597bsLBbMlyJBV3oS8gmpY51KvgT
         eoXehYJNToOaOrxnH7mdFR2I8ekpehd5je6hDd7FYC3qQEQpPahe+MQJ8pez5cMLzBUl
         eTjL508SO05/s7thNfaQSZZ2F+maejq2c2H4sjp0bpNDZBP0qKj45+ONbeZjZW+z7ujv
         lpVADhJ6TTAJMY3RsMZ7TVR74rYm8ybbuj/LLsMg8eP3kn2ZYa3+nTgtDs3jyM4MBWlb
         sk3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I2IreTQ93dL5ePJ58xne5SlIrHlddgsBPfpXJi8+oag=;
        b=AySz4FcIry+tqMvjuILxv5sGWacBRIknN3gLrdtE4vLShlfdXKkYegbpZPECZSl4/S
         0LxmB/Nl52njjtZn2ALMxzBibksIFLpwe85M4g/QixGFEpC1aXbSj5vyYkScrcnLdYuP
         1s3FyDQaBkx3+TgF6Lb1t90guL9rRdKYWv+bdAleiCY0fUgxOvuZeR26AN7WKUzuLlAd
         ilgSeUb3/HOcne+JWjNoNHniJL43bXr75wRPVTkbWy9FGSEPLIT928iOumb6xJnOrQKZ
         rfwanN48oYrsXqR2C41GktKN94gZQWnc8OJVM+whFOjjNw/MjmoSCx9N9s4RI7LBQROT
         VylA==
X-Gm-Message-State: APjAAAWx46gYIEZfTWOiW+RV550YSUOCCk6oBVt/CpqiEyfJjkc2j2vY
        AjFRIN2om7dAYKhqXDi1yN1EitX4duW5WY/NA0Y8AuxNDoQ=
X-Google-Smtp-Source: APXvYqylFb959LXkQrJOwiCpd2QnaE8Qyp9siBQ2P3HYiC0zLhUlIfgp7KI25Np+vatOWixAaOsQtF42LUgY5LR6cyg=
X-Received: by 2002:a9d:588c:: with SMTP id x12mr25245625otg.2.1576412454862;
 Sun, 15 Dec 2019 04:20:54 -0800 (PST)
MIME-Version: 1.0
References: <CAHzMYBTXvY1VgcoFDUvc2NFmVKq2HJRHuS0VXzoneUMh79cySA@mail.gmail.com>
 <2b0e5191-740f-0530-4825-0b0b6b653efb@gmx.com>
In-Reply-To: <2b0e5191-740f-0530-4825-0b0b6b653efb@gmx.com>
From:   Jorge Bastos <jorge.mrbastos@gmail.com>
Date:   Sun, 15 Dec 2019 12:20:44 +0000
Message-ID: <CAHzMYBSPr0e_+AQgY1J97QxNo_P_cWwWuGpj3TTT=iNv2FTfyw@mail.gmail.com>
Subject: Re: RAID5 scrub performance
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

One last data point on this from a larger pool, 11 disk raid5 pool
(raid1 metadata), this is probably not a very recommended
configuration but it's a 3rd backup and mostly for testing raid5 on a
larger pool:

UUID:             1236acc8-dbd5-41bd-bf3d-872a8fbbce49
Scrub started:    Sun Dec 15 11:23:45 2019
Status:           running
Duration:         0:51:34
Time left:        90:06:52
ETA:              Thu Dec 19 06:22:13 2019
Total to scrub:   18.10TiB
Bytes scrubbed:   175.12GiB
Rate:             57.96MiB/s
Error summary:    no errors found



Same pool during a btrfs send to /dev/null:

btrfs send /mnt/disks/Pics/T12_disk1_Pics_2019-12-15-0829/ | pv -bart
> /dev/null
At subvol /mnt/disks/Pics/T12_disk1_Pics_2019-12-15-0829/
 447GiB 0:13:19 [ 635MiB/s] [ 573MiB/s]
                                   ^                 ^
                             cur. spd   /    avg. spd



So looks to me like scrub performance is around 1/10 of what it should
be, and not optimal to wait multiple days to scrub a larger pool.

Jorge
