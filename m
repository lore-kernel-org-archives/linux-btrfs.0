Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36220 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbeHURa1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 13:30:27 -0400
Received: by mail-it0-f66.google.com with SMTP id p81-v6so4244752itp.1
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 07:10:08 -0700 (PDT)
Subject: =?UTF-8?Q?Re:_lazytime_mount_option=e2=80=94no_support_in_Btrfs?=
To: "Janos Toth F." <toth.f.janos@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <ompef3$sim$1@blaine.gmane.org>
 <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
 <2641568.fxl50hTsRH@merkaba> <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
 <088684be-c1ff-c144-6ff7-e41670669c7e@gmail.com>
 <20180821120636.fatftem5qbhv22m4@angband.pl>
 <d959efa3-4e45-c471-625d-c4ad747083ad@gmail.com>
 <CANznX5EwH-DSNzFwCiUrLgxA8P_nrNQoVfPQDQ=v6jM2_dEHAw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <774d8406-d8c8-f26b-b176-8ac954c59722@gmail.com>
Date: Tue, 21 Aug 2018 10:10:04 -0400
MIME-Version: 1.0
In-Reply-To: <CANznX5EwH-DSNzFwCiUrLgxA8P_nrNQoVfPQDQ=v6jM2_dEHAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-21 09:32, Janos Toth F. wrote:
>>>> so pretty much everyone who wants to avoid the overhead from them can just
>>>> use the `noatime` mount option.
> 
> It would be great if someone finally fixed this old bug then:
> https://bugzilla.kernel.org/show_bug.cgi?id=61601
> Until then, it seems practically impossible to use both noatime (this
> can't be added as rootflag in the command line and won't apply if the
> kernel already mounted the root as RW) and space-cache-v2 (has to be
> added as a rootflag along with RW to take effect) for the root
> filesystem (at least without an init*fs, which I never use, so can't
> tell).
> 
Last I knew, it was fixed.  Of course, it's been quite a while since I 
last tried this, as I run locally patched kernels that have `noatime` as 
the default instead of `relatime`.

Also, once you've got the space cache set up by mounting once writable 
with the appropriate flag and then waiting for it to initialize, you 
should not ever need to specify the `space_cache` option again.
