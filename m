Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:35683 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbdB0TU1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 14:20:27 -0500
Received: by mail-ot0-f171.google.com with SMTP id w44so58516511otw.2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Feb 2017 11:19:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170226054712.bt73qk4vqm5civw2@angband.pl>
References: <CAPLCSGCeD5KaFmMZWCKQ8nEbMEYTeDsb4ksgxQiU7-6P7dR=3w@mail.gmail.com>
 <1020cf90-bb59-eea4-5f82-166427b3363e@mendix.com> <CAPLCSGCWighTDFAyN3ixz3Xk5_ArLJfGaWHSDyvstZ9cZmx6rQ@mail.gmail.com>
 <20170226054712.bt73qk4vqm5civw2@angband.pl>
From: Bhasker C V <bhasker@unixindia.com>
Date: Tue, 28 Feb 2017 00:49:41 +0530
Message-ID: <CAPLCSGBDJXsfWfZajsYQQE+O1tWH=p5osOAbWQeM=jH7BwFnVg@mail.gmail.com>
Subject: Re: BTRFS hybrid system setup issues
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
 On further testing I found that many of the functionality works fine
(most of the core functionality). One function I could not get to work
with this x86_64 kernel and i386 userland is
btrfs subvolme functionality works; btrfsck works; scrub works fine.
BUT
-------
$ sudo btrfs send aa > /tmp/a
At subvol aa
ERROR: send ioctl failed with -25: Inappropriate ioctl for device
-------
kernel 4.10.0
btrfs-prog 4.7.3 (debian)





On Sun, Feb 26, 2017 at 11:17 AM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Sun, Feb 26, 2017 at 10:47:40AM +0530, Bhasker C V wrote:
>> I compiled kernel 4.10 and I can confirm it is working fnie now.  4.10
>> has the compat-ioctl patches for btrfs progs to work with x86_64
>> kernel in i386 userland.
>
> So does 4.9.10 if you prefer running long-lived releases.
>
> --
> Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
>   ./configure --host=zx-spectrum --build=pdp11
