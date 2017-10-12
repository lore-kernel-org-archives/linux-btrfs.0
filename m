Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:52368 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755002AbdJLRTY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 13:19:24 -0400
Received: by mail-oi0-f44.google.com with SMTP id c202so9446934oih.9
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 10:19:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1507775222.470249.1135998984.4D5929F4@webmail.messagingengine.com>
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <87o9pf7o3g.wl-satoru.takeuchi@gmail.com> <1507695493.605704.1134784560.530EF386@webmail.messagingengine.com>
 <1507775222.470249.1135998984.4D5929F4@webmail.messagingengine.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 12 Oct 2017 18:19:22 +0100
Message-ID: <CAJCQCtQ8EW9E2uNc=wBY_PsTZKRRfEmQXPcfZMiioaYzpms0uw@mail.gmail.com>
Subject: Re: USB upgrade fun
To: Kai Hendry <hendry@iki.fi>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 12, 2017 at 3:27 AM, Kai Hendry <hendry@iki.fi> wrote:
> A guy on #btrsfs suggests:
>
> 15:09 <multicore> hendry: super_total_bytes 8001581707264 mismatch with
> fs_devices total_rw_bytes 8001581710848 that one is because unaligned
> partitions, 4.12 - 4.13 kernels are affected (at least some versions)
>
>
> However I rebooted into 4.9.54-1-lts and I have the same issue.
> super_total_bytes 8001581707264 mismatch with fs_devices total_rw_bytes
> 8001581710848
>
> https://s.natalian.org/2017-10-12/1507775104_2548x1398.png
>
> Any ideas what I can do now? I am getting rather nervous!
>
> Btw I checked sudo btrfs check -p /dev/sd{b,c,d}1 and they are all fine.
>
> Just can't mount my data! :(

I should have read the whole thread. Sad.

OK this is a new problem I haven't heard of before. So maybe yet
another regression. *sigh*

What do you get for

btrfs insp dump-s -f <anydev>
btrfs-debug-tree -t 3 <anydev>


-- 
Chris Murphy
