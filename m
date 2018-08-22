Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:40818 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbeHVUZd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 16:25:33 -0400
Received: by mail-it0-f68.google.com with SMTP id h23-v6so3828952ita.5
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Aug 2018 09:59:53 -0700 (PDT)
Subject: =?UTF-8?Q?Re:_lazytime_mount_option=e2=80=94no_support_in_Btrfs?=
To: dsterba@suse.cz, "Janos Toth F." <toth.f.janos@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <E6FB1ABD-4C84-422B-BD9D-E46D96D03155@gmail.com>
 <088684be-c1ff-c144-6ff7-e41670669c7e@gmail.com>
 <20180821120636.fatftem5qbhv22m4@angband.pl>
 <d959efa3-4e45-c471-625d-c4ad747083ad@gmail.com>
 <CANznX5EwH-DSNzFwCiUrLgxA8P_nrNQoVfPQDQ=v6jM2_dEHAw@mail.gmail.com>
 <774d8406-d8c8-f26b-b176-8ac954c59722@gmail.com>
 <20180821160547.GF24025@twin.jikos.cz>
 <49b2ad81-256a-981e-cf6c-04e3bf32e932@gmail.com>
 <20180822134851.GH24025@twin.jikos.cz>
 <742cf725-e691-530a-d8a8-ea45b08d0450@gmail.com>
 <20180822150157.GI24025@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a3520a30-1f76-d7bf-d97a-a9c9354ffef5@gmail.com>
Date: Wed, 22 Aug 2018 12:59:47 -0400
MIME-Version: 1.0
In-Reply-To: <20180822150157.GI24025@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-22 11:01, David Sterba wrote:
> On Wed, Aug 22, 2018 at 09:56:59AM -0400, Austin S. Hemmelgarn wrote:
>> On 2018-08-22 09:48, David Sterba wrote:
>>> On Tue, Aug 21, 2018 at 01:01:00PM -0400, Austin S. Hemmelgarn wrote:
>>>> On 2018-08-21 12:05, David Sterba wrote:
>>>>> On Tue, Aug 21, 2018 at 10:10:04AM -0400, Austin S. Hemmelgarn wrote:
>>>>>> On 2018-08-21 09:32, Janos Toth F. wrote:
>>>>>>>>>> so pretty much everyone who wants to avoid the overhead from them can just
>>>>>>>>>> use the `noatime` mount option.
>>>>>>>
>>>>>>> It would be great if someone finally fixed this old bug then:
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=61601
>>>>>>> Until then, it seems practically impossible to use both noatime (this
>>>>>>> can't be added as rootflag in the command line and won't apply if the
>>>>>>> kernel already mounted the root as RW) and space-cache-v2 (has to be
>>>>>>> added as a rootflag along with RW to take effect) for the root
>>>>>>> filesystem (at least without an init*fs, which I never use, so can't
>>>>>>> tell).
>>>>>>>
>>>>>> Last I knew, it was fixed.  Of course, it's been quite a while since I
>>>>>> last tried this, as I run locally patched kernels that have `noatime` as
>>>>>> the default instead of `relatime`.
>>>>>
>>>>> I'm using VMs without initrd, tested the rootflags=noatime and it still
>>>>> fails, the same way as in the bugreport.
>>>>>
>>>>> As the 'noatime' mount option is part of the mount(2) API (passed as a
>>>>> bit via mountflags), the remaining option in the filesystem is to
>>>>> whitelist the generic options and ignore them. But this brings some
>>>>> layering violation question.
>>>>>
>>>>> On the other hand, this would be come confusing as the user expectation
>>>>> is to see the effects of 'noatime'.
>>>>>
>>>> Ideally there would be a way to get this to actually work properly.  I
>>>> think ext4 at least doesn't panic, though I'm not sure if it actually
>>>> works correctly.
>>>
>>> No, ext4 also refuses to mount, the panic happens in VFS that tries
>>> either the rootfstype= or all available filesystems.
>>>
>>> [    3.763602] EXT4-fs (sda): Unrecognized mount option "noatime" or missing value
>>>
>>> [    3.761315] BTRFS info (device sda): unrecognized mount option 'noatime'
>>>
>>>> Otherwise, the only option for people who want it set is to patch the
>>>> kernel to get noatime as the default (instead of relatime).  I would
>>>> look at pushing such a patch upstream myself actually, if it weren't for
>>>> the fact that I'm fairly certain that it would be immediately NACK'ed by
>>>> at least Linus, and probably a couple of other people too.
>>>
>>> An acceptable solution could be to parse the rootflags and translate
>>> them to the MNT_* values, ie. what the commandline tool mount does
>>> before it calls the mount syscall.
>>>
>> That would be helpful, but at that point you might as well update the
>> CLI mount tool to just pass all the named options to the kernel and have
>> it do the parsing (I mean, keep the old interface too obviously, but
>> provide a new one and use that preferentially).
> 
> The initial mount is not done by the mount tool but internally by
> kernel init sequence (files in init/):
> 
> mount_block_root
>    do_mount_root
>      ksys_mount
> 
> The mount options (as a string) is passed unchanged via variable
> root_mount_data (== rootflags). So before this step, the options would
> have to be filtered and all known generic options turned into bit flags.
> 
What I'm saying is that if there's going to be parsing for it in the 
kernel anyway, why not expose that interface to userspace too so that 
the regular `mount` tool can take advantage of it as well.
