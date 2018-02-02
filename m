Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:34731 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753782AbeBBCJv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Feb 2018 21:09:51 -0500
Received: by mail-ot0-f176.google.com with SMTP id x15so18887924ote.1
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Feb 2018 18:09:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a95b4757-c63a-3566-e6ed-9065240a6f1d@gmx.com>
References: <CALvFGyCYKs_MMB5st-nm463_UBcA859iBDHX8xjRX8eCME7Ytw@mail.gmail.com>
 <a95b4757-c63a-3566-e6ed-9065240a6f1d@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 1 Feb 2018 19:09:49 -0700
Message-ID: <CAJCQCtSd=1XDD6gui_D9ufsux=eFyFccKVSXQQhJQ_QauBWwbg@mail.gmail.com>
Subject: Re: btrfs - kernel warning
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Patrik Ostrihon <patrik.ostrihon@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 1, 2018 at 6:40 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> Fortunately btrfs-progs provides offline tool to fix it.
> You could use "btrfs rescue fix-device-size <device>" to easily fix it.
> And since it's an offline tool, you need to umount your fs first.
>

This feature first appears in btrfs-progs v4.14.



-- 
Chris Murphy
