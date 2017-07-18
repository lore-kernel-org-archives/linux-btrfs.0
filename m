Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33505 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751424AbdGRS5n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 14:57:43 -0400
Received: by mail-lf0-f53.google.com with SMTP id z78so21256265lff.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 11:57:42 -0700 (PDT)
Subject: Re: bind mounts on btrfs cause mountinfo confusion
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAJCQCtT=-YoFJgEo=BFqfiPdtMoJCYR3dJPSekf+HQ22GYGztw@mail.gmail.com>
 <pan$78a03$5a3730b6$f093b5e5$da803183@cox.net>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <c367de04-a154-41c1-fc74-79cad1e2fc90@gmail.com>
Date: Tue, 18 Jul 2017 21:57:40 +0300
MIME-Version: 1.0
In-Reply-To: <pan$78a03$5a3730b6$f093b5e5$da803183@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

18.07.2017 10:24, Duncan пишет:
> 
> Before the kernel started printing that subvol= stuff, this information 
> was missing, as it still is for non-btrfs.
> 

Huh?

tail -1 /proc/self/mountinfo

215 25 8:4 /tmp/from /tmp/to rw,relatime shared:1 - ext4 /dev/sda4
rw,errors=remount-ro,data=ordered

You just need to look in the right place ...
