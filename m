Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34030 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbdBZFRm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Feb 2017 00:17:42 -0500
Received: by mail-ot0-f193.google.com with SMTP id w44so5613013otw.1
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Feb 2017 21:17:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1020cf90-bb59-eea4-5f82-166427b3363e@mendix.com>
References: <CAPLCSGCeD5KaFmMZWCKQ8nEbMEYTeDsb4ksgxQiU7-6P7dR=3w@mail.gmail.com>
 <1020cf90-bb59-eea4-5f82-166427b3363e@mendix.com>
From: Bhasker C V <bhasker@unixindia.com>
Date: Sun, 26 Feb 2017 10:47:40 +0530
Message-ID: <CAPLCSGCWighTDFAyN3ixz3Xk5_ArLJfGaWHSDyvstZ9cZmx6rQ@mail.gmail.com>
Subject: Re: BTRFS hybrid system setup issues
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I compiled kernel 4.10 and I can confirm it is working fnie now.  4.10
has the compat-ioctl patches for btrfs progs to work with x86_64
kernel in i386 userland.
thanks to all

On Sun, Feb 26, 2017 at 2:10 AM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> On 02/25/2017 08:30 PM, Bhasker C V wrote:
>> Hi all,
>>
>>   I have an x86_64 kernel running with i386 userland rootfs.
>
> Which kernel version? (`uname -a`)
The old 4.9.0 did not
I today got 4.10 kernel and found that it is all fine. The
compat-ioctl does the trick.
>
>>  Long back I believe there were some fixes for btrfs-tools which ran
>> smoothly in this setup but after several dist-upgrades(debian) and
>> long forgotten command, the btrfs-tools commands have started to fail
>
> Which btrfs progs version? (`btrfs version`)
>
btrfs-progs (master)
>> for instance
>>
>> $ sudo btrfs fi sync  .
>> ERROR: sync ioctl failed on '.': Inappropriate ioctl for device
>> $
>>
>> Is there any fix for this ? I downloaded the git master branch and it
>> too seems to suffer from this issue.
>
> Maybe this is relevant here:
> https://www.spinics.net/lists/linux-btrfs/msg62692.html
>
> --
> Hans van Kranenburg
