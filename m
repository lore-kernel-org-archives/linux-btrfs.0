Return-Path: <SRS0=M5eb=BV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEEAC433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Aug 2020 21:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0471F20756
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Aug 2020 21:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgHKVkQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 17:40:16 -0400
Received: from www5.web-server.biz ([185.181.105.105]:46617 "EHLO
        mail5.web-server.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgHKVkQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Aug 2020 17:40:16 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Aug 2020 17:40:15 EDT
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail5.web-server.biz (Postfix) with ESMTPSA id 7E72D47C7D
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2020 21:30:45 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id b16so427568ioj.4
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2020 14:30:45 -0700 (PDT)
X-Gm-Message-State: AOAM5315cf3CYOATDgWH1j+YtcTorELWD+wF6NmE1GMionmXap5R7gf4
        tWG6rTemBzf2WFZHk49SmP1WUFI2e+clLDChAYY=
X-Google-Smtp-Source: ABdhPJw1ttKibhzJlAnfgt5kVkXFYZtpiDGJ711cVyFo2sPoQ/Pz2kTYg9b886d6G1lyHOB97Doy+OXsWgY4/xKhSQw=
X-Received: by 2002:a6b:b2cb:: with SMTP id b194mr25120316iof.105.1597181443858;
 Tue, 11 Aug 2020 14:30:43 -0700 (PDT)
MIME-Version: 1.0
References: <c684e9ac-f28b-7056-0a46-6c6450ac4c1f@gmail.com>
 <8a3370fd-7cda-78d2-b036-8350c5a3e964@gmx.com> <feffe90f-de6b-0f53-c54d-0df135c49868@gmail.com>
 <10ac3036-52cc-3963-d55e-b8352388e1f6@gmail.com>
In-Reply-To: <10ac3036-52cc-3963-d55e-b8352388e1f6@gmail.com>
From:   Lukas Tribus <lukas@ltri.eu>
Date:   Tue, 11 Aug 2020 23:30:31 +0200
X-Gmail-Original-Message-ID: <CACC_My_qwyrVPDnaXoF7fKoXc3eDdjAtp7SKBw5wF4MrsRYJZA@mail.gmail.com>
Message-ID: <CACC_My_qwyrVPDnaXoF7fKoXc3eDdjAtp7SKBw5wF4MrsRYJZA@mail.gmail.com>
Subject: Re: system hangs when running btrfs balance
To:     Johannes Rohr <jorohr@gmail.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 11 Aug 2020 at 18:43, Johannes Rohr <jorohr@gmail.com> wrote:
>
> Dear Qu, dear all,
>
> hat the fix also been backported to the 5.6 kernel series? If so, from
> which version on?

No, 5.6 is EOL.

http://lkml.iu.edu/hypermail/linux/kernel/2006.2/02484.html


Lukas
