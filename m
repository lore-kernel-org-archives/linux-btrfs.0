Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:32857 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752731AbdDLQu1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 12:50:27 -0400
Received: by mail-oi0-f50.google.com with SMTP id b187so38803327oif.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Apr 2017 09:50:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ec5a00c8-5eb8-b7fa-c1e5-5eb72cb3512c@gmail.com>
References: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
 <20170411210023.vfqck3h6nepdow3z@angband.pl> <CAJCQCtTyNUx-P2aPNBE0x2W01qUfrBcHyA-46frM4X+suKMxrw@mail.gmail.com>
 <fdb571b4-0069-b124-8a22-7de09346bee7@gmail.com> <ec5a00c8-5eb8-b7fa-c1e5-5eb72cb3512c@gmail.com>
From: Amin Hassani <ahassani@google.com>
Date: Wed, 12 Apr 2017 09:50:06 -0700
Message-ID: <CACC_xWBakrLnAgJ7i+wJcyJ21X9oNYO4T2Og_yCHWaLHra170A@mail.gmail.com>
Subject: Re: Btrfs disk layout question
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Adam Borowski <kilobyte@angband.pl>,
        Amin Hassani <ahassani@chromium.org>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Thanks for responses.

I actually need the physical addresses. FIEMAP I believe (and I
tested) gives logical address which as Andrei mentioned is useless.
I'm assuming btfs-debug-tree gives the physical addresses right? I
also need to know the compression method used on each extent and I
don't think I can get that with the fiemap stuff. It seems that fiemap
capability is not implemented in Btrfs as I'm looking at the Btrfs
implementation and based on documentation of fiemap:

"File systems wishing to support fiemap must implement a ->fiemap
callback on their inode_operations structure. The fs ->fiemap call is
responsible for
defining its set of supported fiemap flags, and calling a helper function on
each discovered extent:"

Thanks,
Amin.



On Wed, Apr 12, 2017 at 9:44 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 12.04.2017 14:20, Austin S. Hemmelgarn пишет:
>> On 2017-04-12 00:18, Chris Murphy wrote:
>>> On Tue, Apr 11, 2017 at 3:00 PM, Adam Borowski <kilobyte@angband.pl>
>>> wrote:
>>>> On Tue, Apr 11, 2017 at 12:15:32PM -0700, Amin Hassani wrote:
>>>>> I am working on a project with Btrfs and I was wondering if there is
>>>>> any way to see the disk layout of the btrfs image. Let's assume I have
>>>>> a read-only btrfs image with compression on and only using one disk
>>>>> (no raid or anything). Is it possible to get a set of offset-lengths
>>>>> for each file
>>>>
>>>> While btrfs-specific ioctls give more information, you might want to
>>>> look at
>>>> FIEMAP (Documentation/filesystems/fiemap.txt) as it works on most
>>>> filesystems, not just btrfs.  One interface to FIEMAP is provided in
>>>> "/usr/sbin/filefrag -v".
>>>
>>> Good idea. Although, on Btrfs I'm pretty sure it reports the Btrfs
>>> (internal) logical addressing; not the actual physical sector address
>>> on the drive. So it depends on what the original poster is trying to
>>> discover.
>>>
>> That said, there is a tool to translate that back, and depending on how
>> detailed you want to get, that may be more efficient than debug tree.
>
> Could you give pointer to this tool? I use filefrag on bootinfoscript to
> display physical disk offset of files of interest to bootloader. I was
> not aware it shows logical offset which makes it kinda pointless.



-- 
Amin Hassani.
