Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:45142 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752290AbdIRI3B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 04:29:01 -0400
Received: by mail-qt0-f172.google.com with SMTP id t46so6756037qtj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 01:29:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org> <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Mon, 18 Sep 2017 11:29:00 +0300
Message-ID: <CAA91j0W5YNU-StfRY_M4YUC=aLY-W+VEZ+wP2XciiHmDB1q7gQ@mail.gmail.com>
Subject: Re: how to run balance successfully (No space left on device)?
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 18, 2017 at 11:20 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>>> # df -h /var/lib/lxd
>>>
>>> FWIW, standard (aka util-linux) df is effectively useless in a situation
>>> such as this, as it really doesn't give you the information you need (it
>>> can say you have lots of space available, but if btrfs has all of it
>>> allocated into chunks, even if the chunks have space in them still, there
>>> can be problems).
>
>
> I see here on RAID-1, "df -h" it shows pretty much the same amount of free
> space as "btrfs fi show":
>
> - "df -h" shows 105G free
> - "btrfs fi show" says: Free (estimated):            104.28GiB      (min:
> 104.28GiB)
>

I think both use the same algorithm to compute free space (df at the
end just shows what kernel returns). The problem is that this
algorithm itself is just approximation in general case. For uniform
RAID1 profile it should be correct though.
