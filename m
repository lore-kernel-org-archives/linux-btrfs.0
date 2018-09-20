Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:52755 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731240AbeITMCh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 08:02:37 -0400
Received: by mail-it0-f41.google.com with SMTP id h3-v6so11673457ita.2
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 23:20:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53806b04-c239-cb23-1d8a-e84d7453950a@gmx.com>
References: <CAOc3t=v+ZTN7wZRSZO0afx5BVJYzrorD3HWoWkeJyUoUZ2KoTg@mail.gmail.com>
 <53806b04-c239-cb23-1d8a-e84d7453950a@gmx.com>
From: "Zbigniew 'zibi' Jarosik" <zibi@nora.pl>
Date: Thu, 20 Sep 2018 08:20:49 +0200
Message-ID: <CAOc3t=ssEVxn5Z-WN2fFRuEde=UeGNZEFUz+yawn6O-6D3t7oA@mail.gmail.com>
Subject: Re: cannot mount btrfs as root
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19 September 2018 at 15:54, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
> Does the iniramfs do a "btrfs dev scan" to make populate btrfs devices
> lists?

This solved problem. Looks like btrfs scans disks to early, before
bcache initializes. I need to debug initrfamfs scripts.

Thanks a lot for hint!


-- 
Zbigniew 'zibi' Jarosik
cell: +48 667956686
jid: tapiau@gmail.com
gg: 2830
http://zibi.nora.pl/
