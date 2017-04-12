Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35259 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754842AbdDLQoE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 12:44:04 -0400
Received: by mail-lf0-f53.google.com with SMTP id 75so17315984lfs.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Apr 2017 09:44:03 -0700 (PDT)
Subject: Re: Btrfs disk layout question
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Adam Borowski <kilobyte@angband.pl>
References: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
 <20170411210023.vfqck3h6nepdow3z@angband.pl>
 <CAJCQCtTyNUx-P2aPNBE0x2W01qUfrBcHyA-46frM4X+suKMxrw@mail.gmail.com>
 <fdb571b4-0069-b124-8a22-7de09346bee7@gmail.com>
Cc: Amin Hassani <ahassani@chromium.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <ec5a00c8-5eb8-b7fa-c1e5-5eb72cb3512c@gmail.com>
Date: Wed, 12 Apr 2017 19:44:00 +0300
MIME-Version: 1.0
In-Reply-To: <fdb571b4-0069-b124-8a22-7de09346bee7@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

12.04.2017 14:20, Austin S. Hemmelgarn пишет:
> On 2017-04-12 00:18, Chris Murphy wrote:
>> On Tue, Apr 11, 2017 at 3:00 PM, Adam Borowski <kilobyte@angband.pl>
>> wrote:
>>> On Tue, Apr 11, 2017 at 12:15:32PM -0700, Amin Hassani wrote:
>>>> I am working on a project with Btrfs and I was wondering if there is
>>>> any way to see the disk layout of the btrfs image. Let's assume I have
>>>> a read-only btrfs image with compression on and only using one disk
>>>> (no raid or anything). Is it possible to get a set of offset-lengths
>>>> for each file
>>>
>>> While btrfs-specific ioctls give more information, you might want to
>>> look at
>>> FIEMAP (Documentation/filesystems/fiemap.txt) as it works on most
>>> filesystems, not just btrfs.  One interface to FIEMAP is provided in
>>> "/usr/sbin/filefrag -v".
>>
>> Good idea. Although, on Btrfs I'm pretty sure it reports the Btrfs
>> (internal) logical addressing; not the actual physical sector address
>> on the drive. So it depends on what the original poster is trying to
>> discover.
>>
> That said, there is a tool to translate that back, and depending on how
> detailed you want to get, that may be more efficient than debug tree.

Could you give pointer to this tool? I use filefrag on bootinfoscript to
display physical disk offset of files of interest to bootloader. I was
not aware it shows logical offset which makes it kinda pointless.
