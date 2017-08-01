Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36738 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751784AbdHAQlt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 12:41:49 -0400
Received: by mail-wm0-f45.google.com with SMTP id t201so19948111wmt.1
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 09:41:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMG9ccx5zyYJTfGfT6RaRbNtipxHJS+mD3Z6Ux_zmp_aorJLuw@mail.gmail.com>
References: <20170501170641.GG3516@merlins.org> <20170707163834.GA6083@merlins.org>
 <20170709043417.GE6704@merlins.org> <21425367.VGcO8ck7Vu@merkaba>
 <CAMG9ccyWS87NwUrJGNvF6Dt440yhCp_P9_-hFeJE70YDRwpfNg@mail.gmail.com>
 <20170731211750.bpo4roiqkr4t5iae@merlins.org> <CAMG9ccx5zyYJTfGfT6RaRbNtipxHJS+mD3Z6Ux_zmp_aorJLuw@mail.gmail.com>
From: Ivan Sizov <sivan606@gmail.com>
Date: Tue, 1 Aug 2017 19:41:27 +0300
Message-ID: <CAMG9ccxLNtnvA9CMciBXf_sD80HMWzVU5-+_K=OhZ=GKwWJ6Tw@mail.gmail.com>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more
 recent gen (33682) compared to the found root node (0)
To: Marc MERLIN <marc@merlins.org>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Duncan <1i5t5.duncan@cox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-08-01 0:39 GMT+03:00 Ivan Sizov <sivan606@gmail.com>:
> 2017-08-01 0:17 GMT+03:00 Marc MERLIN <marc@merlins.org>:
>> On Tue, Aug 01, 2017 at 12:07:14AM +0300, Ivan Sizov wrote:
>>> 2017-07-09 10:57 GMT+03:00 Martin Steigerwald <martin@lichtvoll.de>:
>>> > Hello Marc.
>>> >
>>> > Marc MERLIN - 08.07.17, 21:34:
>>> >> Sigh,
>>> >>
>>> >> This is now the 3rd filesystem I have (on 3 different machines) that is
>>> >> getting corruption of some kind (on 4.11.6).
>>> >
>>> > Anyone else getting corruptions with 4.11?
>>> Yes, a lot. There are at least 3 cases, probably I've missed something.
>>> https://www.spinics.net/lists/linux-btrfs/msg67177.html
>>> https://www.spinics.net/lists/linux-btrfs/msg67681.html
>>> https://unix.stackexchange.com/questions/369133/dealing-with-btrfs-ref-backpointer-mismatches-backref-missing/369275
>>
>> Indeed. My main server is happy back on 4.9.36 and while my laptop is
>> stuck on 4.11 due to other kernel issues that prevent me from going back
>> to 4.9, it only corrupted a single filesystem so far, and no other ones
>> that I've noticed yet.
>> Hopefully that will hold :-/
>>
>> Marc
>> --
>> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>> Microsoft is to operating systems ....
>>                                       .... what McDonalds is to gourmet cooking
>> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
>
> I want to try mounting and checking FS under Live images with
> different kernels tomorrow. Today's Fedora Rawhide image seems to be
> built incorrectly. Can you advice me where to get a fresh live image
> with 4.12 kernel (it's not important which distro that will be)?
>
> --
> Ivan Sizov
Mounting problem persists:
on 4.13.0 with btrfs-progs v4.11.1 (latest Fedora Rawhide Live)
on 4.10.0 with btrfs-progs v4.9.1 (Ubuntu 17.04 Live)
on 4.9.0 with btrfs-progs v 4.7.3 (Debian 9 Stretch Live)
"btrfs check --readonly" also gives the same output on 4.11, 4.10 and 4.9.

Marc, how did you roll back and fix those errors?

-- 
Ivan Sizov
