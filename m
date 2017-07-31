Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38153 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbdGaWAz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 18:00:55 -0400
Received: by mail-wm0-f49.google.com with SMTP id m85so2119906wma.1
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 15:00:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170731211750.bpo4roiqkr4t5iae@merlins.org>
References: <20170501170641.GG3516@merlins.org> <20170707163834.GA6083@merlins.org>
 <20170709043417.GE6704@merlins.org> <21425367.VGcO8ck7Vu@merkaba>
 <CAMG9ccyWS87NwUrJGNvF6Dt440yhCp_P9_-hFeJE70YDRwpfNg@mail.gmail.com> <20170731211750.bpo4roiqkr4t5iae@merlins.org>
From: Justin Maggard <jmaggard10@gmail.com>
Date: Mon, 31 Jul 2017 15:00:53 -0700
Message-ID: <CAKgsxVST3+DVxAoZ87JW0hLW56CakeHy8LUbLLs6Sp_X2UXOCg@mail.gmail.com>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more
 recent gen (33682) compared to the found root node (0)
To: Marc MERLIN <marc@merlins.org>
Cc: Ivan Sizov <sivan606@gmail.com>, Martin Steigerwald <martin@lichtvoll.de>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Duncan <1i5t5.duncan@cox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 31, 2017 at 2:17 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Tue, Aug 01, 2017 at 12:07:14AM +0300, Ivan Sizov wrote:
>> 2017-07-09 10:57 GMT+03:00 Martin Steigerwald <martin@lichtvoll.de>:
>> > Hello Marc.
>> >
>> > Marc MERLIN - 08.07.17, 21:34:
>> >> Sigh,
>> >>
>> >> This is now the 3rd filesystem I have (on 3 different machines) that is
>> >> getting corruption of some kind (on 4.11.6).
>> >
>> > Anyone else getting corruptions with 4.11?
>> Yes, a lot. There are at least 3 cases, probably I've missed something.
>> https://www.spinics.net/lists/linux-btrfs/msg67177.html
>> https://www.spinics.net/lists/linux-btrfs/msg67681.html
>> https://unix.stackexchange.com/questions/369133/dealing-with-btrfs-ref-backpointer-mismatches-backref-missing/369275
>
> Indeed. My main server is happy back on 4.9.36 and while my laptop is
> stuck on 4.11 due to other kernel issues that prevent me from going back
> to 4.9, it only corrupted a single filesystem so far, and no other ones
> that I've noticed yet.
> Hopefully that will hold :-/
>

Marc, do you have quotas enabled?  IIRC, you're a send/receive user.
The combination of quotas and btrfs receive can corrupt your
filesystem, as shown by the xfstest I sent to the list a little while
ago.

-Justin
