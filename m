Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35965 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751660AbdGaVHg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 17:07:36 -0400
Received: by mail-wm0-f47.google.com with SMTP id t201so1279594wmt.1
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 14:07:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21425367.VGcO8ck7Vu@merkaba>
References: <20170501170641.GG3516@merlins.org> <20170707163834.GA6083@merlins.org>
 <20170709043417.GE6704@merlins.org> <21425367.VGcO8ck7Vu@merkaba>
From: Ivan Sizov <sivan606@gmail.com>
Date: Tue, 1 Aug 2017 00:07:14 +0300
Message-ID: <CAMG9ccyWS87NwUrJGNvF6Dt440yhCp_P9_-hFeJE70YDRwpfNg@mail.gmail.com>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more
 recent gen (33682) compared to the found root node (0)
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Marc MERLIN <marc@merlins.org>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Duncan <1i5t5.duncan@cox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-07-09 10:57 GMT+03:00 Martin Steigerwald <martin@lichtvoll.de>:
> Hello Marc.
>
> Marc MERLIN - 08.07.17, 21:34:
>> Sigh,
>>
>> This is now the 3rd filesystem I have (on 3 different machines) that is
>> getting corruption of some kind (on 4.11.6).
>
> Anyone else getting corruptions with 4.11?
Yes, a lot. There are at least 3 cases, probably I've missed something.
https://www.spinics.net/lists/linux-btrfs/msg67177.html
https://www.spinics.net/lists/linux-btrfs/msg67681.html
https://unix.stackexchange.com/questions/369133/dealing-with-btrfs-ref-backpointer-mismatches-backref-missing/369275

If an additional debug info is needed, I'm ready to provide it.

-- 
Ivan Sizov
