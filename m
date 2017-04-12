Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33260 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753846AbdDLLUZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 07:20:25 -0400
Received: by mail-io0-f171.google.com with SMTP id k87so21868233ioi.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Apr 2017 04:20:25 -0700 (PDT)
Subject: Re: Btrfs disk layout question
To: Chris Murphy <lists@colorremedies.com>,
        Adam Borowski <kilobyte@angband.pl>
References: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
 <20170411210023.vfqck3h6nepdow3z@angband.pl>
 <CAJCQCtTyNUx-P2aPNBE0x2W01qUfrBcHyA-46frM4X+suKMxrw@mail.gmail.com>
Cc: Amin Hassani <ahassani@chromium.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <fdb571b4-0069-b124-8a22-7de09346bee7@gmail.com>
Date: Wed, 12 Apr 2017 07:20:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTyNUx-P2aPNBE0x2W01qUfrBcHyA-46frM4X+suKMxrw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-12 00:18, Chris Murphy wrote:
> On Tue, Apr 11, 2017 at 3:00 PM, Adam Borowski <kilobyte@angband.pl> wrote:
>> On Tue, Apr 11, 2017 at 12:15:32PM -0700, Amin Hassani wrote:
>>> I am working on a project with Btrfs and I was wondering if there is
>>> any way to see the disk layout of the btrfs image. Let's assume I have
>>> a read-only btrfs image with compression on and only using one disk
>>> (no raid or anything). Is it possible to get a set of offset-lengths
>>> for each file
>>
>> While btrfs-specific ioctls give more information, you might want to look at
>> FIEMAP (Documentation/filesystems/fiemap.txt) as it works on most
>> filesystems, not just btrfs.  One interface to FIEMAP is provided in
>> "/usr/sbin/filefrag -v".
>
> Good idea. Although, on Btrfs I'm pretty sure it reports the Btrfs
> (internal) logical addressing; not the actual physical sector address
> on the drive. So it depends on what the original poster is trying to
> discover.
>
That said, there is a tool to translate that back, and depending on how 
detailed you want to get, that may be more efficient than debug tree.
