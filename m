Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:51625 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbeHUUWB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 16:22:01 -0400
Received: by mail-it0-f65.google.com with SMTP id e14-v6so5114417itf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 10:01:05 -0700 (PDT)
Subject: =?UTF-8?Q?Re:_lazytime_mount_option=e2=80=94no_support_in_Btrfs?=
To: dsterba@suse.cz, "Janos Toth F." <toth.f.janos@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <ompef3$sim$1@blaine.gmane.org>
 <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
 <2641568.fxl50hTsRH@merkaba> <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
 <088684be-c1ff-c144-6ff7-e41670669c7e@gmail.com>
 <20180821120636.fatftem5qbhv22m4@angband.pl>
 <d959efa3-4e45-c471-625d-c4ad747083ad@gmail.com>
 <CANznX5EwH-DSNzFwCiUrLgxA8P_nrNQoVfPQDQ=v6jM2_dEHAw@mail.gmail.com>
 <774d8406-d8c8-f26b-b176-8ac954c59722@gmail.com>
 <20180821160547.GF24025@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <49b2ad81-256a-981e-cf6c-04e3bf32e932@gmail.com>
Date: Tue, 21 Aug 2018 13:01:00 -0400
MIME-Version: 1.0
In-Reply-To: <20180821160547.GF24025@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-21 12:05, David Sterba wrote:
> On Tue, Aug 21, 2018 at 10:10:04AM -0400, Austin S. Hemmelgarn wrote:
>> On 2018-08-21 09:32, Janos Toth F. wrote:
>>>>>> so pretty much everyone who wants to avoid the overhead from them can just
>>>>>> use the `noatime` mount option.
>>>
>>> It would be great if someone finally fixed this old bug then:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=61601
>>> Until then, it seems practically impossible to use both noatime (this
>>> can't be added as rootflag in the command line and won't apply if the
>>> kernel already mounted the root as RW) and space-cache-v2 (has to be
>>> added as a rootflag along with RW to take effect) for the root
>>> filesystem (at least without an init*fs, which I never use, so can't
>>> tell).
>>>
>> Last I knew, it was fixed.  Of course, it's been quite a while since I
>> last tried this, as I run locally patched kernels that have `noatime` as
>> the default instead of `relatime`.
> 
> I'm using VMs without initrd, tested the rootflags=noatime and it still
> fails, the same way as in the bugreport.
> 
> As the 'noatime' mount option is part of the mount(2) API (passed as a
> bit via mountflags), the remaining option in the filesystem is to
> whitelist the generic options and ignore them. But this brings some
> layering violation question.
> 
> On the other hand, this would be come confusing as the user expectation
> is to see the effects of 'noatime'.
> 
Ideally there would be a way to get this to actually work properly.  I 
think ext4 at least doesn't panic, though I'm not sure if it actually 
works correctly.

Otherwise, the only option for people who want it set is to patch the 
kernel to get noatime as the default (instead of relatime).  I would 
look at pushing such a patch upstream myself actually, if it weren't for 
the fact that I'm fairly certain that it would be immediately NACK'ed by 
at least Linus, and probably a couple of other people too.
