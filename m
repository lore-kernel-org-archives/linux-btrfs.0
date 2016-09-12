Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38796 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758209AbcILOND (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 10:13:03 -0400
Received: by mail-it0-f52.google.com with SMTP id n143so8483433ita.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 07:13:02 -0700 (PDT)
Subject: Re: Small fs
To: Henk Slager <eye1tm@gmail.com>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
 <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com>
 <1771908.LWBdy5fQ5X@merkaba> <3e8e686c-9c42-a1e1-a0ac-9eb27208360d@gmail.com>
 <CAPmG0jZprQr8vnasD9E8hmadj3rYXvwkm9Ny6eCwqznbOGzDtA@mail.gmail.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        Imran Geriskovan <imran.geriskovan@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3902d905-6138-c31a-2f69-35110c270cba@gmail.com>
Date: Mon, 12 Sep 2016 10:12:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZprQr8vnasD9E8hmadj3rYXvwkm9Ny6eCwqznbOGzDtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 10:09, Henk Slager wrote:
>> FWIW, I use BTRFS for /boot, but it's not for snapshotting or even the COW,
>> it's for DUP mode and the error recovery it provides.  Most people don't
>> think about this if it hasn't happened to them, but if you get a bad read
>> from /boot when loading the kernel or initrd, it can essentially nuke your
>> whole system.  I run BTRFS for /boot in DUP mode with mixed-bg (because I
>> only use 512MB for boot) to mitigate the chance that a failed read has any
>> impact, and ensure that if it does, it will refuse to boot instead of
>> booting with a corrupted kernel or initrd.
>
> Suppose kernel and initrd are on a BTRFS fs with data, metadata and
> system all single profile. Will a bootloader then just continue
> booting up a system even when there are csum errors in kernel and/or
> initrd files?  Suppose the bootloader is grub2.
>
Assuming I understand how they implemented their BTRFS support in GRUB, 
it should still be checking csums just like the kernel implementation, 
and thus should throw a read error when a block is corrupted.  For a 
stock upstream version of GRUB2, this would mean that it will refuse to 
boot that entry, and may try to auto-boot a fallback entry (which will 
probably fail given how most distros set up their fallback entries).
