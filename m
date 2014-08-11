Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:57417 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaHKQEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 12:04:01 -0400
Received: by mail-la0-f43.google.com with SMTP id hr17so6979342lab.30
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:04:00 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <51F1A674-280C-4AF9-93BD-82B38F8E9C92@colorremedies.com>
References: <2BBB0EBF-DD55-45B4-8BF5-F8DAA9398A4F@colorremedies.com>
	<CF539008-5930-447D-B26C-2A2BBE9337EA@colorremedies.com>
	<CAL3q7H591BbVenxFn_EiBDyqmJEcwgOKjw0Xv2J+jkgic+3dxQ@mail.gmail.com>
	<16C9BBD0-FD7B-488B-A77F-E937007F292F@colorremedies.com>
	<CAL3q7H5rpoPFBKjLD9F0_4UdBcG8BgzKUQGGTzbmBmdkG2_Jwg@mail.gmail.com>
	<51F1A674-280C-4AF9-93BD-82B38F8E9C92@colorremedies.com>
Date: Mon, 11 Aug 2014 17:04:00 +0100
Message-ID: <CAL3q7H7MfE84dgfS==HbKE5N9_MiznYM5B6gMN7xQjX5nhKE0Q@mail.gmail.com>
Subject: Re: [BUG] btrfs send/receive, page allocation failure
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 4:55 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Aug 11, 2014, at 2:46 AM, Filipe David Manana <fdmanana@gmail.com> wrote:
>
>> On Mon, Aug 11, 2014 at 4:07 AM, Chris Murphy <lists@colorremedies.com> wrote:
>>>>
>>>>
>>>> Can you try the following patch and confirm if it helps?
>>>> https://patchwork.kernel.org/patch/4705171/
>>>
>>> This one applies without problems, I didn't build it because I saw v4. The v4 patch I get:
>>>
>>> + patch -p1 -F1 -s
>>> 4 out of 4 hunks FAILED -- saving rejects to file fs/btrfs/send.c.rej
>>>
>>> Should v4 alone be applied over 3.16.0? Or each version in succession?
>>
>> Alone. How did you try to apply it to 3.16?
>
> rpmbuild
> https://fedoraproject.org/wiki/Building_a_custom_kernel
>
> Gist is, save the patch, create patch filename entry into kernel.spec, then run rpmbuild. rpmbuild uses 'patch -p1 -F1 -s' to apply the patch. The v1 patch applies, as does Liu Bo's patch from July 29 "Btrfs: fix regression of btrfs device replace" which I was also going to test. But the v4 patch isn't applying.
>
>> Try "cd source_dir && git
>> am patchfile" if you didn't (e.g. you used patch command directly).
>
> I'd kinda prefer to build an rpm since I need to test it on baremetal for this bug, and a VM for the device replace bug.

Sorry, I don't know anything about fedora's way of kernel patching.
Either way, it seems the problem is simple to solve:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
git checkout v3.16
git am /path/to/my_patch_file
git diff HEAD^..HEAD > /tmp/diff

The resulting patch file [1] /tmp/diff then applies cleanly with
"patch -p1 -F1 -s"

https://friendpaste.com/Bgwdjk31P3pZHtArr341G

>
>
> Chris Murphy



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
