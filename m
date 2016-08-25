Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:36256 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755279AbcHYG3P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 02:29:15 -0400
Received: by mail-ua0-f174.google.com with SMTP id m60so27828863uam.3
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Aug 2016 23:29:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC8ULPbST1tMtfW8MBdEXiFSxknQtUHYneZu8FpQij5DRon_gg@mail.gmail.com>
References: <CAC8ULPbST1tMtfW8MBdEXiFSxknQtUHYneZu8FpQij5DRon_gg@mail.gmail.com>
From: Robert Munteanu <robert.munteanu@gmail.com>
Date: Thu, 25 Aug 2016 09:29:14 +0300
Message-ID: <CAC8ULPaFE1oNRGnjGDhLHgtVf+HZ=+omAGoQr_GmmUSUAqB08Q@mail.gmail.com>
Subject: Re: btrfs partition fails to mount - kernel BUG at ../fs/btrfs/extent-tree.c:1872
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Replying to myself as I'm not subscribed and can't reply to Duncan's message)

Hi Duncan,

Good catch, mounting with -o skip_balance does allow me to mount the
disk properly.

Scrubbing the partition once mounted results in 0 errors.

I'm still going to keep this untouched for further investigation.

Thanks,

Robert


-- 
http://robert.muntea.nu/
