Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:40827 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdLLGuC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 01:50:02 -0500
Received: by mail-ot0-f169.google.com with SMTP id e74so16961100ote.7
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Dec 2017 22:50:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABB28CxbiCTVOUYKbUv7-O-0bAAweSJF--7OnJtNAnud6TipwQ@mail.gmail.com>
References: <CABB28CxbiCTVOUYKbUv7-O-0bAAweSJF--7OnJtNAnud6TipwQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 11 Dec 2017 23:50:00 -0700
Message-ID: <CAJCQCtTd2y8vs5WYwgLKGZJfRr4-G0RGh+1OEanq_u00+zL-TQ@mail.gmail.com>
Subject: Re: 4.15.0-0.rc2.git2.1.fc28.x86_64: possible circular locking
 dependency detected
To: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 11, 2017 at 10:12 PM, Tomasz Kłoczko
<kloczko.tomasz@gmail.com> wrote:
> Hi,
>
> Jut done upgrade on my laptop to the latest Fedora rawhide packages.
> After reboot and login in dmesg I found logged btrfs issue:
>
> [   94.192907] ======================================================
> [   94.192911] WARNING: possible circular locking dependency detected
> [   94.192917] 4.15.0-0.rc2.git2.1.fc28.x86_64 #1 Not tainted

I'm not seeing it so far with 4.15.0-0.rc3.git0.1.fc28.x86_64+debug.



-- 
Chris Murphy
