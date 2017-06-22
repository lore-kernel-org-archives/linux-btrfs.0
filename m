Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:35232 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdFVMCr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 08:02:47 -0400
Received: by mail-ua0-f172.google.com with SMTP id j53so14494714uaa.2
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Jun 2017 05:02:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANT5p=p_EXUL=zWPqym8BygcQZpFgJk0kK9+zKdE1zgMkJccGQ@mail.gmail.com>
References: <CANT5p=p_EXUL=zWPqym8BygcQZpFgJk0kK9+zKdE1zgMkJccGQ@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Thu, 22 Jun 2017 17:32:06 +0530
Message-ID: <CAKuJGC9JcA=xdXpbizOZexqMmsUDZO_GDe-mKTnPx-YGJrQzWQ@mail.gmail.com>
Subject: Re: Stability status of btrfs-convert...
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>Is this tool supported, at least? Can I use this tool as a part of
>software upgrade to change the data filesystem to btrfs?

Yes its supported. If your existing FS is too large (>22TB) we have a bug for it
https://bugzilla.kernel.org/show_bug.cgi?id=194795

AFAIK, there are quite number of people converted their EXT4 to BTRFS .
IMO, btrfs-convert is fairly stable, especially if you have only GB's of data
----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org
