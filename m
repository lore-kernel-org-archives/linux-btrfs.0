Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:38542 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757286AbcILO4d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 10:56:33 -0400
Received: by mail-it0-f47.google.com with SMTP id n143so10248638ita.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 07:56:32 -0700 (PDT)
Subject: Re: Small fs
To: Chris Murphy <lists@colorremedies.com>, Henk Slager <eye1tm@gmail.com>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
 <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com>
 <1771908.LWBdy5fQ5X@merkaba> <3e8e686c-9c42-a1e1-a0ac-9eb27208360d@gmail.com>
 <CAPmG0jZprQr8vnasD9E8hmadj3rYXvwkm9Ny6eCwqznbOGzDtA@mail.gmail.com>
 <CAJCQCtTJChtn3hCwQKN0PHga07ze-tT0uJQf=dw3Woyv3-yjvg@mail.gmail.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        Imran Geriskovan <imran.geriskovan@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3bc0a59f-df91-72b4-5592-c4c9a7658a53@gmail.com>
Date: Mon, 12 Sep 2016 10:56:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTJChtn3hCwQKN0PHga07ze-tT0uJQf=dw3Woyv3-yjvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 10:51, Chris Murphy wrote:
> On Mon, Sep 12, 2016 at 8:09 AM, Henk Slager <eye1tm@gmail.com> wrote:
>>> FWIW, I use BTRFS for /boot, but it's not for snapshotting or even the COW,
>>> it's for DUP mode and the error recovery it provides.  Most people don't
>>> think about this if it hasn't happened to them, but if you get a bad read
>>> from /boot when loading the kernel or initrd, it can essentially nuke your
>>> whole system.  I run BTRFS for /boot in DUP mode with mixed-bg (because I
>>> only use 512MB for boot) to mitigate the chance that a failed read has any
>>> impact, and ensure that if it does, it will refuse to boot instead of
>>> booting with a corrupted kernel or initrd.
>>
>> Suppose kernel and initrd are on a BTRFS fs with data, metadata and
>> system all single profile. Will a bootloader then just continue
>> booting up a system even when there are csum errors in kernel and/or
>> initrd files?  Suppose the bootloader is grub2.
>
> I"m wondering the same thing. I don't know if GRUB's Btrfs code checks
> for csum matches, and on error whether it knows to retry from some
> other block group.
I can test this and report results (I've got GRUB built with the FUSE 
based mount tool, which lets you use GRUB's FS modules from regular 
Linux userspace), but it may be a while before I can get things set up 
to properly test it.

