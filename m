Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36506 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932711AbcJQUkX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 16:40:23 -0400
Received: by mail-oi0-f46.google.com with SMTP id m72so226950378oik.3
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 13:40:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
References: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 17 Oct 2016 14:40:21 -0600
Message-ID: <CAJCQCtR97w1PDsMRSg_RkfjCL1J+ZTA4xAhMVZz1T-1JWwGiwA@mail.gmail.com>
Subject: Re: Monitoring Btrfs
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

May be better to use /sys/fs/btrfs/<uuid>/devices to find the device
to monitor, and then monitor them with blktrace - maybe there's some
courser granularity available there, I'm not sure. The thing is, as
far as Btrfs alone is concerned, a drive can be "bad" and you're
effectively degraded, while the drive is not missing. Unless it's
physical removed or somehow dead, it'll still be seen but can produce
all kinds of mayhem.


Chris Murphy
